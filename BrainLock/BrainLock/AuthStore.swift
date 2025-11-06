//
//  AuthStore.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import Foundation
import Combine

final class AuthStore: ObservableObject {
    @Published private(set) var users: [CuentaUsuario] = []
    @Published var currentUser: CuentaUsuario? = nil
    
    private let usersKey = "auth_users_v1"
    private let sessionKey = "auth_current_user_email_v1"
    
    init() {
        loadUsers()
        restoreSession()
    }
    
    // MARK: - Persistencia
    private func loadUsers() {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else { return }
        if let decoded = try? JSONDecoder().decode([CuentaUsuario].self, from: data) {
            self.users = decoded
        }
    }
    
    private func saveUsers() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }
    
    private func restoreSession() {
        guard let email = UserDefaults.standard.string(forKey: sessionKey) else { return }
        self.currentUser = users.first(where: { $0.email == email })
    }
    
    private func persistSession(email: String?) {
        if let email = email {
            UserDefaults.standard.set(email, forKey: sessionKey)
        } else {
            UserDefaults.standard.removeObject(forKey: sessionKey)
        }
    }
    
    // MARK: - API
    enum AuthError: LocalizedError {
        case emptyFields
        case invalidEmail
        case weakPassword
        case termsNotAccepted
        case emailInUse
        case wrongCredentials
        
        var errorDescription: String? {
            switch self {
            case .emptyFields: return "Completa todos los campos."
            case .invalidEmail: return "Correo inválido."
            case .weakPassword: return "La contraseña debe tener al menos 8 caracteres."
            case .termsNotAccepted: return "Debes aceptar privacidad/deslinde."
            case .emailInUse: return "Ese correo ya está registrado."
            case .wrongCredentials: return "Correo o contraseña incorrectos."
            }
        }
    }
    
    func register(email: String, password: String, accepted: Bool) throws {
        let email = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty, !password.isEmpty else { throw AuthError.emptyFields }
        guard email.contains("@"), email.contains(".") else { throw AuthError.invalidEmail }
        guard password.count >= 8 else { throw AuthError.weakPassword }
        guard accepted else { throw AuthError.termsNotAccepted }
        guard users.first(where: { $0.email == email }) == nil else { throw AuthError.emailInUse }
        
        let user = CuentaUsuario(email: email, passwordPlain: password, acceptedTerms: accepted)
        users.append(user)
        saveUsers()
        // Opcional: inicias sesión automáticamente tras registrarte
        currentUser = user
        persistSession(email: user.email)
    }
    
    func login(email: String, password: String) throws {
        let email = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let hash = CuentaUsuario.sha256(password)
        guard let user = users.first(where: { $0.email == email && $0.passwordHash == hash }) else {
            throw AuthError.wrongCredentials
        }
        currentUser = user
        persistSession(email: user.email)
    }
    
    func logout() {
        currentUser = nil
        persistSession(email: nil)
    }
}
