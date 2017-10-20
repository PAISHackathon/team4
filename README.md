# team4
Team 4's project for the SSED PAIS Hackathon.

## Overview
This is a short POC for the concept documented at [ezpx.github.io](https://ezpx.github.io/) for iOS, using Apple's [`MultipeerConnectivity`](https://developer.apple.com/documentation/multipeerconnectivity/) framework to do peer-to-peer networking over the **Apple Wireless Direct Link** protocol. Because it uses AWDL, **it does not require devices to be _connected_ to an access point**.

The sample app implements cross-device credential exchange, allowing a user to login on device B if they're logged into device A already.

## Limitations
- No security is implemented in the POC, tho the framework supports encryption using X.509 certificates.
- Error handling is minimal
- Code is messy and nowhere ready for being used in anything serious (hey it's a hackathon, right…)

## Next steps
[ ] Public key exchange and proper security.
[ ] Android implementation using Wi-Fi P2P.
[ ] Support for iOS⬌Android data exchange (this should already work over tethered Wi-Fi, actualy).
[ ] Proper implementation of every state.
[ ] Conquer the world.

## Team 4 members
|⭐️|Name|
|-|-|
|![the-pear](https://avatars3.githubusercontent.com/u/30165525?s=32)|[@the-pear](https://github.com/the-pear)|
|![jcayzac](https://avatars0.githubusercontent.com/u/106682?s=32)|[@jcayzac](https://github.com/jcayzac)|

## License
See [LICENSE](//github.com/PAISHackathon/team4/blob/master/LICENSE)
