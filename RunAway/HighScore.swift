//
//  HighScore.swift
//  RunAway
//
//  Created by Nityam Shrestha on 8/5/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit

class HighScore: SKScene {
    
    var distance:Int = NSUserDefaults.standardUserDefaults().integerForKey("distance") ?? 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(distance, forKey:"distance")
            // Saves to disk immediately, otherwise it will save when it has time
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var score:Int = NSUserDefaults.standardUserDefaults().integerForKey("score") ?? 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey:"score")
            // Saves to disk immediately, otherwise it will save when it has time
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var distanceLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var returnBtn: SKSpriteNode!
    var returnback:SKAction!
    var confirmBoard: SKSpriteNode!

    
    override func didMoveToView(view: SKView)
    {
        distanceLabel = self.childNodeWithName("distanceLabel") as! SKLabelNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        returnBtn = self.childNodeWithName("//returnBtn") as! SKSpriteNode
        confirmBoard = self.childNodeWithName("confirmBoard") as! SKSpriteNode
        
        distanceLabel.text = String (distance)
        scoreLabel.text = String (score)
        
        returnback = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = MainMenu(fileNamed:"MainMenu") as MainMenu!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        
        //resetAct
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let pt = touch.locationInNode(self)
            if (nodeAtPoint(pt) == returnBtn || nodeAtPoint(pt).name == "returnBtns")
            {
                self.runAction(returnback)
                
            }else if (nodeAtPoint(pt).name == "reset" || nodeAtPoint(pt).name == "resetBtn")
            {
                confirmBoard.runAction(SKAction.moveToY(200 , duration: 0.2))

            }
            else if (nodeAtPoint(pt).name == "No")
            {
                 confirmBoard.runAction(SKAction.moveToY(450 , duration: 0.2))
            }
            else if (nodeAtPoint(pt).name == "Yes")
            {
                    distance = 0
                    score = 0
                distanceLabel.text = String(distance)
                scoreLabel.text = String(score)
                let scene = GameScene(fileNamed:"GameScene") as GameScene!
                scene.missionNumber = 1
                confirmBoard.runAction(SKAction.moveToY(450 , duration: 0.2))
            }
            else{
                return
            }
        }
    }
    
}