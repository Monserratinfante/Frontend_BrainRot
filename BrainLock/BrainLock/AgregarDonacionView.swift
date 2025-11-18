//
//  AgregarDinacionesView
//  BrainLock
//
//  Created by Alumno on 14/11/25.


import SwiftUI
import UIKit

// MARK: - Modelo
struct DonacionView {
    var clasificacion: String
    var descripcion: String
    var peso: String
    var imagenes: [UIImage] = []
}

// MARK: - Vista principal
struct AgregarDonacionView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var clasificacion = ""
    @State private var descripcion = ""
    @State private var peso = ""
    
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    
    let opcionesClasificacion = ["Salud", "Higiene", "Alimentos", "Calzado", "Medicamentos", "Otro"]
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    var onAgregar: (Donacion) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Agregar Producto")
                            .font(.largeTitle.bold())
                            .foregroundColor(azulOscuro)
                            .padding(.top, 100)
                        
                        // Clasificación
                        HStack(spacing: 16) {
                            Text("Clasificación:")
                                .foregroundColor(azulOscuro)
                                .bold()
                            
                            Picker("Selecciona una opción", selection: $clasificacion) {
                                ForEach(opcionesClasificacion, id: \.self) { opcion in
                                    Text(opcion)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        // Descripción
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Descripción")
                                .foregroundColor(azulOscuro)
                                .bold()
                            TextField("Descripción de la donación", text: $descripcion)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulOscuro)
                        }
                        .padding(.horizontal)
                        
                        // Peso
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Peso")
                                .foregroundColor(azulOscuro)
                                .bold()
                            TextField("Peso aproximado", text: $peso)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulOscuro)
                        }
                        .padding(.horizontal)
                        
                        // Imágenes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Imágenes")
                                .foregroundColor(azulOscuro)
                                .bold()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(selectedImages, id: \.self) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                    
                                    Button {
                                        pickerSource = .photoLibrary
                                        showingImagePicker = true
                                    } label: {
                                        VStack {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .font(.largeTitle)
                                            Text("Galería")
                                                .font(.caption)
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(8)
                                    }
                                    
                                    Button {
                                        pickerSource = .camera
                                        showingImagePicker = true
                                    } label: {
                                        VStack {
                                            Image(systemName: "camera")
                                                .font(.largeTitle)
                                            Text("Cámara")
                                                .font(.caption)
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .frame(height: 120)
                        }
                        .padding(.horizontal)
                        
                        // Botón Agregar
                        Button(action: {
                            let nueva = Donacion(
                                clasificacion: clasificacion,
                                descripcion: descripcion,
                                peso: peso,
                                imagenes: selectedImages
                            )
                            onAgregar(nueva)
                        }) {
                            Text("Agregar")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(azulOscuro)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .disabled(descripcion.isEmpty || peso.isEmpty)
                        
                        // Botón Cancelar
                        Button(action: { dismiss() }) {
                            Text("Cancelar")
                                .foregroundColor(azulOscuro)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage, sourceType: pickerSource)
                .onDisappear {
                    if let img = inputImage {
                        selectedImages.append(img)
                        inputImage = nil
                    }
                }
        }
    }
}

// MARK: - ImagePicker integrado
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Preview
#Preview {
    AgregarDonacionView { _ in }
}
