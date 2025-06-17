
import Foundation
import RealmSwift

final class RootViewModel: ObservableObject {
    let storage: MainDomainModelStorage = .init()
    
    func loadData() {
        guard storage.read().isEmpty else { return }
        let wordLevels = List<RealmWordDomainModel>()
        let codeLevels = List<RealmCodeDomainModel>()
        
        wordLevels.append(.init(image: "lvlC1", level: 1, isResolved: true))
        wordLevels.append(.init(image: "lvlC2", level: 2, isResolved: false))
        wordLevels.append(.init(image: "lvlC3", level: 3, isResolved: false))
        wordLevels.append(.init(image: "lvlC4", level: 4, isResolved: false))
        wordLevels.append(.init(image: "lvlC5", level: 5, isResolved: false))
        wordLevels.append(.init(image: "lvlC6", level: 6, isResolved: false))
        wordLevels.append(.init(image: "lvlC7", level: 7, isResolved: false))
        wordLevels.append(.init(image: "lvlC8", level: 8, isResolved: false))
        
        codeLevels.append(.init(image: "lvlW1", level: 1, isResolved: true))
        codeLevels.append(.init(image: "lvlW2", level: 2, isResolved: false))
        codeLevels.append(.init(image: "lvlW3", level: 3, isResolved: false))
        codeLevels.append(.init(image: "lvlW4", level: 4, isResolved: false))
        codeLevels.append(.init(image: "lvlW5", level: 5, isResolved: false))
        codeLevels.append(.init(image: "lvlW6", level: 6, isResolved: false))
        codeLevels.append(.init(image: "lvlW7", level: 7, isResolved: false))
        codeLevels.append(.init(image: "lvlW8", level: 8, isResolved: false))
        
        storage.store(item: .init(codeLevels: codeLevels, wordLevels: wordLevels))
    }
    
    func loadLevels(category: Games) -> [LvlItemViewModel] {
        if category == .code {
            let levelItems: [LvlItemViewModel] = storage.read().first?.codeLevels
                .compactMap { makeCodesCellViewModel(for: $0) } ?? []
            return levelItems
        } else {
            let levelItems: [LvlItemViewModel] = storage.read().first?.wordLevels
                .compactMap { makeWordsCellViewModel(for: $0) } ?? []
            return levelItems
        }
    }
    
    func makeWordsCellViewModel(
        for model: RealmWordDomainModel
    ) -> LvlItemViewModel? {
        return .init(id: model.id.uuidString, image: model.image, title: "LVL \(model.level)", level: model.level)
    }
    
    
    func makeCodesCellViewModel(
        for model: RealmCodeDomainModel
    ) -> LvlItemViewModel? {
        return .init(id: model.id.uuidString, image: model.image, title: "LVL \(model.level)", level: model.level)
    }
}
