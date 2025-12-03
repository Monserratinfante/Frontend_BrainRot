//
//  LoginRegister.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import SwiftUI

struct LoginRegisterView: View {

    // Recibe el modo inicial (0 = login, 1 = registro)
    var initialTab: Int = 0

    // Estado del modo actual
    @State private var tabIndex: Int = 0
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var accepted: Bool = false
    @State private var errorMsg: String? = nil
    @State private var goToApp: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false


    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    init(initialTab: Int = 0) {
        self.initialTab = initialTab
        _tabIndex = State(initialValue: initialTab)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                    Spacer().frame(height: 30)

                    // Logo
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .padding(.top, 10)

                    // Selector Login/Register
                    HStack(spacing: 8) {
                        Button(action: { tabIndex = 0; clearErrors() }) {
                            Text("LOGIN")
                                .font(.title3).bold()
                                .foregroundColor(tabIndex == 0 ? azulOscuro : .gray)
                        }
                        Text("|").foregroundColor(.gray.opacity(0.6))
                        Button(action: { tabIndex = 1; clearErrors() }) {
                            Text("REGISTER")
                                .font(.title3).bold()
                                .foregroundColor(tabIndex == 1 ? azulOscuro : .gray)
                        }
                    }
                    .padding(.top, 6)

                    // Inputs
                    Group {
                        TextField("email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(14)
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 2))

                        SecureField("password", text: $password)
                            .padding(14)
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 2))

                        if tabIndex == 1 {
                            SecureField("confirm password", text: $confirm)
                                .padding(14)
                                .foregroundColor(.black)
                                .background(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 2))
                        }

                        PrivacidadBox(isChecked: $accepted)
                    }
                    .padding(.horizontal, 28)

                    // Error
                    if let msg = errorMsg {
                        Text(msg)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 28)
                            .multilineTextAlignment(.center)
                    }

                    // Botón Login/Register
                    Button {
                        Task { await submit() }
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
            // AQUÍ SE CAMBIA LA NAVEGACIÓN
            .navigationDestination(isPresented: $goToApp) {
                BarraView2()   // YA NO DonationView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    private func clearErrors() { errorMsg = nil }

    private func submit() async {
        errorMsg = nil
        
        do {
            guard accepted else {
                errorMsg = "Debes aceptar la política de privacidad."
                return
            }

            if tabIndex == 0 {
                // LOGIN
                let _ = try await AuthAPI.login(email: email, password: password)
            } else {
                // REGISTER
                guard password == confirm else {
                    errorMsg = "Las contraseñas no coinciden."
                    return
                }
                try await AuthAPI.register(email: email, password: password)
            }

            // GUARDAR ESTADO DE SESIÓN
            isLoggedIn = true

            // 👇 AQUI GUARDAS EL CORREO DEL USUARIO
            UserDefaults.standard.set(email, forKey: "userEmail")

            // 👇 IMPORTANTE PARA QUE NAVEGUE
            goToApp = true

            // Limpiar campos
            password = ""
            confirm = ""

        } catch {
            errorMsg = error.localizedDescription
        }
    }
}
