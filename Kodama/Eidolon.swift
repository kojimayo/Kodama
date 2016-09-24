//
//  Eidolon.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2016/06/26.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

protocol EidolonAction {
    func runAction(on secne:SKScene)
    func stopAction()
    func onTapIn(_ scene :SKScene)
    var name :String {get}
    func getScore() -> Int32
    func getDamage()->Int32
    func remove()
}

protocol EidolonDelegate {
    func eidolonRemove(_ eidolon :Eidolon) -> Void
}


class Eidolon {
    let imageName : String
    var delegate :EidolonDelegate? = nil
    var actions : [SKAction?]
    var scene:SKScene?
    var score : Int32
    lazy var sprite : SKSpriteNode = { (imageName : String) -> SKSpriteNode in
        let sprite : SKSpriteNode
        sprite = SKSpriteNode(imageNamed: imageName)
        sprite.name = imageName
        sprite.userData = NSMutableDictionary();
        sprite.userData?.setObject(self, forKey: "wrapped" as NSCopying)
        return sprite
    }(self.imageName)
    
    
    var size : CGSize {
        didSet { self.sprite.size = self.size }
    }
    var position : CGPoint {
        didSet { self.sprite.position = self.position }
    }
    var alpha : CGFloat {
        get { return self.sprite.alpha }
        set { self.sprite.alpha = newValue }
    }
    var zPosition : CGFloat {
        get { return self.sprite.zPosition }
        set { self.sprite.zPosition = newValue }
    }
    
    
    init (imageName : String) {
        self.imageName = imageName
        size = CGSize(width: 0.0, height: 0.0)
        position = CGPoint(x: 0, y: 0)
        actions = [SKAction?]()
        score = 0
    }
    
    func runDamageAction(on scene: SKScene){
        if let emitterSprite = SKEmitterNode(fileNamed: "damageParticle.sks") {
            emitterSprite.position = self.sprite.position
            emitterSprite.alpha = 0
            emitterSprite.zPosition = self.sprite.zPosition
            scene.addChild(emitterSprite)
            emitterSprite.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0, duration: 1.0), SKAction.removeFromParent()]))

        }

    }
    
    func runAction(on scene:SKScene) {
        self.sprite.isPaused = false
        self.scene = scene
        for action in self.actions {
            if (action != nil && self.delegate != nil) {
                self.sprite.run(action!){self.completeAction()}
            } else {
                self.sprite.run(action!)
            }
        }
        
    }
    
    func completeAction(){
        self.delegate?.eidolonRemove(self)
        if let scene = self.scene {
            runDamageAction(on: scene)
        }
    }
    
    func stopAction() {
        self.sprite.isPaused = true
    }

    func remove() {
        self.sprite.removeAllActions()
        self.sprite.removeFromParent()
    }
    
    func getDamage() -> Int32{
        return 0
    }

    
    
}
