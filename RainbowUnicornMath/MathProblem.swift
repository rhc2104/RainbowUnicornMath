//
//  MathProblem.swift
//  RainbowUnicornMath
//

import Foundation

struct MathProblem {
    let a: Int
    let b: Int
    let c: Int
    let correctAnswer: Int
    let choices: [Int]

    var questionText: String {
        return "\(a) + \(b) - \(c) = ?"
    }

    static func generate() -> MathProblem {
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...9)
        let c = Int.random(in: 0...9)
        let correct = a + b - c

        let wrongAnswers = generateWrongAnswers(correct: correct)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: c, correctAnswer: correct, choices: allChoices)
    }

    private static func generateWrongAnswers(correct: Int) -> [Int] {
        var wrong: [Int] = []
        let offsets = [-9, -8, -7, -6, -5, -4, -3, 3, 4, 5, 6, 7, 8, 9].shuffled()

        for offset in offsets where wrong.count < 2 {
            let candidate = correct + offset
            // Ensure at least 3 apart from correct and all other wrong answers
            let validSpacing = wrong.allSatisfy { abs($0 - candidate) >= 3 }
            if validSpacing {
                wrong.append(candidate)
            }
        }

        // Fallback if we couldn't find 2 wrong answers (shouldn't happen)
        while wrong.count < 2 {
            let candidate = correct + (wrong.count == 0 ? 5 : -5)
            if !wrong.contains(candidate) {
                wrong.append(candidate)
            }
        }

        return wrong
    }
}
