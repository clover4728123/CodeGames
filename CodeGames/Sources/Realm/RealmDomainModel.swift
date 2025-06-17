

import Foundation
import RealmSwift

final class RealmDomainModel: Object {
    @Persisted(primaryKey: true)  var id: UUID = .init()
    @Persisted var codeLevels: List<RealmCodeDomainModel>
    @Persisted var wordLevels: List<RealmWordDomainModel>
        
    convenience init(
        id: UUID = .init(),
        codeLevels: List<RealmCodeDomainModel>,
        wordLevels: List<RealmWordDomainModel>
    ) {
        self.init()
        self.id = id
        self.codeLevels = codeLevels
        self.wordLevels = wordLevels
    }
}
