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
    
    var missionNumber:Int = NSUserDefaults.standardUserDefaults().integerForKey("mNumber") {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(missionNumber, forKey:"mNumber")
            // Saves to disk immediately, otherwise it will save when it has time
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var missionReport = MissionReport()
    
    var gameState:State = .Paused
    var missionLabel: SKLabelNode!
 //   var titeLabel: SKLabelNode!
    var missionBoard:SKSpriteNode!
    var missionHide: SKAction!
    var missionComplete: Bool = false
    var menuScene: SKAction!
    var menuBtn: SKSpriteNode!
    var groundScroll: SKNode!
    var cloudScroll: SKNode!
    var backScroll: SKNode!
    var hero: SKSpriteNode!
    var ghost: SKSpriteNode!
    
    
    // background effect
    var backPart1: SKSpriteNode!
    var backPart2: SKSpriteNode!
    var backPart3: SKSpriteNode!
    var backPart4: SKSpriteNode!
    var backPart5: SKSpriteNode!
    var backPart6: SKSpriteNode!
    var backPart7: SKSpriteNode!
    var backPart8: SKSpriteNode!
    var backPart9: SKSpriteNode!
    var backPart10: SKSpriteNode!
    var backPart11: SKSpriteNode!
    var backPart12: SKSpriteNode!
    var backPart13: SKSpriteNode!
    var backPart14: SKSpriteNode!
    
    var potionSpawnTimer: CFTimeInterval = 0
    var lanternSpawnTimer: CFTimeInterval = 0
    var ghostSpawnTimer: CFTimeInterval = -5
    var boostSpawnTimer: CFTimeInterval = 0
    var generalLanternTimeCounter:CFTimeInterval = 21
    
    var originalGravity:CGFloat!
    
    let ghostOriginalPos:CGPoint = CGPoint(x: -54, y: 89.963)
    
    var myBox:SKSpriteNode!
    
    var flameCount:Int = 0
    var totalFlameCount:Int = 0
    var totalLanterns:Int = 0
    var totalMegaLantern:Int = 0
    var totalJumps = 0
    var totalSlides = 0
    var totalTrees = 0
    
    var jumpImpulse:CGFloat = 18
    var flameLabel:SKLabelNode!
    
    var megaLantern:SKSpriteNode!
    var lanternFlame: SKEmitterNode!
    var heroLight: SKLightNode!
    var light1: SKLightNode!
    var light2: SKLightNode!
    
    var scrollSpeed:CGFloat = 230
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var lastLanternTime: CFTimeInterval = 0
    var obsSpawn: Int = 89
    var score: Int = 1
    var scoreCounter = 0
    var scoreLabel:SKLabelNode!
    
    var isAtGround: Bool = true
    var tempLabel: SKLabelNode?
    
    var gameOverScene:SKAction!
    //  var ambientColor: UIColor?
    
    override func didMoveToView(view: SKView)
    {
        physicsWorld.contactDelegate = self
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        menuBtn = self.childNodeWithName("//menubtn") as! SKSpriteNode
        
        megaLantern = self.childNodeWithName("//lanternBig") as! SKSpriteNode
        lanternFlame = self.childNodeWithName("//lanternFlame") as! SKEmitterNode

        heroLight = self.childNodeWithName("//heroLight") as! SKLightNode
        light1 = self.childNodeWithName("light1") as! SKLightNode
        light2 = self.childNodeWithName("light2") as! SKLightNode
        
        
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        ghost = self.childNodeWithName("//ghost") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        flameLabel = self.childNodeWithName("flameLabel") as! SKLabelNode
        
//        titeLabel = self.childNodeWithName("//titleLabel") as! SKLabelNode
        missionLabel = self.childNodeWithName("//missionLabel") as! SKLabelNode
        missionBoard = self.childNodeWithName("missionBoard") as! SKSpriteNode
        
        /* background color effects */
        backPart1 = self.childNodeWithName("part1") as! SKSpriteNode
        backPart2 = self.childNodeWithName("part2") as! SKSpriteNode
        backPart3 = self.childNodeWithName("part3") as! SKSpriteNode
        backPart4 = self.childNodeWithName("part4") as! SKSpriteNode
        backPart5 = self.childNodeWithName("part5") as! SKSpriteNode
        backPart6 = self.childNodeWithName("part6") as! SKSpriteNode
        backPart7 = self.childNodeWithName("part7") as! SKSpriteNode
        backPart8 = self.childNodeWithName("part8") as! SKSpriteNode
        backPart9 = self.childNodeWithName("part9") as! SKSpriteNode
        backPart10 = self.childNodeWithName("part10") as! SKSpriteNode
        backPart11 = self.childNodeWithName("part11") as! SKSpriteNode
        
        restoreActions()
        
        if missionNumber == 0 { missionNumber = 1 }
        
        /* Swipe Gestures */
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
        
        
        /* Reset Run Block */
        
            gameOverScene = SKAction.runBlock({
            let skView = self.view as SKView!
            
            let scene = GameOver(fileNamed: "GameOver") as GameOver!
            scene.score = self.score
            scene.levelCompelete = self.missionComplete
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        })
        
        
        menuScene = SKAction.runBlock({
            let skView = self.view as SKView!
            let scene = MainMenu(fileNamed: "MainMenu") as MainMenu!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        })
        
        
        
        //    ambientColor = UIColor.darkGrayColor()
//        initSprite()
//        initLight()
        
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
            heroJump()
        }
        else
        {
            heroJump()
        }
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
        
        let runTexture = SKTexture(imageNamed: "punk0" )
        hero.texture = runTexture
        
        hero.physicsBody = SKPhysicsBody.init(rectangleOfSize: CGSize.init(width: 45, height: 50), center: CGPoint(x: -2.3, y: -5))
        hero.size.height = 76
            hero.size.width = 76
        hero.physicsBody?.affectedByGravity = true;
        hero.physicsBody?.dynamic = true;
        hero.physicsBody?.allowsRotation = false;
        hero.physicsBody?.categoryBitMask = 1
        hero.physicsBody?.collisionBitMask = 6
        hero.physicsBody?.contactTestBitMask = 14
        hero.physicsBody?.mass = 0.0374875403940678
 
    }
    
    func heroSlide()
    {
        hero.paused = true
        let slideTexture =  SKTexture(imageNamed: "runSlide1")
        
        hero.physicsBody = SKPhysicsBody.init(rectangleOfSize: CGSize.init(width: 48.0, height: 15.0), center: CGPoint(x: 0, y: -8))
        hero.physicsBody?.affectedByGravity = true;
        hero.physicsBody?.dynamic = true;
        hero.physicsBody?.allowsRotation = false;
        hero.physicsBody?.categoryBitMask = 1
        hero.physicsBody?.collisionBitMask = 6
        hero.physicsBody?.contactTestBitMask = 14
        hero.physicsBody?.mass = 0.0374875403940678
 
        hero.texture = slideTexture
        hero.xScale = 0.96
        hero.yScale = 0.96
        
        totalSlides += 1
        // physics body doesn't change during slide and hero flies
        
        print("hero texture changed")
    }
    
    /*
    func initSprite(){
        
    }
    func initLight()
    {
        //www.codeandweb.com/spriteilluminator/tutorials/spritekit-dynamic-light-tutorial
    }
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches
        {
            if gameState == .Paused
            {
                if missionBoard.position.y <= 350
                {
                   missionBoard.runAction(missionHide)
                }
                    gameState = .Active
                    unpauseHero()
                    ghost.paused = false
                    ghostCreepIn()
                
                let pt = touch.locationInNode(self)
                if (nodeAtPoint(pt).name == "menu")
                {
                    self.runAction(menuScene)
                }
                return
            }
            
            if gameState == .GameOver
            {
                return
            }
            
            if gameState == .Active
            {
                let pt = touch.locationInNode(self)
                if (nodeAtPoint(pt).name == "pauseButton")
                {
                    menuBtn.runAction(SKAction.moveToX(135, duration: 0.4))
                   gameState = .Paused
                    return
                }

                hero.paused = false
                if flameCount >= 10
                {
                    megaLantern.zPosition = 3
                    lanternFlame.zPosition = 2
                    if(nodeAtPoint(pt).name == "lanternBig")
                    {
                        totalMegaLantern += 1
                        heroPowerUp(-4)
                        superHeroUp()
                        flameCount -= 10
                        if flameCount < 10
                        {
                        megaLantern.zPosition = -1
                        lanternFlame.zPosition = -1
                        }
                    }
                }
            }
        }
    }
    
    func showMission()
    {
        hero.paused = true
        missionLabel.text = missionReport.getMission(missionNumber)
        print("mission number: \(missionNumber)")
        print("missionLabel: \(missionLabel.text)")
        let missionShow = SKAction.moveToY(250, duration: 0.3)
        missionHide = SKAction.moveToY(475, duration: 0.3)
        missionBoard.runAction(missionShow)
        
        gameState = .Paused
        print("\(missionBoard.position.x)")
    }
    func heroJump()
    {
        if(isAtGround)
        {
            hero.physicsBody?.applyImpulse(CGVectorMake(0, jumpImpulse))
            hero.paused = true;
            isAtGround = false
            totalJumps += 1
        }
    }
    
    func lightsDrama(x: Int)
    {
        switch x {
        case 1:
            backPart1.runAction(SKAction.fadeOutWithDuration(2))
        case 2:
            backPart2.runAction(SKAction.fadeOutWithDuration(2))
        case 3:
            backPart3.runAction(SKAction.fadeOutWithDuration(2))
            light1.falloff += 0.5
        case 4:
            backPart4.runAction(SKAction.fadeOutWithDuration(2))
        case 5:
            backPart5.runAction(SKAction.fadeOutWithDuration(2))
             light1.falloff += 0.5
        case 6:
            backPart6.runAction(SKAction.fadeOutWithDuration(2))
             light2.falloff += 0.5
        case 7:
            backPart7.runAction(SKAction.fadeOutWithDuration(2))
           
        case 8:
            backPart8.runAction(SKAction.fadeOutWithDuration(2))
            light2.falloff += 0.5
        case 9:
            backPart9.runAction(SKAction.fadeOutWithDuration(2))
           
        case 10:
            backPart10.runAction(SKAction.fadeOutWithDuration(2))
            
        case 11:
            backPart11.runAction(SKAction.fadeOutWithDuration(2))
        case 12:
            backPart12.runAction(SKAction.fadeOutWithDuration(2))
        case 13:
            backPart13.runAction(SKAction.fadeOutWithDuration(2))
        case 14:
            backPart14.runAction(SKAction.fadeOutWithDuration(2))
        default:
            return
        }
    }
    func pauseGhost()
    {
        ghost.paused = true
        ghost.removeActionForKey("creepIn")
    }
    func pauseHero()
    {
        hero.paused = true
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.dynamic = false
    }
    func unpauseHero()
    {
        hero.paused = false
        hero.physicsBody?.affectedByGravity = true
        hero.physicsBody?.dynamic = true
    }
    func missionValidation()-> Bool
    {
        if missionNumber == 1
        {
            return missionReport.missionCheck(missionNumber, value: totalFlameCount)
        }else if missionNumber == 2
        {
            return missionReport.missionCheck(missionNumber, value: totalLanterns)
        }else if missionNumber == 3
        {
            return missionReport.missionCheck(missionNumber, value: totalMegaLantern)
        }else if missionNumber == 4
        {
            return missionReport.missionCheck(missionNumber, value: totalMegaLantern)
        }else if missionNumber == 5
        {
            return missionReport.missionCheck(missionNumber, value: score)
        }else if missionNumber == 6
        {
            return missionReport.missionCheck(missionNumber, value: totalFlameCount)
        }else if missionNumber == 7
        {
            return missionReport.missionCheck(missionNumber, value: totalTrees)
        }else if missionNumber == 8
        {
            return missionReport.missionCheck(missionNumber, value: totalJumps)
        }else if missionNumber == 9
        {
            return missionReport.missionCheck(missionNumber, value: totalSlides)
        }else if missionNumber == 10
        {
            return missionReport.missionCheck(missionNumber, value: 1)
        }else
        {
            return false
        }
    }
    override func update(currentTime: CFTimeInterval)
    {
        if gameState == .Paused{
              showMission()
                pauseHero()
                pauseGhost()
            return
        }
        if gameState == .GameOver{
            hero.removeAllActions()
            groundScroll.removeAllActions()
            cloudScroll.removeAllActions()
            backScroll.removeAllActions()
            hero.removeFromParent()
            pauseGhost()
            missionComplete = missionValidation()
            
            if missionComplete == true{
                missionNumber += 1
            }
            
            print("flames \(totalFlameCount)")
            print("lanterns \(totalLanterns)")
            print("megalanterns \(totalMegaLantern)")
            print("slides \(totalSlides)")
            print("jump \(totalJumps)")
            
            let scene = HighScore(fileNamed: "HighScoreScene") as HighScore!
            if scene.distance < score
            {
                scene.distance = score
            }
            
            self.runAction(gameOverScene)
            return
        }
        
        if gameState == .Active{
            
            menuBtn.runAction(SKAction.moveToX(-60, duration: 0.4))
            missionBoard.runAction(SKAction.moveToY(450, duration: 0.3))
                
            if ghost.position.x > 319
            {
                lightsDrama(11)
            }else if ghost.position.x > 298
            {
                lightsDrama(10)
            }
            else if ghost.position.x > 277
            {
                lightsDrama(9)
            }else if ghost.position.x > 256
            {
                lightsDrama(8)
            }
            else if ghost.position.x > 235
            {
                lightsDrama(7)
            }
            else if ghost.position.x > 214
            {
                lightsDrama(6)
            }
            else if ghost.position.x > 193
            {
                lightsDrama(5)
            }else if ghost.position.x > 172
            {
                lightsDrama(4)
            }
            else if ghost.position.x > 151
            {
                lightsDrama(3)
            }else if ghost.position.x > 130
            {
                lightsDrama(2)
            }
            else if ghost.position.x > 109
            {
                lightsDrama(1)
            }
            else
            {//do nothing
            }
            
           /* potion count */
            flameLabel.text = String (flameCount)
    
            if (score % 69 == 0 && scrollSpeed < 800)
            {
                scrollSpeed += 65
                obsSpawn = 79
                score += 1
            }
            scoreLabel.text = String(score)

            if hero.parent?.position.x < -20
            {
                gameState = .GameOver
                return;
            }
            
            if hero.parent?.position.x > 300 // make this dynamic screen size
            {
                let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! - 100, duration: 1)
                hero.runAction(heroLimit)
            }
            
            if scoreCounter % 31 == 0
            {
                score += 1
            }
            
            if scoreCounter % obsSpawn == 0
            {
//                let randomNumber = Int(arc4random_uniform(UInt32(20)))
    
                let randomNumber = 20
                
                if randomNumber >= 19
                {
                    addObstacle(4) // trees
                }
                else if randomNumber >= 17
                {
                    addObstacle(5)  // floating box
                }
                else if randomNumber >= 14
                {
                    addObstacle(3)  // box 4
                }
                else if randomNumber >= 8{
                    addObstacle(2)   // box 2
                }else if randomNumber >= 0{
                    addObstacle(1)   // box1
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
            if hero.xScale < 1
            {
                return
            }
            else
            {
                isAtGround = true;
                hero.paused = false
                hero.removeActionForKey("hero limit")
                return}
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
        
        if nodeA.name == "lantern" || nodeB.name == "lantern"
        {
            totalLanterns += 1
            heroPowerUp(-1)                       // powerUp Effects
            
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
            flameCount += 1
            totalFlameCount += 1
            if hero.parent?.position.x < 200
            {
                let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! + 10, duration: 1.5)
                hero.runAction(heroLimit, withKey: "hero limit")
            }
            
            print("potion collected: \(flameCount)")
            
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
    func superHeroUp()
    {
        light1.falloff = 0
        light2.falloff = 0
    }
    /*
     @param: that decideds the reward brightness of the gameplay
     */
    func heroPowerUp(ghostTimer: CFTimeInterval)
    {
        
        // add effects of bright glow
        // world brightness = current.brightness + 30, not fully bright, i.e done by superLantern
        
        /* Effects #1 */
        // world pause
        hero.paused = true
        hero.physicsBody?.dynamic = false
        hero.physicsBody?.affectedByGravity = false
        
        gameState = .LanternGlow
        light1.falloff = 0
        light2.falloff = 0
        
        let pauseTime = SKAction.waitForDuration(2)
        let unpause = SKAction.performSelector(#selector(resume), onTarget: self)
        let stepSequence = SKAction.sequence([pauseTime,  unpause])
        self.runAction(stepSequence)
        
        
        /* Effects #2 */
        ghostReset(ghostTimer)
        
        /* Effects #3 */
        obstacleDisappear()
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
        gameState = .Active
    }
    
    func ghostReset(x: CFTimeInterval)
    {
        let ghostreset = SKAction.moveTo(ghostOriginalPos, duration: 2.5)
        ghost.runAction(ghostreset)
        ghost.removeActionForKey("creepIn")
        
        ghostSpawnTimer = x
      // setting the background back to normal
        backPart11.runAction(SKAction.fadeInWithDuration(2))
        backPart10.runAction(SKAction.fadeInWithDuration(2))
        backPart9.runAction(SKAction.fadeInWithDuration(2))
        backPart8.runAction(SKAction.fadeInWithDuration(2))
        backPart7.runAction(SKAction.fadeInWithDuration(2))
        backPart6.runAction(SKAction.fadeInWithDuration(2))
        backPart5.runAction(SKAction.fadeInWithDuration(2))
        backPart4.runAction(SKAction.fadeInWithDuration(2))
        backPart3.runAction(SKAction.fadeInWithDuration(2))
        backPart2.runAction(SKAction.fadeInWithDuration(2))
        backPart1.runAction(SKAction.fadeInWithDuration(2))
        
        
        
    }
    
    func ghostCreepIn()
    {
        let creepIn = SKAction.moveToX(CGFloat(800), duration:100)
        ghost.runAction(creepIn, withKey: "creepIn")
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
                node.runAction(disappearSequence)
            }
        }
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
        
        if potionSpawnTimer > 7       //flame spawn
        {
            let resourchPath = NSBundle.mainBundle().pathForResource("Boost", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 176), toNode: groundScroll)
            groundScroll.addChild(box)
            
            //
            potionSpawnTimer = 0
            return
            
        }
        
        if flameCount < 10            // i.e, if SuperLantern is complete== less regular lantern
        {
            generalLanternTimeCounter = 17
            
        }
        else
        {
            generalLanternTimeCounter = 23
        }
        
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
        lanternSpawnTimer += fixedDelta
        ghostSpawnTimer += fixedDelta
        
    }
    
    
    /*
     @func: adds type of boxes to the game scene
     @param: x == 1 for Box1.sks
     x == 2 for Box2.sks
     x == 3 for Box3.sks
     */
    func addObstacle(x: Int)
    {
        var resourcePath:String!
        var box:SKReferenceNode!
        if x <= 4{
            
            if x == 1{
                resourcePath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
            }
            else if x == 2{
                resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            }
            else if x == 3{
                resourcePath = NSBundle.mainBundle().pathForResource("Box4", ofType: "sks")
                //      addDummyBox()
            }
            else if score > 3 //77
            {
                resourcePath = NSBundle.mainBundle().pathForResource("treeSlide", ofType: "sks")
                totalTrees += 1
            }
            else
            {
            resourcePath = NSBundle.mainBundle().pathForResource("Dummy", ofType: "sks")
            }
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 70), toNode: groundScroll)
            
        }
//        else if x == 6
//        {
//            resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
//            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath))
//            
//            box.position = self.convertPoint(CGPoint(x: 600, y: 108), toNode: groundScroll)
//            box.setScale(0.75)
//        }
        else
        {
            // flyinh box
            resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath))
            
            box.position = self.convertPoint(CGPoint(x: 600, y: 108), toNode: groundScroll)
            box.setScale(0.75)
        }
        groundScroll.addChild(box)
        
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
                   // let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10 , groundposition.y)
                   let newPosition = CGPointMake(self.size.width * 1.5, groundposition.y)
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
            if groundposition.x <= -ground.size.width/2 + 10
            {
                let newPosition = CGPointMake((self.size.width*1.5), groundposition.y)
                ground.position = self.convertPoint(newPosition, toNode: backScroll)
            }
        }
    }    
    
}