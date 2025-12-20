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
    case moreComplex = 6

    var displayName: String {
        switch self {
        case .addition: return "Addition"
        case .subtraction: return "Subtraction"
        case .addSubtract: return "Add & Subtract"
        case .multiplication: return "Multiplication"
        case .division: return "Division"
        case .moreComplex: return "More Complex"
        }
    }

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"  // U+2212 mathematical minus (same width as +)
        case .addSubtract: return "±"
        case .multiplication: return "×"
        case .division: return "÷"
        case .moreComplex: return "⊛"
        }
    }

    var difficulties: [DifficultyLevel] {
        switch self {
        case .addition:
            return [.addSingleDigit, .addTens, .addTwoDigit]
        case .subtraction:
            return [.subSingleDigit, .subTens, .subTwoDigit]
        case .addSubtract:
            return [.addSubSingleDigit, .addSubTens, .addSubTwoDigit]
        case .multiplication:
            return [.mulSingleDigit, .mulTwoByOne]
        case .division:
            return [.divSingleDigit, .divLarger]
        case .moreComplex:
            return [.complexSingleDigit, .complexLarger]
        }
    }
}

enum DifficultyLevel: CaseIterable {
    // Addition (3)
    case addSingleDigit        // 0-9 + 0-9
    case addTens               // 10-19 + 10-19
    case addTwoDigit           // 20-99 + 20-99

    // Subtraction (3)
    case subSingleDigit        // 0-9 - 0-9, no negatives
    case subTens               // 10-19 - 1-19, no negatives
    case subTwoDigit           // 20-99 - 1-99, no negatives

    // Add & Subtract (3)
    case addSubSingleDigit     // 0-9 for all operands
    case addSubTens            // 10-19 for all operands
    case addSubTwoDigit        // 20-99 for all operands

    // Multiplication (2)
    case mulSingleDigit        // 1-9 × 1-9
    case mulTwoByOne           // 10-99 × 2-9

    // Division (2)
    case divSingleDigit        // quotient 1-9, divisor 1-9
    case divLarger             // quotient 10-50, divisor 2-9

    // More Complex (2)
    // Types: a×b±c, a÷b±c
    case complexSingleDigit    // 1-9 × 1-9 or ÷1-9, ±1-9
    case complexLarger         // 10-99 × 2-9 or ÷2-9 (quotient 10-50), ±1-50

    var displayName: String {
        switch self {
        case .addSingleDigit, .subSingleDigit, .addSubSingleDigit:
            return "Single Digit (0-9)"
        case .addTens, .subTens, .addSubTens:
            return "Teens (10-19)"
        case .addTwoDigit, .subTwoDigit, .addSubTwoDigit:
            return "Two-Digit (20-99)"
        case .mulSingleDigit:
            return "Single Digit (1-9)"
        case .mulTwoByOne:
            return "Two-Digit × Single"
        case .divSingleDigit:
            return "Single Digit (1-9)"
        case .divLarger:
            return "Larger Numbers"
        case .complexSingleDigit:
            return "Single Digit (1-9)"
        case .complexLarger:
            return "Larger Numbers"
        }
    }
}

/// For moreComplex level, tracks which operation pattern is used
enum ComplexOperationType: CaseIterable {
    case multiplyAdd    // a × b + c
    case multiplySubtract // a × b − c
    case divideAdd      // a ÷ b + c
    case divideSubtract // a ÷ b − c
}

struct MathProblem {
    let a: Int
    let b: Int
    let c: Int?
    let correctAnswer: Int
    let choices: [Int]
    let level: MathLevel
    let complexOp: ComplexOperationType?  // Only used for moreComplex level

    var questionText: String {
        switch level {
        case .addition:
            return "\(a) + \(b) = ?"
        case .subtraction:
            return "\(a) − \(b) = ?"
        case .addSubtract:
            return "\(a) + \(b) − \(c!) = ?"
        case .multiplication:
            return "\(a) × \(b) = ?"
        case .division:
            return "\(a) ÷ \(b) = ?"
        case .moreComplex:
            guard let op = complexOp, let cVal = c else { return "? = ?" }
            switch op {
            case .multiplyAdd:
                return "\(a) × \(b) + \(cVal) = ?"
            case .multiplySubtract:
                return "\(a) × \(b) − \(cVal) = ?"
            case .divideAdd:
                return "\(a) ÷ \(b) + \(cVal) = ?"
            case .divideSubtract:
                return "\(a) ÷ \(b) − \(cVal) = ?"
            }
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
        case .moreComplex:
            guard let op = complexOp, let cVal = c else { return "complex_0_0_0" }
            return "complex_\(op)_\(a)_\(b)_\(cVal)"
        }
    }

