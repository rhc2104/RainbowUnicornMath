//
//  GameViewController.swift
//  RainbowUnicornMath
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    private var currentSceneSize: CGSize = .zero

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true

            // Disable debug info for production
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let skView = self.view as? SKView else { return }

        let newSize = skView.bounds.size

        // Only update if size changed significantly (orientation change)
        if abs(newSize.width - currentSceneSize.width) > 1 || abs(newSize.height - currentSceneSize.height) > 1 {
            currentSceneSize = newSize

            // Determine which scene to present based on current scene type
            let newScene: SKScene
            if let currentScene = skView.scene {
                if currentScene is GameScene {
                    newScene = GameScene(size: newSize)
                } else if currentScene is ResultsScene {
                    newScene = ResultsScene(size: newSize)
                } else {
                    newScene = MenuScene(size: newSize)
                }
            } else {
                newScene = MenuScene(size: newSize)
            }

            newScene.scaleMode = .resizeFill
            skView.presentScene(newScene)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
