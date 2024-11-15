//
//  GameScene.swift
//  Day 66 Shooting Game by Chatgpt
//
//  Created by Bruce on 2024/11/14.
//

import SpriteKit

class GameScene: SKScene {
    
    // Properties for game setup
    var scoreLabel: SKLabelNode!
    var score = 0
    var targetSpeed: TimeInterval = 2.0
    
    override func didMove(to view: SKView) {
        // Set up the background color
        self.backgroundColor = .white
        
        // Create and add score label to the scene
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 50)
        scoreLabel.text = "Score: \(score)"
        
        addChild(scoreLabel)
        
        // Start spawning targets
        spawnTargets()
    }
    
    func spawnTargets() {
        // Create three rows
        let rows = [self.frame.height * 0.75, self.frame.height * 0.5, self.frame.height * 0.25]
        
        for row in rows {
            // Create and move targets
            let target = createTarget()
            let startX: CGFloat = -target.size.width
            let endX: CGFloat = self.frame.width + target.size.width
            target.position = CGPoint(x: startX, y: row)
            
            // Add the target to the scene
            addChild(target)
            
            // Define movement action for the target
            let moveAction = SKAction.moveTo(x: endX, duration: targetSpeed)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            target.run(sequence)
        }
        
        // Recurse and spawn new targets every 2 seconds
        let waitAction = SKAction.wait(forDuration: 2.0)
        let spawnAction = SKAction.run { self.spawnTargets() }
        let spawnSequence = SKAction.sequence([waitAction, spawnAction])
        run(spawnSequence)
    }
    
    func createTarget() -> SKSpriteNode {
        let target = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        target.name = "target" // Naming the target to detect taps
        return target
    }
    
    // Handle touch events for shooting
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)
            
            for node in nodesAtPoint {
                if node.name == "target" {
                    // Remove target and increase score
                    node.removeFromParent()
                    score += 1
                    scoreLabel.text = "Score: \(score)"
                }
            }
        }
    }
    
    // Optional: Adjust difficulty over time (e.g., speed up targets as score increases)
    override func update(_ currentTime: TimeInterval) {
        if score % 10 == 0 && targetSpeed > 1.0 {
            targetSpeed -= 0.1 // Make targets move faster as the score increases
        }
    }
}
