
import SwiftUI

struct LvlItemView: View {
    @ObservedObject var viewModel: LvlItemViewModel
    var onTap: () -> Void
    
    init(viewModel: LvlItemViewModel, onTap: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack(alignment: .leading) {
                Image(viewModel.image)
                    .resizable()
                    .scaledToFit()
                Text(viewModel.title)
                    .foregroundStyle(Color.init(r: 248, g: 211, b: 71))
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .textCase(.uppercase)
                    .padding(.horizontal, 24)
            }
        }
        .shadow(color: Color.init(r: 235, g: 51, b: 35), radius: 6, x: 0, y: 0)
    }
}

#Preview {
    LvlItemView(viewModel: .init(id: "", image: "lvlW2", title: "lvl1", level: 1), onTap: {})
}
