//
//  CustomProgressBar.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2016/09/11.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

class CustomProgressBar : SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize){
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(){
        let texture : SKTexture? = SKTexture(imageNamed:"progressBarImage")
        //self.init(texture: texture, color: UIColor.red, size: texture!.size())
        self.init(texture: texture, color:UIColor.red, size: texture!.size())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress:CGFloat){
        //self.maskNode?.xScale = progress
    }
    
}
