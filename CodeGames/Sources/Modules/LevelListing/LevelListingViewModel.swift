

import Foundation

final class LevelListingViewModel: ObservableObject {
    @Published var items: [LvlItemViewModel]
    @Published var category: Games
    
    init(items: [LvlItemViewModel], category: Games) {
        self.items = items
        self.category = category
    }
}

enum Games {
    case code
    case words
}
