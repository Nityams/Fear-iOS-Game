//
//  GameScene.swift
//  RunAway
//
//  Created by Nityam Shrestha on 7/18/16.
//  Copyright (c) 2016 nityamshrestha.com. All rights reserved.
//

import SpriteKit


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
    
    var spawnTimer: CFTimeInterval = 0
    var pitSpawnTimer: CFTimeInterval = 0
    var lanternSpawnTimer: CFTimeInterval = 0
    var ghostSpawnTimer: CFTimeInterval = -5
    var boostSpawnTimer: CFTimeInterval = 0
    
    let ghostOriginalPos:CGPoint = CGPoint(x: -54, y: 89.963)
    
    var nodeObstacle: SKNode!
    var nodeLantern: SKNode!
    
    var myBox:SKSpriteNode!
    
    var scrollSpeed:CGFloat = 230
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var lastLanternTime: CFTimeInterval = 0
    
    var score: Int = 0
    var scoreCounter = 0
   // var creepIn:SKAction;
    var isAtGround: Bool = true
    var tempLabel: SKLabelNode?
    
    var ambientColor: UIColor?
    
    override func didMoveToView(view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        nodeLantern = self.childNodeWithName("nodeLantern")
        nodeObstacle = self.childNodeWithName("nodeObstacle")
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        ghost = self.childNodeWithName("//ghost") as! SKSpriteNode
        
        ambientColor = UIColor.darkGrayColor()
        initSprite()
        initLight()
        
    }
    func initSprite(){
        
    }
    func initLight()
    {
       //www.codeandweb.com/spriteilluminator/tutorials/spritekit-dynamic-light-tutorial
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
//        let changeColorAction = SKAction.colorizeWithColor(SKColor.blueColor(), colorBlendFactor: 1.0, duration: 0.5)
//        self.runAction(changeColorAction)
        heroJump()
    }
    
    func heroJump()
    {
        if(isAtGround)
        {
            hero.physicsBody?.applyImpulse(CGVectorMake(0, 13.5))
          //  print(hero.position.x)
            hero.paused = true;
            isAtGround = false
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        if gameState == .GameOver{
            hero.removeFromParent()
            
            let resourchPath = NSBundle.mainBundle().pathForResource("TempLabel", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            box.position = CGPoint(x: 100, y: 100)
            self.addChild(box)

            
        }
        if gameState == .Active{
            if hero.position.x < -200
            {
                gameState = .GameOver
                return;
            }
            
            //  print("Ghost timer : \(ghostSpawnTimer)")
            if hero.position.x > 30
            {
                let heroLimit =  SKAction.moveToX(hero.position.x - 2, duration: 2)
                hero.runAction(heroLimit)
            }
            
            if scoreCounter % 31 == 0
            {
                score += 1
                print("Score: \(score)")
                
                if score % 3 == 0
                {
                    let randomNumber = Int(arc4random_uniform(UInt32(6)))
                    //  print("Number of boxes: \(randomNumber)")
                    if randomNumber > 3{
                        addBoxes()
                    }else if randomNumber > 0{
                        addBox()
                    }else{
                        //do nothing
                    }
                    
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
        
        if nodeA.name == "ground" || nodeB.name == "ground"
        {
        //    print("ground")
            isAtGround = true;
            hero.paused = false
            return
        }
        
        if nodeA.name == "box" || nodeB.name == "box"
        {
           // print("box")
            isAtGround = true;
            hero.paused = false;
            return
        }
        
        if nodeA.name == "lantern" || nodeB.name == "lantern"
        {
            
            // add effects of bright glow
           
            /* Effects #1 */
            // world pause
            hero.paused = true
            hero.physicsBody?.dynamic = false
            hero.physicsBody?.affectedByGravity = false
            gameState = .LanternGlow
            
            
            let pauseTime = SKAction.waitForDuration(2)
            let unpause = SKAction.performSelector(#selector(resume), onTarget: self)
            let stepSequence = SKAction.sequence([pauseTime, unpause])
            self.runAction(stepSequence)
            
            /* Effects #2 */
            ghostReset()
            
            /* Effects #3 */
            obstacleDisappear()
            

            
            heroBoost()
            
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
        if nodeA.name == "ghost" || nodeB.name == "ghost"
        {
            gameState = .GameOver
            return
        }
        
    }
    
    func resume()
    {
        hero.paused = false
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.affectedByGravity = true
        gameState = .Active
    }
    
    func heroBoost() {
        
        if hero.position.x < 15
        {
            let heroLimit =  SKAction.moveToX(hero.position.x + 2, duration: 2)
            hero.runAction(heroLimit)
        }
 
    }
    func ghostReset()
    {
        let ghostreset = SKAction.moveTo(ghostOriginalPos, duration: 2.5)
        ghost.runAction(ghostreset)
        ghost.removeActionForKey("creepIn")
            
        ghostSpawnTimer = -5
    }
    
    func ghostCreepIn()
    {
        let creepIn = SKAction.moveToX(CGFloat(800), duration:75)
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
        spawnTimer = 0
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
        
        if spawnTimer > 3.5     //monster spawn
        {
            let resourchPath = NSBundle.mainBundle().pathForResource("Monster", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 65), toNode: groundScroll)
            groundScroll.addChild(box)
            //    print("Monster")
            spawnTimer = 0
            return
            
        }
        
        if lanternSpawnTimer > 13   //lantern spawn
        {
            let resourchPath = NSBundle.mainBundle().pathForResource("Lantern", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 176), toNode: groundScroll)
            groundScroll.addChild(box)
            //    print("Lantern")
            lanternSpawnTimer = 0
            return
        }
        
        spawnTimer+=fixedDelta
        pitSpawnTimer += fixedDelta
        lanternSpawnTimer += fixedDelta
        ghostSpawnTimer += fixedDelta
        
    }
    
    
    func addBoxes()
    {
        let resourchPath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
        let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
        box.position = self.convertPoint(CGPoint(x: 600, y: 66), toNode: groundScroll)
        groundScroll.addChild(box)
    }
    
    func addBox()
    {
        let resourchPath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
        let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
        box.position = self.convertPoint(CGPoint(x: 600, y: 66), toNode: groundScroll)
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
                    let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10 , groundposition.y)
                    ground.position = self.convertPoint(newPosition, toNode: groundScroll)
                }
            }
        }
    }
    func updateCloudScroll()
    {
        if scrollSpeed > 150
        { cloudSpeed = scrollSpeed - 150}
        
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
        if scrollSpeed > 110
        {
            backSpeed = scrollSpeed - 110
        }
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
