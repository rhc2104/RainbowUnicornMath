//
//  ResultsScene.swift
//  RainbowUnicornMath
//

import SpriteKit

class ResultsScene: SKScene {

    private var playAgainButton: SKShapeNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupUnicorn()
        setupStars()
        setupScoreLabel()
        setupPlayAgainButton()
        setupDecorations()
    }

    private func setupBackground() {
        let background = createRainbowGradientBackground()
        addChild(background)
    }

    private func setupTitle() {
        let starsEarned = GameState.shared.starsEarned

        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        if starsEarned >= 5 {
            titleLabel.text = "Amazing!"
        } else if starsEarned >= 4 {
            titleLabel.text = "Great Job!"
        } else if starsEarned >= 3 {
            titleLabel.text = "Good Try!"
        } else {
            titleLabel.text = "Keep Practicing!"
        }
        titleLabel.fontSize = 38
        titleLabel.fontColor = .white
        // Fixed offset from top
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 90)
        titleLabel.zPosition = 10
        addChild(titleLabel)
    }

    private func setupUnicorn() {
        let starsEarned = GameState.shared.starsEarned

        let unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 80
        // Fixed offset from top
        unicornLabel.position = CGPoint(x: size.width / 2, y: size.height - 170)
        unicornLabel.zPosition = 10
        addChild(unicornLabel)

        // Animation based on performance
        if starsEarned >= 3 {
            // Happy bouncing
            let moveUp = SKAction.moveBy(x: 0, y: 15, duration: 0.4)
            moveUp.timingMode = .easeOut
            let moveDown = SKAction.moveBy(x: 0, y: -15, duration: 0.4)
            moveDown.timingMode = .easeIn
            let bounce = SKAction.sequence([moveUp, moveDown])
            unicornLabel.run(SKAction.repeatForever(bounce))
        } else {
            // Gentle sway
            let rotateRight = SKAction.rotate(byAngle: 0.1, duration: 0.5)
            let rotateLeft = SKAction.rotate(byAngle: -0.1, duration: 0.5)
            let sway = SKAction.sequence([rotateRight, rotateLeft])
            unicornLabel.run(SKAction.repeatForever(sway))
        }
    }

    private func setupStars() {
        let starsEarned = GameState.shared.starsEarned
        let starSpacing: CGFloat = 50
        let totalWidth = starSpacing * 4
        let startX = (size.width - totalWidth) / 2
        // Centered vertically
        let starY = size.height / 2 + 20

        for i in 0..<5 {
            let starLabel = SKLabelNode()
            if i < starsEarned {
                starLabel.text = "⭐"
            } else {
                starLabel.text = "☆"
                starLabel.fontColor = UIColor.white.withAlphaComponent(0.5)
            }
            starLabel.fontSize = 40
            starLabel.position = CGPoint(x: startX + CGFloat(i) * starSpacing, y: starY)
            starLabel.zPosition = 10
            addChild(starLabel)

            // Animate earned stars appearing
            if i < starsEarned {
                starLabel.setScale(0)
                let delay = SKAction.wait(forDuration: Double(i) * 0.2)
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                let appear = SKAction.sequence([delay, scaleUp, scaleDown])
                starLabel.run(appear)
            }
        }
    }

    private func setupScoreLabel() {
        let correct = GameState.shared.correctAnswers
        let total = GameState.shared.totalQuestions

        // Create label first to measure its size
        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        scoreLabel.text = "You got \(correct) out of \(total) correct!"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .center

        // Calculate background size based on text with fixed padding
        let horizontalPadding: CGFloat = 24
        let verticalPadding: CGFloat = 14
        let textFrame = scoreLabel.frame
        let bgSize = CGSize(width: textFrame.width + horizontalPadding * 2,
                            height: textFrame.height + verticalPadding * 2)

        // Background pill shape
        let scoreBg = SKShapeNode(rectOf: bgSize, cornerRadius: bgSize.height / 2)
        scoreBg.fillColor = RainbowColors.purple
        scoreBg.strokeColor = .white
        scoreBg.lineWidth = 3
        // Centered, below stars
        scoreBg.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        scoreBg.zPosition = 10
        addChild(scoreBg)

        // Add label to background
        scoreLabel.position = CGPoint.zero
        scoreLabel.zPosition = 11
        scoreBg.addChild(scoreLabel)
    }

    private func setupPlayAgainButton() {
        let buttonSize = CGSize(width: 200, height: 55)
        playAgainButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 16)
        playAgainButton.fillColor = RainbowColors.green
        playAgainButton.strokeColor = .white
        playAgainButton.lineWidth = 4
        // Fixed offset from bottom
        playAgainButton.position = CGPoint(x: size.width / 2, y: 80)
        playAgainButton.zPosition = 10
        playAgainButton.name = "playAgainButton"
        addChild(playAgainButton)

        let buttonLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        buttonLabel.text = "Play Again!"
        buttonLabel.fontSize = 24
        buttonLabel.fontColor = .white
        buttonLabel.verticalAlignmentMode = .center
        buttonLabel.horizontalAlignmentMode = .center
        buttonLabel.zPosition = 11
        playAgainButton.addChild(buttonLabel)

        // Pulse animation
        let scaleUp = SKAction.scale(to: 1.05, duration: 0.6)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.6)
        scaleDown.timingMode = .easeInEaseOut
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        playAgainButton.run(SKAction.repeatForever(pulse))
    }

    private func setupDecorations() {
        // Rainbows at bottom corners
        let rainbowLeft = SKLabelNode(text: "🌈")
        rainbowLeft.fontSize = 40
        rainbowLeft.position = CGPoint(x: 50, y: 30)
        rainbowLeft.zPosition = 10
        addChild(rainbowLeft)

        let rainbowRight = SKLabelNode(text: "🌈")
        rainbowRight.fontSize = 40
        rainbowRight.position = CGPoint(x: size.width - 50, y: 30)
        rainbowRight.zPosition = 10
        addChild(rainbowRight)

        // Sparkles for high scores
        if GameState.shared.starsEarned >= 4 {
            let sparklePositions: [(CGFloat, CGFloat)] = [
                (40, size.height - 120), (size.width - 40, size.height - 130),
                (60, size.height / 2), (size.width - 60, size.height / 2 + 20)
            ]
            for (x, y) in sparklePositions {
                let sparkle = SKLabelNode(text: "✨")
                sparkle.fontSize = 25
                sparkle.position = CGPoint(x: x, y: y)
                sparkle.zPosition = 5
                addChild(sparkle)

                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 0.5...1.0))
                let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 0.5...1.0))
                let twinkle = SKAction.sequence([fadeOut, fadeIn])
                sparkle.run(SKAction.repeatForever(twinkle))
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if node.name == "playAgainButton" || node.parent?.name == "playAgainButton" {
                restartGame()
                return
            }
        }
    }

    private func restartGame() {
        GameState.shared.reset()

        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(menuScene, transition: transition)
    }
}
