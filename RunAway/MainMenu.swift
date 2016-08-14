//
//  MainMenu.swift
//  Fear
//
//  Created by Nityam Shrestha on 8/5/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class MainMenu:SKScene{
    
    var startGame:SKAction!
    var highscoreScene: SKAction!
    var instructions:SKAction!
    var credits: SKAction!
    var myAudioPlayer:AVAudioPlayer!
    override func didMoveToView(view: SKView)
    {
        let gameSoundPath = NSBundle.mainBundle().pathForResource("Dusty Authority", ofType: "mp3")
        if let gameSoundPaths = gameSoundPath
        {
            let gameSoundURL = NSURL(fileURLWithPath: gameSoundPaths)
            do{
                try myAudioPlayer = AVAudioPlayer(contentsOfURL: gameSoundURL)
                myAudioPlayer.play()
                if myAudioPlayer.play() == true{
                    print("play here")
                }
            }
            catch{
                print("error")
            }
        }
        
        /* scene run blocks */
        
        startGame = SKAction.runBlock({
            self.myAudioPlayer.stop()
            let skview = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        highscoreScene = SKAction.runBlock({
           self.myAudioPlayer.stop()
            let skview = self.view as SKView!
            let scene = HighScore(fileNamed:"HighScoreScene") as HighScore!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        instructions = SKAction.runBlock({
           self.myAudioPlayer.stop()
            let skview = self.view as SKView!
            let scene = TutMenu(fileNamed:"Tut") as TutMenu!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        credits = SKAction.runBlock({
            self.myAudioPlayer.stop()
            let skview = self.view as SKView!
            let scene = Credits(fileNamed:"Credits") as Credits!
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
            else if (nodeAtPoint(pt).name == "credits" || nodeAtPoint(pt).name == "creditsBtn")
            {
                self.runAction(credits)
                return
            }
            else
            {return}
        }
    }
}
