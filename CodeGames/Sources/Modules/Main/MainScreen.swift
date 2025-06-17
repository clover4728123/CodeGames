
import SwiftUI

struct MainScreen: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack() {
                Spacer()
                Button {
                    path.append(Router.info)
                } label: {
                    Image(.infoButton)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 60, height: 60)
            }
            
            Button {
                path.append(Router.lvlList(.words))
            } label: {
                Image(.mainGame1)
                    .resizable()
                    .scaledToFit()
            }
            
            Button {
                path.append(Router.lvlList(.code))
            } label: {
                Image(.mainGame2)
                    .resizable()
                    .scaledToFit()
            }
            
            Button {
                path.append(Router.profile)
            } label: {
                Image(.accountButton)
                    .resizable()
                    .scaledToFit()
            }
            .padding(.horizontal, 60)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    MainScreen(path: .constant(.init()))
}
