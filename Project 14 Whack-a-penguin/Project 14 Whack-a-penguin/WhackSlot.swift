//
//  WhackSlot.swift
//  Project 14 Whack-a-penguin
//
//  Created by Bruce on 2024/10/24.
//

import Foundation
import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let hole = SKSpriteNode(imageNamed: "whackHole")
        addChild(hole)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.move(by: CGVector(dx: 0, dy: 80), duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) { [weak self] in
            self?.hide()
        }
        if let fireParticles = SKEmitterNode(fileNamed: "mud") {
            fireParticles.position = CGPoint(x: 0, y: 0)
            fireParticles.zPosition = 2
            addChild(fireParticles)
        }
    }
    
    func hide() {
        if !isVisible { return }

        charNode.run(SKAction.move(by: CGVector(dx: 0, dy: -80), duration: 0.05))
        isVisible = false
        if let fireParticles = SKEmitterNode(fileNamed: "mud") {
            fireParticles.position = charNode.position
            fireParticles.zPosition = 2
            addChild(fireParticles)
        }
    }
    
    func hit() {
        isHit = true

        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = charNode.position
            addChild(fireParticles)
        }
    }
}
