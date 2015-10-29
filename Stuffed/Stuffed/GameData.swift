//
//  GameData.swift
//  Stuffed
//
//  Created by Joe E. on 10/29/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import Foundation

let serviceType = "stuffed"

class GameData: NSObject, NSCoding {
    
    enum GameAction:String {
        case Move, Fire, Jump
    }
    
    var action: GameAction?
    var direction: PlayerDirection?
    
    init(action:GameAction, direction:PlayerDirection? = nil) {
        self.action = action
        self.direction = direction
        
    }
    
    class func data(data:NSData) -> GameData? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GameData
    }
    
    var data:NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let actionString = aDecoder.decodeObjectForKey("action") as? String {
            action = GameAction(rawValue:actionString)
            
        }
        
        if let directionString = aDecoder.decodeObjectForKey("action") as? String {
            direction = PlayerDirection(rawValue: directionString)
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(action?.rawValue, forKey: "action")
        aCoder.encodeObject(direction?.rawValue, forKey: "direction")
        
    }
    
}