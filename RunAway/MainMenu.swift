//
//  MainMenu.swift
//  RunAway
//
//  Created by Nityam Shrestha on 8/5/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu:SKScene{
    
//    var start:SKLabelNode!
//    var startButton:SKLabelNode!
//    var highScores:SKLabelNode!
//    var highScoreButton: SKLabelNode!
    var startGame:SKAction!
    var highscoreScene: SKAction!
    var settings:SKAction!
    
    override func didMoveToView(view: SKView)
    {
//        start = self.childNodeWithName("start") as! SKLabelNode
//        startButton = self.childNodeWithName("startButton") as! SKLabelNode
//        highScores = self.childNodeWithName("highScores") as! SKLabelNode
//        highScoreButton = self.childNodeWithName("highScoreButton") as! SKLabelNode
        startGame = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skview.presentScene(scene)
        })
        highscoreScene = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skview.presentScene(scene)
        })
        settings = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skview.presentScene(scene)
        })
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    
        for touch in touches
        {
            let pt = touch.locationInNode(self)
            if(nodeAtPoint(pt).name == "start" || nodeAtPoint(pt).name == "startButton")
            {
                self.runAction(startGame)
            }
            if(nodeAtPoint(pt).name == "highScoreButton" || nodeAtPoint(pt) == "highScores"){
                
            }
            if (nodeAtPoint(pt).name == "settings" || nodeAtPoint(pt) == "settingsButton")
            {
                
            }
        }
    }
}
