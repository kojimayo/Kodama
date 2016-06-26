//
//  GameScene.swift
//  Kodama
//
//  Created by 小島 佳幸 on 2015/11/08.
//  Copyright (c) 2015年 小島 佳幸. All rights reserved.
//

import Foundation
import SpriteKit

struct UserScoreData {
    let count:Int
    let level:Int
    let playDate:String
}

class GameScene: SKScene {
    var timer : NSTimer?
    var timeIntervarl : NSTimeInterval = 2.0
    var tileDiv : CGFloat = 8.0
    var depthDiv : CGFloat = 3.0
    
    var gameLevel : Int32 = 1
    var ratio : CGFloat = 0.0
    var totalCnt : Int32 = 0
    var getCnt : Int32 = 0
    var lvlCnt :Int32 = 0
    
    var gameOverFlag : Bool = false
    var gameOverDone : Bool = false
    
    var lvlLabel : SKLabelNode?
    var gameOverLabel : SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Lvl 1 total 0";
        myLabel.fontSize = 35;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height - 45);
        myLabel.zPosition = 50
        self.lvlLabel = myLabel
        
        self.setBackground()
        self.addChild(myLabel)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeIntervarl, target: self, selector: "createKodama", userInfo: nil, repeats: true)
    }
    
    func updateString() {
        self.lvlLabel?.text = "Lvl \(self.gameLevel) total \(self.getCnt)"
    }
    
    func setBackground(){
        let background = SKTexture(imageNamed: "mori")
        let sprite = SKSpriteNode(texture: background)
        sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        sprite.size = self.size
       
        self.addChild(sprite)

    }
    
    
    func createKodama(){
        var posix : CGFloat
        var posiy : CGFloat
        var posiz : UInt32 = 0
        var depthsize : [CGFloat] = [1.5 ,1.0 ,0.75]
        
        self.totalCnt += 1
        self.lvlCnt += 1

        posiz = arc4random_uniform(UInt32(self.depthDiv))
        posix = CGFloat(arc4random_uniform(UInt32(self.tileDiv * depthsize[Int(posiz)])))
        posiy = CGFloat(arc4random_uniform(UInt32(self.tileDiv * depthsize[Int(posiz)])))

        
        let kodamaSprite = SKSpriteNode(imageNamed: "kodama")
        kodamaSprite.name = "kodama"
        kodamaSprite.size = CGSize(width: self.frame.width/(self.tileDiv*depthsize[Int(posiz)]), height: self.frame.height/(self.tileDiv*depthsize[Int(posiz)]))
        kodamaSprite.position = CGPoint(x: kodamaSprite.size.width*(0.5+posix), y: kodamaSprite.size.height*(0.5+posiy))
        kodamaSprite.alpha = 0.0
        kodamaSprite.zPosition = 50
        
        kodamaSprite.runAction(SKAction.sequence([SKAction.waitForDuration(3.0),SKAction.removeFromParent()]))
        kodamaSprite.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0), SKAction.waitForDuration(1.0),SKAction.fadeAlphaTo(0.0, duration: 1.0)]))
        
        //print("add kodama")
        self.addChild(kodamaSprite)
        
        
    }
    
    func createMagicParticle(position :CGPoint){
        if let magicEmitterSprite = SKEmitterNode(fileNamed: "MyParticle.sks") {
            magicEmitterSprite.position = position
            magicEmitterSprite.alpha = 0
            magicEmitterSprite.zPosition = 50
            self.addChild(magicEmitterSprite)
        
            magicEmitterSprite.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.fadeAlphaTo(0, duration: 1.1), SKAction.removeFromParent()]))
        }
        
    }
    
    func judgeLevel(){
        
        if self.timeIntervarl * Double(self.lvlCnt) > 10.0 {
            self.lvlCnt = 0
            self.ratio = CGFloat(self.getCnt)/CGFloat(self.totalCnt)
        
            if self.ratio < 0.8 {
                self.gameOverFlag = true
                self.gameOver()
            } else {
                self.gameLevel += 1
                if self.timeIntervarl > 0.2 {
                    self.timeIntervarl -= 0.1
                    self.timer?.invalidate()
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeIntervarl, target: self, selector: "createKodama", userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    func setHighScore(cnt :Int, level: Int)->Int{
        var usrScoreDatas : [UserScoreData] = getHighScore()
        let userDefault = NSUserDefaults.standardUserDefaults()
        var rank = 5
        
        for n in 0...4 {
            if usrScoreDatas[n].count < cnt {
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale.currentLocale()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let now_date = formatter.stringFromDate(NSDate())
                let new_data : UserScoreData = UserScoreData(count: cnt, level: level, playDate: now_date)
                usrScoreDatas.insert(new_data, atIndex: n)
                rank = n
                break
            }
        }
        
        for n in 0...4 {
            userDefault.setInteger(usrScoreDatas[n].count, forKey: "HighCount" + n.description)
            userDefault.setInteger(usrScoreDatas[n].level, forKey: "HighLevel" + n.description)
            userDefault.setObject(usrScoreDatas[n].playDate, forKey: "HighDate" + n.description)
        }

        return rank
    }
    
    func getHighScore() -> Array<UserScoreData> {
        var highScores : [UserScoreData] = []
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        var count :Int, level:Int
        for n in 0...4 {
            count = userDefault.integerForKey("HighCount" + n.description)
            level  = userDefault.integerForKey("HighLevel" + n.description)
            if let dateString = userDefault.stringForKey("HighDate" + n.description) {
                highScores.append(UserScoreData(count: count, level: level, playDate: dateString))
            } else {
                highScores.append(UserScoreData(count: 0, level: 0, playDate: "---/--/-- --:--:--"))
            }
            
        }
        
        return highScores
    
    }
    
    func gameOver(){
        var newRank = 0
        
        if self.gameOverDone == false {
           let scene = self.createImageScene("mori-gameover")
            
            let overLabel  = SKLabelNode(fontNamed: "Chalkduster")
            overLabel.fontColor = UIColor.blueColor()
            overLabel.fontSize = 45
            overLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.size.height - 40)
            overLabel.zPosition = 10
            overLabel.text = "Sa yo na ra"
            let scoreLabel  = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.fontColor = UIColor.whiteColor()
            scoreLabel.fontSize = 35
            scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.size.height-80)
            scoreLabel.zPosition = 100
            scoreLabel.text = "Total \(self.getCnt) Lvl \(self.gameLevel)"
            
            newRank = setHighScore(Int(self.getCnt), level: Int(self.gameLevel))
            
            let highScores : [UserScoreData] = getHighScore()
            
            for n in 0...4 {
                let newScoreBack = SKSpriteNode(imageNamed: "ScoreBack")
                newScoreBack.size = CGSize(width: self.size.width*5/6.0, height: 50.0)
                newScoreBack.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5)))
                newScoreBack.zPosition = 99
                
                let scoreHisLabel1 = SKLabelNode(fontNamed: "Chalkduster")
                scoreHisLabel1.color = SKColor.blackColor()
                scoreHisLabel1.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5)))
                scoreHisLabel1.fontSize = 16
                scoreHisLabel1.text = "Rank:\(n+1) Total: " + highScores[n].count.description + " Level: " + highScores[n].level.description
                scoreHisLabel1.zPosition = 100
                
                let scoreHisLabel2 = SKLabelNode(fontNamed: "Chalkduster")
                scoreHisLabel2.color = SKColor.blackColor()
                scoreHisLabel2.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5 )) - 16)
                scoreHisLabel2.fontSize = 16
                scoreHisLabel2.zPosition = 100
                scoreHisLabel2.text = highScores[n].playDate
                
                if newRank == n {
                    let star = SKSpriteNode(imageNamed: "Star")
                    star.size = CGSize(width: 25.0, height: 25.0)
                    star.position = CGPoint(x: self.size.width*1.0/6.0/2.0 + 10, y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5)))
                    star.zPosition = 110
                    scene.addChild(star)
                }

                
                scene.addChild(newScoreBack)
                scene.addChild(scoreHisLabel1)
                scene.addChild(scoreHisLabel2)
            }
            
            scene.addChild(overLabel)
            scene.addChild(scoreLabel)
            
            let transition = SKTransition.crossFadeWithDuration(1.0)
            self.view?.presentScene(scene, transition: transition)
            
            self.gameOverLabel = overLabel
            self.timer?.invalidate()
            self.timer = nil
            
            self.paused = true
            
            self.gameOverDone = true
        }
        
    }
    
    func reset(){
        if self.gameOverFlag == true {
            self.totalCnt = 0
            self.getCnt = 0
            self.lvlCnt = 0
            self.gameLevel = 1
            self.timeIntervarl = 2.0
            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeIntervarl, target: self, selector: "createKodama", userInfo: nil, repeats: true)

            
            self.judgeLevel()
            self.updateString()
            
            self.gameOverLabel?.removeFromParent()
            
            self.paused = false
            
            self.gameOverFlag = false
            self.gameOverDone = false
        }
    }
    
    func createImageScene(imageName: String)-> SKScene{
        let scene = SKScene(size: self.size)
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = scene.size
        sprite.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scene.addChild(sprite)
        
        let restartTouch = TouchButton(imageNamed: "RestartBack")
        restartTouch.size = CGSize(width:self.size.width*3/4.0, height:80)
        restartTouch.position = CGPoint(x: scene.size.width*0.5, y: restartTouch.size.height/2 + 20)
        restartTouch.userInteractionEnabled = true
    
        scene.addChild(restartTouch)
        return scene
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches ){
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location)
            for node in (nodes ) {
                if node.name == "kodama" {
                    node.removeAllActions()
                    node.removeFromParent()
                    self.getCnt += 1
            
                    self.createMagicParticle(location)
                }
            }
            
            if self.gameOverFlag == true {
                self.reset()
            }
            
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.judgeLevel()
        self.updateString()
    }
}

class TouchButton: SKSpriteNode {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        let scene = GameScene()
        scene.scaleMode = .AspectFill
        scene.size = CGSize(width: self.scene!.size.width, height: self.scene!.size.height)
        self.scene?.view?.presentScene(scene, transition: transition)

    }
}

class TouchScene: SKScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        
        let scene = GameScene()
        scene.scaleMode = .AspectFill
        scene.size = self.size
        
        self.view?.presentScene(scene, transition: transition)
    }
}