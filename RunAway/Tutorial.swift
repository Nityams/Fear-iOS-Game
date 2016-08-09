    //
//  Tutorial.swift
//  RunAway
//
//  Created by Nityam Shrestha on 8/8/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit

class Tutorial:SKScene, SKPhysicsContactDelegate{
    var hero: SKSpriteNode!
    var groundScroll: SKNode!
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var isAtGround: Bool = true
    var scrollSpeed:CGFloat = 175
    var swipped = true
    var fps:NSTimeInterval = 0
    var bx1: SKNode!
    var bx2: SKNode!
    var bx3: SKNode!
    var bx4: SKNode!
    var bx5: SKNode!
    var bx6: SKNode!

//    var jumpStop: SKNode!
//    var slideStop: SKNode!
//    var fullStop: SKNode!
    
    override func didMoveToView(view: SKView) {
         physicsWorld.contactDelegate = self
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        groundScroll = self.childNodeWithName("groundScroll")
        bx1 = self.childNodeWithName("//bx1")
        bx2 = self.childNodeWithName("//bx2")
        bx3 = self.childNodeWithName("//bx3")
        bx4 = self.childNodeWithName("//bx4")
        bx5 = self.childNodeWithName("//bx5")
        bx6 = self.childNodeWithName("//bx6")
        
        //        jumpStop = self.childNodeWithName("jumpStop")
//        slideStop = self.childNodeWithName("slideStop")
//        fullStop = self.childNodeWithName("fullStop")
        
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
        
    }
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("Swipped Right here")
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("Swipped Left here")
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        scrollSpeed = 175
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
    {   scrollSpeed = 175
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
 
    }

    func heroJump()
    {
        if(isAtGround)
        {
            hero.physicsBody?.applyImpulse(CGVectorMake(0, 18))
            hero.paused = true;
            isAtGround = false
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
            if hero.xScale < 1
            {
                return
            }else{
                hero.paused = false
            }
            return
            
        }
//        if nodeA.name == "jumpStop" || nodeB.name == "jumpStop"
//        {
//            
//            swipped = false
//           // scrollSpeed = 0
//            print("\(fps)")
//        }
//        if nodeA.name == "slideStop" || nodeB.name == "slideStop"
//        {
//            
//             print("\(fps)")
//            swipped = false
//           // scrollSpeed = 0
//        }
//        if nodeA.name == "fullStop" || nodeB.name == "fullStop"
//        {
//             print("\(fps)")
//           // scrollSpeed = 0
//        }
        

    }
    override func update(currentTime: NSTimeInterval) {

        var heroPosition = self.convertPoint(hero.position, toNode: groundScroll).x
        if heroPosition > 530 && heroPosition < 534
        {
           scrollSpeed = 0
        }
        if heroPosition > 830 && heroPosition < 833
        {
            
            scrollSpeed = 0
        }
        
        if heroPosition > 1553 && heroPosition < 1558
        {
            scrollSpeed = 0
        }
        if heroPosition > 1873 && heroPosition < 1876
        {
          scrollSpeed = 0
        }
        if heroPosition > 2326 && heroPosition < 2329
        {
          scrollSpeed = 0
        }
        
        updateObstacle()
    
    
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("hero: : \(self.convertPoint(hero.position, toNode: groundScroll).x)")
        print("box1 \(bx1.position.x))")
    }
    func updateObstacle()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)

    }
}
