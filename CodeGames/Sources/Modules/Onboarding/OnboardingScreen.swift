

import SwiftUI

struct OnboardingScreen: View {
    @State private var isRotating = false
    @State private var isLoading = false

    var body: some View {
        if isLoading {
            RootScreen()
        } else {
            VStack {
                Text("loading...")
                    .foregroundStyle(.white)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(72)
                    .textCase(.uppercase)
                    .background(
                        Image(.loader)
                            .resizable()
                            .scaledToFill()
                            .rotationEffect(.degrees(isRotating ? 360 : 0))
                            .onAppear {
                                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                    isRotating = true
                                }
                            }
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(.onbBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isLoading = true
                    }
                }
            }
        }
    }
}


#Preview {
    OnboardingScreen()
}
