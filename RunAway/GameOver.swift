//
//  GameOver.swift
//  RunAway
//
//  Created by Nityam Shrestha on 8/3/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit
class GameOver:SKScene
{
    var gameReset:SKAction!
    var touchCount = 0
    var score = 0
    var levelCompelete: Bool!
    var scoreLabel: SKLabelNode!
    var missionScoreLabel: SKLabelNode!
    var totalScoreLabel: SKLabelNode!
    var missionCompleteLabel:SKLabelNode!
    var totalScore:Int = 0
    var labels1:SKLabelNode!
    var labels2:SKLabelNode!
    var labels3: SKLabelNode!
    var missionScore = 0
    override func didMoveToView(view: SKView)
    {
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        missionScoreLabel = self.childNodeWithName("missionScoreLabel") as! SKLabelNode
        totalScoreLabel = self.childNodeWithName("totalScoreLabel") as! SKLabelNode
        missionCompleteLabel = self.childNodeWithName("missionCompleteLabel") as! SKLabelNode
        labels1 = self.childNodeWithName("labels1") as! SKLabelNode
        labels2 = self.childNodeWithName("labels2") as! SKLabelNode
        labels3 = self.childNodeWithName("labels3") as! SKLabelNode
        gameReset = SKAction.runBlock({
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            scene.scaleMode = .AspectFit
            skView.presentScene(scene)
        })
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for _ in touches
        {
           // if touchCount >= 1
            //{
                let scene = HighScore(fileNamed: "HighScoreScene") as HighScore!
                if scene.score < totalScore
                {
                    scene.score = totalScore
                }
                
                self.runAction(gameReset)
            //}
//            else
//            {
//                missionScoreLabel.text = String (missionScore)
//                missionScoreLabel.zPosition = 1
//                scoreLabel.zPosition = 1
//                totalScoreLabel.text = String(totalScore)
//                totalScoreLabel.zPosition = 1
//                labels1.zPosition = 1
//                labels2.zPosition = 1
//                labels3.zPosition = 1
//                touchCount += 1
//            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        scoreLabel.text = String(score)
        if levelCompelete == true
        {
            missionCompleteLabel.zPosition = 1
            missionScore = 100
            totalScore = 100 + score
        }
        else
        {
            totalScore = score
        }
        
        
        missionScoreLabel.text = String (missionScore)
        missionScoreLabel.zPosition = 1
        scoreLabel.zPosition = 1
        totalScoreLabel.text = String(totalScore)
        totalScoreLabel.zPosition = 1
        labels1.zPosition = 1
        labels2.zPosition = 1
        labels3.zPosition = 1
        touchCount += 1

    }
}