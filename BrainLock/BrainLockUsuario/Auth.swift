//
//  Auth.swift
//  BrainLock
//
//  Created by Alumno on 06/11/25.
//

import Foundation
import Security

// MARK: - Models

struct ValidatePayload: Decodable {
    let role: String
}

enum Roles {
    case USER
    case ADMIN
    case GUEST
    
    init(from backend: String) {
        switch backend.uppercased() {
            case "USER": self = .USER
            case "ADMIN": self = .ADMIN
            default: self = .GUEST
        }
    }
}

struct RegisterPayload: Encodable {
    let email: String
    let password: String
}

struct RegisterResponse: Decodable {
    let token: String
}

struct LoginPayload: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let role: String
}

// MARK: - Keychain

enum KeychainError: Error { case unexpectedStatus(OSStatus) }

func saveJWTToKeychain(_ token: String, account: String = "auth_jwt") throws -> Void {
    let data = Data(token.utf8)

    // Delete any existing value first (idempotent upsert)
    let deleteQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account
    ]
    SecItemDelete(deleteQuery as CFDictionary)

    let addQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecValueData as String: data,
        // Optional: make it available after first unlock
        kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
    ]
    let status = SecItemAdd(addQuery as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
}

func readJWTFromKeychain(account: String = "auth_jwt") throws -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecItemNotFound { return nil }
    guard status == errSecSuccess, let data = item as? Data else {
        throw KeychainError.unexpectedStatus(status)
    }
    return String(data: data, encoding: .utf8)
}

// MARK: - API

enum AuthError: Error, LocalizedError {
    case badStatus(Int, String?)
    case invalidURL
    case decodingFailed
    case network(Error)
    case missingJWT

    var errorDescription: String? {
        switch self {
        case .badStatus(let code, let msg): return "Server returned \(code)\(msg.map { ": \($0)" } ?? "")"
        case .invalidURL: return "Invalid URL."
        case .decodingFailed: return "Failed to decode server response."
        case .network(let err): return err.localizedDescription
        case .missingJWT: return "Please log in"
        }
    }
}

struct AuthAPI {
    // Change this to your actual base URL
    static let baseURL = URL(string: "http://10.14.255.216:3000")!

    static func register(email: String, password: String) async throws {
        guard let url = URL(string: "/authentication/register", relativeTo: baseURL) else {
            throw AuthError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(RegisterPayload(email: email, password: password))

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw AuthError.decodingFailed }

            guard (200...299).contains(http.statusCode) else {
                // Try to extract message if the server returns JSON error { message: ... } (optional)
                let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["message"] as? String
                throw AuthError.badStatus(http.statusCode, message)
            }

            // Decode token
            guard let register = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
                throw AuthError.decodingFailed
            }

            // Save to Keychain
            try saveJWTToKeychain(register.token)
        } catch let err as AuthError {
            throw err
        } catch {
            throw AuthError.network(error)
        }
    }
    
    static func login(email: String, password: String) async throws -> String {
            guard let url = URL(string: "/authentication/login", relativeTo: baseURL) else {
                throw AuthError.invalidURL
            }

            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try JSONEncoder().encode(
                LoginPayload(email: email, password: password)
            )

            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw AuthError.badStatus((resp as? HTTPURLResponse)?.statusCode ?? -1, nil)
            }
        
            let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
            try saveJWTToKeychain(decoded.token)
            return decoded.role
        }
    
    static func validateSession() async throws -> ValidatePayload {
        guard let url = URL(string: "/authorization/validate", relativeTo: AuthAPI.baseURL) else {
            throw AuthError.invalidURL
        }

        guard let jwt = try? readJWTFromKeychain() else {
            throw AuthError.missingJWT
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw AuthError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1, nil)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ValidatePayload.self, from: data)
    }
}