    /// Generate a problem for the given difficulty level
    static func generate(for difficulty: DifficultyLevel, usedProblems: inout Set<String>) -> MathProblem {
        var attempts = 0
        let maxAttempts = 100

        while attempts < maxAttempts {
            let problem = generateProblem(for: difficulty)

            if !usedProblems.contains(problem.uniqueKey) {
                usedProblems.insert(problem.uniqueKey)
                return problem
            }

            attempts += 1
        }

        // Fallback: return any problem if we can't find a unique one
        return generateProblem(for: difficulty)
    }

    private static func generateProblem(for difficulty: DifficultyLevel) -> MathProblem {
        switch difficulty {
        // Addition
        case .addSingleDigit:
            return generateAddition(range: 0...9)
        case .addTens:
            return generateAddition(range: 10...19)
        case .addTwoDigit:
            return generateAddition(range: 20...99)

        // Subtraction
        case .subSingleDigit:
            return generateSubtraction(aRange: 0...9, bRange: 0...9)
        case .subTens:
            return generateSubtraction(aRange: 10...19, bRange: 1...19)
        case .subTwoDigit:
            return generateSubtraction(aRange: 20...99, bRange: 1...99)

        // Add & Subtract
        case .addSubSingleDigit:
            return generateAddSubtract(range: 0...9)
        case .addSubTens:
            return generateAddSubtract(range: 10...19)
        case .addSubTwoDigit:
            return generateAddSubtract(range: 20...99)

        // Multiplication
        case .mulSingleDigit:
            return generateMultiplication(aRange: 1...9, bRange: 1...9)
        case .mulTwoByOne:
            return generateMultiplication(aRange: 10...99, bRange: 2...9)

        // Division
        case .divSingleDigit:
            return generateDivision(quotientRange: 1...9, divisorRange: 1...9)
        case .divLarger:
            return generateDivision(quotientRange: 10...50, divisorRange: 2...9)

        // More Complex
        case .complexSingleDigit:
            // Same as single digit multiplication (1-9 × 1-9) and division (quotient 1-9, divisor 1-9)
            return generateMoreComplex(mulARange: 1...9, mulBRange: 1...9, divQuotientRange: 1...9, divDivisorRange: 1...9, addSubRange: 1...9)
        case .complexLarger:
            // Same as mulTwoByOne (10-99 × 2-9) and divLarger (quotient 10-50, divisor 2-9)
            return generateMoreComplex(mulARange: 10...99, mulBRange: 2...9, divQuotientRange: 10...50, divDivisorRange: 2...9, addSubRange: 1...50)
        }
    }

    // MARK: - Level-specific generation

