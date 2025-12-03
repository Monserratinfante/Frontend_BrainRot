//
//  BarraView.swift
//  caritas
//
//  Created by GP  on 12/11/25.
//

import SwiftUI

struct BarraView2: View {
    
    
    var body: some View {
        TabView {
            DonationView()
                .tabItem { Label("Donaciones", systemImage: "heart.fill") }
            
            UsuarioPerfil()
                .tabItem{
                    Label("Perfil", systemImage: "person.circule")
                }
            }
        }
    }



#Preview {
    BarraView2()
}
