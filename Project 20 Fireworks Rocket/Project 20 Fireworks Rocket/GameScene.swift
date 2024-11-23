//
//  GameScene.swift
//  Project 20 Fireworks Rocket
//
//  Created by Bruce on 2024/11/20.
//

import SpriteKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var gameTimer: Timer?
    var fireworks = [SKNode]()

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var launchCount = 4
    let interval: TimeInterval = 6
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        self.backgroundColor = .yellow
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        // .replace means totally replace the origional color
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let label = SKLabelNode(text: "Score: 0")
        label.color = .red
        label.position = CGPoint(x: 0, y: 0)
        label.horizontalAlignmentMode = .left
        addChild(label)
        scoreLabel = label
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
    }
    
    @objc func launchFireworks() {
        if launchCount <= 0 {
            stopGame()
        }
        
        let xMovement: CGFloat = 1200
        
        switch Int.random(in: 0...3) {
        case 0:
            // streight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            // left to right
            createFirework(xMovement: xMovement, x: leftEdge, y: 0)
            createFirework(xMovement: xMovement, x: leftEdge, y: 100)
            createFirework(xMovement: xMovement, x: leftEdge, y: 200)
            createFirework(xMovement: xMovement, x: leftEdge, y: 300)
            createFirework(xMovement: xMovement, x: leftEdge, y: 400)
        case 2:
            // right to left
            createFirework(xMovement: xMovement, x: rightEdge, y: 0)
            createFirework(xMovement: xMovement, x: rightEdge, y: 100)
            createFirework(xMovement: xMovement, x: rightEdge, y: 200)
            createFirework(xMovement: xMovement, x: rightEdge, y: 300)
            createFirework(xMovement: xMovement, x: rightEdge, y: 400)
        case 3:
            // fan shape
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
        default:
            break
        }
        
        launchCount -= 1
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)

        // 2
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .red
        case 2:
            firework.color = .yellow
        default:
            break
        }
        
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        /*
         // Add an arc (half circle) from start angle (π) to end angle (0) with clockwise set to false
         halfCirclePath.addArc(withCenter: center,
                               radius: radius,
                               startAngle: .pi,         // 180 degrees in radians
                               endAngle: 0,            // 0 degrees in radians
                               clockwise: true)
         */
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 20)
        
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
         
        fireworks.append(node)
        addChild(node)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }

            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let action1 = SKAction.wait(forDuration: 2)
            let action2 = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([action1, action2])
            emitter.run(sequence)
        }

        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
    func stopGame() {
        gameTimer?.invalidate()
        
        let label = SKLabelNode(text: "Game over!")
        label.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        label.fontSize = 100
        label.color = .red
        addChild(label)
    }
}
