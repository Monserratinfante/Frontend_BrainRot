//
//  AgregarDonacionView.swift
//  BrainLock
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI
import UIKit
import MapKit

// MARK: - Vista principal
struct AgregarDonacionView: View {
    @Environment(\.dismiss) var dismiss
    
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
    let opcionesClasificacion = ["MEDICATION", "CLOTHING", "INMOBILIERAIRE"]
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    // Navegación
    @State private var irADonacionEnviada = false
    @State private var irABasares = false
    @State private var donacionFinal: Donacion?
    
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
                        
                        // BOTÓN AGREGAR
                        Button(action: validarYRedirigir) {
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
        // Navegación a Donación Enviada
        .navigationDestination(isPresented: $irADonacionEnviada) {
            if let d = donacionFinal {
                DonationEnviadaView(donacion: d)
            }
        }
        // Navegación a Basar
        .navigationDestination(isPresented: $irABasares) {
            BasarMapTemplate(
                basarName: "Basar Principal",
                address: "Monte Cristal 141, Juárez N.L.",
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 25.6510, longitude: -100.2040),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ),
                coordinate: CLLocationCoordinate2D(latitude: 25.6510, longitude: -100.2040)
            )
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
    
    func loadImage(fileName: String) -> UIImage? {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
    func getImageURL(fileName: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
    
    // MARK: - VALIDACIÓN Y ENVÍO AL BACKEND
    func validarYRedirigir() {
        // Para ver rápido si el botón sí se toca
        print("👉 BOTÓN AGREGAR TOCADO")
        
        // Limpiar espacios
        let descLimpia = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
        let pesoLimpio = peso.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validaciones básicas
        errorClasificacion = clasificacion.isEmpty
        errorDescripcion = descLimpia.isEmpty
        errorPeso = pesoLimpio.isEmpty
        
        if errorClasificacion || errorDescripcion || errorPeso {
            print("❌ Validación básica falló")
            return
        }
        
        // Aceptar coma o punto
        let pesoConvertible = pesoLimpio.replacingOccurrences(of: ",", with: ".")
        guard let pesoNum = Double(pesoConvertible), pesoNum > 0 else {
            errorPeso = true
            print("❌ Peso inválido: \(pesoLimpio)")
            return
        }
        
        let pesoKg = unidadPeso == "g" ? pesoNum / 1000 : pesoNum
        let pesoFinal = "\(pesoLimpio) \(unidadPeso)"
        
        // Donación local (para la vista de confirmación)
        let nuevaDonacion = Donacion(
            clasificacion: clasificacion,
            descripcion: descLimpia,
            peso: pesoFinal,
            imagenes: selectedImages
        )
        donacionFinal = nuevaDonacion
        
        // Llamada al backend
        Task {
            var urls: [String] = []
            
            // 🔹 Mientras NO tengas /upload, mandamos URLs de prueba
            if !selectedImages.isEmpty {
                urls = selectedImages.enumerated().map { index, _ in
                    "https://example.com/mock-image-\(index).jpg"
                }
            }
            
            // Si ya tuvieras /upload implementado, sería algo así:
            /*
             for fileName in savedImageNames {
             let fileURL = getImageURL(fileName: fileName)
             do {
             let url = try await uploadImage(fileURL: fileURL)
             urls.append(url)
             } catch {
             print("Error subiendo imagen:", error)
             }
             }
             */
            
            let payload = CreateDonationPayload(
                description: descLimpia,
                weight: pesoKg,
                category: clasificacion,
                images: urls
            )
            
            do {
                let _ = try await postDonation(payload: payload)
                print("✅ Donación enviada al backend con \(urls.count) imágenes")
            } catch {
                print("Error enviando donación:", error)
            }
        }
        
        // Navegación según peso
        if pesoKg > 50 {
            irADonacionEnviada = true
        } else {
            irABasares = true
        }
    }
    
    
    // MARK: - ImagePicker
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
    AgregarDonacionView ()
}
