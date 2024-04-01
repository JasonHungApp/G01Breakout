//
//  Border.swift
//  G01Breakout
//
//  Created by jasonhung on 2024/4/1.
//

import SpriteKit

class Border: SKSpriteNode {
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Border
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
