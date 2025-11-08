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
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Título principal
                        Text("¿Quiénes somos?")
                            .font(.largeTitle.bold())
                            .foregroundColor(azulOscuro)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        // --- VISIÓN ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Visión")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            Text("""
Gracias a Dios, a la sensibilidad y a la confianza de la comunidad en Cáritas de Monterrey, A.B.P., contamos con un liderazgo que mediante la optimización de recursos ha incrementado los servicios asistenciales, de promoción humana y administrativos; atenuando las necesidades de los más desprotegidos a través de una infraestructura adecuada con personas en capacitación continua y comprometidas por amor.
""")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                        
                        Divider()
                            .background(azulOscuro.opacity(0.2))
                            .padding(.vertical, 5)
                        
                        // --- MISIÓN ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Misión")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            Text("""
Cáritas de Monterrey, A.B.P. es un organismo de la Iglesia Católica fundamentado en el amor que proporciona servicios asistenciales, de promoción humana y desarrollo comunitario a nuestros hermanos más desprotegidos sin distinción de credo o religión haciendo realidad la cristiana comunicación de bienes.
""")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                        
                        Divider()
                            .background(azulOscuro.opacity(0.2))
                            .padding(.vertical, 5)
                        
                        // --- VALORES ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Valores")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                // Los primeros 6 valores
                                Label("Caridad", systemImage: "checkmark.circle.fill")
                                Label("Espiritualidad", systemImage: "checkmark.circle.fill")
                                Label("Servicio", systemImage: "checkmark.circle.fill")
                                Label("Humildad", systemImage: "checkmark.circle.fill")
                                Label("Respeto", systemImage: "checkmark.circle.fill")
                                Label("Profesionalismo", systemImage: "checkmark.circle.fill")
                                
                                // Séptimo valor centrado en su propia fila
                                HStack {
                                    Spacer()
                                    Label("Mejora continua", systemImage: "checkmark.circle.fill")
                                    Spacer()
                                }
                                .gridCellColumns(2) // Ocupa las dos columnas
                            }
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .symbolRenderingMode(.hierarchical)
                            .tint(azulOscuro)
                        }

                        
                        // --- BOTONES ---
                        HStack(spacing: 40) {
                            NavigationLink(destination: LoginRegisterView(initialTab: 0)) {
                                Text("Login")
                                    .font(.title3.bold())
                                    .foregroundColor(azulOscuro)
                            }

                            NavigationLink(destination: LoginRegisterView(initialTab: 1)) {
                                Text("Register")
                                    .font(.title3.bold())
                                    .foregroundColor(azulOscuro)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    VistaInicio()
}
