//
//  LevelButton.swift
//  RainbowUnicornMath
//

import SpriteKit

@MainActor
class LevelButton: SKNode {
    let level: MathLevel
    let difficulty: DifficultyLevel?
    private let background: SKShapeNode
    private let nameLabel: SKLabelNode
    private let symbolLabel: SKLabelNode?

    // Initializer for level buttons (main menu)
    init(level: MathLevel, size: CGSize, color: UIColor) {
        self.level = level
        self.difficulty = nil

        background = SKShapeNode(rectOf: size, cornerRadius: 12)
        background.fillColor = color
        background.strokeColor = .white
        background.lineWidth = 3

        nameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        nameLabel.text = level.displayName
        nameLabel.fontSize = 22
        nameLabel.fontColor = .white
        nameLabel.verticalAlignmentMode = .center
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: -size.width / 2 + 20, y: 0)

        let symbol = SKLabelNode(fontNamed: "AvenirNext-Bold")
        symbol.text = level.symbol
        symbol.fontSize = 28
        symbol.fontColor = .white
        symbol.verticalAlignmentMode = .center
        symbol.horizontalAlignmentMode = .right
        symbol.position = CGPoint(x: size.width / 2 - 20, y: 0)
        symbolLabel = symbol

        super.init()

        self.name = "levelButton_\(level.rawValue)"
        self.addChild(background)
        self.addChild(nameLabel)
        if let symbol = symbolLabel {
            self.addChild(symbol)
        }
    }

    // Initializer for difficulty buttons (submenu)
    init(difficulty: DifficultyLevel, size: CGSize, color: UIColor) {
        self.level = .addition  // Placeholder, not used for difficulty buttons
        self.difficulty = difficulty

        background = SKShapeNode(rectOf: size, cornerRadius: 12)
        background.fillColor = color
        background.strokeColor = .white
        background.lineWidth = 3

        nameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        nameLabel.text = difficulty.displayName
        nameLabel.fontSize = 20
        nameLabel.fontColor = .white
        nameLabel.verticalAlignmentMode = .center
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: 0)

        symbolLabel = nil

        super.init()

        self.name = "difficultyButton_\(difficulty)"
        self.addChild(background)
        self.addChild(nameLabel)
    }

    // Initializer for text-only buttons (back button)
    init(text: String, size: CGSize, color: UIColor) {
        self.level = .addition  // Placeholder, not used
        self.difficulty = nil

        background = SKShapeNode(rectOf: size, cornerRadius: 12)
        background.fillColor = color
        background.strokeColor = .white
        background.lineWidth = 3

        nameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        nameLabel.text = text
        nameLabel.fontSize = 20
        nameLabel.fontColor = .white
        nameLabel.verticalAlignmentMode = .center
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: 0)

        symbolLabel = nil

        super.init()

        self.name = "textButton_\(text)"
        self.addChild(background)
        self.addChild(nameLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
