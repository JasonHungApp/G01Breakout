//
//  GameScene.swift
//  G01Breakout
//
//  Created by jasonhung on 2024/3/31.
//

import SpriteKit
import GameplayKit

extension UIColor {
    static func random() -> UIColor {
        // 生成隨機的RGB顏色
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0.01...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 0.9)
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle: Paddle!
    var ball: SKShapeNode!
    var bricks = [[Brick]]()
    var gameStarted = false
    let impulseMagnitude: CGFloat = 7.0 // 設置推力大小
    // 定義直角的閾值（以弧度為單位）
    let rightAngleThreshold: CGFloat = 0.1

    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        printFrame()
        
        // Create paddle
        createPaddle()
        
        //addBorders()
        
        // Create ball
        ball = SKShapeNode(circleOfRadius: 10)
        ball.fillColor = .white
        ball.position = CGPoint(x: frame.midX, y: paddle.frame.minY + 50)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Brick | PhysicsCategory.Paddle
        ball.physicsBody?.linearDamping = 0 // 線性阻尼設置為0，球就不會受到外部阻力的影響，速度將保持不變
        ball.physicsBody?.restitution = 1.0 // 彈性設置為1，碰撞後速度不減慢
        addChild(ball)

        
        
        
        // Create bricks
        let brickSize = CGSize(width: 100, height: 40)
        let numRows = 5
        let rowsSpace = 1.5
        let numCols = Int(frame.width) / Int(brickSize.width)
        let colsSpace = 1.1
        
