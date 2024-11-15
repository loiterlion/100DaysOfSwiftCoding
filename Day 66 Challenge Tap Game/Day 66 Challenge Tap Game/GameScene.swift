//
//  GameScene.swift
//  Day 66 Challenge Tap Game
//
//  Created by Bruce on 2024/11/12.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var label : SKLabelNode?
    private var scoreLabel : SKLabelNode!
    private var timeLabel : SKLabelNode!
    var gameTimer: Timer?
    var countDown: Int = 10  {
        didSet {
            timeLabel.text = "Time remained: \(countDown)"
        }
    }//60 seconds
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        let screenSize = UIScreen.main.bounds.size
        background.position = CGPoint(x: screenSize.width / 2.0, y: screenSize.height / 2.0)
        background.blendMode = .replace
        background.scale(to: screenSize)
        background.zPosition = -1
        background.name = "background"

        addChild(background)
        
        let ChalkdusterFont = "Chalkduster"
        
        scoreLabel = SKLabelNode(fontNamed: ChalkdusterFont)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.fontColor = .black
        addChild(scoreLabel)
        
        let aLabel = SKLabelNode(fontNamed: ChalkdusterFont)
        aLabel.text = "Time remained: 0"
        aLabel.horizontalAlignmentMode = .left
        aLabel.position = CGPoint(x: 50, y: 700)
        aLabel.fontColor = .black
        
        addChild(aLabel)
        timeLabel = aLabel
        
        restartGame()
    }
    
    @objc func createSprite() {
        if countDown <= 0 {
            // Game Over
            gameOver()
        }
        
        createASprite(fromLeft: false, yPosition: 576)
        createASprite(fromLeft: true, yPosition: 384)
        createASprite(fromLeft: false, yPosition: 192)
        
        countDown -= 1
    }
    
    func gameOver() {
        gameTimer?.invalidate()
        
        let label = SKLabelNode(text: "Game Over!")
        label.fontSize = 30
        label.fontColor = .red
        label.fontName = "Helvetica-Bold"
        label.position = CGPoint(x: 512, y: 384)
        label.zPosition = 2
        
        addChild(label)
        
        for child in children {
            if child.name == "sprite" {
                child.removeFromParent()
            }
        }
    }
    
    @objc func createASprite(fromLeft: Bool, yPosition: CGFloat) {
        var velocity = 0
        var xStartPosition = 0.0
        if fromLeft {
            velocity = 500
            xStartPosition = -200
        } else {
            velocity = -500
            xStartPosition = 1200
        }
        
        let imageNames = ["apple", "banana", "orange", "coconut", "pineapple", "watermelon", "explosion", "bomb"]
        let randomImage = imageNames.randomElement()!
        let sprite = SKSpriteNode(imageNamed: randomImage)
        sprite.position = CGPoint(x: xStartPosition, y: yPosition)
        sprite.name = "sprite"
        addChild(sprite)
        
        let physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        physicsBody.categoryBitMask = (randomImage == "bomb") ? 1 : 2
        physicsBody.velocity = CGVector(dx: velocity, dy: 0)
        physicsBody.angularVelocity = 5
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        sprite.physicsBody = physicsBody
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            if (node.position.x <= -210 ||
                node.position.x >= 1210) {
                node.removeFromParent()
            }
        }
    }
    
    func restartGame() {
        
        score = 0
        
        countDown = 10
        
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createSprite), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = nodes(at: location)
        
        for node in nodes {
            if node is SKLabelNode {
                // Restart Game
                restartGame()
            }
            
            if node.name == "background" { continue }
            
            if node.physicsBody?.categoryBitMask == 1 { // bomb
                score -= 1
            } else {
                score += 1
            }
            
            node.removeFromParent()
        }
    }
}
