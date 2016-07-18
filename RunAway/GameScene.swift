//
//  GameScene.swift
//  RunAway
//
//  Created by Nityam Shrestha on 7/18/16.
//  Copyright (c) 2016 nityamshrestha.com. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var groundScroll: SKNode!
    var cloudScroll: SKNode!
    var backScroll: SKNode!
    var hero: SKSpriteNode!
    
    
    var nodeObstacle: SKNode!
    var nodeLantern: SKNode!
    
    var myBox:SKSpriteNode!
    
    var scrollSpeed:CGFloat = 200
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var lastLanternTime: CFTimeInterval = 0
   
    var score: Int = 0
    var scoreCounter = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        nodeLantern = self.childNodeWithName("nodeLantern")
        nodeObstacle = self.childNodeWithName("nodeObstacle")
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
            heroJump()
    }
    func heroJump()
    {
        
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if scoreCounter % 31 == 0
        {
            score += 1
            print("Score: \(score)")
            
            if score % 3 == 0
            {
                let randomNumber = Int(arc4random_uniform(UInt32(6)))
                print("Number of boxes: \(randomNumber)")
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
    
    func updateObstacles()
    {
        for elements in groundScroll.children{
            if elements.position.x < -5
            {
                elements.removeFromParent()
            }
        }
    }
    func addBoxes()
    {
        let resourchPath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
        let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
        box.position = self.convertPoint(CGPoint(x: 600, y: 76), toNode: groundScroll)
        groundScroll.addChild(box)
    }
    
    func addBox()
    {
        let resourchPath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
        let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 76), toNode: groundScroll)
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
