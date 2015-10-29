//
//  ViewController.swift
//  Stuffed
//
//  Created by Joe E. on 10/27/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SpriteKit

typealias PeerInfo = [DisplayName:[String:String]?]

class ViewController: UIViewController {
    var session: MCSession!
    var browser: MCNearbyServiceBrowser!
    var myPeerID: MCPeerID = MCPeerID(displayName: "Board")
    let scene = GameBoardScene(fileNamed: "GameBoard")
    
    var peerInfo: PeerInfo = [:]

    //ForMCSessionExtension
    var waitingPeers: [MCPeerID] = []
    var sendingInvite: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = view as? SKView {
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = false
            
        }
        
        session = MCSession(peer: myPeerID)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: "stuffed")

        browser.delegate = self
        browser.startBrowsingForPeers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension ViewController: MCNearbyServiceBrowserDelegate {
    func sendInvite() {
        if let peerID = waitingPeers.first {
            sendingInvite = true
            waitingPeers.removeFirst()
            browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
            
        }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if session.connectedPeers.contains(peerID) { return }
        
        peerInfo[peerID.displayName] = info
        if waitingPeers.contains(peerID) { return }
        waitingPeers.append(peerID)
        
        if !sendingInvite { sendInvite() }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("LostPeer \(peerID.displayName)")
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        
    }
    
}

extension ViewController: MCSessionDelegate {
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        if let gameData = GameData.data(data) {
            scene?.movePixel(peerID.displayName, direction: gameData.direction!.rawValue)
                
            
        }
        
        if let info = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String:String] {
            if let action = info?["action"] where action == "move", let direction = info?["direction"] {
                scene?.movePixel(peerID.displayName, direction:direction)
        
            }
            
            if let action = info?["action"] where action == "jump" {
                scene?.jumpPixel(peerID.displayName)
                
            }
            if let action = info?["action"] where action == "fire" {
                scene?.firePixel(peerID.displayName)
            }
            
        }
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        certificateHandler(true)
        
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        //ifPeerIDDidChangeAKAIfSomeoneJoinedTheSession
        let states = ["NotConnected","Connecting", "Connected"]
        let stateName = states[state.rawValue]
        
        if state != .Connecting {
            browser.stopBrowsingForPeers()
            browser.startBrowsingForPeers()
        }
        
        print("\(peerID.displayName)" + stateName)
        
        if state != .Connecting {
            sendingInvite = false
            sendInvite()
        }
        if state == .Connected {
            print(stateName)
            
            if let color = peerInfo[peerID.displayName]??["color"] {
                scene?.addPixel(peerID.displayName, colorName: color)
                
            }
            scene?.addPixel(peerID.displayName)
            
        }
        
        if state == .NotConnected {
            scene?.removePixel(peerID.displayName)
        }
        
    }
    
}