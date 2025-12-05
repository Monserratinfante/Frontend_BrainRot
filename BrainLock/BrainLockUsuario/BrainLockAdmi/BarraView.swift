//
//  BarraView.swift
//  caritas
//
//  Created by GP  on 12/11/25.
//

import SwiftUI

struct BarraView: View {
    @State private var showScannerMenu = false
    @State private var showScannerCamera = false
    @State private var showSuccessAlert = false

    var body: some View {
        TabView {

            FolioControl()
                .tabItem { Label("Solicitudes", systemImage: "doc.text") }

            UsuarioView()
                .tabItem { Label("Usuario", systemImage: "person.circle") }

            Button("Abrir escanear") {
                showScannerMenu = true
            }
            .tabItem { Label("Escaner", systemImage: "qrcode.viewfinder") }
        }
        .sheet(isPresented: $showScannerMenu) {
            scanGood(showSuccess: $showScannerCamera)
        }
        .sheet(isPresented: $showScannerCamera) {
            scanGood(showSuccess: $showSuccessAlert)
        }
        .alert("Donación entregada", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("La donación ha sido marcada como entregada correctamente.")
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
