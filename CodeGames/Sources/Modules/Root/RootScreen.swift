
import SwiftUI

struct RootScreen: View {
    @State private var viewModel: RootViewModel = .init()
    @State private var path: NavigationPath = .init()
    @StateObject private var authMain = AuthMain()
    
    var body: some View {
        NavigationStack(path: $path) {
            mainView
                .onAppear {
                    viewModel.loadData()
                }
                .navigationDestination(for: Router.self) { router in
                    switch router {
                    case .main:
                        MainScreen(path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .info:
                        InfoScreen()
                            .navigationBarBackButtonHidden(true)
                    case .lvlList(let games):
                        LevelListingScreen(viewModel: .init(items: viewModel.loadLevels(category: games), category: games), path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .profile:
                        ProfileScreen(viewModel: .init(), authMain: authMain, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .game1(let item):
                        CodeDecoderScreen(viewModel: .init(id: item.id, currentLevel: item.level), path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .game2(let item):
                        WordDecoderScreen(viewModel: .init(id: item.id, currentLevel: item.level), path: $path)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
    
    @ViewBuilder
    var mainView: some View {
        if authMain.userSession != nil {
            MainScreen(path: $path)
        } else {
            AuthorizationScreen(viewModel: authMain, path: $path)
        }
    }
}

#Preview {
    RootScreen()
}
