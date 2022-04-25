

import  SpriteKit
import UIKit

//create class that inherit from SKScene
public class WithoutMask: SKScene, SKPhysicsContactDelegate {
    //VIP CONSTANT
    let numberOfPeople = 20
    let maxEnemySpeed: uint32 = 350
    var currentSpeed: uint32 = 0
    var minimumLenght: CGFloat = 0.01
    
    var player: SKSpriteNode!
    var people = [SKSpriteNode]()
    var gameOver = false
    var movingPlayer = false
    var offSet: CGPoint!
    
    var prevScoreCalcTime:TimeInterval = 0
    
    func positionWithin(range: CGFloat, containerSize: CGFloat) -> CGFloat {
        let partA = CGFloat(arc4random_uniform(50)) / 50.0
        let partB = (containerSize * (1.0 - range) * 0.5)
        let partC = (containerSize * range + partB)
        return partA * partC
    }
    
    func distanceFrom(posA: CGPoint, posB: CGPoint) -> CGFloat {
        let aSquared = (posA.x - posB.x) * (posA.x - posB.x)
        let bSquared = (posA.y - posB.y) * (posA.y - posB.y)
        
        return sqrt(aSquared + bSquared)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if currentTime - prevScoreCalcTime > 1 {
            
        }
    }
    
    public override func didMove(to view: SKView) {
        
        minimumLenght /= 2.0
        
//        var uiButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        uiButton.backgroundColor = .lightGray
//        uiButton.setTitle("PPKM", for: .normal)
//        uiButton.layer.cornerRadius = 10
//        uiButton.clipsToBounds = true
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //add physicsbody
        physicsBody?.friction = 0.0 //no friction on physics body
        physicsWorld.contactDelegate = self //check contact with other
        
        //add Background
        let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "background.png"))) ///background.png
        background.setScale(2.0)
        background.zPosition = -10 //set z position so don't overlap
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        //add Player
        //        player = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "image-removebg-preview-3.png")), color: .clear, size: CGSize(width: size.width * 0.05, height: size.width * 0.05))
        //        player.position = CGPoint(x: frame.midX, y: frame.midY)
        //        addChild(player)
        //        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width * (0.05 + minimumLenght))
        //        player.physicsBody?.isDynamic = false
        //        player.physicsBody?.categoryBitMask = BitMask.player
        //        player.physicsBody?.contactTestBitMask = BitMask.enemy
        //        player.addCircle(radius: minimumLenght, edgeColor: .green, filled: true)
        
        //people
        for _ in 1 ... numberOfPeople {
            createPerson()
        }
        
        for person in people {
            person.physicsBody?.applyImpulse(CGVector(dx: CGFloat(arc4random_uniform(maxEnemySpeed)) - (CGFloat(maxEnemySpeed) * 0.05), dy: CGFloat(arc4random_uniform(maxEnemySpeed)) - (CGFloat(maxEnemySpeed) * 0.05)))
            currentSpeed = uint32(person.speed)
        }
        
        let maskedPerson = people[Int(arc4random_uniform(uint(people.count)))]
        maskedPerson.texture = SKTexture(image: #imageLiteral(resourceName: "masked person.png")) ///maskedperson.png
        maskedPerson.physicsBody?.categoryBitMask = BitMask.maskedPerson
        (maskedPerson.children.first as? SKShapeNode)?.strokeColor = .green
        
        let infectedEnemy = people[Int(arc4random_uniform(UInt32(people.count)))]
        infectedEnemy.texture = SKTexture(image: #imageLiteral(resourceName: "virus.png")) ///virus.png
        infectedEnemy.physicsBody?.categoryBitMask = BitMask.enemy
        (infectedEnemy.children.first as? SKShapeNode)?.strokeColor = .red
    }
    
    func createPerson() {
        
        let person = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "normal person.png")), color: .clear, size: CGSize(width: size.width * 0.05, height: size.width * 0.05)) ///normalperson.png
        
        person.position = CGPoint(x: positionWithin(range: 1, containerSize: size.width), y: positionWithin(range: 1, containerSize: size.height))
        
        person.addCircle(radius: minimumLenght, edgeColor: .orange, filled: false)
        
        //        while distanceFrom(posA: person.position, posB: player.position) < person.size.width * minimumLenght * 5 {
        //            person.position = CGPoint(x: positionWithin(range: 1, containerSize: size.width), y: positionWithin(range: 1, containerSize: size.height))
        //            print("Test")
        //        }
        
        addChild(person)
        people.append(person)
        print("Person spawned")
        person.physicsBody = SKPhysicsBody(circleOfRadius: person.size.width * (0.5 + minimumLenght))
        person.physicsBody?.affectedByGravity = false
        person.physicsBody?.categoryBitMask = BitMask.uninfectedPerson
        person.physicsBody?.contactTestBitMask = BitMask.enemy
        person.physicsBody?.friction = 0.0
        person.physicsBody?.angularDamping = 0.0
        person.physicsBody?.restitution = 1.1
        person.physicsBody?.allowsRotation = false
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchNodes = nodes(at: touchLocation)
        
        for node in touchNodes{
            if node == player {
                movingPlayer = true
                offSet = CGPoint(x: touchLocation.x - player.position.x, y: touchLocation.y - player.position.x)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver && movingPlayer else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let newPlayerPosition = CGPoint(x: touchLocation.x - offSet.x, y: touchLocation.y - offSet.y)
        
        player.run(SKAction.move(to: newPlayerPosition, duration: 0.01)) //for smoothening
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingPlayer = false
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == BitMask.uninfectedPerson && contact.bodyB.categoryBitMask == BitMask.enemy {
            infect(person: contact.bodyA.node as! SKSpriteNode)
            
        } else if contact.bodyB.categoryBitMask == BitMask.uninfectedPerson && contact.bodyA.categoryBitMask == BitMask.enemy {
            
            infect(person: contact.bodyB.node as! SKSpriteNode)
        } else if contact.bodyA.categoryBitMask == BitMask.player || contact.bodyB.categoryBitMask == BitMask.player {
            triggerGameOver()
        }    
    }
    
    func infect(person: SKSpriteNode) {
        person.texture = SKTexture(image: #imageLiteral(resourceName: "sick person.png")) ///sickperson.png
        person.physicsBody?.categoryBitMask = BitMask.enemy
        (person.children.first as? SKShapeNode)?.strokeColor = .red
    }
    
    func triggerGameOver() {
        gameOver = true
        player.texture = SKTexture(image: #imageLiteral(resourceName: "sick person.png")) ///sickperson.png
        (player.children.first as? SKShapeNode)?.strokeColor = .red
        (player.children.first as? SKShapeNode)?.fillColor = .init(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.3) 
        
        for person in people {
            person.physicsBody?.velocity = .zero
        }
        
        let gameOverLabel = SKLabelNode(text: "You've been infected")
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.fontSize = 75
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 3
        gameOverLabel.fontColor = .systemRed
        
        addChild(gameOverLabel)
    }
}


