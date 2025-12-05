//
//  MenuScene.swift
//  RainbowUnicornMath
//

import SpriteKit

class MenuScene: SKScene {

    private var unicornLabel: SKLabelNode!
    private var playButton: SKShapeNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupUnicorn()
        setupPlayButton()
        setupDecorations()
    }

    private func setupBackground() {
        let background = createRainbowGradientBackground()
        addChild(background)
    }

    private func setupTitle() {
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLabel.text = "Rainbow Unicorn"
        titleLabel.fontSize = 42
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.82)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        let subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        subtitleLabel.text = "Math!"
        subtitleLabel.fontSize = 48
        subtitleLabel.fontColor = RainbowColors.yellow
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.74)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)
    }

    private func setupUnicorn() {
        unicornLabel = SKLabelNode(text: "🦄")
        unicornLabel.fontSize = 120
        unicornLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.52)
        unicornLabel.zPosition = 10
        addChild(unicornLabel)

        // Bobbing animation
        let moveUp = SKAction.moveBy(x: 0, y: 15, duration: 0.8)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -15, duration: 0.8)
        moveDown.timingMode = .easeInEaseOut
        let bob = SKAction.sequence([moveUp, moveDown])
        unicornLabel.run(SKAction.repeatForever(bob))
    }

    private func setupPlayButton() {
        let buttonSize = CGSize(width: 200, height: 70)
        playButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 20)
        playButton.fillColor = RainbowColors.purple
        playButton.strokeColor = .white
        playButton.lineWidth = 4
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.28)
        playButton.zPosition = 10
        playButton.name = "playButton"
        addChild(playButton)

        let playLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playLabel.text = "Play!"
        playLabel.fontSize = 36
        playLabel.fontColor = .white
        playLabel.verticalAlignmentMode = .center
        playLabel.horizontalAlignmentMode = .center
        playLabel.zPosition = 11
        playButton.addChild(playLabel)

        // Pulse animation
        let scaleUp = SKAction.scale(to: 1.08, duration: 0.5)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        scaleDown.timingMode = .easeInEaseOut
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        playButton.run(SKAction.repeatForever(pulse))
    }

    private func setupDecorations() {
        // Rainbow emoji decorations
        let rainbowLeft = SKLabelNode(text: "🌈")
        rainbowLeft.fontSize = 50
        rainbowLeft.position = CGPoint(x: size.width * 0.15, y: size.height * 0.12)
        rainbowLeft.zPosition = 10
        addChild(rainbowLeft)

        let rainbowRight = SKLabelNode(text: "🌈")
        rainbowRight.fontSize = 50
        rainbowRight.position = CGPoint(x: size.width * 0.85, y: size.height * 0.12)
        rainbowRight.zPosition = 10
        addChild(rainbowRight)

        // Stars
        let positions: [(CGFloat, CGFloat)] = [
            (0.1, 0.9), (0.9, 0.88), (0.15, 0.65), (0.85, 0.62), (0.08, 0.4), (0.92, 0.38)
        ]
        for (xRatio, yRatio) in positions {
            let star = SKLabelNode(text: "⭐")
            star.fontSize = CGFloat.random(in: 20...35)
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
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if node.name == "playButton" || node.parent?.name == "playButton" {
                startGame()
                return
            }
        }
    }

    private func startGame() {
        GameState.shared.reset()

        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