    private static func generateAddition(range: ClosedRange<Int>) -> MathProblem {
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        let correct = a + b

        let wrongRange = range.count > 20 ? -20...20 : -6...6
        let wrongAnswers = generateWrongAnswers(correct: correct, range: wrongRange)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: nil, correctAnswer: correct, choices: allChoices, level: .addition, complexOp: nil)
    }

    private static func generateSubtraction(aRange: ClosedRange<Int>, bRange: ClosedRange<Int>) -> MathProblem {
        // Ensure a >= b so answer is non-negative
        let a = Int.random(in: aRange)
        let b = Int.random(in: 1...a)  // b must be <= a for non-negative result
        let correct = a - b

        let wrongRange = aRange.upperBound > 20 ? -20...20 : -6...6
        let wrongAnswers = generateWrongAnswers(correct: correct, range: wrongRange)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: nil, correctAnswer: correct, choices: allChoices, level: .subtraction, complexOp: nil)
    }

    private static func generateAddSubtract(range: ClosedRange<Int>) -> MathProblem {
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        // Ensure c <= a + b so the answer is non-negative
        let maxC = a + b
        let c = maxC > 0 ? Int.random(in: 0...maxC) : 0
        let correct = a + b - c

        let wrongRange = range.count > 20 ? -20...20 : -9...9
        let wrongAnswers = generateWrongAnswers(correct: correct, range: wrongRange)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: c, correctAnswer: correct, choices: allChoices, level: .addSubtract, complexOp: nil)
    }

    private static func generateMultiplication(aRange: ClosedRange<Int>, bRange: ClosedRange<Int>) -> MathProblem {
        let a = Int.random(in: aRange)
        let b = Int.random(in: bRange)
        let correct = a * b

        let wrongRange = correct > 50 ? -30...30 : -15...15
        let wrongAnswers = generateWrongAnswers(correct: correct, range: wrongRange)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: nil, correctAnswer: correct, choices: allChoices, level: .multiplication, complexOp: nil)
    }

    private static func generateDivision(quotientRange: ClosedRange<Int>, divisorRange: ClosedRange<Int>) -> MathProblem {
        // Generate clean division: pick quotient and divisor, calculate dividend
        let quotient = Int.random(in: quotientRange)
        let divisor = Int.random(in: divisorRange)
        let dividend = quotient * divisor

        let wrongRange = quotientRange.upperBound > 20 ? -15...15 : -6...6
        let wrongAnswers = generateWrongAnswers(correct: quotient, range: wrongRange)
        var allChoices = [quotient] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: dividend, b: divisor, c: nil, correctAnswer: quotient, choices: allChoices, level: .division, complexOp: nil)
    }

    private static func generateMoreComplex(mulARange: ClosedRange<Int>, mulBRange: ClosedRange<Int>, divQuotientRange: ClosedRange<Int>, divDivisorRange: ClosedRange<Int>, addSubRange: ClosedRange<Int>) -> MathProblem {
        let opType = ComplexOperationType.allCases.randomElement()!

        let a: Int
        let b: Int
        let c: Int
        let correct: Int

        switch opType {
        case .multiplyAdd:
            // a × b + c
            a = Int.random(in: mulARange)
            b = Int.random(in: mulBRange)
            c = Int.random(in: addSubRange)
            correct = a * b + c

        case .multiplySubtract:
            // a × b − c, ensure non-negative result
            a = Int.random(in: mulARange)
            b = Int.random(in: mulBRange)
            let product = a * b
            c = Int.random(in: 1...max(1, product))
            correct = product - c

        case .divideAdd:
            // a ÷ b + c (a is dividend, b is divisor)
            let quotient = Int.random(in: divQuotientRange)
            let divisor = Int.random(in: divDivisorRange)
            a = quotient * divisor  // dividend
            b = divisor
            c = Int.random(in: addSubRange)
            correct = quotient + c

        case .divideSubtract:
            // a ÷ b − c, ensure non-negative result
            let quotient = Int.random(in: divQuotientRange)
            let divisor = Int.random(in: divDivisorRange)
            a = quotient * divisor  // dividend
            b = divisor
            c = Int.random(in: 1...max(1, quotient))
            correct = quotient - c
        }

        let wrongRange = correct > 50 ? -30...30 : -15...15
        let wrongAnswers = generateWrongAnswers(correct: correct, range: wrongRange)
        var allChoices = [correct] + wrongAnswers
        allChoices.shuffle()

        return MathProblem(a: a, b: b, c: c, correctAnswer: correct, choices: allChoices, level: .moreComplex, complexOp: opType)
    }

    // MARK: - Wrong answer generation

    private static func generateWrongAnswers(correct: Int, range: ClosedRange<Int>) -> [Int] {
        var wrong: [Int] = []
        let offsets = Array(range).filter { abs($0) >= 3 }.shuffled()

        for offset in offsets where wrong.count < 2 {
            let candidate = correct + offset
            // Ensure candidate is non-negative and at least 3 apart from correct and all other wrong answers
            let validSpacing = wrong.allSatisfy { abs($0 - candidate) >= 3 }
            if candidate >= 0 && validSpacing {
                wrong.append(candidate)
            }
        }

        // Fallback if we couldn't find 2 wrong answers with non-negative values
        var fallbackOffset = 3
        while wrong.count < 2 {
            let candidate = correct + fallbackOffset
            if candidate >= 0 && !wrong.contains(candidate) && wrong.allSatisfy({ abs($0 - candidate) >= 3 }) {
                wrong.append(candidate)
            }
            fallbackOffset += 3
        }

        return wrong
    }
}
