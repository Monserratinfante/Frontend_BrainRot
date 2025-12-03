//
//  VistaInicio.swift
//  BrainLock
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct VistaInicio: View {
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    
    var body: some View {
            ZStack {
                // Fondo de imagen
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                 
                ScrollView {
                    VStack(alignment: .center, spacing: 30) {
                        
                        Spacer()

                        // Título principal
                        Text("¿Quiénes somos?")
                            .font(.largeTitle.bold())
                            .foregroundColor(azulOscuro)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        
                        
                        // --- VISIÓN ---
                        VStack(alignment: .center, spacing: 10) {
                            Text("Visión")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            Text("""
    Gracias a Dios, a la sensibilidad y a la confianza de la comunidad en Cáritas de Monterrey, A.B.P., contamos con un liderazgo que mediante la optimización de recursos ha incrementado los servicios asistenciales, de promoción humana y administrativos; atenuando las necesidades de los más desprotegidos a través de una infraestructura adecuada con personas en capacitación continua y comprometidas por amor.
""")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        }
                        .cardStyle()
                        
                        // --- MISIÓN ---
                        VStack(alignment: .center, spacing: 10) {
                            Text("Misión")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            Text("""
Cáritas de Monterrey, A.B.P. es un organismo de la Iglesia Católica fundamentado en el amor que proporciona servicios asistenciales, de promoción humana y desarrollo comunitario a nuestros hermanos más desprotegidos sin distinción de credo o religión haciendo realidad la cristiana comunicación de bienes.
""")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        }
                        .cardStyle()
                        
                        // --- VALORES ---
                        VStack(alignment: .center, spacing: 10) {
                            Text("Valores")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                Label("Caridad", systemImage: "checkmark.circle.fill")
                                Label("Espiritualidad", systemImage: "checkmark.circle.fill")
                                Label("Servicio", systemImage: "checkmark.circle.fill")
                                Label("Humildad", systemImage: "checkmark.circle.fill")
                                Label("Respeto", systemImage: "checkmark.circle.fill")
                                Label("Profesionalismo", systemImage: "checkmark.circle.fill")
                                
                                HStack {
                                    Spacer()
                                    Label("Mejora continua", systemImage: "checkmark.circle.fill")
                                    Spacer()
                                }
                                .gridCellColumns(2)
                            }
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .symbolRenderingMode(.hierarchical)
                            .tint(azulOscuro)
                            .multilineTextAlignment(.center)

                        }
                        .cardStyle()
                // --- POLITICA DE CALIDAD ---
                    VStack(alignment: .center, spacing: 10) {
                            Text("Política de Calidad")
                                .font(.title2.bold())
                                .foregroundColor(azulOscuro)
                            
                            Text("""
Cáritas de Monterrey, A.B.P. mantiene y amplia los canales de comunicacion interna, perseverando en servicios de excelencia con calidez, optimizando los recursos disponibles mediante un plan de educacion en la fe, capacitacion y mejora continua proyectos dirigidos a los mas desprotegidos.
""")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        }
                        .cardStyle()
                        
                        
                        // --- BOTONES ---
                        HStack(spacing: 40) {
                            NavigationLink(destination: LoginRegisterView(initialTab: 0)) {
                                Text(" Login")
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
                        .padding(.top, 60)
                        .padding(.bottom, 70)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
        }
    }

#Preview {
    VistaInicio()
}

//
//  --- MODIFICADOR GLOBAL ---
//

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.35))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 6)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
