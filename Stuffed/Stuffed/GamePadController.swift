//
//  GamePadController.swift
//  Stuffed
//
//  Created by Joe E. on 10/27/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GamePadController: UIViewController, MCNearbyServiceAdvertiserDelegate {
    
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var myPeerID: MCPeerID = MCPeerID(displayName: "KungFuPanda")
    
    var boardID: MCPeerID?

    @IBAction func jumpPressed(sender: AnyObject) {
        let info = ["action" : "jump"]
        sendInfo(info)
        
    }
    
    @IBAction func firePressed(sender: AnyObject) {
        let info = ["action" : "fire"]
        sendInfo(info)
        
    }
    
    @IBAction func leftPressed(sender: AnyObject) {
        let info = [
            "action" : "move",
            "direction" : "left",
            
        ]
        
        sendInfo(info)
        
    }
    
    @IBAction func rightPressed(sender: AnyObject) {
        sendData(GameData(action: .Move, direction: .Right))

    }
    
    
    func sendData(gameData: GameData) {
        if let bID = boardID {
            
            do {
                try session.sendData(gameData.data, toPeers: [bID], withMode: .Reliable)
                
            } catch {
                print(error)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = MCSession(peer: myPeerID)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["color":"yellow"], serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        print(("InvitingPeer \(peerID.displayName)"))
        
        if peerID.displayName == "Board" {
            print(peerID)
            
            boardID = peerID
            print("acceptingInvite")
            invitationHandler(true, session)
            
        } else {
            print("decliningInvite")
            invitationHandler(false, session)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    func sendInfo(info:[String:String]) {
        if let data = try? NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted) {
            if let bID = boardID {
                
                do {
                    try session.sendData(data, toPeers: [bID], withMode: .Reliable)
                    
                } catch {
                    print(error)
                    
                }
                
            }
            
        }
        
    }

}

extension GamePadController: MCSessionDelegate {
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        print("\(peerID.displayName)")
        
        let states = ["NotConnected","Connecting", "Connected"]
        let stateName = states[state.rawValue]
        
        print(peerID)
        print("\(peerID.displayName)" + stateName)
        print(session.connectedPeers)
        
    }
    
}