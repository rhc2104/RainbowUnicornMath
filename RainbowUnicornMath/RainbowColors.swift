//
//  RainbowColors.swift
//  RainbowUnicornMath
//

import UIKit
import SpriteKit

struct RainbowColors {
    static let red = UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0)       // #FF6B6B
    static let orange = UIColor(red: 1.0, green: 0.66, blue: 0.30, alpha: 1.0)    // #FFA94D
    static let yellow = UIColor(red: 1.0, green: 0.88, blue: 0.40, alpha: 1.0)    // #FFE066
    static let green = UIColor(red: 0.41, green: 0.86, blue: 0.49, alpha: 1.0)    // #69DB7C
    static let blue = UIColor(red: 0.45, green: 0.75, blue: 0.99, alpha: 1.0)     // #74C0FC
    static let purple = UIColor(red: 0.85, green: 0.47, blue: 0.95, alpha: 1.0)   // #DA77F2
    static let pink = UIColor(red: 1.0, green: 0.71, blue: 0.76, alpha: 1.0)      // #FFB5C2

    static let allColors: [UIColor] = [red, orange, yellow, green, blue, purple]

    static func randomColor() -> UIColor {
        return allColors.randomElement() ?? purple
    }
}

extension SKScene {
    func createRainbowGradientBackground() -> SKSpriteNode {
        let size = self.size
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return SKSpriteNode()
        }

        let colors = RainbowColors.allColors.map { $0.cgColor } as CFArray
        let locations: [CGFloat] = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]

        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                         colors: colors,
                                         locations: locations) else {
            UIGraphicsEndImageContext()
            return SKSpriteNode()
        }

        context.drawLinearGradient(gradient,
                                   start: CGPoint(x: 0, y: size.height),
                                   end: CGPoint(x: 0, y: 0),
                                   options: [])

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let texture = SKTexture(image: image ?? UIImage())
        let backgroundNode = SKSpriteNode(texture: texture, size: size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -100

        return backgroundNode
    }
}
