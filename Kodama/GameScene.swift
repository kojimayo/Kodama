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

class GameScene: SKScene , EidolonDelegate {
    var timer : Timer?
    var timeIntervarl : TimeInterval = 2.0
    var tileDiv : CGFloat = 8.0
    var depthDiv : CGFloat = 3.0
    
    var gameLevel : Int32 = 1
    var totalCnt : Int32 = 0
    var getCnt : Int32 = 0
    var timerCallCnt :Int32 = 0
    
    var gameOverFlag : Bool = false
    var gameOverDone : Bool = false
    
    var lvlLabel : SKLabelNode?
    var gameOverLabel : SKLabelNode?
    
    var enemyList : [EidolonAction] = [EidolonAction]()
    let progressBar : CustomProgressBar = CustomProgressBar()
    
    var life : CGFloat = 100 {
        didSet {
            self.progressBar.setProgress(self.life/100.0)
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Lvl 1 total 0";
        myLabel.fontSize = 35;
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.height - 45);
        myLabel.zPosition = 50
        self.lvlLabel = myLabel
        
        self.setBackground()
        self.addChild(myLabel)
        
        self.progressBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.progressBar.position = CGPoint(x: 15, y: self.frame.size.height - 100)
        // TODO:カスタムプログレスバー位置がうまくいない。暫定
        
        self.addChild(self.progressBar)
        
        self.timer = Timer.scheduledTimer(timeInterval: self.timeIntervarl, target: self, selector: #selector(GameScene.createEldolon), userInfo: nil, repeats: true)
    }
    
    func updateString() {
        self.lvlLabel?.text = "Lvl \(self.gameLevel) Score \(self.getCnt)"
    }
    
    func setBackground(){
        let background = SKTexture(imageNamed: "mori")
        let sprite = SKSpriteNode(texture: background)
        sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        sprite.size = self.size
       
        self.addChild(sprite)

    }
    
    
    
    func createEldolon(){
        self.timerCallCnt += 1
        if arc4random_uniform(8) == 0 && self.gameLevel >= 10 {
            self.createGejigeji()
        } else if (self.totalCnt % 30 == 0 && self.totalCnt != 0){
            self.createOhotokesama()
        } else {
            self.createKodama()
        }
        self.totalCnt += 1
    }
    
    func createKodama(){
        var posix : CGFloat
        var posiy : CGFloat
        var posiz : UInt32 = 0
        var depthsize : [CGFloat] = [1.5 ,1.0 ,0.75]


        posiz = arc4random_uniform(UInt32(self.depthDiv))
        posix = CGFloat(arc4random_uniform(UInt32(self.tileDiv * depthsize[Int(posiz)])))
        posiy = CGFloat(arc4random_uniform(UInt32(self.tileDiv * depthsize[Int(posiz)])))

        let kodama = Kodama()
        kodama.size = CGSize(width: self.frame.width/(self.tileDiv*depthsize[Int(posiz)]), height: self.frame.height/(self.tileDiv*depthsize[Int(posiz)]))
        kodama.position = CGPoint(x: kodama.size.width*(0.5+posix), y: kodama.size.height*(0.5+posiy))
        kodama.alpha = 0.0
        kodama.zPosition = 50.0
        kodama.delegate = self
        enemyList.append(kodama)
        kodama.runAction(on:self)

        //print("add kodama")
        self.addChild(kodama.sprite)
        
        
    }
    
    func removeFromEnemyList<T:Eidolon>(element : T){
        var index = 0
        for enemy in enemyList {
            guard let listElement = enemy as? T else {
                continue
            }
            if listElement === element {
                enemyList.remove(at: index)
                break;
            }
            index += 1
        }
    }
    
    func eidolonRemove(_ eidolon: Eidolon) {
        if let kodama = eidolon as? Kodama {
            removeFromEnemyList(element: kodama)
        } else if let gejigeji = eidolon as? GejiGeji {
            removeFromEnemyList(element: gejigeji)
        }
        self.life -= CGFloat(eidolon.getDamage())
    }
    
    func createGejigeji(){
        var posix : CGFloat
        var posiy : CGFloat
        var posiz : UInt32 = 0
        var depthsize : [CGFloat] = [1.5 ,1.0 ,0.75]
        
        posiz = arc4random_uniform(UInt32(self.depthDiv))
        posix = CGFloat(arc4random_uniform(UInt32(self.tileDiv * depthsize[Int(posiz)])))
        posiy = CGFloat(arc4random_uniform(UInt32(self.tileDiv * depthsize[Int(posiz)])))
        
        let gejigeji = GejiGeji()
        gejigeji.size = CGSize(width: self.frame.width/(self.tileDiv*depthsize[Int(posiz)]), height: self.frame.height/(self.tileDiv*depthsize[Int(posiz)]))
        gejigeji.position = CGPoint(x: gejigeji.size.width*(0.5+posix), y: gejigeji.size.height*(0.5+posiy))
        gejigeji.alpha = 0.0
        gejigeji.zPosition = 50.0
        gejigeji.runAction(on:self)

        self.addChild(gejigeji.sprite)
        
        
    }
    
    func createOhotokesama(){
        let posiy = CGFloat(arc4random_uniform(UInt32(self.tileDiv)))
        
        let ohotoke = Ohotokesama()
        ohotoke.size = CGSize(width: self.frame.width/(self.tileDiv), height: self.frame.height/(self.tileDiv))
        ohotoke.position = CGPoint(x: -ohotoke.size.width*0.5, y: ohotoke.size.height*(0.5+posiy))
        ohotoke.alpha = 0.0
        ohotoke.zPosition = 50.0
        ohotoke.runAction(on:self)
        
        self.addChild(ohotoke.sprite)

        
    }

    
    func createMagicParticle(_ position :CGPoint){
        if let magicEmitterSprite = SKEmitterNode(fileNamed: "MyParticle.sks") {
            magicEmitterSprite.position = position
            magicEmitterSprite.alpha = 0
            magicEmitterSprite.zPosition = 50
            self.addChild(magicEmitterSprite)
        
            magicEmitterSprite.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.fadeAlpha(to: 0, duration: 1.1), SKAction.removeFromParent()]))
        }
        
    }
    
    func judgeLevel(){
        //print("Intervarl:" + self.timeIntervarl.description + "*" + self.timerCallCnt.description)
        if self.timeIntervarl * Double(self.timerCallCnt) > 5.0 {
            self.timerCallCnt = 0
            print("getcnt:" + self.getCnt.description + "/" + totalCnt.description)
        
            if self.life <= 0 {
                self.gameOverFlag = true
                self.gameOver()
            } else {
                self.gameLevel += 1
                if self.timeIntervarl > 0.2 {
                    self.timeIntervarl -= 0.1
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: self.timeIntervarl, target: self, selector: #selector(GameScene.createEldolon), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    func setHighScore(_ cnt :Int, level: Int)->Int{
        var usrScoreDatas : [UserScoreData] = getHighScore()
        let userDefault = UserDefaults.standard
        var rank = 5
        
        for n in 0...4 {
            if usrScoreDatas[n].count < cnt {
                let formatter = DateFormatter()
                formatter.locale = Locale.current
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let now_date = formatter.string(from: Date())
                let new_data : UserScoreData = UserScoreData(count: cnt, level: level, playDate: now_date)
                usrScoreDatas.insert(new_data, at: n)
                rank = n
                break
            }
        }
        
        for n in 0...4 {
            userDefault.set(usrScoreDatas[n].count, forKey: "HighCount" + n.description)
            userDefault.set(usrScoreDatas[n].level, forKey: "HighLevel" + n.description)
            userDefault.set(usrScoreDatas[n].playDate, forKey: "HighDate" + n.description)
        }

        return rank
    }
    
    func getHighScore() -> Array<UserScoreData> {
        var highScores : [UserScoreData] = []
        let userDefault = UserDefaults.standard
        
        var count :Int, level:Int
        for n in 0...4 {
            count = userDefault.integer(forKey: "HighCount" + n.description)
            level  = userDefault.integer(forKey: "HighLevel" + n.description)
            if let dateString = userDefault.string(forKey: "HighDate" + n.description) {
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
            overLabel.fontColor = UIColor.blue
            overLabel.fontSize = 45
            overLabel.position = CGPoint(x: self.frame.midX, y: self.size.height - 40)
            overLabel.zPosition = 10
            overLabel.text = "Sa yo na ra"
            let scoreLabel  = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.fontColor = UIColor.white
            scoreLabel.fontSize = 35
            scoreLabel.position = CGPoint(x: self.frame.midX, y: self.size.height-80)
            scoreLabel.zPosition = 100
            scoreLabel.text = "Total \(self.getCnt) Lvl \(self.gameLevel)"
            
            newRank = setHighScore(Int(self.getCnt), level: Int(self.gameLevel))
            
            let highScores : [UserScoreData] = getHighScore()
            
            for n in 0...4 {
                let newScoreBack = SKSpriteNode(imageNamed: "ScoreBack")
                newScoreBack.size = CGSize(width: self.size.width*5/6.0, height: 50.0)
                newScoreBack.position = CGPoint(x: self.frame.midX, y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5)))
                newScoreBack.zPosition = 99
                
                let scoreHisLabel1 = SKLabelNode(fontNamed: "Chalkduster")
                scoreHisLabel1.color = SKColor.black
                scoreHisLabel1.position = CGPoint(x: self.frame.midX, y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5)))
                scoreHisLabel1.fontSize = 16
                scoreHisLabel1.text = "Rank:\(n+1) Total: " + highScores[n].count.description + " Level: " + highScores[n].level.description
                scoreHisLabel1.zPosition = 100
                
                let scoreHisLabel2 = SKLabelNode(fontNamed: "Chalkduster")
                scoreHisLabel2.color = SKColor.black
                scoreHisLabel2.position = CGPoint(x: self.frame.midX, y: self.size.height - 110.0  - (CGFloat(n)*(50 + 5 )) - 16)
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
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
            
            self.gameOverLabel = overLabel
            self.timer?.invalidate()
            self.timer = nil
            
            self.isPaused = true
            
            self.gameOverDone = true
        }
        
    }
    
    func reset(){
        if self.gameOverFlag == true {
            self.totalCnt = 0
            self.getCnt = 0
            self.timerCallCnt = 0
            self.gameLevel = 1
            self.timeIntervarl = 2.0
            self.timer = Timer.scheduledTimer(timeInterval: self.timeIntervarl, target: self, selector: #selector(GameScene.createKodama), userInfo: nil, repeats: true)

            
            self.judgeLevel()
            self.updateString()
            
            self.gameOverLabel?.removeFromParent()
            
            self.isPaused = false
            
            self.gameOverFlag = false
            self.gameOverDone = false
        }
    }
    
    func createImageScene(_ imageName: String)-> SKScene{
        let scene = SKScene(size: self.size)
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = scene.size
        sprite.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scene.addChild(sprite)
        
        let restartTouch = TouchButton(imageNamed: "RestartBack")
        restartTouch.size = CGSize(width:self.size.width*3/4.0, height:80)
        restartTouch.position = CGPoint(x: scene.size.width*0.5, y: restartTouch.size.height/2 + 20)
        restartTouch.isUserInteractionEnabled = true
    
        scene.addChild(restartTouch)
        return scene
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches){
            let location = touch.location(in: self)
            
            let nodes = self.nodes(at: location)
            for node in (nodes) {
                if let eidolon = node.userData?.object(forKey: "wrapped") as? EidolonAction {
                    self.getCnt += eidolon.getScore()

                    eidolon.onTapIn(self)
                    eidolon.remove()
                    
                    if eidolon.name.hasPrefix(Kodama.picname) || eidolon.name.hasPrefix(GejiGeji.picname){
                        if let nodeKodama = node.userData?.object(forKey: "wrapped") as? Kodama {
                            removeFromEnemyList(element: nodeKodama)
                        } else if let nodeGejiGeji = node.userData?.object(forKey: "wrapped") as? GejiGeji {
                            removeFromEnemyList(element: nodeGejiGeji)
                        }
                    }
                    
                    if node.userData?.object(forKey: "wrapped") is Ohotokesama {
                        for enemy in enemyList{
                            enemy.onTapIn(self)
                            self.getCnt += enemy.getScore()
                        }
                        enemyList.removeAll()
                    }
                
                }
            }
            
            if self.gameOverFlag == true {
                self.reset()
            }
        }
        
    }
        
        
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        self.judgeLevel()
        self.updateString()
    }
}

class TouchButton: SKSpriteNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        scene.size = CGSize(width: self.scene!.size.width, height: self.scene!.size.height)
        self.scene?.view?.presentScene(scene, transition: transition)

    }
}

class TouchScene: SKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        scene.size = self.size
        
        self.view?.presentScene(scene, transition: transition)
    }
}
