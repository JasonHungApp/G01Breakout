//
//  PhysicsCategory.swift
//  G01Breakout
//
//  Created by jasonhung on 2024/3/31.
//

import Foundation

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Ball: UInt32 = 0b1       //1:Ball,2:Brick,4:Paddle
    static let Brick: UInt32 = 0b10     //
    static let Paddle: UInt32 = 0b100   //
    static let Border: UInt32 = 0b1000  // 定義邊界類別成員

}
