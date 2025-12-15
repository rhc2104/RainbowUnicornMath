//
//  GameScene.swift
//  RainbowUnicornMath
//

import SpriteKit

class GameScene: SKScene {

    private var progressLabel: SKLabelNode!
    private var unicornLabel: SKLabelNode!
    private var questionLabel: SKLabelNode!
    private var questionBg: SKShapeNode!
    private var answerButtons: [AnswerButton] = []
    private var currentProblem: MathProblem!
    private var isAnswered = false

    // Exit button and dialog
    private var exitButton: SKShapeNode!
    private var dialogOverlay: SKShapeNode?
    private var dialogBox: SKShapeNode?
    private var isShowingDialog = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupProgressLabel()
        setupUnicorn()
        setupQuestionArea()
        setupAnswerButtons()
        setupDecorations()
        setupExitButton()
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
        // Fixed offset from top
        progressLabel.position = CGPoint(x: size.width * 0.35, y: size.height - 90)
        progressLabel.horizontalAlignmentMode = .center
        progressLabel.zPosition = 10
        addChild(progressLabel)
    }

    private func setupUnicorn() {
        unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 60
        // Fixed offset from top
        unicornLabel.position = CGPoint(x: size.width * 0.85, y: size.height - 100)
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
        // Question background - centered vertically
        let bgWidth = min(size.width * 0.85, 400)
        questionBg = SKShapeNode(rectOf: CGSize(width: bgWidth, height: 100), cornerRadius: 20)
        questionBg.fillColor = UIColor.white.withAlphaComponent(0.25)
        questionBg.strokeColor = .white
        questionBg.lineWidth = 3
        questionBg.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        questionBg.zPosition = 5
        addChild(questionBg)

        questionLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        questionLabel.fontSize = 44
        questionLabel.fontColor = .white
        questionLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
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
        // Fixed offset from bottom
        let buttonY = max(size.height / 2 - 80, 120)

        for i in 0..<3 {
            let button = AnswerButton(value: 0, size: CGSize(width: buttonWidth, height: 80), color: buttonColors[i])
            button.position = CGPoint(x: startX + CGFloat(i) * (buttonWidth + spacing), y: buttonY)
            button.zPosition = 10
            button.name = "answerButton_\(i)"
            addChild(button)
            answerButtons.append(button)
        }
    }

    private func setupDecorations() {
        // Rainbow decoration at bottom
        let rainbows = ["🌈", "🌈", "🌈", "🌈", "🌈"]
        let spacing: CGFloat = size.width / CGFloat(rainbows.count + 1)

        for (i, emoji) in rainbows.enumerated() {
            let rainbow = SKLabelNode(text: emoji)
            rainbow.fontSize = 40
            // Fixed offset from bottom
            rainbow.position = CGPoint(x: spacing * CGFloat(i + 1), y: 40)
            rainbow.zPosition = 10
            addChild(rainbow)
        }
    }

    private func setupExitButton() {
        // Small circular X button in upper right
        let buttonSize: CGFloat = 36
        exitButton = SKShapeNode(circleOfRadius: buttonSize / 2)
        exitButton.fillColor = UIColor.white.withAlphaComponent(0.3)
        exitButton.strokeColor = .white
        exitButton.lineWidth = 2
        exitButton.position = CGPoint(x: 40, y: size.height - 50)
        exitButton.zPosition = 100
        exitButton.name = "exitButton"
        addChild(exitButton)

        // X label
        let xLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        xLabel.text = "✕"
        xLabel.fontSize = 20
        xLabel.fontColor = .white
        xLabel.verticalAlignmentMode = .center
        xLabel.horizontalAlignmentMode = .center
        xLabel.zPosition = 101
        exitButton.addChild(xLabel)
    }

    private func loadNewQuestion() {
        isAnswered = false
        currentProblem = MathProblem.generate(for: GameState.shared.selectedLevel,
                                               usedProblems: &GameState.shared.usedProblems)

        // Update progress
        progressLabel.text = GameState.shared.progressText

        // Update question
        questionLabel.text = currentProblem.questionText

        // Update answer buttons
        let buttonColors = [RainbowColors.blue, RainbowColors.purple, RainbowColors.pink]
        for button in answerButtons {
            button.removeFromParent()
        }
        answerButtons.removeAll()

        let buttonWidth: CGFloat = 100
        let spacing: CGFloat = 20
        let totalWidth = (buttonWidth * 3) + (spacing * 2)
        let startX = (size.width - totalWidth) / 2 + buttonWidth / 2
        let buttonY = max(size.height / 2 - 80, 120)

        for i in 0..<3 {
            let button = AnswerButton(value: currentProblem.choices[i],
                                       size: CGSize(width: buttonWidth, height: 80),
                                       color: buttonColors[i])
            button.position = CGPoint(x: startX + CGFloat(i) * (buttonWidth + spacing), y: buttonY)
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
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Handle dialog interactions
        if isShowingDialog {
            let nodesAtPoint = nodes(at: location)
            for node in nodesAtPoint {
                if node.name == "cancelButton" || node.parent?.name == "cancelButton" {
                    dismissDialog()
                    return
                }
                if node.name == "startOverButton" || node.parent?.name == "startOverButton" {
                    returnToMenu()
                    return
                }
            }
            return // Block all other touches while dialog is showing
        }

        // Handle exit button tap
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "exitButton" || node.parent?.name == "exitButton" {
                showExitConfirmationDialog()
                return
            }
        }

        // Handle answer buttons (only if not answered)
        guard !isAnswered else { return }
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
        resultsScene.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(resultsScene, transition: transition)
    }

    // MARK: - Exit Dialog

    private func showExitConfirmationDialog() {
        isShowingDialog = true

        // Semi-transparent overlay
        dialogOverlay = SKShapeNode(rectOf: CGSize(width: size.width * 2, height: size.height * 2))
        dialogOverlay?.fillColor = UIColor.black.withAlphaComponent(0.5)
        dialogOverlay?.strokeColor = .clear
        dialogOverlay?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dialogOverlay?.zPosition = 200
        dialogOverlay?.name = "dialogOverlay"
        addChild(dialogOverlay!)

        // Dialog box
        let boxSize = CGSize(width: 280, height: 180)
        dialogBox = SKShapeNode(rectOf: boxSize, cornerRadius: 20)
        dialogBox?.fillColor = .white
        dialogBox?.strokeColor = RainbowColors.purple
        dialogBox?.lineWidth = 3
        dialogBox?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dialogBox?.zPosition = 210
        addChild(dialogBox!)

        // Title
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "Start Over?"
        titleLabel.fontSize = 24
        titleLabel.fontColor = RainbowColors.purple
        titleLabel.position = CGPoint(x: 0, y: 50)
        titleLabel.zPosition = 211
        dialogBox?.addChild(titleLabel)

        // Message
        let messageLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        messageLabel.text = "Your progress will be lost"
        messageLabel.fontSize = 16
        messageLabel.fontColor = .darkGray
        messageLabel.position = CGPoint(x: 0, y: 15)
        messageLabel.zPosition = 211
        dialogBox?.addChild(messageLabel)

        // Cancel button
        let cancelButton = SKShapeNode(rectOf: CGSize(width: 100, height: 44), cornerRadius: 12)
        cancelButton.fillColor = UIColor(white: 0.7, alpha: 1.0)
        cancelButton.strokeColor = .white
        cancelButton.lineWidth = 2
        cancelButton.position = CGPoint(x: -60, y: -45)
        cancelButton.zPosition = 211
        cancelButton.name = "cancelButton"
        dialogBox?.addChild(cancelButton)

        let cancelLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        cancelLabel.text = "Cancel"
        cancelLabel.fontSize = 16
        cancelLabel.fontColor = .white
        cancelLabel.verticalAlignmentMode = .center
        cancelLabel.zPosition = 212
        cancelButton.addChild(cancelLabel)

        // Start Over button
        let startOverButton = SKShapeNode(rectOf: CGSize(width: 120, height: 44), cornerRadius: 12)
        startOverButton.fillColor = RainbowColors.red
        startOverButton.strokeColor = .white
        startOverButton.lineWidth = 2
        startOverButton.position = CGPoint(x: 60, y: -45)
        startOverButton.zPosition = 211
        startOverButton.name = "startOverButton"
        dialogBox?.addChild(startOverButton)

        let startOverLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        startOverLabel.text = "Start Over"
        startOverLabel.fontSize = 16
        startOverLabel.fontColor = .white
        startOverLabel.verticalAlignmentMode = .center
        startOverLabel.zPosition = 212
        startOverButton.addChild(startOverLabel)
    }

    private func dismissDialog() {
        dialogOverlay?.removeFromParent()
        dialogBox?.removeFromParent()
        dialogOverlay = nil
        dialogBox = nil
        isShowingDialog = false
    }

    private func returnToMenu() {
        GameState.shared.reset()
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(menuScene, transition: transition)
    }
}
