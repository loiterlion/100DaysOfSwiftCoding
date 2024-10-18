//
//  GameScene.swift
//  Project 11
//
//  Created by Bruce on 2024/10/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var lifeLabel: SKLabelNode!
    var boxes = [SKSpriteNode]()
    
    var editingMode = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    
    var lifeCount = 5 {
        didSet {
            if lifeCount < 0 { lifeCount = 0 }
            lifeLabel.text = "Life: \(lifeCount)"
        }
    }
    var boxCount = 0

    fileprivate func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    override func didMove(to view: SKView) {
        let backgroud = SKSpriteNode(imageNamed: "background")
        backgroud.position = CGPoint(x: 512, y: 384)
        backgroud.blendMode = .replace
        backgroud.zPosition = -1
        addChild(backgroud)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        let ChalkdusterFont = "Chalkduster"
        
        scoreLabel = SKLabelNode(fontNamed: ChalkdusterFont)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        lifeLabel = SKLabelNode(fontNamed: ChalkdusterFont)
        lifeLabel.text = "Life: 5"
        lifeLabel.horizontalAlignmentMode = .center
        lifeLabel.position = CGPoint(x: 512, y: 700)
        addChild(lifeLabel)
        
        editLabel = SKLabelNode(fontNamed: ChalkdusterFont)
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 894, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    
        restartGame(action: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
            if editingMode {
                if boxes.count == 0 {
                    let ac = UIAlertController(title: "No obstacles!", message: "At least one box should be added", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    if let view = self.view, let viewController = view.window?.rootViewController {
                        viewController.present(ac, animated: true, completion: nil)
                    }
                }
            }
            editLabel.text  = editingMode ? "Done": "Edit"
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let color = UIColor(red: CGFloat.random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
                
                let box = SKSpriteNode(color: color, size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                boxes.append(box)
                boxCount += 1
                addChild(box)
            } else {
                let allBallImages = ["ballGrey", "ballCyan", "ballYellow", "ballRed", "ballGreen", "ballPurple"]
                let ball = SKSpriteNode(imageNamed: allBallImages.randomElement()!)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                
                location = CGPoint(x: location.x, y: 700)
                ball.position = location
                ball.name = "ball"
                addChild(ball)
            }
        }
    }
    
    func makeSlot(at position:  CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collison(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            lifeCount -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
            
        ball.removeFromParent()
    }
    
    func destroy(box: SKNode) {
        boxCount -= 1
        box.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // Coz box can only be hit by ball. Whenever balls are hit, destroy balls
        if nodeA.name == "box" {
            destroy(box: nodeA)
        } else if nodeB.name == "box" {
            destroy(box: nodeB)
        }
        
        //
        if nodeA.name == "ball" {
            collison(between: nodeA, object: nodeB)
        } else if contact.bodyB.node?.name == "ball" {
            collison(between: nodeB, object: nodeA)
        }
        
        updateGameResult()
    }
    
    func updateGameResult() {
        if lifeCount == 0 {
            // Game over!
            for box in boxes {
                box.removeFromParent()
            }
            showGameAlert(won: false)
            
        } else if boxCount == 0 {
            // Win the game!
            showGameAlert(won: true)
        }
    }
    
    func restartGame(action: UIAlertAction? = nil) {
        lifeCount = 5
        score = 0
        
        editLabel.text = "Done"
        editingMode = true
        
        for box in boxes {
            box.removeFromParent()
        }
        boxes.removeAll()
        boxCount = 0
    }
    
    func showGameAlert(won: Bool) {
        let ac = UIAlertController(title: won ? "Congrats!" : "Game Over!", message: "Try again!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart game", style: .default, handler: restartGame))
        
        if let view = self.view, let viewController = view.window?.rootViewController {
            viewController.present(ac, animated: true, completion: nil)
        }
    }
}
