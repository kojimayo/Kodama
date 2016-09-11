//
//  GejiGeji.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2016/07/21.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

private let GEJIGEJI_SCORE : Int32 = -5

class GejiGeji : Eidolon, EidolonAction {
    static let picname : String = "gejigeji"
    static var number : Int32 = 0
    let name : String
    
    init (){
        GejiGeji.number += 1
        name = GejiGeji.picname + GejiGeji.number.description
        super.init(imageName: GejiGeji.picname);
        
        self.score = GEJIGEJI_SCORE
        self.actions.append(SKAction.sequence([SKAction.waitForDuration(3.0),SKAction.removeFromParent()]))
        self.actions.append(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI*2), duration: 0.8)))
        self.actions.append(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0), SKAction.waitForDuration(1.0),SKAction.fadeAlphaTo(0.0, duration: 1.0)]))
    }
    
    
    func onTapIn(scene: SKScene) {
        if let magicEmitterSprite = SKEmitterNode(fileNamed: "GejigejiParticle.sks") {
            magicEmitterSprite.position = self.sprite.position
            magicEmitterSprite.alpha = 0
            magicEmitterSprite.zPosition = 50
            scene.addChild(magicEmitterSprite)
            
            magicEmitterSprite.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.fadeAlphaTo(0, duration: 1.5), SKAction.removeFromParent()]))
        }
        
    }
    
    func getScore() -> Int32 {
        return self.score
    }

    
}
