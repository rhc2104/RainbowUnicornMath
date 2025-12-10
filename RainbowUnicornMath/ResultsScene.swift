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
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.88)
        titleLabel.zPosition = 10
        addChild(titleLabel)
    }

    private func setupUnicorn() {
        let starsEarned = GameState.shared.starsEarned

        let unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 100
        unicornLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.70)
        unicornLabel.zPosition = 10
        addChild(unicornLabel)

        // Animation based on performance
        if starsEarned >= 3 {
            // Happy bouncing
            let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 0.4)
            moveUp.timingMode = .easeOut
            let moveDown = SKAction.moveBy(x: 0, y: -20, duration: 0.4)
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
        let starSpacing: CGFloat = 55
        let totalWidth = starSpacing * 4
        let startX = (size.width - totalWidth) / 2

        for i in 0..<5 {
            let starLabel = SKLabelNode()
            if i < starsEarned {
                starLabel.text = "⭐"
            } else {
                starLabel.text = "☆"
                starLabel.fontColor = UIColor.white.withAlphaComponent(0.5)
            }
            starLabel.fontSize = 45
            starLabel.position = CGPoint(x: startX + CGFloat(i) * starSpacing, y: size.height * 0.52)
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
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .center

        // Calculate background size based on text with fixed padding
        let horizontalPadding: CGFloat = 24
        let verticalPadding: CGFloat = 16
        let textFrame = scoreLabel.frame
        let bgSize = CGSize(width: textFrame.width + horizontalPadding * 2,
                            height: textFrame.height + verticalPadding * 2)

        // Background pill shape
        let scoreBg = SKShapeNode(rectOf: bgSize, cornerRadius: bgSize.height / 2)
        scoreBg.fillColor = RainbowColors.purple
        scoreBg.strokeColor = .white
        scoreBg.lineWidth = 3
        scoreBg.position = CGPoint(x: size.width / 2, y: size.height * 0.40)
        scoreBg.zPosition = 10
        addChild(scoreBg)

        // Add label to background
        scoreLabel.position = CGPoint.zero
        scoreLabel.zPosition = 11
        scoreBg.addChild(scoreLabel)
    }

    private func setupPlayAgainButton() {
        let buttonSize = CGSize(width: 220, height: 65)
        playAgainButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 18)
        playAgainButton.fillColor = RainbowColors.purple
        playAgainButton.strokeColor = .white
        playAgainButton.lineWidth = 4
        playAgainButton.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        playAgainButton.zPosition = 10
        playAgainButton.name = "playAgainButton"
        addChild(playAgainButton)

        let buttonLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        buttonLabel.text = "Play Again!"
        buttonLabel.fontSize = 28
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
        // Rainbows at bottom
        let rainbowLeft = SKLabelNode(text: "🌈")
        rainbowLeft.fontSize = 50
        rainbowLeft.position = CGPoint(x: size.width * 0.15, y: size.height * 0.10)
        rainbowLeft.zPosition = 10
        addChild(rainbowLeft)

        let rainbowRight = SKLabelNode(text: "🌈")
        rainbowRight.fontSize = 50
        rainbowRight.position = CGPoint(x: size.width * 0.85, y: size.height * 0.10)
        rainbowRight.zPosition = 10
        addChild(rainbowRight)

        // Sparkles for high scores
        if GameState.shared.starsEarned >= 4 {
            let sparklePositions: [(CGFloat, CGFloat)] = [
                (0.1, 0.75), (0.9, 0.78), (0.2, 0.60), (0.8, 0.63),
                (0.15, 0.85), (0.85, 0.82)
            ]
            for (xRatio, yRatio) in sparklePositions {
                let sparkle = SKLabelNode(text: "✨")
                sparkle.fontSize = 30
                sparkle.position = CGPoint(x: size.width * xRatio, y: size.height * yRatio)
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
        menuScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(menuScene, transition: transition)
    }
}
