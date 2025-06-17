
import SwiftUI

struct WordDecoderScreen: View {
    @ObservedObject private var viewModel: WordDecoderViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss

    init(viewModel: WordDecoderViewModel, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.backButton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                    Spacer()
                }

                Spacer()

                Text(viewModel.timeFormatted)
                    .monospacedDigit()
                    .font(.system(size: 32, weight: .semibold, design: .default))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(colors: [
                            Color(r: 179, g: 57, b: 1),
                            Color(r: 255, g: 81, b: 0)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(12)
                    .shadow(color: Color(r: 255, g: 81, b: 0), radius: 4, x: 0, y: 0)
                
                Spacer()
                
                TextField("", text: $viewModel.userInput, prompt:
                            Text("Enter a transcript")
                                .foregroundColor(Color(r: 255, g: 212, b: 0))
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                )
                .foregroundStyle(Color(r: 255, g: 212, b: 0))
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [
                        Color(r: 255, g: 0, b: 4),
                        Color(r: 141, g: 16, b: 0)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(12)
                .shadow(color: Color(r: 255, g: 62, b: 0), radius: 4, x: 0, y: 0)

                VStack(spacing: 12) {
                    ForEach(pyramidChunks(from: viewModel.encodedMessage), id: \.self) { row in
                        HStack(spacing: 24) {
                            Spacer()
                            ForEach(row, id: \.self) { character in
                                Text(String(character))
                                    .foregroundStyle(Color(r: 255, g: 212, b: 0))
                                    .shadow(color: Color(r: 120, g: 12, b: 9), radius: 1, x: 0, y: 1)
                                    .font(.system(size: 44, weight: .bold, design: .default))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.9)
                                    .textCase(.uppercase)
                                    .padding(12)
                                    .background(
                                        LinearGradient(colors: [
                                            Color(r: 255, g: 0, b: 4),
                                            Color(r: 141, g: 16, b: 0)
                                        ], startPoint: .top, endPoint: .bottom)
                                    )
                                    .cornerRadius(12)
                                    .shadow(color: Color(r: 255, g: 62, b: 0), radius: 4, x: 0, y: 0)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.top, 24)

                Spacer()

                HStack {
                    Button {
                        viewModel.checkSolution()
                    } label: {
                        Image(.checkButton)
                            .resizable()
                            .scaledToFit()
                    }

                    Button {
                        viewModel.generateMessage()
                    } label: {
                        Image(.resetButton)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(.wordGameBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            )

            if viewModel.isSolved {
                FinalScreen {
                    dismiss()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 18)
                .background(Color.black.opacity(0.5))
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.isSolved)
        .onAppear {
            viewModel.generateMessage()
        }
    }

    func pyramidChunks(from text: String) -> [[Character]] {
        var result: [[Character]] = []
        var remaining = Array(text)
        var rowSize = 1

        while !remaining.isEmpty {
            let count = min(rowSize, remaining.count)
            let row = Array(remaining.prefix(count))
            result.append(row)
            remaining.removeFirst(count)
            rowSize += 1
        }

        return result
    }
}


#Preview {
    WordDecoderScreen(viewModel: .init(id: "", currentLevel: 9), path: .constant(.init()))
}
