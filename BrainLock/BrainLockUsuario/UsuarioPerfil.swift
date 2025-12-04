import SwiftUI

struct UsuarioPerfil: View {

    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        VStack(spacing: 50) {

            // Logo arriba del perfil
            Image("ave")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.top, 70)

            Text("Perfil del Usuario")
                .font(.largeTitle.bold())
                .foregroundColor(azulOscuro)

            VStack(spacing: 12) {
                Text("Correo:")
                    .font(.title3)
                    .foregroundColor(.gray)

                Text(userEmail)
                    .font(.title2.bold())
                    .foregroundColor(azulOscuro)
            }

            Spacer()

            Button {
                isLoggedIn = false
            } label: {
                Text("Cerrar sesión")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(azulOscuro)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
        .background(
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    UsuarioPerfil()
}
