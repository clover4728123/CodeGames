
import Foundation

enum Router: Hashable {
    case main
    case info
    case lvlList(Games)
    case profile
    case game1(LvlItemViewModel)
    case game2(LvlItemViewModel)
}
