//
//  AnswerButton.swift
//  RainbowUnicornMath
//

import SpriteKit

@MainActor
class AnswerButton: SKNode {
    let value: Int
    private let background: SKShapeNode
    private let label: SKLabelNode
    private let buttonSize: CGSize

    init(value: Int, size: CGSize = CGSize(width: 100, height: 80), color: UIColor) {
        self.value = value
        self.buttonSize = size

        // Create rounded rectangle background
        background = SKShapeNode(rectOf: size, cornerRadius: 15)
        background.fillColor = color
        background.strokeColor = .white
        background.lineWidth = 3

        // Create label
        label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "\(value)"
        label.fontSize = 36
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center

        super.init()

        self.isUserInteractionEnabled = true
        self.addChild(background)
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showCorrect() {
        background.fillColor = RainbowColors.green
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.15)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.15)
        self.run(SKAction.sequence([scaleUp, scaleDown]))
    }

    func showWrong() {
        background.fillColor = RainbowColors.red
        let shakeRight = SKAction.moveBy(x: 10, y: 0, duration: 0.05)
        let shakeLeft = SKAction.moveBy(x: -20, y: 0, duration: 0.1)
        let shakeBack = SKAction.moveBy(x: 10, y: 0, duration: 0.05)
        self.run(SKAction.sequence([shakeRight, shakeLeft, shakeBack]))
    }

    func highlightCorrect() {
        background.fillColor = RainbowColors.green
        background.lineWidth = 5
    }

    func disable() {
        self.isUserInteractionEnabled = false
    }
}
