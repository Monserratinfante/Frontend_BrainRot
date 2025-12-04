//
//  AgregarDonacionView.swift
//  BrainLock
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI
import UIKit

// MARK: - Vista principal
struct AgregarDonacionView: View {
    @Environment(\.dismiss) var dismiss

    // Callback para regresar la donación a DonationView
    var onAdd: (Donacion) -> Void

    // Campos
    @State private var clasificacion = ""
    @State private var descripcion = ""
    @State private var peso = ""
    @State private var unidadPeso = "kg"

    // Errores
    @State private var errorClasificacion = false
    @State private var errorDescripcion = false
    @State private var errorPeso = false

    // Imágenes
    @State private var selectedImages: [UIImage] = []
    @State private var savedImageNames: [String] = []
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

    let unidades = ["kg", "g"]
    // CAMBIAR POR LAS CATEGORÍAS REALES
    let opcionesClasificacion = ["MEDICATION",
                                 "CLOTHING",
                                 "INMOBILIERAIRE",
                                 "ALIMENTOS",
                                 "ROPAYCALZADO",
                                 "MUEBLES",
                                 "OTROSARTICULOS",
                                 "ELECTRODOMESTICOS",
                                 "HIGIENEPERSONAL",
                                 "MEDICINAS",
                                 "ELECTRONICOS"]
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }

                ScrollView {
                    VStack(spacing: 20) {

                        Text("Agregar Producto")
                            .font(.largeTitle.bold())
                            .foregroundColor(azulOscuro)
                            .padding(.top, 100)

                        // CLASIFICACIÓN
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 16) {
                                Text("Clasificación:")
                                    .foregroundColor(azulOscuro)
                                    .bold()

                                Menu {
                                    Button("Selecciona una opción") {
                                        clasificacion = ""
                                    }

                                    ForEach(opcionesClasificacion, id: \.self) { opcion in
                                        Button(opcion) {
                                            clasificacion = opcion
                                        }
                                    }

                                } label: {
                                    HStack {
                                        Text(clasificacion.isEmpty ? "Selecciona una opción" : clasificacion)
                                            .foregroundColor(azulOscuro)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(azulOscuro)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }

                            if errorClasificacion {
                                Text("Debes seleccionar una clasificación.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)

                        // DESCRIPCIÓN
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Descripción")
                                .foregroundColor(azulOscuro)
                                .bold()

                            TextField("Descripción de la donación", text: $descripcion)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulOscuro)

                            if errorDescripcion {
                                Text("Este campo es obligatorio.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)

                        // PESO + PICKER (KG/G)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Peso")
                                .foregroundColor(azulOscuro)
                                .bold()

                            HStack {
                                TextField("Peso", text: Binding(
                                    get: { peso },
                                    set: { newValue in
                                        let filtered = newValue.filter { $0.isNumber || $0 == "." }
                                        peso = filtered
                                    }
                                ))
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulOscuro)

                                Picker("", selection: $unidadPeso) {
                                    ForEach(unidades, id: \.self) { unidad in
                                        Text(unidad)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(width: 70)
                                .padding(8)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                            }

                            if errorPeso {
                                Text("Debes ingresar un peso válido.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)

                        // IMÁGENES
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

                        // BOTÓN AGREGAR (solo crea donación local)
                        Button(action: validarYCrearDonacion) {
                            Text("Agregar")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(azulOscuro)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        // CANCELAR
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
        // Picker de imágenes
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage, sourceType: pickerSource)
                .onDisappear {
                    if let img = inputImage {
                        selectedImages.append(img)
                        let name = UUID().uuidString
                        if let saved = saveImage(img, name: name) {
                            savedImageNames.append(saved)
                        }
                        inputImage = nil
                    }
                }
        }
    }

    // MARK: - FUNCIONES DE IMÁGENES

    func saveImage(_ image: UIImage, name: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(name).jpg")
        do {
            try data.write(to: url)
            return url.lastPathComponent
        } catch {
            print("Error al guardar imagen:", error)
            return nil
        }
    }

    // MARK: - VALIDACIÓN (solo local, no backend)
    func validarYCrearDonacion() {
        print("BOTÓN AGREGAR TOCADO")

        let descLimpia = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
        let pesoLimpio = peso.trimmingCharacters(in: .whitespacesAndNewlines)

        // Validaciones
        errorClasificacion = clasificacion.isEmpty
        errorDescripcion = descLimpia.isEmpty
        errorPeso = pesoLimpio.isEmpty

        if errorClasificacion || errorDescripcion || errorPeso {
            print("Validación básica falló")
            return
        }

        let pesoConvertible = pesoLimpio.replacingOccurrences(of: ",", with: ".")
        guard let pesoNum = Double(pesoConvertible), pesoNum > 0 else {
            errorPeso = true
            print("Peso inválido: \(pesoLimpio)")
            return
        }

        let pesoFinal = "\(pesoLimpio) \(unidadPeso)"

        let nuevaDonacion = Donacion(
            foto: selectedImages.first.map { Image(uiImage: $0) },
            clasificacion: clasificacion,
            descripcion: descLimpia,
            peso: pesoFinal,
            estado: "Pendiente",
            imagenes: selectedImages,
            backendId: nil,
            bazarNombre: nil
        )

        onAdd(nuevaDonacion)
        dismiss()
    }
    

    // MARK: - ImagePicker interno
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
}

// Extensión global para ocultar teclado
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// MARK: - Preview
#Preview {
    AgregarDonacionView { _ in }
}
