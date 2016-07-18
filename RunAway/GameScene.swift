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
    
    var scrollSpeed:CGFloat = 200
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        updateGroundScroll()
        updateCloudScroll()
        updateBackScroll()
        
    }
    func addElements()
    {
        let resourchPath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
        let newLevel = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
        groundScroll.addChild(newLevel)
    }
    func updateGroundScroll()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for ground in groundScroll.children as! [SKSpriteNode]
        {
            let groundposition = groundScroll.convertPoint(ground.position, toNode: self)
            if groundposition.x <= -ground.size.width/2
            {
                let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10 , groundposition.y)
                ground.position = self.convertPoint(newPosition, toNode: groundScroll)
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
