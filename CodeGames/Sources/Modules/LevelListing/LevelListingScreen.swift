

import SwiftUI

struct LevelListingScreen: View {
    @ObservedObject private var viewModel: LevelListingViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: LevelListingViewModel, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 10) {
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
            
            ScrollView(.vertical, content: {
                ForEach(viewModel.items, id: \.self) { item in
                    LvlItemView(viewModel: item, onTap: {
                        if viewModel.category == .code {
                            path.append(Router.game1(item))
                        } else {
                            path.append(Router.game2(item))
                        }
                    })
                }
                .padding(.top, 24)
            })
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("levelsBackground")
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    LevelListingScreen(viewModel: .init(items: [
        .init(id: "1", image: "lvlC1", title: "lvl1", level: 1),
        .init(id: "2", image: "lvlW2", title: "lvl2", level: 1),
        .init(id: "4", image: "lvlW4", title: "lvl4", level: 1)
    ], category: .words), path: .constant(.init()))
}
