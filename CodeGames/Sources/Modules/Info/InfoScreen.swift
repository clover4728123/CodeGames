

import SwiftUI

struct InfoScreen: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack() {
                Button {
                    dismiss()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 60, height: 60)
                
                Spacer()
                
                Image(.infoButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            VStack {
                HStack() {
                    Spacer()
                    
                    Text("info")
                        .foregroundStyle(.white)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .textCase(.uppercase)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                }
                
                ScrollView(showsIndicators: false) {
                    Text("""
                        🔐 Game 1: Code Lock
                        Unlock the code in 60 seconds.
                        Rotate the number dials to match the clue.
                        Example: the sum of all numbers must be 15.

                        With each level:
                        More dials,
                        Harder logic,
                        Same time limit.

                        Can you crack every lock before time runs out?

                        🔤 Game 2: Caesar Cipher
                        Decrypt the message in one minute.
                        Each level is a coded message using the Caesar cipher.
                        Shift the letters and reveal the hidden text.

                        With each level:
                        Messages get longer,
                        Time stays the same,
                        Pressure builds.

                        Think fast.
                        Decode faster.
                        Beat the clock.
                        """)
                        .foregroundStyle(.white)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .padding(12)
                }
            }
            .background(Color.init(r: 174, g: 174, b: 174, opacity: 0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(LinearGradient(colors: [
                        Color.init(r: 249, g: 237, b: 10),
                        Color.init(r: 255, g: 166, b: 0)
                    ], startPoint: .top, endPoint: .bottom), lineWidth: 7)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .cornerRadius(22)
            .padding(.vertical, 52)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.infoBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    InfoScreen()
}
