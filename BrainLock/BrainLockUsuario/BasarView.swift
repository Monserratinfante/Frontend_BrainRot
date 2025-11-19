//
//  Basariew.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 18/11/25.
//

import SwiftUI

struct BasarView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Basares Cercanos")
                .font(.largeTitle.bold())
                .foregroundColor(.blue)

            Text("Aquí aparecerán los basares más cercanos según tu ubicación.")
                .multilineTextAlignment(.center)
                .padding()

            Image(systemName: "location.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .foregroundColor(.blue)
        }
        .padding()
        .navigationTitle("Basares")
    }
}

#Preview {
    BasarView()
}
