//
//  Opening.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2015/11/15.
//  Copyright (c) 2015年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

class OpeningScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let back = SKSpriteNode(imageNamed: "mori-opening")
        back.size = self.size
        back.position = CGPoint(x: self.frame.width/2.0, y: self.frame.size.height/2.0)
        back.zPosition = 90
        
        let texture = SKTexture(imageNamed: "kodama_title")
        let title = SKSpriteNode(texture: texture)
        title.size = CGSize(width: self.frame.width * 3.0/4.0, height: texture.size().height)
        title.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        title.zPosition = 100
        
        self.addChild(back)
        self.addChild(title)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let transition = SKTransition.doorsOpenHorizontalWithDuration(1.0)
        
        let scene = GameScene()
        scene.scaleMode = .AspectFill
        scene.size = self.size
        
        self.view?.presentScene(scene, transition: transition)
        
        //self.removeAllChildren()
    }

}