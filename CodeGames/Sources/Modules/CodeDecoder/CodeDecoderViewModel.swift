
import Foundation

class CodeDecoderViewModel: ObservableObject {
    @Published var id: String
    @Published var disks: [Int] = [0, 0, 0]
    @Published var targetSum: Int = 0
    @Published var sumComponents: (Int, Int) = (0, 0)
    @Published var isUnlocked: Bool = false
    @Published var currentLevel: Int
    @Published var maxLevel: Int = 8
    
    @Published var timeRemaining: Int = 60
    private var timer: Timer?
    
    var timeFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    private var targetCombination: [Int] = []

    init(id: String, currentLevel: Int) {
        self.id = id
        self.currentLevel = currentLevel
        resetLevel()
    }

    var diskCount: Int {
        return min(2 + currentLevel / 2, 5)
    }

    func checkCombination() {
        isUnlocked = (disks == targetCombination)
        if isUnlocked {
            stopTimer()
        }
    }

    func resetLevel() {
        let count = diskCount
        disks = Array(repeating: 0, count: count)
        targetCombination = (0..<count).map { _ in Int.random(in: 0...9) }
        targetSum = targetCombination.reduce(0, +)
        sumComponents = generateSumComponents(for: targetSum)
        isUnlocked = false
        timeRemaining = 60
        startTimer()
        print("Target: \(targetCombination)")
    }

    private func generateSumComponents(for target: Int) -> (Int, Int) {
        let firstPart = Int.random(in: (target / 3)...(target * 2 / 3))
        let secondPart = target - firstPart
        return (firstPart, secondPart)
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.resetLevel()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

