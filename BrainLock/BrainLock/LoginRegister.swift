//
//  LoginRegister.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import SwiftUI

struct LoginRegisterView: View {
    @EnvironmentObject var auth: AuthStore

    // Recibe el modo inicial (0 = login, 1 = registro)
    var initialTab: Int = 0

    // Estado del modo actual
    @State private var tabIndex: Int = 0
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var accepted: Bool = false
    @State private var errorMsg: String? = nil
    @State private var goToDonations: Bool = false

    private let azulOscuro = Color(red: 0.01, green: 0.23, blue: 0.36)

    // Inicializador para establecer el modo inicial
    init(initialTab: Int = 0) {
        self.initialTab = initialTab
        _tabIndex = State(initialValue: initialTab)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                Image("Colores")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.35))

                VStack(spacing: 22) {
                    Spacer().frame(height: 30)

                    // Logo
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .padding(.top, 10)

                    // Selector entre Login y Registro
                    HStack(spacing: 8) {
                        Button(action: { tabIndex = 0; clearErrors() }) {
                            Text("LOGIN")
                                .font(.title3).bold()
                                .foregroundColor(tabIndex == 0 ? .white : .gray.opacity(0.7))
                        }
                        Text("|").foregroundColor(.gray.opacity(0.6))
                        Button(action: { tabIndex = 1; clearErrors() }) {
                            Text("REGISTER")
                                .font(.title3).bold()
                                .foregroundColor(tabIndex == 1 ? .white : .gray.opacity(0.7))
                        }
                    }
                    .padding(.top, 6)

                    // Campos de texto
                    Group {
                        TextField("email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(14)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 6).stroke(.white, lineWidth: 2))

                        SecureField("password", text: $password)
                            .padding(14)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 6).stroke(.white, lineWidth: 2))

                        if tabIndex == 1 {
                            SecureField("confirm password", text: $confirm)
                                .padding(14)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 6).stroke(.white, lineWidth: 2))
                            

                        }
                        PrivacidadBox(isChecked: $accepted)

                    }
                    .padding(.horizontal, 28)

                    // Mensaje de error
                    if let msg = errorMsg {
                        Text(msg)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, -6)
                            .padding(.horizontal, 28)
                            .multilineTextAlignment(.center)
                    }

                    // Botón principal
                    Button {
                        Task {
                            await submit()
                        }
                    } label: {
                        Text(tabIndex == 0 ? "Ingresar" : "Crear cuenta")
                            .font(.headline).bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 32)
                            .background(Capsule().fill(azulOscuro))
                    }
                    .padding(.top, 4)

                    Spacer()
                }
                .padding(.bottom, 16)
            }
            .navigationDestination(isPresented: $goToDonations) {
                DonationsView()
            }
        }
    }

    private func clearErrors() { errorMsg = nil }

    private func submit() async {
        errorMsg = nil
        do {
            if tabIndex == 0 {
                try await AuthAPI.login(email: email, password: password)
            } else {
                guard password == confirm else {
                    errorMsg = "Las contraseñas no coinciden."
                    return
                }
                guard accepted else {
                    errorMsg = "Debes aceptar la política de privacidad."
                    return
                }
                //try auth.register(email: email, password: password, accepted: accepted)
                try await AuthAPI.register(
                    email: email,
                    username: "myuser",
                    password: password
                )

            }
            goToDonations = true
            password = ""
            confirm = ""
        } catch {
            errorMsg = (error as? AuthStore.AuthError)?.errorDescription ?? error.localizedDescription
        }
    }
}
