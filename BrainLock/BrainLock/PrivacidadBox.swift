//
//  PrivacidadBox.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 24/10/25.
//

import SwiftUI

struct PrivacidadBox: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            Button {
                configuration.isOn.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(lineWidth: 2)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Group {
                            if configuration.isOn {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                    )
            }
            configuration.label
        }
        .buttonStyle(.plain)
    }
}
