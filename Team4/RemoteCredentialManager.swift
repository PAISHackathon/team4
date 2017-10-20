//
//  RemoteCredentialManager.swift
//  Team4
//
//  Created by Julien Cayzac on 10/20/17.
//

import Foundation
import UIKit
import MultipeerConnectivity

extension Notification.Name {
    static let credentialServersFound = Notification.Name("credentialServersFound")
    static let credentialServersNotFound = Notification.Name("credentialServersNotFound")
    static let credentialAcquired = Notification.Name("credentialAcquired")
}

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
    private var discoveredPeers = [MCPeerID]()

    private var isBroadcasting = false
    private var isListening = false

    override init() {
        super.init()

        localPeerId = MCPeerID(displayName: UIDevice.current.name)

        session = MCSession(peer: localPeerId, securityIdentity: nil, encryptionPreference: .none)
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

        discoveredPeers.removeAll()
        isListening = false
    }

    // MARK: Request management
    // ------------------------

    func requestCredential() {
        for peerID in discoveredPeers {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30.0)
        }
    }

    fileprivate func postCredentialAcquired(_ credential: UserCredential!) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .credentialAcquired, object: credential)
        }
    }

    // MARK: MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising: \(error.localizedDescription)")
    }

    // Grant/Deny peer credential requests
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from [\(peerID.displayName)] peer")

        if isBroadcasting {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil,
                                              message: "[\(peerID.displayName)] would like to access your credentials",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Deny",
                                              style: .cancel,
                                              handler: { _ in invitationHandler(false, nil) }))

                alert.addAction(UIAlertAction(title: "Grant",
                                              style: .default,
                                              handler: { _ in invitationHandler(true, self.session) }))

                AppDelegate.shared.show(viewController: alert)
            }
        }
    }

    // MARK: MCNearbyServiceBrowserDelegate

    //
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found [\(peerID.displayName)] peer")

        if isListening {
            if !discoveredPeers.contains(peerID) {
                discoveredPeers.append(peerID)
            }

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .credentialServersFound, object: self)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost [\(peerID.displayName)] peer")

        if let index = discoveredPeers.index(of: peerID) {
            discoveredPeers.remove(at: index)
        }

        if discoveredPeers.isEmpty {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .credentialServersNotFound, object: self)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Did not start browing: \(error.localizedDescription)")
    }

    // MARK: MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected, let user = LocalCredentialManager.shared.loadUser() {
            do {
                let data = try JSONEncoder().encode(user)
                try session.send(data, toPeers: [peerID], with: .reliable)
            } catch {
                print("Something wrong", error.localizedDescription)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let userCredential: UserCredential = try JSONDecoder().decode(UserCredential.self, from: data)
            // get it back
            session.disconnect()
            postCredentialAcquired(userCredential)
        } catch {
            print("Something wrong", error.localizedDescription)
        }
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

