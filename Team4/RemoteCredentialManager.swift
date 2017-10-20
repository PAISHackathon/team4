//
//  RemoteCredentialManager.swift
//  Team4
//
//  Created by Julien Cayzac on 10/20/17.
//

import Foundation
import UIKit
import MultipeerConnectivity

class RemoteCredentialManager :
    NSObject,
    MCNearbyServiceAdvertiserDelegate,
    MCNearbyServiceBrowserDelegate,
    MCSessionDelegate
{
    private let serviceType = "r10-id-jp"
    private var localPeerId : MCPeerID!
    private var advertiser : MCNearbyServiceAdvertiser!
    private var browser : MCNearbyServiceBrowser!
    private var session : MCSession!
    
    private var isBroadcasting = false
    private var isListening = false

    override init() {
        super.init()

        localPeerId = MCPeerID(displayName: UIDevice.current.name)

        session = MCSession(peer: localPeerId)
        session.delegate = self

        advertiser = MCNearbyServiceAdvertiser(peer: localPeerId, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self

        browser = MCNearbyServiceBrowser(peer: localPeerId, serviceType: serviceType);
        browser.delegate = self
    }

    // MARK: Broadcasting
    // ------------------
    //
    // Used by devices that have credentials to share.
    //

    // Should be called when the app is foreground and has credentials
    func startBroadcasting() {
        advertiser.startAdvertisingPeer()
        isBroadcasting = true
    }

    // Should be called when the app goes to background
    func stopBroadcasting() {
        advertiser.stopAdvertisingPeer()
        isBroadcasting = false
    }

    // MARK: Listening
    // ---------------
    //
    // Used by devices that don't have any credential, when a user wants to log in

    // Should be called by the login form when it's shown
    func startListening() {
        browser.startBrowsingForPeers()
        isListening = true
    }

    // Should be called by the login form when it's dismissed
    func stopListening() {
        browser.stopBrowsingForPeers()
        isListening = false
    }

    // MARK: MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising: \(error.localizedDescription)")
    }

    // Grant/Deny peer credential requests
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from [\(peerID.displayName)] peer")

        if isBroadcasting {
            let alert = UIAlertController(title: nil,
                                          message: "[\(peerID.displayName)] would like to access your credentials",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Deny",
                                          style: .cancel,
                                          handler: { _ in invitationHandler(false, nil) }))

            alert.addAction(UIAlertAction(title: "Grant",
                                          style: .default,
                                          handler: { _ in invitationHandler(true, self.session) }))

            // Dirty!
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let parent = appDelegate.window?.rootViewController?.presentingViewController {
                parent.show(alert, sender: nil)
            }
        }
    }

    // MARK: MCNearbyServiceBrowserDelegate

    //
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found [\(peerID.displayName)] peer")

        if isListening {
            // Invite server to join the session. Note we may invite multiple servers, but it's ok
            // we'll just take the credentials from the first that grants us access.
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30.0)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost [\(peerID.displayName)] peer")
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Did not start browing: \(error.localizedDescription)")
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

