//
//  GameScene.swift
//  Project 26 Core Motion
//
//  Created by Bruce on 2025/1/24.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case teleport = 16
    case finish = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    let motionManager = CMMotionManager()
    
    var scoreLabel: SKLabelNode!
    
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var totalLevelCount = 3
    var nextLevel = 1
    
    var teleports = [SKSpriteNode]()
    var currentTeleport: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        loadLevel()
        createPlayer()
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
    }
    
    fileprivate func loadWall(_ position: CGPoint) {
        // load wall
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    fileprivate func loadVortex(_ position: CGPoint) {
        // load vortex
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
    }
    
    fileprivate func loadStart(_ position: CGPoint) {
        // load start
        let node = SKSpriteNode(imageNamed: "star")
        node.position = position
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
    }
    
    fileprivate func loadFinishPoint(_ position: CGPoint) {
        // load finish point
        let node = SKSpriteNode(imageNamed: "finish")
        node.position = position
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
    }
    
    func loadTeleport(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.position = position
        node.name = "teleport"
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
        
        teleports.append(node)
    }
    
    func loadLevel() {
        let nextLevelFilename = "level\(nextLevel)"
        guard let levelURL = Bundle.main.url(forResource: nextLevelFilename, withExtension: "txt") else {
            fatalError("Cound not find level1.txt in the app bundle")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Cound not load level1.txt in the app bundle")
        }
        
        // add background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // add scorelabel
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        let lines = levelString.components(separatedBy: "\n")
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    loadWall(position)
                } else if letter == "v" {
                    loadVortex(position)
                } else if letter == "s" {
                    loadStart(position)
                } else if letter == "f" {
                    loadFinishPoint(position)
                } else if letter == "t" {
                    loadTeleport(position)
                } else if letter == " " {
                    
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }

    func createPlayer(_ position: CGPoint = CGPoint(x: 96, y: 672)) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        if let tmp = currentTeleport {
            if !player.intersects(tmp) {
                currentTeleport = nil
            }
        }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
                
            
        }
        #else
        if let data = motionManager.accelerometerData {
            self.physicsWorld.gravity = CGVector(dx: data.acceleration.y * -50, dy: data.acceleration.x * 50)
        }
        #endif
            
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func moveToNextTeleport(_ node: SKNode) {
        teleports.enumerated().forEach { (index, tmp) in
            if tmp == node {
                let cnt = teleports.count
                let nextNode = teleports[(index + 1) % cnt]
                player.removeFromParent()
                createPlayer(nextNode.position)
                currentTeleport = nextNode
            }
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "teleport" {
            // move to next teleport
            if currentTeleport == nil {
                moveToNextTeleport(node)
            }
        } else if node.name == "finish" {
            
            showLevelCompleteAlert()
        }
    }
    
    func showLevelCompleteAlert() {
        let ac = UIAlertController(title: "Next Level", message: "Replay current level or continue to the next", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Replay", style: .default, handler: { [self] ac in
            player.removeFromParent()
            self.removeAllChildren()
            self.loadLevel()
            self.createPlayer()
        }))
        ac.addAction(UIAlertAction(title: "Next Level", style: .default, handler: { [self] ac in
            self.nextLevel += 1
            if nextLevel > totalLevelCount {
                showGameCompleteAlert()
            } else {
                player.removeFromParent()
                self.removeAllChildren()
                self.loadLevel()
                self.createPlayer()
            }
        }))
        
        // Present the alert on the root view controller
        if let viewController = self.view?.window?.rootViewController {
            viewController.present(ac, animated: true, completion: nil)
        }
    }
    
    func showGameCompleteAlert() {
//        let finishLabel = SKLabelNode(fontNamed: "Chalkduster")
//        finishLabel.name = ""
//        finishLabel.text = "游戏结束：得分：\(score)"
//        finishLabel.horizontalAlignmentMode = .left
//        finishLabel.position = CGPoint(x: 512, y: 384)
//        finishLabel.zPosition = 2
//        addChild(finishLabel)
        
        let ac = UIAlertController(title: "Total Score: \(score)", message: "Total socre is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] ac in
            // restart game
            score = 0
            nextLevel = 1
            
            player.removeFromParent()
            self.removeAllChildren()
            self.loadLevel()
            self.createPlayer()
        }))
        
        // Present the alert on the root view controller
        if let viewController = self.view?.window?.rootViewController {
            viewController.present(ac, animated: true, completion: nil)
        }
    }
}
