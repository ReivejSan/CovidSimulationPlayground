
//apple game engine
import SpriteKit

//to display the game
import PlaygroundSupport

//import UIKit
import UIKit

//view that display the scene for the game
let skView = SKView(frame: .zero)

let withMask = WithMask(size: UIScreen.main.bounds.size)
withMask.scaleMode = .aspectFill //fill up the screen
skView.presentScene(withMask)
skView.preferredFramesPerSecond = 60



//feeding skview to display in playground
PlaygroundPage.current.liveView = skView

//use fullscreen
PlaygroundPage.current.wantsFullScreenLiveView = true
