//
//  UsuarioView.swift
//  caritas
//
//  Created by Gladys Pérez on 12/11/25.
//

import SwiftUI

struct UsuarioView: View {
    @State private var mostrarAlertaLogout = false
    
    var body: some View {
        NavigationStack {
            
            List {
                Section("Perfil") {
                    ScrollView{
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.accentColor)
                            VStack(alignment: .leading) {
                                Text("Nombre")
                                    .font(.headline)
                                Text("Administrador General")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section("Gestión") {
                        
                        Label("Usuarios", systemImage: "person.3.fill")
                        Label("Reportes", systemImage: "chart.bar.fill")
                    }
                    
                    Section("Configuración") {
                        Label("Cambiar contraseña", systemImage: "key.fill")
                        Label("Notificaciones", systemImage: "bell.fill")
                      
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            mostrarAlertaLogout = true
                        } label: {
                            Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
                .navigationTitle("Usuario")
                .alert("¿Cerrar sesión?", isPresented: $mostrarAlertaLogout) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Cerrar sesión", role: .destructive) {}
                }
            }
            
        }
    }
}

#Preview {
    UsuarioView()
}
