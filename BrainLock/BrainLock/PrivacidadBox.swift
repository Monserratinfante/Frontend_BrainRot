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
        NavigationLink(destination: PDFViewerView(pdfName: "Privacidad")) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.white, lineWidth: 2)
                    .frame(width: 26, height: 26)
                    .overlay(
                        Group {
                            if isChecked {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    )

                Text("Privacidad / Deslinde")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
