//
//  PDFView.swift
//  BrainLock
//
//  Created by Alumno on 06/11/25.
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let pdfName: String

    var body: some View {
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
           let pdfDocument = PDFDocument(url: url) {
            PDFKitView(document: pdfDocument)
                .navigationTitle("Privacidad / Deslinde")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("No se pudo cargar el PDF")
                .foregroundColor(.red)
                .navigationTitle("Privacidad / Deslinde")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
