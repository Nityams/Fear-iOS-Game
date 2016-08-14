//
//  Tut.swift
//  Fear
//
//  Created by Nityam Shrestha on 8/9/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit
/*
 Scene accessed only sfor the first time gameplay
 */
class Tut: SKScene {
    var startGame:SKAction!
    
    override func didMoveToView(view: SKView) {
        startGame = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.runAction(startGame)
            }
}
