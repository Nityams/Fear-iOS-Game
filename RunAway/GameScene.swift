//
//  GameScene.swift
//  RunAway
//
//  Created by Nityam Shrestha on 7/18/16.
//  Copyright (c) 2016 nityamshrestha.com. All rights reserved.
//

import SpriteKit
import Foundation

enum State{
    case Active, Paused, GameOver, LanternGlow
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var gameState:State = .Active
    var groundScroll: SKNode!
    var cloudScroll: SKNode!
    var backScroll: SKNode!
    var hero: SKSpriteNode!
    var ghost: SKSpriteNode!
    
    // background effect
    var bnw1: SKSpriteNode!
    var bnw2: SKSpriteNode!
    var bnw3: SKSpriteNode!
    var bnw4: SKSpriteNode!
    var bnw5: SKSpriteNode!
    var bnw6: SKSpriteNode!
    var bnw7: SKSpriteNode!
    var bnw8: SKSpriteNode!
    
    var potionSpawnTimer: CFTimeInterval = 0
    var pitSpawnTimer: CFTimeInterval = 0
    var lanternSpawnTimer: CFTimeInterval = 0
    var ghostSpawnTimer: CFTimeInterval = -5
    var boostSpawnTimer: CFTimeInterval = 0
    var generalLanternTimeCounter:CFTimeInterval = 13
    
    var originalGravity:CGFloat!
    
    let ghostOriginalPos:CGPoint = CGPoint(x: -54, y: 89.963)
    
    var myBox:SKSpriteNode!
    
    var potion:Int = 0
    var jumpImpulse:CGFloat = 18
    // var superLanternRectangle: CGRect
    var lamp1:SKNode!
    var lamp2:SKNode!
    var lamp3:SKNode!
    var lamp4:SKNode!
    var light1: SKLightNode!
    var light2: SKLightNode!
    
    var scrollSpeed:CGFloat = 230
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var lastLanternTime: CFTimeInterval = 0
    
    var score: Int = 1
    var scoreCounter = 0
    var scoreLabel:SKLabelNode!
    var speedLabel: SKLabelNode!
   
    var isAtGround: Bool = true
    var tempLabel: SKLabelNode?
    
    //  var ambientColor: UIColor?
    
