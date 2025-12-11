//
//  MenuScene.swift
//  RainbowUnicornMath
//

import SpriteKit

class MenuScene: SKScene {

    private var unicornLabel: SKLabelNode!
    private var levelButtons: [LevelButton] = []

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupUnicorn()
        setupLevelButtons()
        setupDecorations()
    }

    private func setupBackground() {
        let background = createRainbowGradientBackground()
        addChild(background)
    }

    private func setupTitle() {
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLabel.text = "Rainbow Unicorn"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        let subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        subtitleLabel.text = "Math!"
        subtitleLabel.fontSize = 42
        subtitleLabel.fontColor = RainbowColors.yellow
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.79)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)
    }

    private func setupUnicorn() {
        unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 70
        unicornLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.70)
        unicornLabel.zPosition = 10
        addChild(unicornLabel)

        // Bobbing animation
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.8)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.8)
        moveDown.timingMode = .easeInEaseOut
        let bob = SKAction.sequence([moveUp, moveDown])
        unicornLabel.run(SKAction.repeatForever(bob))
    }

    private func setupLevelButtons() {
        let chooseLevelLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        chooseLevelLabel.text = "Choose a Level:"
        chooseLevelLabel.fontSize = 24
        chooseLevelLabel.fontColor = .white
        chooseLevelLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.66)
        chooseLevelLabel.zPosition = 10
        addChild(chooseLevelLabel)

        let buttonSize = CGSize(width: size.width * 0.75, height: 50)
        let buttonSpacing: CGFloat = 58
        let startY = size.height * 0.58

        let levelColors: [UIColor] = [
            RainbowColors.red,
            RainbowColors.orange,
            RainbowColors.yellow,
            RainbowColors.green,
            RainbowColors.blue
        ]

        for (index, level) in MathLevel.allCases.enumerated() {
            let button = LevelButton(level: level, size: buttonSize, color: levelColors[index])
            button.position = CGPoint(x: size.width / 2, y: startY - CGFloat(index) * buttonSpacing)
            button.zPosition = 10
            addChild(button)
            levelButtons.append(button)
        }
    }

    private func setupDecorations() {
        // Rainbow emoji decorations
        let rainbowLeft = SKLabelNode(text: "🌈")
        rainbowLeft.fontSize = 40
        rainbowLeft.position = CGPoint(x: size.width * 0.15, y: size.height * 0.08)
        rainbowLeft.zPosition = 10
        addChild(rainbowLeft)

        let rainbowRight = SKLabelNode(text: "🌈")
        rainbowRight.fontSize = 40
        rainbowRight.position = CGPoint(x: size.width * 0.85, y: size.height * 0.08)
        rainbowRight.zPosition = 10
        addChild(rainbowRight)

        // Stars on the sides
        let positions: [(CGFloat, CGFloat)] = [
            (0.08, 0.95), (0.92, 0.93), (0.05, 0.45), (0.95, 0.42)
        ]
        for (xRatio, yRatio) in positions {
            let star = SKLabelNode(text: "⭐")
            star.fontSize = CGFloat.random(in: 18...28)
            star.position = CGPoint(x: size.width * xRatio, y: size.height * yRatio)
            star.zPosition = 5
            star.alpha = 0.8
            addChild(star)

            // Twinkle animation
            let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: Double.random(in: 0.8...1.5))
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 0.8...1.5))
            let twinkle = SKAction.sequence([fadeOut, fadeIn])
            star.run(SKAction.repeatForever(twinkle))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for button in levelButtons {
            if button.calculateAccumulatedFrame().contains(location) {
                startGame(with: button.level)
                return
            }
        }
    }

    private func startGame(with level: MathLevel) {
        GameState.shared.reset()
        GameState.shared.selectedLevel = level

        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
