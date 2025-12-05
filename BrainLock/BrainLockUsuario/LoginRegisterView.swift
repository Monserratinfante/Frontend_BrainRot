//
//  LoginRegister.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import SwiftUI

struct LoginRegisterView: View {
    @State var validatedRole = Roles.GUEST

    // Modo inicial: 0 = Login, 1 = Registro
    var initialTab: Int = 0
    
    // Estado interno
    @State private var tabIndex: Int
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var accepted: Bool = false
    @State private var errorMsg: String? = nil
    @State private var goToApp: Bool = false
    
    
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    // Inicializador
    init(initialTab: Int = 0) {
        self.initialTab = initialTab
        self._tabIndex = State(initialValue: initialTab)
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
                    
                    // Selector Login / Register
                    HStack(spacing: 8) {
                        Button { tabIndex = 0; clearErrors() } label: {
                            Text("LOGIN")
                                .font(.title3).bold()
                                .foregroundColor(tabIndex == 0 ? azulOscuro : .gray)
                        }
                        Text("|").foregroundColor(.gray.opacity(0.6))
                        Button { tabIndex = 1; clearErrors() } label: {
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
                    
                    // Mensaje de error
                    if let msg = errorMsg {
                        Text(msg)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 28)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Botón principal
                    Button { Task { await submit() } } label: {
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
            // Navegación tras login/registro
            .navigationDestination(isPresented: $goToApp) {
                switch validatedRole {
                case Roles.USER:
                    BarraView2().navigationBarBackButtonHidden(true)
                case Roles.ADMIN:
                    BarraView().navigationBarBackButtonHidden(true)
                default:
                    VistaInicio().navigationBarBackButtonHidden(true)
                }
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
                let role = try await AuthAPI.login(email: email, password: password)
                print(role)
                // Guardar email en AppStorage
                UserDefaults.standard.set(email, forKey: "userEmail")

                if role == "USER" {
                    validatedRole = .USER
                } else if role == "ADMIN" {
                    validatedRole = .ADMIN
                } else {
                    errorMsg = "El rol de usuario no es válido."
                    return
                }
            } else {
                // REGISTER
                guard password == confirm else {
                    errorMsg = "Las contraseñas no coinciden."
                    return
                }
                try await AuthAPI.register(email: email, password: password)
                validatedRole = .USER
            }
            UserDefaults.standard.set(email, forKey: "userEmail")

            // Navegar a la app
            goToApp = true

            
            // Limpiar campos
            password = ""
            confirm = ""
            
        } catch {
            errorMsg = error.localizedDescription
        }
    }
}

#Preview {
    LoginRegisterView()
}
