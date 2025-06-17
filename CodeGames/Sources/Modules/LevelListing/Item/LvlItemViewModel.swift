

import Foundation

final class LvlItemViewModel: ObservableObject, Hashable {
    @Published var id: String
    @Published var image: String
    @Published var title: String
    @Published var level: Int
    
    init(id: String, image: String, title: String, level: Int) {
        self.id = id
        self.image = image
        self.title = title
        self.level = level
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LvlItemViewModel, rhs: LvlItemViewModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.title == rhs.title &&
            lhs.level == rhs.level
    }
}
