//
//  GameScene.swift
//  RainbowUnicornMath
//

import SpriteKit

class GameScene: SKScene {

    private var progressLabel: SKLabelNode!
    private var unicornLabel: SKLabelNode!
    private var questionLabel: SKLabelNode!
    private var answerButtons: [AnswerButton] = []
    private var currentProblem: MathProblem!
    private var isAnswered = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupProgressLabel()
        setupUnicorn()
        setupQuestionArea()
        setupAnswerButtons()
        setupDecorations()
        loadNewQuestion()
    }

    private func setupBackground() {
        let background = createRainbowGradientBackground()
        addChild(background)
    }

    private func setupProgressLabel() {
        progressLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        progressLabel.fontSize = 22
        progressLabel.fontColor = .white
        progressLabel.position = CGPoint(x: size.width * 0.35, y: size.height * 0.92)
        progressLabel.horizontalAlignmentMode = .center
        progressLabel.zPosition = 10
        addChild(progressLabel)
    }

    private func setupUnicorn() {
        unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 60
        unicornLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.90)
        unicornLabel.zPosition = 10
        addChild(unicornLabel)

        // Gentle bobbing
        let moveUp = SKAction.moveBy(x: 0, y: 5, duration: 0.6)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -5, duration: 0.6)
        moveDown.timingMode = .easeInEaseOut
        let bob = SKAction.sequence([moveUp, moveDown])
        unicornLabel.run(SKAction.repeatForever(bob))
    }

    private func setupQuestionArea() {
        // Question background
        let questionBg = SKShapeNode(rectOf: CGSize(width: size.width * 0.85, height: 100), cornerRadius: 20)
        questionBg.fillColor = UIColor.white.withAlphaComponent(0.25)
        questionBg.strokeColor = .white
        questionBg.lineWidth = 3
        questionBg.position = CGPoint(x: size.width / 2, y: size.height * 0.68)
        questionBg.zPosition = 5
        addChild(questionBg)

        questionLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        questionLabel.fontSize = 44
        questionLabel.fontColor = .white
        questionLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.68)
        questionLabel.verticalAlignmentMode = .center
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.zPosition = 10
        addChild(questionLabel)
    }

    private func setupAnswerButtons() {
        let buttonColors = [RainbowColors.blue, RainbowColors.purple, RainbowColors.pink]
        let buttonWidth: CGFloat = 100
        let spacing: CGFloat = 20
        let totalWidth = (buttonWidth * 3) + (spacing * 2)
        let startX = (size.width - totalWidth) / 2 + buttonWidth / 2

        for i in 0..<3 {
            let button = AnswerButton(value: 0, size: CGSize(width: buttonWidth, height: 80), color: buttonColors[i])
            button.position = CGPoint(x: startX + CGFloat(i) * (buttonWidth + spacing), y: size.height * 0.42)
            button.zPosition = 10
            button.name = "answerButton_\(i)"
            addChild(button)
            answerButtons.append(button)
        }
    }

    private func setupDecorations() {
        // Rainbow decoration at bottom
        let rainbowRow = SKNode()
        let rainbows = ["🌈", "🌈", "🌈", "🌈", "🌈"]
        let spacing: CGFloat = size.width / CGFloat(rainbows.count + 1)

        for (i, emoji) in rainbows.enumerated() {
            let rainbow = SKLabelNode(text: emoji)
            rainbow.fontSize = 40
            rainbow.position = CGPoint(x: spacing * CGFloat(i + 1), y: size.height * 0.12)
            rainbow.zPosition = 10
            addChild(rainbow)
        }
    }

    private func loadNewQuestion() {
        isAnswered = false
        currentProblem = MathProblem.generate(for: GameState.shared.selectedLevel)

        // Update progress
        progressLabel.text = GameState.shared.progressText

        // Update question
        questionLabel.text = currentProblem.questionText

        // Update answer buttons
        let buttonColors = [RainbowColors.blue, RainbowColors.purple, RainbowColors.pink]
        for (i, button) in answerButtons.enumerated() {
            button.removeFromParent()
        }
        answerButtons.removeAll()

        let buttonWidth: CGFloat = 100
        let spacing: CGFloat = 20
        let totalWidth = (buttonWidth * 3) + (spacing * 2)
        let startX = (size.width - totalWidth) / 2 + buttonWidth / 2

        for i in 0..<3 {
            let button = AnswerButton(value: currentProblem.choices[i],
                                       size: CGSize(width: buttonWidth, height: 80),
                                       color: buttonColors[i])
            button.position = CGPoint(x: startX + CGFloat(i) * (buttonWidth + spacing), y: size.height * 0.42)
            button.zPosition = 10
            button.name = "answerButton_\(i)"
            addChild(button)
            answerButtons.append(button)
        }

        // Reset unicorn
        unicornLabel.text = "🦄"

        // Fade in animation
        questionLabel.alpha = 0
        questionLabel.run(SKAction.fadeIn(withDuration: 0.3))
        for button in answerButtons {
            button.alpha = 0
            button.run(SKAction.fadeIn(withDuration: 0.3))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isAnswered else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for button in answerButtons {
            if button.calculateAccumulatedFrame().contains(location) {
                handleAnswer(selectedButton: button)
                return
            }
        }
    }

    private func handleAnswer(selectedButton: AnswerButton) {
        isAnswered = true

        let isCorrect = selectedButton.value == currentProblem.correctAnswer
        GameState.shared.recordAnswer(correct: isCorrect)

        if isCorrect {
            selectedButton.showCorrect()
            unicornLabel.text = "🦄"
            showSparkles(at: selectedButton.position)
            celebrateUnicorn()
        } else {
            selectedButton.showWrong()
            unicornLabel.text = "🦄"
            sadUnicorn()

            // Highlight correct answer
            for button in answerButtons {
                if button.value == currentProblem.correctAnswer {
                    button.highlightCorrect()
                }
            }
        }

        // Advance after delay
        let wait = SKAction.wait(forDuration: 1.5)
        let advance = SKAction.run { [weak self] in
            self?.advanceGame()
        }
        run(SKAction.sequence([wait, advance]))
    }

    private func celebrateUnicorn() {
        let jump = SKAction.moveBy(x: 0, y: 20, duration: 0.15)
        let fall = SKAction.moveBy(x: 0, y: -20, duration: 0.15)
        unicornLabel.run(SKAction.sequence([jump, fall, jump, fall]))
    }

    private func sadUnicorn() {
        let shake = SKAction.sequence([
            SKAction.rotate(byAngle: 0.1, duration: 0.1),
            SKAction.rotate(byAngle: -0.2, duration: 0.1),
            SKAction.rotate(byAngle: 0.1, duration: 0.1)
        ])
        unicornLabel.run(shake)
    }

    private func showSparkles(at position: CGPoint) {
        let sparkleEmojis = ["✨", "⭐", "💫", "🌟"]
        for _ in 0..<6 {
            let sparkle = SKLabelNode(text: sparkleEmojis.randomElement())
            sparkle.fontSize = 25
            sparkle.position = position
            sparkle.zPosition = 20
            addChild(sparkle)

            let randomX = CGFloat.random(in: -60...60)
            let randomY = CGFloat.random(in: 20...80)
            let move = SKAction.moveBy(x: randomX, y: randomY, duration: 0.5)
            let fade = SKAction.fadeOut(withDuration: 0.5)
            let group = SKAction.group([move, fade])
            let remove = SKAction.removeFromParent()
            sparkle.run(SKAction.sequence([group, remove]))
        }
    }

    private func advanceGame() {
        if GameState.shared.isGameComplete {
            showResults()
        } else {
            loadNewQuestion()
        }
    }

    private func showResults() {
        let resultsScene = ResultsScene(size: self.size)
        resultsScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(resultsScene, transition: transition)
    }
}
