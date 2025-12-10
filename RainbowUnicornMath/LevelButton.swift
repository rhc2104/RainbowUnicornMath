//
//  LevelButton.swift
//  RainbowUnicornMath
//

import SpriteKit

@MainActor
class LevelButton: SKNode {
    let level: MathLevel
    private let background: SKShapeNode
    private let nameLabel: SKLabelNode
    private let symbolLabel: SKLabelNode

    init(level: MathLevel, size: CGSize, color: UIColor) {
        self.level = level

        // Create rounded rectangle background
        background = SKShapeNode(rectOf: size, cornerRadius: 12)
        background.fillColor = color
        background.strokeColor = .white
        background.lineWidth = 3

        // Create name label
        nameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        nameLabel.text = level.displayName
        nameLabel.fontSize = 22
        nameLabel.fontColor = .white
        nameLabel.verticalAlignmentMode = .center
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: -size.width / 2 + 20, y: 0)

        // Create symbol label
        symbolLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        symbolLabel.text = level.symbol
        symbolLabel.fontSize = 28
        symbolLabel.fontColor = .white
        symbolLabel.verticalAlignmentMode = .center
        symbolLabel.horizontalAlignmentMode = .right
        symbolLabel.position = CGPoint(x: size.width / 2 - 20, y: 0)

        super.init()

        self.name = "levelButton_\(level.rawValue)"
        self.addChild(background)
        self.addChild(nameLabel)
        self.addChild(symbolLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
