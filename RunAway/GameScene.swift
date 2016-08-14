//
//  GameScene.swift
//  Fear
//
//  Created by Nityam Shrestha on 7/18/16.
//  Copyright (c) 2016 nityamshrestha.com. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation
import Mixpanel

/*
 Game States
 */
enum State{
    case Active, Paused, GameOver, LanternGlow
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*
     missionNumber: this number gets stored in the user's device
     */
    var missionNumber:Int = NSUserDefaults.standardUserDefaults().integerForKey("mNumber") {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(missionNumber, forKey:"mNumber")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var isPlayed: Int = NSUserDefaults.standardUserDefaults().integerForKey("isPlayed") ?? 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(isPlayed, forKey:"isPlayed")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }// used int instead of Bool -> unable to use bool
    
    var missionReport = MissionReport()
    var missionComplete: Bool = false
    var gameState:State = .Paused
    var missionLabel: SKLabelNode!
    var missionBoard:SKSpriteNode!
    var menuBtn: SKSpriteNode!
    var groundScroll: SKNode!
    var cloudScroll: SKNode!
    var backScroll: SKNode!
    var treeScroll: SKNode!
    var hero: SKSpriteNode!
    var ghost: SKSpriteNode!
    var myBox:SKSpriteNode!
    var flameLabel:SKLabelNode!
    var flamepic: SKNode!
    var flameLabels: SKLabelNode!
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
    // Timer Variables
    var potionSpawnTimer: CFTimeInterval = 0
    var lanternSpawnTimer: CFTimeInterval = 0
    var ghostSpawnTimer: CFTimeInterval = -5
    var boostSpawnTimer: CFTimeInterval = 0
    var generalLanternTimeCounter:CFTimeInterval = 23
    
    let ghostOriginalPos:CGPoint = CGPoint(x: -54, y: 89.963)
    // Counters for mission
    var flameCount:Int = 0
    var totalFlameCount:Int = 0
    var totalLanterns:Int = 0
    var totalMegaLantern:Int = 0
    var totalJumps = 0
    var totalSlides = 0
    // Game physics vairables
    var jumpImpulse:CGFloat = 18
    var isAtGround: Bool = true
    //Node effects
    var megaLantern:SKSpriteNode!
    var lanternFlame: SKEmitterNode!
    var heroLight: SKLightNode!
    var light1: SKLightNode!
    var light2: SKLightNode!
    // Parallax speed
    var scrollSpeed:CGFloat = 230
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var lastLanternTime: CFTimeInterval = 0
    var obsSpawn: Int = 89
    var score: Int = 1
    var scoreCounter = 0
    var scoreLabel:SKLabelNode!
    
    var gameOverScene:SKAction!
    var missionHide: SKAction!
    var menuScene: SKAction!
    // Sound effects
    var myAudioPlayer: AVAudioPlayer!
    let sound = SKAction.playSoundFileNamed("helter_Skelter11", waitForCompletion: false)
    var ghostSound:Bool = true
    
    override func didMoveToView(view: SKView)
    {
        let gameSoundPath = NSBundle.mainBundle().pathForResource("woo", ofType: "mp3")
        if let gameSoundPaths = gameSoundPath
        {
            let gameSoundURL = NSURL(fileURLWithPath: gameSoundPaths)
            do{
                try myAudioPlayer = AVAudioPlayer(contentsOfURL: gameSoundURL)
                myAudioPlayer.play()
                if myAudioPlayer.play() == true{
                }
            }
            catch{
                print("error")
            }
        }
        
        
        physicsWorld.contactDelegate = self
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        treeScroll = self.childNodeWithName("treeScroll")
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
        flamepic = self.childNodeWithName("flamePic")
        flameLabels = self.childNodeWithName("flameLabels") as! SKLabelNode
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
        
        if missionNumber == 0
        {
            missionNumber = 1
        }
        
        /* Swipe Gestures */
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        
        /* GameOver Run Block */
        gameOverScene = SKAction.runBlock({
            self.myAudioPlayer.stop()
            self.isPlayed += 1
            let skView = self.view as SKView!
            Mixpanel.mainInstance().track(event: "Deaths", properties: ["Score" : self.score])
            let scene = GameOver(fileNamed: "GameOver") as GameOver!
            scene.score = self.score
            scene.levelCompelete = self.missionComplete
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        })
        
        /* Main Menu Run Block */
        menuScene = SKAction.runBlock({
            let skView = self.view as SKView!
            let scene = MainMenu(fileNamed: "MainMenu") as MainMenu!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        })
        
        /* Tutorial Run Block */
        let tutorialScene = SKAction.runBlock({
            let skView = self.view as SKView!
            let scene = Tut(fileNamed:"Tut") as Tut!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        })
        
        // Check if played ever before to show the tutorial scene
        if self.isPlayed == 0
        {
            self.isPlayed += 1
            self.runAction(tutorialScene)
        }
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
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
    }
    
    func restoreActions()
    {
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
    }
    
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
                if (nodeAtPoint(pt).name == "menu" || nodeAtPoint(pt) == menuBtn)
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
                    megaLantern.zPosition = 5
                    lanternFlame.zPosition = 2
                    flamepic.zPosition = -1
                    flameLabel.zPosition = -1
                    flameLabels.zPosition = -1
                    
