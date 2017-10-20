//
//  RemoteCredentialManager.swift
//  Team4
//
//  Created by Julien Cayzac on 10/20/17.
//

import Foundation
import UIKit
import MultipeerConnectivity

class RemoteCredentialManager : NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    private let serviceType = "com.rakuten.id.japan.passwordCredential"
    private var peerId : MCPeerID!
    private var advertiser : MCNearbyServiceAdvertiser!

    override init() {
        super.init()

        // Create a peer id using the device name as a display name
        peerId = MCPeerID(displayName: UIDevice.current.name)

        // Get the app's display name
        let appBundle = Bundle.main
        let appName = appBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String

        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: ["appName": appName], serviceType: serviceType)
        advertiser.delegate = self
    }

    func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }

    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }

    // MARK: MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        // no-op for now
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = MCSession(peer: peerId)
        session.delegate = self
    }

    // MARK: MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // TODO
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // TODO
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // TODO
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // TODO
    }
}

