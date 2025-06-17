
import SwiftUI

struct CodeDecoderScreen: View {
    @ObservedObject private var viewModel: CodeDecoderViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: CodeDecoderViewModel, path: Binding<NavigationPath>) {
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
                }
                Spacer()
                
                Text("\(viewModel.sumComponents.0) + \(viewModel.sumComponents.1)")
                    .foregroundStyle(Color(r: 248, g: 211, b: 78))
                    .font(.system(size: 42, weight: .heavy, design: .default))
                    .textCase(.uppercase)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                
                VStack {
                    ForEach(0..<viewModel.disks.count, id: \.self) { index in
                        HStack {
                            Button {
                                if viewModel.disks[index] > 0 {
                                    viewModel.disks[index] -= 1
                                }
                            } label: {
                                Image(.minusButton)
                                    .resizable()
                                    .scaledToFit()
                            }
                            
                            Text("\(viewModel.disks[index])")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color(r: 248, g: 211, b: 78))
                                .font(.system(size: 34, weight: .bold, design: .default))
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .textCase(.uppercase)
                                .padding()
                                .background(
                                    LinearGradient(colors: [
                                        Color(r: 255, g: 0, b: 4),
                                        Color(r: 141, g: 16, b: 0)
                                        
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(r: 255, g: 62, b: 0), radius: 4, x: 0, y: 0)
                                .padding(8)
                            
                            Button {
                                if viewModel.disks[index] < 9 {
                                    viewModel.disks[index] += 1
                                }
                            } label: {
                                Image(.plusButton)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                }

                Spacer()
                if viewModel.isUnlocked {
                    Image(.openButton)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(viewModel.showWrongAttempt ? .wrongButton : .closeButton)
                        .resizable()
                        .scaledToFit()
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showWrongAttempt)
                }

                Spacer()
                HStack {
                    Button {
                        viewModel.checkCombination()
                    } label: {
                        Image(.checkButton)
                            .resizable()
                            .scaledToFit()
                    }

                    Button {
                        viewModel.resetLevel()
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
                Image(.onbBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            if viewModel.isUnlocked {
                FinalScreen {
                    dismiss()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 18)
                .background(Color.black.opacity(0.5))
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.isUnlocked)
        .onAppear {
            viewModel.resetLevel()
        }
    }
}

#Preview {
    CodeDecoderScreen(viewModel: .init(id: "", currentLevel: 8), path: .constant(.init()))
}
