//
//  GameScene.swift
//  PixelBattle
//
//  Created by Joe E. on 10/26/15.
//  Copyright (c) 2015 Joe E. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        print(frame)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
    
    }
}
