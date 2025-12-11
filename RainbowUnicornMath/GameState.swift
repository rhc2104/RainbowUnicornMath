//
//  GameState.swift
//  RainbowUnicornMath
//

import Foundation

@MainActor
class GameState {
    static let shared = GameState()

    private init() {}

    var selectedLevel: MathLevel = .addSubtract
    var currentQuestion: Int = 0
    var correctAnswers: Int = 0
    let totalQuestions: Int = 15
    var usedProblems: Set<String> = []

    var starsEarned: Int {
        switch correctAnswers {
        case 0...3:
            return 1
        case 4...7:
            return 2
        case 8...11:
            return 3
        case 12...14:
            return 4
        case 15:
            return 5
        default:
            return 1
        }
    }

    var isGameComplete: Bool {
        return currentQuestion >= totalQuestions
    }

    var progressText: String {
        return "Question \(currentQuestion + 1) of \(totalQuestions)"
    }

    func reset() {
        currentQuestion = 0
        correctAnswers = 0
        usedProblems.removeAll()
    }

    func recordAnswer(correct: Bool) {
        if correct {
            correctAnswers += 1
        }
        currentQuestion += 1
    }
}
