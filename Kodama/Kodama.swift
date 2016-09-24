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
private let KODAMA_DAMAGE : Int32 = 10
private let KODAMA_NAME_LENGTH : Int = 6

class Kodama : Eidolon, EidolonAction {
    static var number : Int32 = 0
    static var picname : String = "kodama2"
    let name: String
    
    init (){
        Kodama.number += 1
        name = Kodama.picname + Kodama.number.description
        super.init(imageName: Kodama.picname);
        
        self.score = KODAMA_SCORE
        let rmAction : SKAction
        let nmAction : SKAction
        let alphaAction : SKAction
        
        rmAction = SKAction.sequence([SKAction.wait(forDuration: 3.0),SKAction.removeFromParent()])
        nmAction = SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.rotate(toAngle: CGFloat(M_PI_4/2), duration: 0.05),SKAction.rotate(toAngle: CGFloat(-1*M_PI_4/2), duration: 0.05)]), count: 5),SKAction.rotate(toAngle: 0.0, duration: 0.05)])
        alphaAction = SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 1.0), SKAction.wait(forDuration: 1.0),SKAction.fadeAlpha(to: 0.0, duration: 1.0)])
        
        self.actions.append(SKAction.group([rmAction, nmAction, alphaAction]))
    }
        
    func onTapIn(_ scene: SKScene) {
        self.remove()
        if let magicEmitterSprite = SKEmitterNode(fileNamed: "MyParticle.sks") {
            magicEmitterSprite.position = self.sprite.position
            magicEmitterSprite.alpha = 0
            magicEmitterSprite.zPosition = 50
            scene.addChild(magicEmitterSprite)
            
            magicEmitterSprite.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.fadeAlpha(to: 0, duration: 1.1), SKAction.removeFromParent()]))
        }

    }
    
    func getScore() -> Int32 {
        return self.score
    }
    
    func getNumber() -> Int? {
        let number : String =  self.name.substring(from: Kodama.picname.characters.index(Kodama.picname.startIndex, offsetBy: KODAMA_NAME_LENGTH))
        return Int(number)
    }
    
    override func getDamage() -> Int32 {
        return KODAMA_DAMAGE
    }
    
    
    
}