    override func didMoveToView(view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        
        lamp1 = self.childNodeWithName("lamp1")
        lamp2 = self.childNodeWithName("lamp2")
        lamp3 = self.childNodeWithName("lamp3")
        lamp4 = self.childNodeWithName("lamp4")
        light1 = self.childNodeWithName("light1") as! SKLightNode
        light2 = self.childNodeWithName("light2") as! SKLightNode
        
        
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        ghost = self.childNodeWithName("//ghost") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        speedLabel = self.childNodeWithName("speedLabel") as! SKLabelNode
        
        // background color effects
        bnw1 = self.childNodeWithName("bnw1") as! SKSpriteNode
        bnw2 = self.childNodeWithName("bnw2") as! SKSpriteNode
        bnw3 = self.childNodeWithName("bnw3") as! SKSpriteNode
        bnw3.zPosition = 0
        bnw4 = self.childNodeWithName("bnw4") as! SKSpriteNode
        bnw5 = self.childNodeWithName("bnw5") as! SKSpriteNode
        bnw5.zPosition = 0
        bnw6 = self.childNodeWithName("bnw6") as! SKSpriteNode
        bnw7 = self.childNodeWithName("bnw7") as! SKSpriteNode
        bnw8 = self.childNodeWithName("bnw8") as! SKSpriteNode
        
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        
        //    ambientColor = UIColor.darkGrayColor()
        initSprite()
        initLight()
        
    }
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("Swipped Right here")
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("Swipped Left here")
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        if hero.xScale < 1
        {
            restoreActions()
        }
        else
        {
            heroJump()
        }
        print("up swipe here")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer)
        {
        heroSlide()
        print("Down swipped")
    }
    
    func restoreActions()
    {
        print("restored")
        hero.paused = false
        hero.yScale = 1
        hero.xScale = 1
    }
    
    func heroSlide()
    {
//        let mytexture = SKTexture(imageNamed: "punkSlide")
//        let slideAction = SKAction.animateWithNormalTextures([mytexture], timePerFrame: 1.5)
//        let restoreAction = SKAction.performSelector(#selector(restoreActions), onTarget: self)
//        let similation = SKAction.sequence([slideAction, restoreAction])
//        hero.runAction(similation, withKey: "")
    
        
        hero.paused = true
        hero.texture =  SKTexture(imageNamed: "punkSlide")
        hero.xScale = 0.4
        hero.yScale = 0.4
        
      //  hero.runAction(slideAction, withKey: "slideAction")
       
//        hero.runAction(SKAction.animateWithTextures([mytexture], timePerFrame: 2), withkey)
       
      //  hero.paused = true
//        hero.xScale = 1
//        hero.yScale = 1
        
        // texture  not working
        print("hero texture changed")
    }
    
    func heroSizeReset()
    {
        hero.xScale = 1
        hero.yScale = 1
        
    }
    func initSprite(){
        
    }
    func initLight()
    {
        //www.codeandweb.com/spriteilluminator/tutorials/spritekit-dynamic-light-tutorial
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches
        {
            if gameState == .Active
            {
                if potion >= 12
                {
                    let pt = touch.locationInNode(self)
                    if(nodeAtPoint(pt).name == "lamp1"||nodeAtPoint(pt).name == "lamp2"||nodeAtPoint(pt).name == "lamp3"||nodeAtPoint(pt).name == "lamp4")
                    {
                        // print("Super Lanter Power up")
                        heroPowerUp()
                        potion = 0
                    }
                }
                //heroSlide()
            }
        }
    }
    
    func heroJump()
    {
        if(isAtGround)
        {
            // never ending decrease  in speed after 300
//            if scrollSpeed > 300
//            {
//                jumpImpulse = jumpImpulse * 0.8
//            }
//            if scrollSpeed > 550
//            {
//                jumpImpulse = jumpImpulse * 0.8
//            }
            hero.physicsBody?.applyImpulse(CGVectorMake(0, jumpImpulse))
            //  print(hero.position.x)
            hero.paused = true;
            isAtGround = false
        }
    }
    
    func lightsDrama(x: Int)
    {
        if x == 0
        {
            // do nothing
        } else if x == 3
        {
            light1.falloff += 0.02
            bnw3.zPosition = 0
            
        }else if x == 4
        {
            bnw4.zPosition = 0
            
        }else if x == 5
        {
            bnw5.zPosition = 0
        }else //x == 6
        {
            bnw6.zPosition = 0
        }
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        if ghost.position.x > 300
        {
            lightsDrama(6)
        }else if ghost.position.x > 250
        {
            lightsDrama(5)
        }
        else if ghost.position.x > 200
        {
            lightsDrama(4)
        }else if ghost.position.x > 150
        {
                lightsDrama(3)
        }
        else if ghost.position.x > 100
        {
            lightsDrama(0)
        }
        else
            //do nothing
        
        if gameState == .GameOver{
            hero.removeAllActions()
            groundScroll.removeAllActions()
            cloudScroll.removeAllActions()
            backScroll.removeAllActions()
            hero.removeFromParent()
            
            let resourchPath = NSBundle.mainBundle().pathForResource("TempLabel", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            box.position = CGPoint(x: 100, y: 100)
            self.addChild(box)
            
            return
        }
        
        if gameState == .Active{
            
            if potion >= 12
            {
                lamp1.zPosition = 3
                
            } else if potion >= 9
            {
                lamp2.zPosition = 3
            } else if potion >= 6
            {
                lamp3.zPosition = 3
            } else if potion >= 3
            {
                lamp4.zPosition = 3
            }else
            {
                lamp1.zPosition = -2
                lamp2.zPosition = -2
                lamp3.zPosition = -2
                lamp4.zPosition = -2
                
            }
            
            
            
            if (score % 97 == 0 && scrollSpeed < 800)
            {
                //   print(scrollSpeed)
                scrollSpeed += 65
                //   print(scrollSpeed)
                print("")
                score += 1
            }
            scoreLabel.text = String(score)
            speedLabel.text = String (scrollSpeed)   // printing speed
            
            //    if hero.position.x < -200
            if hero.parent?.position.x < -9
            {
                gameState = .GameOver
                return;
            }
            
            //   if hero.position.x > 30
            if hero.parent?.position.x > 300 // make this dynamic screen size
            {
                let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! - 100, duration: 1)
                hero.runAction(heroLimit)
            }
            
            if scoreCounter % 31 == 0
            {
                score += 1
                //  print("Score: \(score)")
            }
            
            if scoreCounter % 79 == 0
            {
                let randomNumber = Int(arc4random_uniform(UInt32(18)))
                //  print("Number of boxes: \(randomNumber)")
                
              //  let randomNumber = 18
                
                if randomNumber >= 16
                {
                    addBox(4)
                }
                else if randomNumber >= 13
                {
                    addBox(3)
                }
                else if randomNumber >= 8{
                    addBox(2)
                }else if randomNumber >= 0{
                    addBox(1)
                }else{
                    //do nothing
                }
                
            }
            
            updateGroundScroll()
            updateCloudScroll()
            updateBackScroll()
            updateObstacles()
            
            scoreCounter += 1
        }
    }
    
