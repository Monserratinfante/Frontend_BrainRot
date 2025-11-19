//
//  BaseHeader.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 27/10/25.
//

import SwiftUI

struct BaseHeader: View {
    var title: String
    var logoName: String = "Logo"
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    

    var body: some View {
        HStack {
            HStack(spacing: 56) {
                if UIImage(named: logoName) != nil {
                    Image(logoName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                } else {
                    Image(systemName: "cross.case.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                }

                Text(title.uppercased())
                    .font(.title).bold()
                    .tracking(2)
                    .foregroundColor(azulOscuro)
            }

            Spacer() // empuja todo a la izquierda o crea balance visual
        }
        .padding(.horizontal, 10)
        .padding(.top, 90)
    }
}
