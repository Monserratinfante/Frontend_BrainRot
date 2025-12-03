//
//  ApiClient.swift
//  BrainLock
//
//  Created by Alumno on 02/12/25.
//

import Foundation

final class ApiClient {
    private let baseURL = URL(string: "http://10.14.255.216:3000")!
    
    // MARK: - Subir imágenes
    func uploadImages(donationId: Int, images: [Data]) async throws {
        let url = baseURL.appendingPathComponent("donation/upload-images/\(donationId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Token igual que en postDonation
        if let token = try readJWTFromKeychain() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw AuthError.badStatus(401, "No token stored in Keychain")
        }

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (i, imgData) in images.enumerated() {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"image\(i).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imgData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            let bodyText = String(data: data, encoding: .utf8) ?? "<no body>"
            print("Upload falló. Status: \(http.statusCode)")
            print("Respuesta servidor (upload): \(bodyText)")
            throw AuthError.badStatus(http.statusCode, bodyText)
        }
    }
}
