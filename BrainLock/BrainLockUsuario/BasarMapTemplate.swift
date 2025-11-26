import SwiftUI
import MapKit

// Plantilla genérica para bazares
struct BasarMapTemplate: View {
    let basarName: String
    let address: String
    let region: MKCoordinateRegion
    let coordinate: CLLocationCoordinate2D

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Map(initialPosition: .region(region)) {
                Marker(basarName, coordinate: coordinate)
                Annotation(basarName, coordinate: coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 40, height: 40)
                        .background(.white)
                        .clipShape(Circle())
                }
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(basarName)
                .font(.title2)
                .bold()

            Text(address)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle(basarName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ====== BAZARES ORIGINALES (1–8) ======

// BASAR 1 – Monte Cristal 1
struct Basar1View: View {
    let basarName = "Monte Cristal 1"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.65055,
        longitude: -100.11140    // TODO: ajustar a coordenada real
    )
    let address = """
Ave. Monte Cristal 141
Col. Monte Cristal 1er Sector
Juárez, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 2 – San Marcos / Villas Santo Domingo
struct Basar2View: View {
    let basarName = "San Marcos - Villas Santo Domingo"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6750,
        longitude: -100.0900     // TODO: ajustar
    )
    let address = """
Av. Diego Díaz de Berlanga 172
Col. San Marcos / Villas Santo Domingo
San Nicolás de los Garza, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 3 – Buena Vista Carmen
struct Basar3View: View {
    let basarName = "Buena Vista Carmen"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7770,
        longitude: -100.1050     // TODO: ajustar
    )
    let address = """
Av. Vista Regia 580
Col. Buena Vista
El Carmen, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 4 – Centrito del Valle
struct Basar4View: View {
    let basarName = "Centrito del Valle"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6751,
        longitude: -100.3139     // TODO: ajustar
    )
    let address = """
Río Mississippi 44
Col. Del Valle
San Pedro Garza García, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 5 – Tres Caminos Guadalupe
struct Basar5View: View {
    let basarName = "Tres Caminos Guadalupe"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7280,
        longitude: -100.3070     // TODO: ajustar
    )
    let address = """
1a Privada 901
Col. Tres Caminos Norte
Guadalupe, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 6 – Las Avenidas Guadalupe
struct Basar6View: View {
    let basarName = "Las Avenidas Guadalupe"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6950,
        longitude: -100.2650     // TODO: ajustar
    )
    let address = """
Av. Eloy Cavazos 4301
Col. Residencial Las Avenidas
Guadalupe, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 7 – Infonavit La Huasteca
struct Basar7View: View {
    let basarName = "Infonavit La Huasteca"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6420,
        longitude: -100.3440     // TODO: ajustar
    )
    let address = """
Calle Cada del Obrerón 317
Col. Infonavit La Huasteca
Santa Catarina, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 8 – Praderas de Girasoles Escobedo
struct Basar8View: View {
    let basarName = "Praderas de Girasoles Escobedo"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7500,
        longitude: -100.2000     // TODO: ajustar
    )
    let address = """
Paseo de la Amistad 542
Col. Praderas de Girasoles
Escobedo, N.L.
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// ====== BAZARES DE LOS FLYERS (CONCORDIA, ETC.) 9–18 ======

// BASAR 9 – Concordia
struct Basar9View: View {
    let basarName = "Concordia"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7830,
        longitude: -100.1760     // TODO: ajustar
    )
    let address = """
Fresno 610
Col. Prados de Santa Rosa
Apodaca, N.L.
Tel. 81 42 85 12 59
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 10 – Bernardo Reyes
struct Basar10View: View {
    let basarName = "Bernardo Reyes"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7150,
        longitude: -100.3390     // TODO: ajustar
    )
    let address = """
Bernardo Reyes 5656
Col. Ferrocarrilera, C.P. 64250
Monterrey, N.L.
Tel. 81 1357 3308
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 11 – Acapulco
struct Basar11View: View {
    let basarName = "Acapulco"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6820,
        longitude: -100.2410     // TODO: ajustar
    )
    let address = """
Blvd. Acapulco 415 Local 2 y 3
Fracc. Balcones de San Miguel
(Al lado de Bodega Aurrera)
Guadalupe, N.L.
Tel. 81 41 97 33 59
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 12 – San Gilberto
struct Basar12View: View {
    let basarName = "San Gilberto"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6750,
        longitude: -100.4930     // TODO: ajustar
    )
    let address = """
Ave. Perimetral Norte 512
Col. San Gilberto, C.P. 66369
Santa Catarina, N.L.
Tel. 81 1338 4036
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 13 – Guadalupe Centro
struct Basar13View: View {
    let basarName = "Guadalupe"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6760,
        longitude: -100.2570     // TODO: ajustar
    )
    let address = """
Ignacio Zaragoza 233
Cruz con Morelos, Centro
C.P. 67100
Guadalupe, N.L.
Tel. 81 8191 1950
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 14 – San Nicolás
struct Basar14View: View {
    let basarName = "San Nicolás"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7410,
        longitude: -100.3020     // TODO: ajustar
    )
    let address = """
Escobedo 144 Pte.
Cruz con Treviño, Zona Centro
C.P. 66400
San Nicolás de los Garza, N.L.
Tel. 81 8007 4580
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 15 – Escobedo
struct Basar15View: View {
    let basarName = "Escobedo"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7990,
        longitude: -100.3180     // TODO: ajustar
    )
    let address = """
Ave. Benito Juárez 184-A
Col. Residencial Escobedo
C.P. 66057
Escobedo, N.L.
Tel. 81 8058 3163
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 16 – Chula Vista
struct Basar16View: View {
    let basarName = "Chula Vista"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6840,
        longitude: -100.1870     // TODO: ajustar
    )
    let address = """
Carretera a Reynosa (Ave. Benito Juárez) 225
Col. Chula Vista, C.P. 67188
Guadalupe, N.L.
Tel. 81 1093 7461
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 17 – Arteaga
struct Basar17View: View {
    let basarName = "Arteaga"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6735,
        longitude: -100.3070     // TODO: ajustar
    )
    let address = """
Emilio Carranza 839 Ote
Centro, C.P. 64000
Entre Arteaga y Carlos Salazar
Monterrey, N.L.
Tel. 81 83 74 92 80
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 18 – Cumbres
struct Basar18View: View {
    let basarName = "Cumbres"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7320,
        longitude: -100.3730     // TODO: ajustar
    )
    let address = """
Enrique C. Livas 108
Cumbres 1er Sector
C.P. 64349
Monterrey, N.L.
Tel. 81 8123 3576
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// ====== ÚLTIMOS FLYERS (ALAMEDA, FAMA, ETC.) 19–23 ======

// BASAR 19 – Alameda
struct Basar19View: View {
    let basarName = "Alameda"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6728,
        longitude: -100.3130     // TODO: ajustar
    )
    let address = """
Aramberri 913 Pte (Frente a Alameda)
Col. Centro, C.P. 64000
Monterrey, N.L.
Tel. 81 83 42 76 80
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 20 – Fama
struct Basar20View: View {
    let basarName = "Fama"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6670,
        longitude: -100.4500     // TODO: ajustar
    )
    let address = """
Manuel J. Clouthier 201, Local 3
Col. Fama, C.P. 66100
Santa Catarina, N.L.
Tel. 81 83 15 80 50
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 21 – Divina
struct Basar21View: View {
    let basarName = "Divina"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6691,
        longitude: -100.3019     // TODO: ajustar
    )
    let address = """
Florencio Antillón 1223
Col. Centro, C.P. 64720
Monterrey, N.L.
Tel. 81 83 40 40 77
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 22 – San Rafael
struct Basar22View: View {
    let basarName = "San Rafael"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.6845,
        longitude: -100.2290     // TODO: ajustar
    )
    let address = """
Ave. San Rafael 90, Bodega 8
Col. Ángel Martínez Villarreal
Guadalupe, N.L., C.P. 67110
Tel. 811 159 2629
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}

// BASAR 23 – Solidaridad
struct Basar23View: View {
    let basarName = "Solidaridad"
    let coordinate = CLLocationCoordinate2D(
        latitude: 25.7500,
        longitude: -100.3050     // TODO: ajustar
    )
    let address = """
Criminólogos 601 Lote 22
Col. Trazo Marco, C.P. 64103
Monterrey, N.L.
Tel. 81 27 04 38 70
"""

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    var body: some View {
        BasarMapTemplate(
            basarName: basarName,
            address: address,
            region: region,
            coordinate: coordinate
        )
    }
}
//arreglo de objetos
//clase de bazares
// Preview de ejemplo
#Preview {
    NavigationStack {
        Basar1View()   // cámbialo por el bazar que quieras probar
    }
}

