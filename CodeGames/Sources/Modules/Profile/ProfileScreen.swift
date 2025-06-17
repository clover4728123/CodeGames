

import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    @StateObject private var viewModel: ProfileViewModel
    @ObservedObject var authMain: AuthMain
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var isPresentPrivacyWebView = false
    @State private var isPresentAlert = false
    @State private var showingImagePicker = false
    @State private var selectedImage: PhotosPickerItem? = nil
    
    init(viewModel: ProfileViewModel, authMain: AuthMain, path: Binding<NavigationPath>) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.authMain = authMain
        self._path = path
    }
    
    var body: some View {
        VStack {
            HStack() {
                Button {
                    dismiss()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 60, height: 60)
                
                Spacer()
            }
            
            Spacer()
            
            HStack {
                if let image = viewModel.displayImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Image(.accIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                
                Text(authMain.currentuser?.name ?? "Anonimous")
                    .foregroundStyle(.white)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
                    .padding(.horizontal, 12)
            }
            
            Spacer()
            Spacer()
            Spacer()
            
            Button {
                isPresentPrivacyWebView = true
            } label: {
                Image(.privacyButton)
                    .resizable()
                    .scaledToFit()
            }
            .sheet(isPresented: $isPresentPrivacyWebView) {
                NavigationStack {
                    WebView(url: URL(string: "https://sites.google.com/view/mindlock/privacy-policy")!)
                        .ignoresSafeArea()
                        .navigationTitle("Privacy Policy")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            
            Button {
                authMain.signOut()
                dismiss()
            } label: {
                Image(.logOutButton)
                    .resizable()
                    .scaledToFit()
            }
            
            Button {
                isPresentAlert = true
            } label: {
                Image(.deleteButton)
                    .resizable()
                    .scaledToFit()
            }
            .alert("Are you sure?", isPresented: $isPresentAlert) {
                Button("Delete", role: .destructive) {
                    authMain.deleteUserAccount { result in
                        switch result {
                        case .success():
                            UserDefaults.standard.set("", forKey: "userProfileImage")
                            authMain.userSession = nil
                            authMain.currentuser = nil
                            dismiss()
                        case .failure(let error):
                            print("ERROR DELELETING: \(error.localizedDescription)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("Are you sure you want to delete the account?")
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.infoBackground)
                .resizable()
                .ignoresSafeArea()
        )
        .photosPicker(
            isPresented: $showingImagePicker,
            selection: $selectedImage,
            matching: .images,
            photoLibrary: .shared()
        )
        .task(id: selectedImage) {
            if let item = selectedImage {
                await viewModel.saveProfileImageAsync(item: item)
                selectedImage = nil
            }
        }
    }
}

#Preview {
    ProfileScreen(viewModel: .init(), authMain: .init(), path: .constant(.init()))
}
