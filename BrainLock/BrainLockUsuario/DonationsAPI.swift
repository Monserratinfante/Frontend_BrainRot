//
//  DonationsAPI.swift
//  BrainLock
//
//  Created by Alumno on 24/11/25.
//

import Foundation

// MARK: - Models

struct CreateDonationPayload: Encodable {
    let description: String
    let weight: Double
    let category: String
    let images: [String]
}

struct CreateDonationResponse: Decodable {
    let id: Int
    let userId: Int
    let description: String
    let category: String
    let status: String?
    let weight: Double
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - Base URL

let baseURL = URL(string: "http://10.14.255.216:3000")!

// MARK: - Backend call: create donation

func postDonation(payload: CreateDonationPayload) async throws -> CreateDonationResponse {
    guard let url = URL(string: "donation", relativeTo: baseURL) else {
        throw AuthError.invalidURL
    }

    guard let token = try readJWTFromKeychain() else {
        throw AuthError.badStatus(401, "No token stored in Keychain")
    }

    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    req.httpBody = try JSONEncoder().encode(payload)

    let (data, res) = try await URLSession.shared.data(for: req)
    guard let http = res as? HTTPURLResponse else {
        throw AuthError.decodingFailed
    }

    if !(200...299).contains(http.statusCode) {
        let bodyText = String(data: data, encoding: .utf8) ?? "<no body>"
        print("❌ postDonation falló. Status: \(http.statusCode)")
        print("Respuesta servidor (donation): \(bodyText)")
        throw AuthError.badStatus(http.statusCode, bodyText)
    }

    // Útil para depurar la forma real del JSON
    // print("✅ Respuesta donación:", String(data: data, encoding: .utf8) ?? "<no body>")

    let createdDonation = try JSONDecoder().decode(CreateDonationResponse.self, from: data)
    return createdDonation
}

// MARK: - Backend call: upload image (OJO: tu backend aún no expone /upload)

func uploadImage(fileURL: URL) async throws -> String {
    guard let url = URL(string: "/upload", relativeTo: baseURL) else {
        throw AuthError.invalidURL
    }
    
    guard let token = try readJWTFromKeychain() else {
        throw AuthError.badStatus(401, "No token stored in Keychain")
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    var body = Data()

    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileURL.lastPathComponent)\"\r\n")
    body.appendString("Content-Type: image/jpeg\r\n\r\n")
    body.append(try Data(contentsOf: fileURL))
    body.appendString("\r\n")
    body.appendString("--\(boundary)--\r\n")

    request.httpBody = body

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let http = response as? HTTPURLResponse else {
        throw AuthError.decodingFailed
    }

    // ⛔️ Si no es 2xx, imprime qué respondió el servidor
    guard (200...299).contains(http.statusCode) else {
        let bodyText = String(data: data, encoding: .utf8) ?? "<no body>"
        print("❌ Upload falló. Status: \(http.statusCode)")
        print("Respuesta servidor (upload): \(bodyText)")
        throw AuthError.badStatus(http.statusCode, bodyText)
    }

    struct UploadResponse: Decodable { let url: String }
    let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
    return uploadResponse.url
}

// MARK: - Helpers

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