                    if(nodeAtPoint(pt).name == "lanternBig")
                    {
                        totalMegaLantern += 1
                        heroPowerUp(-4)
                        superHeroUp()
                        flameCount = 0
                        if flameCount < 10
                        {
                            megaLantern.zPosition = -1
                            lanternFlame.zPosition = -1
                            flamepic.zPosition = 3
                            flameLabel.zPosition = 3
                            flameLabels.zPosition = 3
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
        let missionShow = SKAction.moveToY(250, duration: 0.3)
        missionHide = SKAction.moveToY(475, duration: 0.3)
        missionBoard.runAction(missionShow)
        gameState = .Paused
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
    /*
     func lightsDrama: Light effects on the game
     @parem: Int x : int corresponding to the ghost's position
    */
    
    func lightsDrama(x: Int)
    {
        switch x {
        case 1:
            ghostSound = true
            backPart1.runAction(SKAction.fadeOutWithDuration(2))
        case 2:
            if ghostSound == true{
                ghost.runAction(sound)
                ghostSound = false
            }
            backPart2.runAction(SKAction.fadeOutWithDuration(2))
        case 3:
            ghostSound = false
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
        }
        else if missionNumber == 7
        {
            return missionReport.missionCheck(missionNumber, value: totalJumps)
        }else if missionNumber == 8
        {
            return missionReport.missionCheck(missionNumber, value: totalSlides)
        }else if missionNumber == 9
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
            self.myAudioPlayer.stop()
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
            missionBoard.runAction(SKAction.moveToY(550, duration: 0.3))
            
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
            
            /* flame count */
            flameLabel.text = String (flameCount)
            
            if (score % 69 == 0 && scrollSpeed < 800)
            {
                scrollSpeed += 65
                obsSpawn = 79
                score += 1
            }
            scoreLabel.text = String(score)
            
            if hero.position.x < -370
            {
                gameState = .GameOver
                return;
            }
            
            if hero.parent?.position.x > 300
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
                let randomNumber = Int(arc4random_uniform(UInt32(20)))
                print("randomnumber: \(randomNumber)")
                
                if randomNumber >= 18
                {
                    addObstacle(5) // flying bats
                }
                else if randomNumber >= 17
                {
                    addObstacle(4)  // floating box2
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
            updateTrees()
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
        scoreCounter = 1
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
        
        if x < -2
        {
            scoreCounter = -30
        }
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
                // "do nothing"
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
            ghostCreepIn()
            ghostSpawnTimer = 0
        }
        
        if flameCount < 10
        {
            if potionSpawnTimer > 7       //flame spawn
            {
                let resourchPath = NSBundle.mainBundle().pathForResource("Boost", ofType: "sks")
                let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
                box.position = self.convertPoint(CGPoint(x: 600, y: 176), toNode: groundScroll)
                groundScroll.addChild(box)
                potionSpawnTimer = 0
                return
            }
        }
        
        if flameCount < 10            // i.e, if SuperLantern is complete => less frequent regular lantern
        {
            generalLanternTimeCounter = 19
            
        }
        else
        {
            generalLanternTimeCounter = 25
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
     x == 3 for Box4.sks
     x == 4 for Box Floating box 2
     x == 5 for Flying Bat
     */
    func addObstacle(x: Int)
    {
        var resourcePath:String!
        var box:SKReferenceNode!
        if x < 4{
            if x == 1{
                resourcePath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
            }
            else if x == 2{
                resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            }
            else if x == 3{
                resourcePath = NSBundle.mainBundle().pathForResource("Box4", ofType: "sks")
            }
            else{
                // blank space
                resourcePath = NSBundle.mainBundle().pathForResource("Dummy", ofType: "sks")
            }
            
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 70), toNode: groundScroll)
            box.setScale(1)
        }
        else if x == 4
        {
            resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath))
            box.position = self.convertPoint(CGPoint(x: 600, y: 108), toNode: groundScroll)
            box.setScale(0.75)
            
        }
        else
        {
            // flying box if x == 5
            resourcePath = NSBundle.mainBundle().pathForResource("Bats", ofType: "sks")
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath))
            box.position = self.convertPoint(CGPoint(x: 600, y: 68), toNode: groundScroll)
            box.setScale(1.5)
        }
        groundScroll.addChild(box)
        
    }
    
    /* functions for parallax effects and removing unwanted child from scroller*/
    
    func updateGroundScroll()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for node in groundScroll.children as [SKNode]
        {
            if let ground = node as? SKSpriteNode {
                let groundposition = groundScroll.convertPoint(ground.position, toNode: self)
                if groundposition.x <= -ground.size.width/2
                {
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
                let newPosition = CGPointMake((self.size.width/2) + ground.size.width + 1 , groundposition.y)
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
    func updateTrees()
    {
        if scoreCounter % 437 == 39
        {
            let resourcePath = NSBundle.mainBundle().pathForResource("Tree", ofType: "sks")
            let tree = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
            tree.position = self.convertPoint(CGPoint(x: 600, y: 0), toNode: treeScroll)
            treeScroll.addChild(tree)
        }
        treeScroll.position.x -= scrollSpeed * CGFloat(fixedDelta) * 2
        
    }
    
}