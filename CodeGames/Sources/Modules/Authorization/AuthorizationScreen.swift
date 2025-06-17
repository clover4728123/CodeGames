
import SwiftUI

extension AuthorizationScreen: AuthorizationProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
    }
}

struct AuthorizationScreen: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @ObservedObject var viewModel: AuthMain
    @State private var isAuth = true
    
    enum AlertType {
        case error(String)
        case validation
        case none
    }
    
    @State private var alertType: AlertType = .none
    @State private var showAlert = false
    
    @Namespace private var animation
    
    @Binding var path: NavigationPath
    
    init(viewModel: AuthMain, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(isAuth ? "Log in" : "Registration")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 42, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: Color(r: 58, g: 0, b: 0), radius: 4, x: 0, y: 0)
                .padding(.bottom, 24)
                .id(isAuth ? "login_title" : "registration_title")
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut, value: isAuth)
                
            VStack(spacing: 0) {
                if !isAuth {
                    Text("Name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    
                    TextField("", text: $name, prompt: Text(""))
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(12)
                        .padding(.top, 8)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
                
                Text("Email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                
                TextField("", text: $email, prompt: Text(""))
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.top, 8)
                    .matchedGeometryEffect(id: "emailField", in: animation)
                
                Text("Password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                
                SecureField( "", text: $password, prompt: Text(""))
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.top, 8)
                    .matchedGeometryEffect(id: "passwordField", in: animation)
                
                if !isAuth {
                    Text("Confirm password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    
                    SecureField( "", text: $confirmPassword, prompt: Text(""))
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(12)
                        .padding(.top, 8)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                }
            }
            .background(.clear)
            .padding(16)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(LinearGradient(colors: [
                        Color.init(r: 249, g: 237, b: 10),
                        Color.init(r: 255, g: 166, b: 0)
                    ], startPoint: .top, endPoint: .bottom), lineWidth: 7)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .cornerRadius(22)
            
            Button {
                if isAuth {
                    Task {
                        do {
                            try await viewModel.signIn(email: email, password: password)
                            if !viewModel.text.isEmpty {
                                alertType = .error(viewModel.text)
                                showAlert = true
                            }
                        } catch {
                            alertType = .error(viewModel.text)
                            showAlert = true
                        }
                    }
                } else {
                    if isFormValid {
                        Task {
                            do {
                                try await viewModel.createUser(withEmail: email, password: password, name: name)
                                if !viewModel.text.isEmpty {
                                    alertType = .error(viewModel.text)
                                    showAlert = true
                                }
                            } catch {
                                alertType = .error(viewModel.text)
                                showAlert = true
                            }
                        }
                    } else {
                        alertType = .validation
                        showAlert = true
                    }
                }
            } label: {
                Text(isAuth ? "Log in" : "Create")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 32)
            }
            .background(
                LinearGradient(colors: [
                    Color.init(r: 179, g: 57, b: 1),
                    Color.init(r: 255, g: 81, b: 0)
                ], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 28)
            .transition(.scale.combined(with: .opacity))
            .id(isAuth ? "loginButton" : "registerButton")
            
            Spacer()
            
            VStack(spacing: 0) {

                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isAuth.toggle()
                    }
                } label: {
                    Image(isAuth ? .createButton: .logInButton)
                        .resizable()
                        .scaledToFit()
                }
                .padding(.top, 12)
                .transition(.scale.combined(with: .opacity))
                .id(isAuth ? "createAccountButton" : "loginButton")
                
                Button {
                    Task {
                        await viewModel.signInAnonymously()
                    }
                } label: {
                    Image(.anonButton)
                        .resizable()
                        .scaledToFit()
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(isAuth ? .authBackground : .registrationBackground)
                .resizable()
                .ignoresSafeArea()
        )
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .error(let message):
                return Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .cancel()
                )
            case .validation:
                return Alert(
                    title: Text("Error"),
                    message: Text("Please ensure your email address is valid and not empty, your password is at least 6 characters long, and your confirmation password matches your password."),
                    dismissButton: .cancel()
                )
            case .none:
                return Alert(
                    title: Text("Error"),
                    message: Text("An unknown error occurred"),
                    dismissButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    AuthorizationScreen(viewModel: .init(), path: .constant(.init()))
}
