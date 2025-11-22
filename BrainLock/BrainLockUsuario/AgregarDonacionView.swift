//
//  AgregarDinacionesView
//  BrainLock
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI
import UIKit
import MapKit


// MARK: - Modelo actualizado
struct DonacionView {
    var clasificacion: String
    var descripcion: String
    var peso: String   // almacenará "X kg" o "X g"
    var imagenes: [UIImage] = []
}

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
    
    // Imagenes
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    
    let unidades = ["kg", "g"]
    let opcionesClasificacion = ["Salud", "Higiene", "Alimentos", "Calzado", "Medicamentos", "Otro"]
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    var onAgregar: (Donacion) -> Void
    
    // Navegación nueva
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
                                    get: {
                                        peso
                                    },
                                    set: { newValue in
                                        // SOLO números
                                        let filtered = newValue.filter { $0.isNumber }
                                        peso = filtered
                                    }
                                ))
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulOscuro)
                                
                                // Picker de unidad
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
        // Navega a "Donación Enviada"
        .navigationDestination(isPresented: $irADonacionEnviada) {
            if let d = donacionFinal {
                DonationEnviadaView(donacion: d)
            }
        }
        // Navega a "Basares"
        // Navega a "Basares"
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
    
    // VALIDACIÓN + REDIRECCIÓN NUEVA

    func validarYRedirigir() {
        errorClasificacion = clasificacion.isEmpty
        errorDescripcion = descripcion.isEmpty
        errorPeso = peso.isEmpty
        
        if errorClasificacion || errorDescripcion || errorPeso {
            return
        }
        
        guard let pesoNum = Double(peso) else {
            errorPeso = true
            return
        }
        
        let pesoKg = unidadPeso == "g" ? pesoNum / 1000 : pesoNum
        
        let pesoFinal = "\(peso) \(unidadPeso)"
        
        let nueva = Donacion(
            clasificacion: clasificacion,
            descripcion: descripcion,
            peso: pesoFinal,
            imagenes: selectedImages
        )
        
        donacionFinal = nueva
        onAgregar(nueva)
        
        // REGLA NUEVA:
        if pesoKg > 50 {
            irADonacionEnviada = true
        } else {
            irABasares = true
        }
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


// MARK: - Preview
#Preview {
    AgregarDonacionView { _ in }
}
