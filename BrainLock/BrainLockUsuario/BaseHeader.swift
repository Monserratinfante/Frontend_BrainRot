//
//  BaseHeader.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 27/10/25.
//

import SwiftUI

struct BaseHeader: View {
    var title: String
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    

    var body: some View {
        HStack {

                Text(title.uppercased())
                    .font(.title).bold()
                    .tracking(2)
                    .foregroundColor(azulOscuro)
            }
        .padding(.top, 90)


            Spacer() // empuja todo a la izquierda o crea balance visual
        }
    }
