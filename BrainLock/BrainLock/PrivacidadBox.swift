//
//  PrivacidadBox.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import SwiftUI

struct PrivacidadBox: View {
    @Binding var isChecked: Bool

    var body: some View {
        HStack(spacing: 12) {

            // BOTON QUE ACTIVA / DESACTIVA EL CHECK
            Button {
                isChecked.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 26, height: 26)
                    .overlay(
                        Group {
                            if isChecked {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.green)
                            }
                        }
                    )
            }
            .buttonStyle(.plain)

            // TEXTO QUE ABRE EL PDF
            NavigationLink(destination: PDFViewerView(pdfName: "Privacidad")) {
                Text("Privacidad / Deslinde")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }

        }
        .padding(.vertical, 8)
    }
}

