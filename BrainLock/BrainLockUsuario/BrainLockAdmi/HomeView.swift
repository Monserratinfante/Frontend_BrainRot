//
//  HomeView.swift
//  caritas
//
//  Created by Regina Gutiérrez Mayorga  on 14/11/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    //.opacity(0.8)
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    HomeView()
}
