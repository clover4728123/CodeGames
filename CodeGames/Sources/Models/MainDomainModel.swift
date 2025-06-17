
import Foundation
import RealmSwift

struct MainDomainModel {
    var id: UUID
    var name: String
    var codeLevels: List<RealmCodeDomainModel>
    var wordLevels: List<RealmWordDomainModel>
    
    init(
        id: UUID = .init(),
        name: String = "",
        codeLevels: List<RealmCodeDomainModel>,
        wordLevels: List<RealmWordDomainModel>
    ) {
        self.id = id
        self.name = name
        self.codeLevels = codeLevels
        self.wordLevels = wordLevels
    }
}
