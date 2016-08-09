//
//  TutMenu.swift
//  RunAway
//
//  Created by Nityam Shrestha on 8/9/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation
import SpriteKit

class TutMenu: SKScene {
    var startGame:SKAction!
    
    override func didMoveToView(view: SKView) {
        startGame = SKAction.runBlock({
            let skview = self.view as SKView!
            let scene = MainMenu(fileNamed:"MainMenu") as MainMenu!
            scene.scaleMode = .AspectFit
            skview.presentScene(scene)
        })
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.runAction(startGame)
    }
}

//