//
//  UsuarioPerfil.swift
//  BrainLock
//
//  Created by Alumno on 02/12/25.
//

import Foundation
import SwiftUI

struct UsuarioPerfil: View {

    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        VStack(spacing: 30) {

            Text("Perfil del Usuario")
                .font(.largeTitle.bold())
                .foregroundColor(azulOscuro)
                .padding(.top, 40)

            VStack(spacing: 12) {
                Text("Correo:")
                    .font(.title3)
                    .foregroundColor(.gray)

                Text(userEmail)
                    .font(.title2.bold())
                    .foregroundColor(azulOscuro)
            }

            Spacer()

            Button {
                isLoggedIn = false
            } label: {
                Text("Cerrar sesión")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
        .background(
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    UsuarioPerfil()
}
