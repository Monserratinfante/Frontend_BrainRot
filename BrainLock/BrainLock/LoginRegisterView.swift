//
//  LoginRegisterView.swift
//  BrainLock
//
//  Created by Leobardo Navarro Márquez on 06/11/25.
//


import SwiftUI

struct LoginRegisterView: View {
    @EnvironmentObject var auth: AuthStore

    @State private var tabIndex: Int = 0
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var accepted: Bool = false
    @State private var errorMsg: String? = nil
    @State private var goToDonations: Bool = false

    private let azulOscuro = Color(red: 0.01, green: 0.23, blue: 0.36)

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Colores")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.35))

                VStack(spacing: 22) {
                    Spacer().frame(height: 30)

                    Image("Logo")
                        .resizable().scaledToFit().frame(width: 180).padding(.top, 10)

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

                            Toggle(isOn: $accepted) {
                                Text("privacidad/ deslinde")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            .toggleStyle(PrivacidadBox())
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 28)

                    if let msg = errorMsg {
                        Text(msg)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, -6)
                            .padding(.horizontal, 28)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        submit()
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
            // 👇 Aquí es donde ahora va la navegación moderna
            .navigationDestination(isPresented: $goToDonations) {
                DonationsView()
            }
        }
    }

    private func clearErrors() { errorMsg = nil }

    private func submit() {
        errorMsg = nil
        do {
            if tabIndex == 0 {
                try auth.login(email: email, password: password)
            } else {
                guard password == confirm else {
                    errorMsg = "Las contraseñas no coinciden."
                    return
                }
                try auth.register(email: email, password: password, accepted: accepted)
            }
            goToDonations = true
            password = ""; confirm = ""
        } catch {
            errorMsg = (error as? AuthStore.AuthError)?.errorDescription ?? error.localizedDescription
        }
    }
}