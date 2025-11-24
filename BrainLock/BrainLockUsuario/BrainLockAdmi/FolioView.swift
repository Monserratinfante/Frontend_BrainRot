//
//  FolioView.swift
//  caritas
//
//  Created by Gladys Pérez on 05/11/25.
//

/*import SwiftUI

struct FolioView: View {
    @Binding var folio: Donation

    @State private var mostrarConfirmacion = false
    @State private var accionPendiente: EstadoFolio? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Encabezado
                HStack {
                    Text("Folio \(folio.codigo)")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    EstadoBadge(estado: folio.estado)
                }

                // Datos principales
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Fecha: \(folio.fecha)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Text("Descripción")
                        .font(.headline)

                    Text(folio.descripcion)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.9))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.black.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)

                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Artículos donativos")
                        .font(.headline)
                    ForEach(mockArticulos, id: \.self) { item in
                        HStack {
                            Image(systemName: "cube.box")
                            Text(item)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white.opacity(0.85))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black.opacity(0.06), lineWidth: 1)
                        )
                    }
                }

                // Botones de acción
                VStack(spacing: 12) {
                    Button {
                        accionPendiente = .aprobado
                        mostrarConfirmacion = true
                    } label: {
                        Text("Autorizar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .foregroundColor(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        accionPendiente = .negado
                        mostrarConfirmacion = true
                    } label: {
                        Text("Rechazar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .foregroundColor(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.top, 6)
            }
            .padding()
        }
        .navigationTitle("Detalle del folio")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirmar acción", isPresented: $mostrarConfirmacion) {
            Button("Confirmar", role: .destructive) {
                if let accion = accionPendiente {
                    folio.estado = accion  // actualiza el estado en ContentView!
                }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text(accionPendiente == .aprobado
                 ? "¿Deseas autorizar este folio?"
                 : "¿Deseas rechazar este folio?")
        }
        .background(
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.15)
        )
    }

    //Luego con datos reales
    private var mockArticulos: [String] {
        ["Cobijas (5 pzas.)",
         "Leche en polvo (3 kg)"]
    }
}


#Preview {
    // Previsualización con folio de ejemplo usando .constant
    FolioView(
        folio: .constant(
            Folio(
                id: UUID(),
                codigo: "#A1B2C",
                fecha: "05/11/25",
                estado: .enRevision,
                descripcion: "Este es un ejemplo de folio en revisión con artículos donativos incluidos."
            )
        )
    )
}
*/
