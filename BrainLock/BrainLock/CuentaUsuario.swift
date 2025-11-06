//
//  CuentaUsuario.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import Foundation
import CryptoKit //

struct CuentaUsuario: Identifiable, Codable, Hashable {
    let id: UUID
    let email: String
    let passwordHash: String
    let acceptedTerms: Bool
    let createdAt: Date
    
    init(email: String, passwordPlain: String, acceptedTerms: Bool) {
        self.id = UUID()
        self.email = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        self.passwordHash = Self.sha256(passwordPlain)
        self.acceptedTerms = acceptedTerms
        self.createdAt = Date()
    }
    
    static func sha256(_ text: String) -> String {
        let data = Data(text.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