        for row in 0..<numRows {
            var rowBricks = [Brick]()
            for col in 0..<numCols {
                let brick = Brick(color: UIColor.random(), size: brickSize)
                brick.physicsBody?.categoryBitMask = PhysicsCategory.Brick

                brick.position = CGPoint(x: (CGFloat(col) * brickSize.width * colsSpace) + brickSize.width / 2 - 300.0,
                                         y: frame.maxY - (CGFloat(row) * brickSize.height*rowsSpace) - (brickSize.height / 2) - 150.0)
                addChild(brick)
                rowBricks.append(brick)
            }
            bricks.append(rowBricks)
        }
    }
    
    func createPaddle(){
        paddle = Paddle(color: .white, size: CGSize(width: 100, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        addChild(paddle)
    }
    
    // 在 GameScene 中添加邊界物體，在中心點為(0.5,0.5)
    func addBorders() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = self.size.height
        
        // 上邊界
        let topBorder = Border(color: .red, size: CGSize(width: screenWidth, height: 5))
        topBorder.position = CGPoint(x: 0, y: screenHeight / 2)
        addChild(topBorder)
        
        // 右邊界
        let rightBorder = Border(color: .green, size: CGSize(width: 5, height: screenHeight))
        rightBorder.position = CGPoint(x: screenWidth / 2, y: 0)
        addChild(rightBorder)
        
        // 左邊界
        let leftBorder = Border(color: .blue, size: CGSize(width: 5, height: screenHeight))
        leftBorder.position = CGPoint(x: -screenWidth / 2, y: 0)
        addChild(leftBorder)
    }
    
    
//    func addBorders2() {
//        let sceneWidth = self.size.width
//        let sceneHeight = self.size.height
//        
//       // let screenWidth = UIScreen.main.bounds.width
//       // let screenHeight = self.size.height
//        
//        // 上邊界
//        let topBorder = SKSpriteNode(color: .red, size: CGSize(width: sceneWidth, height: 5))
//        topBorder.position = CGPoint(x: 0, y: sceneHeight / 2) //position位置將是上邊界方塊的中心點位置
//        topBorder.physicsBody?.isDynamic = false
//        topBorder.physicsBody?.categoryBitMask = PhysicsCategory.Border
//        
//        addChild(topBorder)
//        
//        // 右邊界
//        let rightBorder = SKSpriteNode(color: .green, size: CGSize(width: 5, height: sceneHeight))
//        rightBorder.position = CGPoint(x: sceneWidth / 2-100, y: 0)
//        // 設置物理特性
//        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: rightBorder.size)
//        rightBorder.physicsBody?.isDynamic = false
//        // 設置碰撞檢測位元遮罩
//        rightBorder.physicsBody?.categoryBitMask = PhysicsCategory.Border
//        rightBorder.physicsBody?.collisionBitMask = PhysicsCategory.None
//        rightBorder.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
//        addChild(rightBorder)
//        
//        // 左邊界
//        let leftBorder = SKSpriteNode(color: .blue, size: CGSize(width: 5, height: sceneHeight))
//        leftBorder.position = CGPoint(x: -sceneWidth / 2, y: 0)
//        leftBorder.physicsBody?.isDynamic = false
//        leftBorder.physicsBody?.categoryBitMask = PhysicsCategory.Border
//        addChild(leftBorder)
//    }
    
    
    
    func printFrame(){
        //self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        print(frame)
        print("frame.minX= \(frame.minX), maxX= \(frame.maxX)")
        print("frame.minY= \(frame.minY), maxY= \(frame.maxY)")
        print("frame.midX= \(frame.midX), midY= \(frame.midY)")
        print("Scene anchorPoint: \(self.anchorPoint)")
        /*
         (-375.0, -667.0, 750.0, 1334.0)
         frame.minX= -375.0, maxX= 375.0
         frame.minY= -667.0, maxY= 667.0
         frame.midX= 0.0,    midY= 0.0
         Scene anchorPoint: (0.5, 0.5)
         */
    }
    
    

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        paddle.position.x = touchLocation.x
        if !gameStarted {
            ball.position.x = touchLocation.x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            gameStarted = true
            // 當遊戲還沒開始時，創造一個向量來推動球
            let vector = CGVector(dx: 0, dy: impulseMagnitude)
            ball.physicsBody?.applyImpulse(vector)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    // MARK: - SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        //1:Ball,2:Brick,4:Paddle
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Brick && secondBody.categoryBitMask == PhysicsCategory.Ball {
            // 球碰到磚塊時的處理邏輯
            if let brick = firstBody.node as? Brick {
                brick.removeFromParent() // 移除被碰撞的磚塊
            }
        }
        
 
    }

    // 在適當的類別或作用域中定義 calculateReflectionVector 方法
    func calculateReflectionVector(contact: SKPhysicsContact) -> CGVector {
        let contactPoint = contact.contactPoint
        let ballPosition = ball.position
        
        // 計算反射向量
        let reflectionVector = CGVector(dx: contactPoint.x - ballPosition.x, dy: contactPoint.y - ballPosition.y)
        
        // 返回反射向量
        return reflectionVector
    }
    
    // 根據碰撞點和球的中心點計算法向量
    func calculateReflectionAngle(contact: SKPhysicsContact) -> CGVector {
        let contactPoint = contact.contactPoint
        let ballPosition = ball.position
        
        // 計算法向量
        var normalVector = CGVector(dx: contactPoint.x - ballPosition.x, dy: contactPoint.y - ballPosition.y)
        
        // 標準化法向量
        let length = sqrt(normalVector.dx * normalVector.dx + normalVector.dy * normalVector.dy)
        if length != 0 {
            normalVector.dx /= length
            normalVector.dy /= length
        }
        
        // 返回法向量的相反值
        return CGVector(dx: -normalVector.dx, dy: -normalVector.dy)
    }
    
    
    
    //    func touchDown(atPoint pos : CGPoint) {
    //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //            n.position = pos
    //            n.strokeColor = SKColor.green
    //            self.addChild(n)
    //        }
    //    }
    //
    //    func touchMoved(toPoint pos : CGPoint) {
    //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //            n.position = pos
    //            n.strokeColor = SKColor.blue
    //            self.addChild(n)
    //        }
    //    }
    
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    

}
