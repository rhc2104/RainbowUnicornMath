//
//  MathProblem.swift
//  RainbowUnicornMath
//

import Foundation

enum MathLevel: Int, CaseIterable {
    case addition = 1
    case subtraction = 2
    case addSubtract = 3
    case multiplication = 4
    case division = 5

    var displayName: String {
        switch self {
        case .addition: return "Addition"
        case .subtraction: return "Subtraction"
        case .addSubtract: return "Add & Subtract"
        case .multiplication: return "Multiplication"
        case .division: return "Division"
        }
    }

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"  // U+2212 mathematical minus (same width as +)
        case .addSubtract: return "±"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }
}

struct MathProblem {
    let a: Int
    let b: Int
    let c: Int?
    let correctAnswer: Int
    let choices: [Int]
    let level: MathLevel

    var questionText: String {
        switch level {
        case .addition:
            return "\(a) + \(b) = ?"
        case .subtraction:
            return "\(a) - \(b) = ?"
        case .addSubtract:
            return "\(a) + \(b) - \(c!) = ?"
        case .multiplication:
            return "\(a) × \(b) = ?"
        case .division:
            return "\(a) ÷ \(b) = ?"
        }
    }

    /// Unique key for this problem. For commutative operations, normalizes order.
    var uniqueKey: String {
        switch level {
        case .addition:
            // Commutative: normalize so smaller number comes first
            let sorted = [a, b].sorted()
            return "add_\(sorted[0])_\(sorted[1])"
        case .subtraction:
            return "sub_\(a)_\(b)"
        case .addSubtract:
            return "addsub_\(a)_\(b)_\(c!)"
        case .multiplication:
            // Commutative: normalize so smaller number comes first
            let sorted = [a, b].sorted()
            return "mul_\(sorted[0])_\(sorted[1])"
        case .division:
            return "div_\(a)_\(b)"
        }
    }

    static func generate(for level: MathLevel, usedProblems: inout Set<String>) -> MathProblem {
        var attempts = 0
        let maxAttempts = 100

        while attempts < maxAttempts {
            let problem: MathProblem
            switch level {
            case .addition:
                problem = generateAddition()
            case .subtraction:
                problem = generateSubtraction()
            case .addSubtract:
                problem = generateAddSubtract()
            case .multiplication:
                problem = generateMultiplication()
            case .division:
                problem = generateDivision()
            }

            if !usedProblems.contains(problem.uniqueKey) {
                usedProblems.insert(problem.uniqueKey)
                return problem
            }

            attempts += 1
        }

        // Fallback: return any problem if we can't find a unique one
        // (shouldn't happen with 15 questions and large problem space)
        switch level {
        case .addition:
            return generateAddition()
        case .subtraction:
            return generateSubtraction()
        case .addSubtract:
            return generateAddSubtract()
        case .multiplication:
            return generateMultiplication()
        case .division:
            return generateDivision()
        }
    }

    // MARK: - Level-specific generation

    private static func generateAddition() -> MathProblem {
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...9)
        let correct = a + b

        let wrongAnswers = generateWrongAnswers(correct: correct, range: -6...6)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: nil, correctAnswer: correct, choices: allChoices, level: .addition)
    }

    private static func generateSubtraction() -> MathProblem {
        // Ensure a >= b so answer is non-negative
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...a)
        let correct = a - b

        let wrongAnswers = generateWrongAnswers(correct: correct, range: -6...6)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: nil, correctAnswer: correct, choices: allChoices, level: .subtraction)
    }

    private static func generateAddSubtract() -> MathProblem {
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...9)
        let c = Int.random(in: 0...9)
        let correct = a + b - c

        let wrongAnswers = generateWrongAnswers(correct: correct, range: -9...9)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: c, correctAnswer: correct, choices: allChoices, level: .addSubtract)
    }

    private static func generateMultiplication() -> MathProblem {
        // Use 1-9 to avoid trivial 0 multiplications
        let a = Int.random(in: 1...9)
        let b = Int.random(in: 1...9)
        let correct = a * b

        let wrongAnswers = generateWrongAnswers(correct: correct, range: -15...15)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: nil, correctAnswer: correct, choices: allChoices, level: .multiplication)
    }

    private static func generateDivision() -> MathProblem {
        // Generate clean division: pick quotient and divisor, calculate dividend
        let quotient = Int.random(in: 1...9)
        let divisor = Int.random(in: 1...9)
        let dividend = quotient * divisor

        let wrongAnswers = generateWrongAnswers(correct: quotient, range: -6...6)
        var allChoices = [quotient] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: dividend, b: divisor, c: nil, correctAnswer: quotient, choices: allChoices, level: .division)
    }

    // MARK: - Wrong answer generation

    private static func generateWrongAnswers(correct: Int, range: ClosedRange<Int>) -> [Int] {
        var wrong: [Int] = []
        let offsets = Array(range).filter { abs($0) >= 3 }.shuffled()

        for offset in offsets where wrong.count < 2 {
            let candidate = correct + offset
            // Ensure at least 3 apart from correct and all other wrong answers
            let validSpacing = wrong.allSatisfy { abs($0 - candidate) >= 3 }
            if validSpacing {
                wrong.append(candidate)
            }
        }

        // Fallback if we couldn't find 2 wrong answers
        while wrong.count < 2 {
            let candidate = correct + (wrong.count == 0 ? 5 : -5)
            if !wrong.contains(candidate) && wrong.allSatisfy({ abs($0 - candidate) >= 3 }) {
                wrong.append(candidate)
            } else {
                wrong.append(correct + (wrong.count == 0 ? 3 : -3))
            }
        }

        return wrong
    }
}
