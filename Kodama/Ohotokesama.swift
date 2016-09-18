//
//  Ohotokesama.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2016/07/23.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

private let OHOTOKESAMA_SCORE : Int32 = 1

class Ohotokesama : Eidolon, EidolonAction {
    static let picname : String = "ohotokesama"
    static var number : Int32 = 0
    let name : String
    
    init (){
        Ohotokesama.number += 1
        name = Ohotokesama.picname + Ohotokesama.number.description
        super.init(imageName: Ohotokesama.picname);
        
        self.score = OHOTOKESAMA_SCORE
        self.actions.append(SKAction.sequence([SKAction.wait(forDuration: 3.0),SKAction.removeFromParent()]))
        self.actions.append(SKAction.moveTo(x: UIScreen.main.bounds.width, duration: 3))
        self.actions.append(SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 1.0), SKAction.wait(forDuration: 1.0),SKAction.fadeAlpha(to: 0.0, duration: 1.0)]))
    }
    
       
    func onTapIn(_ scene: SKScene) {
        if let magicEmitterSprite = SKEmitterNode(fileNamed: "OhotokesamaParticle.sks") {
            magicEmitterSprite.position = self.sprite.position
            magicEmitterSprite.alpha = 0
            magicEmitterSprite.zPosition = 50
            scene.addChild(magicEmitterSprite)
            
            magicEmitterSprite.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.fadeAlpha(to: 0, duration: 1.5), SKAction.removeFromParent()]))
        }
        
    }
    
    func getScore() -> Int32 {
        return self.score
    }
    
    
}
