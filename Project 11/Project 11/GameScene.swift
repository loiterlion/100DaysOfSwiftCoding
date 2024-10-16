//
//  GameScene.swift
//  Project 11
//
//  Created by Bruce on 2024/10/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let backgroud = SKSpriteNode(imageNamed: "background")
        backgroud.position = CGPoint(x: 512, y: 384)
        backgroud.blendMode = .replace
        backgroud.zPosition = -1
        addChild(backgroud)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let box = SKSpriteNode(color: .red, size: CGSize(width: 60, height: 60))
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        box.position = location
        addChild(box)
    }
}
