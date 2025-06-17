
import Foundation
import RealmSwift

final class RealmWordDomainModel: Object {
    @Persisted(primaryKey: true)  var id: UUID = .init()
    @Persisted var image: String = ""
    @Persisted var level: Int = 0
    @Persisted var isResolved: Bool = false
        
    convenience init(
        id: UUID = .init(),
        image: String,
        level: Int,
        isResolved: Bool
    ) {
        self.init()
        self.id = id
        self.image = image
        self.level = level
        self.isResolved = isResolved
    }
}
