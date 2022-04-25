
//apple game engine
import SpriteKit

//to display the game
import PlaygroundSupport

//import UIKit
import UIKit

//view that display the scene for the game
let skView = SKView(frame: .zero)

let theGame = AvoidCovidGame(size: UIScreen.main.bounds.size)
theGame.scaleMode = .aspectFill //fill up the screen
skView.presentScene(theGame)
skView.preferredFramesPerSecond = 60



//feeding skview to display in playground
PlaygroundPage.current.liveView = skView

//use fullscreen
PlaygroundPage.current.wantsFullScreenLiveView = true
