//
//  Brick.swift
//  G01Breakout
//
//  Created by jasonhung on 2024/3/31.
//

import SpriteKit

class Brick: SKSpriteNode {
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Brick
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
