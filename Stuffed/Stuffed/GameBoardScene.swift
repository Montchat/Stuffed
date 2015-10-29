//
//  GameBoardScene.swift
//  Stuffed
//
//  Created by Joe E. on 10/27/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity

typealias DisplayName = String
typealias PlayerPixel = [DisplayName:SKShapeNode]
typealias PlayerCurrentDirection = [DisplayName:PlayerDirection]

private let colors = [
    
    "red": UIColor.redColor(),
    "blue": UIColor.blueColor(),
    "cyan": UIColor.cyanColor(),
    "green": UIColor.greenColor(),
    "yellow": UIColor.yellowColor(),
    "purple" : UIColor.purpleColor(),
    "magenta" : UIColor.magentaColor(),
    "black" : UIColor.blackColor(),
    "white" : UIColor.orangeColor()
    
]

enum PlayerDirection: String {
    case Left = "left", Right = "right"
    
    var dValue: CGFloat {
        return self == .Left ? -1 : 1
    }
}

class GameBoardScene: SKScene {
    
    var playerPixels: PlayerPixel = [:]
    var currentDirections: PlayerCurrentDirection = [:]
    
    override func didMoveToView(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.categoryBitMask = 0b1
        physicsWorld.contactDelegate = self
        
    }
    
    func addPixel(name:DisplayName, colorName:String = "yellow") {
        print("newPixel")
        let pixel = SKShapeNode(rectOfSize: CGSize(width: 20, height: 20))
        pixel.name = name
        pixel.fillColor = colors[colorName] ?? UIColor.yellowColor()
        pixel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))

        print(position)
        pixel.physicsBody = SKPhysicsBody(rectangleOfSize: pixel.frame.size)
        pixel.physicsBody?.categoryBitMask = 0b1
        
        addChild(pixel)
        
        playerPixels[name] = pixel
        currentDirections[name] = .Right
        
    }
    
    func firePixel(name:DisplayName) {
        if let pixel = playerPixels[name] {
            let fireball = SKShapeNode(rectOfSize: CGSize(width: 5, height: 5))
            fireball.fillColor = pixel.fillColor
            fireball.name = "Steve"
            fireball.physicsBody = SKPhysicsBody(rectangleOfSize: fireball.frame.size)
            fireball.physicsBody?.contactTestBitMask = 0b1
            fireball.physicsBody?.categoryBitMask = 0b1
            fireball.physicsBody?.affectedByGravity = false
            addChild(fireball)
            
            let d = currentDirections[name]
            let offsetX = (d?.dValue ?? 0) * 100
            
            fireball.physicsBody?.applyForce(CGVector(dx: offsetX, dy: 0))
            fireball.position.y = pixel.position.y
            fireball.position.x = pixel.position.x + (d?.dValue ?? 0) * 21
            
        }
        
    }
    
    func jumpPixel(name:DisplayName) {
        playerPixels[name]?.physicsBody?.applyForce(CGVector(dx: 0, dy: 100))
        
    }
    
    func movePixel(name:DisplayName, direction: String) {
        let pixel = playerPixels[name]
        let d = PlayerDirection(rawValue: direction)
        let offsetX = (d?.dValue ?? 0) * 50
        pixel?.physicsBody?.applyForce(CGVector(dx: offsetX, dy: 0))
        
        currentDirections[name] = d
    }
    
    func removePixel(name:DisplayName) {
        playerPixels[name]?.removeFromParent()
    }

}

extension GameBoardScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode {
            if nodeA.name == "Steve" {
                nodeA.removeFromParent()
            }
            
        }
        
        if let nodeB = contact.bodyB.node as? SKShapeNode {
            if nodeB.name == "Steve" {
                nodeB.removeFromParent()
            }
            
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
    
}