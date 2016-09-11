//
//  Kodama.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2016/06/26.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

private let KODAMA_SCORE : Int32 = 1
private let KODAMA_NAME_LENGTH : Int = 6

class Kodama : Eidolon, EidolonAction {
    static var number : Int32 = 0
    static var picname : String = "kodama"
    let name: String
    
    init (){
        Kodama.number += 1
        name = Kodama.picname + Kodama.number.description
        super.init(imageName: Kodama.picname);
        
        self.score = KODAMA_SCORE
        let rmAction : SKAction
        let nmAction : SKAction
        let alphaAction : SKAction
        
        rmAction = SKAction.sequence([SKAction.waitForDuration(3.0),SKAction.removeFromParent()])
        nmAction = SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.rotateToAngle(CGFloat(M_PI_4/2), duration: 0.05),SKAction.rotateToAngle(CGFloat(-1*M_PI_4/2), duration: 0.05)]), count: 5),SKAction.rotateToAngle(0.0, duration: 0.05)])
        alphaAction = SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0), SKAction.waitForDuration(1.0),SKAction.fadeAlphaTo(0.0, duration: 1.0)])
        
        self.actions.append(SKAction.group([rmAction, nmAction, alphaAction]))
    }
        
    func onTapIn(scene: SKScene) {
        if let magicEmitterSprite = SKEmitterNode(fileNamed: "MyParticle.sks") {
            magicEmitterSprite.position = self.sprite.position
            magicEmitterSprite.alpha = 0
            magicEmitterSprite.zPosition = 50
            scene.addChild(magicEmitterSprite)
            
            magicEmitterSprite.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.fadeAlphaTo(0, duration: 1.1), SKAction.removeFromParent()]))
        }

    }
    
    func getScore() -> Int32 {
        return self.score
    }
    
    func getNumber() -> Int? {
        let number : String =  self.name.substringFromIndex(Kodama.picname.startIndex.advancedBy(KODAMA_NAME_LENGTH))
        return Int(number)
    }
    
    
}
