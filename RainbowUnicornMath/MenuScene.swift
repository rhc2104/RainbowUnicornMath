//
//  MenuScene.swift
//  RainbowUnicornMath
//

import SpriteKit

enum MenuState {
    case levelSelection
    case difficultySelection(MathLevel)
}

class MenuScene: SKScene {

    private var unicornLabel: SKLabelNode!
    private var levelButtons: [LevelButton] = []
    private var difficultyButtons: [LevelButton] = []
    private var backButton: LevelButton?
    private var chooseLevelLabel: SKLabelNode!
    private var menuState: MenuState = .levelSelection
    private var selectedLevelColor: UIColor = .white

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
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 90)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        let subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        subtitleLabel.text = "Math!"
        subtitleLabel.fontSize = 42
        subtitleLabel.fontColor = RainbowColors.yellow
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height - 135)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)
    }

    private func setupUnicorn() {
        unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 60
        unicornLabel.position = CGPoint(x: size.width / 2, y: size.height - 200)
        unicornLabel.zPosition = 10
        addChild(unicornLabel)

        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.8)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.8)
        moveDown.timingMode = .easeInEaseOut
        let bob = SKAction.sequence([moveUp, moveDown])
        unicornLabel.run(SKAction.repeatForever(bob))
    }

    private func setupLevelButtons() {
        chooseLevelLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        chooseLevelLabel.text = "Choose a Level:"
        chooseLevelLabel.fontSize = 20
        chooseLevelLabel.fontColor = .white
        chooseLevelLabel.position = CGPoint(x: size.width / 2, y: size.height - 250)
        chooseLevelLabel.zPosition = 10
        addChild(chooseLevelLabel)

        let buttonWidth = min(size.width * 0.75, 300)
        let buttonHeight: CGFloat = 44
        let buttonSpacing: CGFloat = 50
        let startY = size.height - 290

        let levelColors: [UIColor] = [
            RainbowColors.red,
            RainbowColors.orange,
            RainbowColors.yellow,
            RainbowColors.green,
            RainbowColors.blue,
            RainbowColors.purple
        ]

        for (index, level) in MathLevel.allCases.enumerated() {
            let color = levelColors[index % levelColors.count]
            let button = LevelButton(level: level, size: CGSize(width: buttonWidth, height: buttonHeight), color: color)
            button.position = CGPoint(x: size.width / 2, y: startY - CGFloat(index) * buttonSpacing)
            button.zPosition = 10
            addChild(button)
            levelButtons.append(button)
        }
    }

    private func setupDecorations() {
        let rainbowLeft = SKLabelNode(text: "🌈")
        rainbowLeft.fontSize = 40
        rainbowLeft.position = CGPoint(x: size.width * 0.15, y: 30)
        rainbowLeft.zPosition = 10
        addChild(rainbowLeft)

        let rainbowRight = SKLabelNode(text: "🌈")
        rainbowRight.fontSize = 40
        rainbowRight.position = CGPoint(x: size.width * 0.85, y: 30)
        rainbowRight.zPosition = 10
        addChild(rainbowRight)

        let positions: [(CGFloat, CGFloat)] = [
            (0.08, 0.88), (0.92, 0.86), (0.05, 0.45), (0.95, 0.42)
        ]
        for (xRatio, yRatio) in positions {
            let star = SKLabelNode(text: "⭐")
            star.fontSize = CGFloat.random(in: 18...28)
            star.position = CGPoint(x: size.width * xRatio, y: size.height * yRatio)
            star.zPosition = 5
            star.alpha = 0.8
            addChild(star)

            let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: Double.random(in: 0.8...1.5))
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 0.8...1.5))
            let twinkle = SKAction.sequence([fadeOut, fadeIn])
            star.run(SKAction.repeatForever(twinkle))
        }
    }

    private func showDifficultySubmenu(for level: MathLevel, color: UIColor) {
        menuState = .difficultySelection(level)
        selectedLevelColor = color

        // Animate out level buttons
        for button in levelButtons {
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            button.run(fadeOut)
        }

        // Update label
        chooseLevelLabel.text = "\(level.displayName) - Choose Difficulty:"

        // Create difficulty buttons after a short delay
        run(SKAction.wait(forDuration: 0.25)) { [weak self] in
            self?.createDifficultyButtons(for: level, color: color)
        }
    }

    private func createDifficultyButtons(for level: MathLevel, color: UIColor) {
        let buttonWidth = min(size.width * 0.75, 300)
        let buttonHeight: CGFloat = 44
        let buttonSpacing: CGFloat = 50
        let startY = size.height - 290

        // Create back button
        let backBtn = LevelButton(
            text: "← Back",
            size: CGSize(width: buttonWidth, height: buttonHeight),
            color: .darkGray
        )
        backBtn.position = CGPoint(x: size.width / 2, y: startY)
        backBtn.zPosition = 10
        backBtn.alpha = 0
        addChild(backBtn)
        backButton = backBtn

        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        backBtn.run(fadeIn)

        // Create difficulty buttons
        let difficulties = level.difficulties
        for (index, difficulty) in difficulties.enumerated() {
            let lighterColor = color.withAlphaComponent(0.8 + CGFloat(index) * 0.05)
            let button = LevelButton(
                difficulty: difficulty,
                size: CGSize(width: buttonWidth, height: buttonHeight),
                color: lighterColor
            )
            button.position = CGPoint(x: size.width / 2, y: startY - CGFloat(index + 1) * buttonSpacing)
            button.zPosition = 10
            button.alpha = 0
            addChild(button)
            difficultyButtons.append(button)

            let delay = SKAction.wait(forDuration: Double(index) * 0.05)
            let fade = SKAction.fadeIn(withDuration: 0.2)
            button.run(SKAction.sequence([delay, fade]))
        }
    }

    private func showMainMenu() {
        menuState = .levelSelection

        // Remove difficulty buttons
        for button in difficultyButtons {
            button.removeFromParent()
        }
        difficultyButtons.removeAll()

        // Remove back button
        backButton?.removeFromParent()
        backButton = nil

        // Update label
        chooseLevelLabel.text = "Choose a Level:"

        // Fade in level buttons
        for button in levelButtons {
            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
            button.run(fadeIn)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        switch menuState {
        case .levelSelection:
            for (index, button) in levelButtons.enumerated() {
                if button.calculateAccumulatedFrame().contains(location) {
                    let levelColors: [UIColor] = [
                        RainbowColors.red,
                        RainbowColors.orange,
                        RainbowColors.yellow,
                        RainbowColors.green,
                        RainbowColors.blue,
                        RainbowColors.purple
                    ]
                    let color = levelColors[index % levelColors.count]
                    showDifficultySubmenu(for: button.level, color: color)
                    return
                }
            }

        case .difficultySelection:
            // Check back button
            if let backBtn = backButton, backBtn.calculateAccumulatedFrame().contains(location) {
                showMainMenu()
                return
            }

            // Check difficulty buttons
            for button in difficultyButtons {
                if button.calculateAccumulatedFrame().contains(location), let difficulty = button.difficulty {
                    startGame(with: difficulty)
                    return
                }
            }
        }
    }

    private func startGame(with difficulty: DifficultyLevel) {
        GameState.shared.reset()
        GameState.shared.selectedDifficulty = difficulty

        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
