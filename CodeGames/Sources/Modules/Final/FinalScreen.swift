
import SwiftUI

struct FinalScreen: View {
    var onTap: () -> Void
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    var body: some View {
        Image(.finish)
            .resizable()
            .scaledToFit()
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    FinalScreen(onTap: {})
}