//    func timerAction()
//    {
//        counter += 1
//        print("counter \(counter)")
//    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        if (contactA.node == nil || contactB.node == nil)
        {
            return
        }
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "box" || nodeB.name == "box"
        {
            //            if (counter > 10)
            //            {
            //                counter = 0
            //                timer?.invalidate()
            //                timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            //                timer?.fire()
            //                hero.paused = false
            //                isAtGround = true
            //                }
        }
        
        if nodeA.name == "pressurePoint" || nodeB.name == "pressurePoint"
        {
            
            print("presure point hit")
            isAtGround = true;
            hero.paused = false
            return

        }
        
        if nodeA.name == "ground" || nodeB.name == "ground"
        {
            //    print("ground")
            
            isAtGround = true;
            if hero.xScale < 1
            {
                return
            }else{
            hero.paused = false
            }
            return
            
        }
        
        if nodeA.name == "jumpNode" || nodeB.name == "jumpNode"
        {
            //   hero.removeActionForKey("hero limit")
            isAtGround = true;
            hero.paused = false;
            return
        }
        
        if nodeA.name == "lantern" || nodeB.name == "lantern"
        {
            heroPowerUp()                       // powerUp Effects
            
            if  nodeA.name != "hero"
            {
                nodeA.removeFromParent()
            }
            else
            {
                nodeB.removeFromParent()
            }
        }
        
        if nodeA.name == "monster" || nodeB.name == "monster"
        {
            
            if  nodeA.name != "hero"
            {
                nodeA.removeFromParent()
            }
            else
            {
                nodeB.removeFromParent()
            }
        }
        
        if nodeA.name == "potion" || nodeB.name == "potion"
        {
            potion += 1
            
            if hero.parent?.position.x < 200
            {
                let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! + 10, duration: 1.5)
                hero.runAction(heroLimit, withKey: "hero limit")
            }
            
            print("potion collected: \(potion)")
            
            if  nodeA.name != "hero"
            {
                nodeA.removeFromParent()
            }
            else
            {
                nodeB.removeFromParent()
            }
            
        }
        
        if nodeA.name == "ghost" || nodeB.name == "ghost"
        {
            gameState = .GameOver
            return
        }
        
    }
    
    /*
     @param: that decideds the reward brightness of the gameplay
     */
    func heroPowerUp()
    {
        
        // add effects of bright glow
        // world brightness = current.brightness + 30, not fully bright, i.e done by superLantern
        
        /* Effects #1 */
        // world pause
        hero.paused = true
        hero.physicsBody?.dynamic = false
        hero.physicsBody?.affectedByGravity = false
        
        gameState = .LanternGlow
        light1.falloff = -1
        light2.falloff = -1
        
        let pauseTime = SKAction.waitForDuration(2)
        let unpause = SKAction.performSelector(#selector(resume), onTarget: self)
        let stepSequence = SKAction.sequence([pauseTime, unpause])
        self.runAction(stepSequence)
        
        
        /* Effects #2 */
        ghostReset()
        
        /* Effects #3 */
        obstacleDisappear()
        
        //     heroBoost()
        
    }
    func resume()
    {
        hero.paused = false
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.affectedByGravity = true
        if hero.parent?.position.x < 200
        {
            let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! + 50, duration: 1)
            hero.runAction(heroLimit)
        }
        //  physicsWorld.gravity.dx = originalGravity
        gameState = .Active
    }
    
    func ghostReset()
    {
        let ghostreset = SKAction.moveTo(ghostOriginalPos, duration: 2.5)
        ghost.runAction(ghostreset)
        ghost.removeActionForKey("creepIn")
        
        ghostSpawnTimer = -5
        light1.falloff -= 0.5
        light2.falloff -= 0.5
    }
    
    func ghostCreepIn()
    {
        let creepIn = SKAction.moveToX(CGFloat(800), duration:80)
        ghost.runAction(creepIn, withKey: "creepIn")
        //ghost.physicsBody?.applyImpulse(CGVectorMake(1, 0))
    }
    
    func obstacleDisappear()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for node in groundScroll.children
        {
            
            if let _ = node as? SKSpriteNode
            {
                "do nothing"
            }else
            {
                let obstacleFadeOut = SKAction.fadeOutWithDuration(0.9)
                let obstacleRemove = SKAction.removeFromParent()
                let disappearSequence = SKAction.sequence([obstacleFadeOut, obstacleRemove])
                // may need to repeat disappearSequence
                node.runAction(disappearSequence)
            }
        }
        //spawnTimer = 0
        pitSpawnTimer = 5
        lanternSpawnTimer = 0
    }
    
    
    func updateObstacles()
    {
        for elements in groundScroll.children
        {
            if elements.position.x < -5
            {
                elements.removeFromParent()
            }
        }
        if ghostSpawnTimer > 2  //ghost Spawn
        {
            print("Ghost Move: \(ghost.position.x)")
            ghostCreepIn()
            //  print("Ghost After Move \(ghost.position.x)")
            ghostSpawnTimer = 0
        }
        
        /*
         if pitSpawnTimer > 17     //pit Spawn
         {
         let resourchPath = NSBundle.mainBundle().pathForResource("Pit", ofType: "sks")
         let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
         box.position = self.convertPoint(CGPoint(x: 600, y: 56), toNode: groundScroll)
         groundScroll.addChild(box)
         //  print("pit")
         pitSpawnTimer = 0
         return
         
         }
         */
        if potion < 12              // i.e, if SuperLantern is complete no more potions
        {
            if potionSpawnTimer > 4       //potions spawn
            {
                let resourchPath = NSBundle.mainBundle().pathForResource("Boost", ofType: "sks")
                let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
                box.position = self.convertPoint(CGPoint(x: 600, y: 176), toNode: groundScroll)
                groundScroll.addChild(box)

//                
                potionSpawnTimer = 0
                return
                
            }
            
        }else
        {
            generalLanternTimeCounter = 16
        }
        // add potions here and pops out after x time
        //more potions then lanterns
        
        
        if lanternSpawnTimer > generalLanternTimeCounter   //lantern spawn
        {
            let resourchPath = NSBundle.mainBundle().pathForResource("Lantern", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            let randomNumber = Int(arc4random_uniform(UInt32(50)))
            box.position = self.convertPoint(CGPoint(x: 600 + randomNumber, y: 176), toNode: groundScroll)
            groundScroll.addChild(box)
            //    print("Lantern")
            lanternSpawnTimer = 0
            return
        }
        
        potionSpawnTimer+=fixedDelta
        pitSpawnTimer += fixedDelta
        lanternSpawnTimer += fixedDelta
        ghostSpawnTimer += fixedDelta
        
    }
    
    
    /*
     @func: adds type of boxes to the game scene
     @param: x == 1 for Box1.sks
     x == 2 for Box2.sks
     x == 3 for Box3.sks
     */
    func addBox(x: Int)
    {
        var resourcePath:String!
        var box:SKReferenceNode!
        if x <= 3{
            
            if x == 1{
                resourcePath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
            }
            else if x == 2{
                resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            }
            else{
                resourcePath = NSBundle.mainBundle().pathForResource("Box4", ofType: "sks")
                addDummyBox()
            }
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 70), toNode: groundScroll)
            
        }
        else
        {
            resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath))
            box.position = self.convertPoint(CGPoint(x: 600, y: 100), toNode: groundScroll)
        }
        groundScroll.addChild(box)
        
    }
    /*
     To create dummy box after box4
     */
    func addDummyBox()
    {
        let resourcePath = NSBundle.mainBundle().pathForResource("Box1_dummy", ofType: "sks")
        let myNil = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
        myNil.position = self.convertPoint(CGPoint(x: 650, y: 70), toNode: groundScroll)
        groundScroll.addChild(myNil)
        
    }

    func updateGroundScroll()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for node in groundScroll.children as [SKNode]
        {
            
            if let ground = node as? SKSpriteNode {
                let groundposition = groundScroll.convertPoint(ground.position, toNode: self)
                if groundposition.x <= -ground.size.width/2
                {
                    let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10 , groundposition.y)
                    ground.position = self.convertPoint(newPosition, toNode: groundScroll)
                }
            }
        }
    }
    func updateCloudScroll()
    {
        cloudSpeed = scrollSpeed * 0.1
        
        cloudScroll.position.x -= cloudSpeed * CGFloat(fixedDelta)
        for ground in cloudScroll.children as! [SKSpriteNode]
        {
            let groundposition = cloudScroll.convertPoint(ground.position, toNode: self)
            if groundposition.x <= -ground.size.width/2
            {
                let newPosition = CGPointMake((self.size.width/2) + ground.size.width , groundposition.y)
                ground.position = self.convertPoint(newPosition, toNode: cloudScroll)
            }
        }
    }
    
    func updateBackScroll()
    {
    
        backSpeed = scrollSpeed * 0.3
        
        backScroll.position.x -= backSpeed * CGFloat(fixedDelta)
        
        for ground in backScroll.children as! [SKSpriteNode]
        {
            let groundposition = backScroll.convertPoint(ground.position, toNode: self)
            if groundposition.x <= -ground.size.width/2
            {
                let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10, groundposition.y)
                ground.position = self.convertPoint(newPosition, toNode: backScroll)
            }
        }
    }
    
}