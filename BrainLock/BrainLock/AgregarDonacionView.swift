import SwiftUI

struct AgregarDonacionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var clasificacion = "Ropa"
    @State private var descripcion = ""
    @State private var peso = ""
    
    let opcionesClasificacion = ["Ropa", "Higiene", "Alimentos", "Calzado", "Electrónicos", "Otro"]
    
    // Color azul oscuro turquesa
    let azulTurquesa = Color(red: 0.0, green: 0.5, blue: 0.6)
    
    var onAgregar: (Donacion) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                Image("Portada")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Agregar Producto")
                            .font(.largeTitle.bold())
                            .foregroundColor(azulTurquesa)
                            .padding(.top, 100)
                        
                        // Clasificación lado a lado
                        HStack(spacing: 16) {
                            Text("Clasificación:")
                                .foregroundColor(azulTurquesa)
                                .bold()
                                .padding(30)
                            
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
                                .foregroundColor(azulTurquesa)
                                .bold()
                            TextField("Descripción de la donación", text: $descripcion)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulTurquesa)
                        }
                        .padding(.horizontal)
                        
                        // Peso
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Peso")
                                .foregroundColor(azulTurquesa)
                                .bold()
                            TextField("Peso aproximado", text: $peso)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(azulTurquesa)
                        }
                        .padding(.horizontal)
                        
                        // Botón Agregar
                        Button(action: {
                            let nueva = Donacion(clasificacion: clasificacion,
                                                 descripcion: descripcion,
                                                 peso: peso)
                            onAgregar(nueva)
                        }) {
                            Text("Agregar")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(azulTurquesa)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .disabled(descripcion.isEmpty || peso.isEmpty)
                        
                        // Botón Cancelar abajo
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancelar")
                                .foregroundColor(azulTurquesa)
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
    }
}

#Preview {
    AgregarDonacionView { _ in }
}
