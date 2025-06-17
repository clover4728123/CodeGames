

import SwiftUI

class WordDecoderViewModel: ObservableObject {
    @Published var id: String
    @Published var encodedMessage: String = ""
    @Published var decodedMessage: String = ""
    @Published var userInput: String = ""
    @Published var isSolved: Bool = false
    @Published var currentLevel: Int

    @Published var timeRemaining: Int = 60
    @Published var timeFormatted: String = "01:00"

    private var timer: Timer?
    private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let maxLevel = 8
    private var shift: Int = 0

    init(id: String, currentLevel: Int) {
        self.id = id
        self.currentLevel = currentLevel
    }

    func generateMessage() {
        let messageLength = min(currentLevel + 3, 10)
        decodedMessage = generateRandomMessage(length: messageLength)

        shift = Int.random(in: 1...25)
        encodedMessage = decodedMessage.map { char in
            guard let index = alphabet.firstIndex(of: char) else { return String(char) }
            let shiftedIndex = (alphabet.distance(from: alphabet.startIndex, to: index) + shift) % alphabet.count
            return String(alphabet[alphabet.index(alphabet.startIndex, offsetBy: shiftedIndex)])
        }.joined()

        userInput = ""
        isSolved = false

        startTimer()
    }

    func checkSolution() {
        if userInput.uppercased() == decodedMessage {
            isSolved = true
            timer?.invalidate()
        } else {
            isSolved = false
        }
    }

    private func generateRandomMessage(length: Int) -> String {
        String((0..<length).map { _ in alphabet.randomElement()! })
    }

    private func startTimer() {
        timeRemaining = 60
        updateFormattedTime()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateFormattedTime()
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.handleTimeout()
            }
        }
    }

    private func updateFormattedTime() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timeFormatted = String(format: "%02d:%02d", minutes, seconds)
    }

    private func handleTimeout() {
        isSolved = false
    }
}

