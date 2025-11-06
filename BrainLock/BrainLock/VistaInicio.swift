//
//  VistaInicio.swift
//  BrainLock
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct VistaInicio: View {
    let azulOscuro = Color(red: 0.01, green: 0.23, blue: 0.36) // #013a5d
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo de imagen
                Image("Portada")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("¿Quiénes somos?")
                            .font(.largeTitle)
                            .foregroundColor(azulOscuro)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        Text("Visión")
                            .font(.title2)
                            .foregroundColor(azulOscuro)
                        
                        Text("""
Gracias a Dios, a la sensibilidad y a la confianza de la comunidad en Cáritas de Monterrey, A.B.P., contamos con un liderazgo que mediante la optimización de recursos ha incrementado los servicios asistenciales, de promoción humana y administrativos; atenuando las necesidades de los más desprotegidos a través de una infraestructura adecuada con personas en capacitación continua y comprometidas por amor.
""")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                        
                        Text("Misión")
                            .font(.title2)
                            .foregroundColor(azulOscuro)
                        
                        Text("""
Cáritas de Monterrey, A.B.P. es un organismo de la Iglesia Católica fundamentado en el amor que proporciona servicios asistenciales, de promoción humana y desarrollo comunitario a nuestros hermanos más desprotegidos sin distinción de credo o religión haciendo realidad la cristiana comunicación de bienes.
""")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                        
                        Text("Valores")
                            .font(.title2)
                            .foregroundColor(azulOscuro)
                        
                        Text("""
• Caridad
• Espiritualidad
• Servicio
• Humildad
• Respeto
• Profesionalismo
• Mejora continua
""")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                        
                        // Botones para Login y Register
                        HStack(spacing: 40) {
                            NavigationLink(destination: LoginRegisterView(initialTab: 0)) {
                                Text("Login")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(azulOscuro)
                            }

                            NavigationLink(destination: LoginRegisterView(initialTab: 1)) {
                                Text("Register")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(azulOscuro)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    VistaInicio()
}
