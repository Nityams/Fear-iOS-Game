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
    var instructions:SKAction!
    
    override func didMoveToView(view: SKView)
    {
//        start = self.childNodeWithName("start") as! SKLabelNode
//        startButton = self.childNodeWithName("startButton") as! SKLabelNode
//        highScores = self.childNodeWithName("highScores") as! SKLabelNode
//        highScoreButton = self.childNodeWithName("highScoreButton") as! SKLabelNode
        startGame = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        highscoreScene = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = HighScore(fileNamed:"HighScoreScene") as HighScore!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        instructions = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = TutMenu(fileNamed:"Tut") as TutMenu!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    
        for touch in touches
        {
            let pt = touch.locationInNode(self)
            if(nodeAtPoint(pt).name == "start" || nodeAtPoint(pt).name == "startbutton")
            {
                self.runAction(startGame)
                return
            }
            else if(nodeAtPoint(pt).name == "highScoreButton" || nodeAtPoint(pt).name == "HighScore"){
                self.runAction(highscoreScene)
                return
            }
            else if (nodeAtPoint(pt).name == "instructionsLabel" || nodeAtPoint(pt).name == "instructionsBtn")
            {
                self.runAction(instructions)
                return
            }
            else
            {return}
        }
    }
}
