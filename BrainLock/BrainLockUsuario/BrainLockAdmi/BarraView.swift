//
//  BarraView.swift
//  caritas
//
//  Created by GP  on 12/11/25.
//

import SwiftUI

struct BarraView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            FolioControl() 
                .tabItem { Label("Solicitudes", systemImage: "doc.text") }

            UsuarioView()
                .tabItem { Label("Usuario", systemImage: "person.circle") }
        }
    }
}





struct UsuarioPlaceholderView: View {
    var body: some View {
        NavigationStack {
            Text("Perfil de usuario")
                .navigationTitle("Usuario")
        }
    }
}

#Preview {
    BarraView()
}
