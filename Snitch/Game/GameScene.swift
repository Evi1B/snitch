//
//  GameScene.swift
//  test
//
//  Created by evilb on 02.10.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var currentHeight: CGFloat = 0.0
    var currentWidth: CGFloat = 0.0
    var settingsBtn = SKSpriteNode(imageNamed: "settingsBtn")
    var bgTint = SKSpriteNode(imageNamed: "bgTint")
    var bg = SKSpriteNode(imageNamed: "bgImage")
    var snitch = SKSpriteNode(imageNamed: "snitchBall")
    var startButton = SKSpriteNode(imageNamed: "pressStart")
    var velocity = CGPoint.zero
    let playableRect: CGRect
    
    lazy var countdownLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "ARCADECLASSIC")
        label.fontSize = 65
        label.zPosition = 2
        label.position = CGPoint(x: size.width / 2, y: 2100)
        label.text = "\(timeString(time: TimeInterval(counterStartValue)))"
        
        return label
    }()
    
    var counter = 0
    var counterTimer = Timer()
    var counterStartValue = 0
    
    var score = 0
    
    //    var timerLabel = SKLabelNode(fontNamed: "ArialMT")
    
    override init(size: CGSize) {
        print("Current Height \(UIScreen.main.sizeType.rawValue)")
//        currentHeigh = UIScreen.main.sizeType.rawValue
        var maxAspectRatio: CGFloat?
        switch UIScreen.main.sizeType {
        case .iPhone4:
            maxAspectRatio = 2.0 / 2.0
        case .iPhone5:
            maxAspectRatio = 9.0 / 15.0
        case .iPhone6to8:
            maxAspectRatio = 9.0 / 15.0
        case .iPhone6to8Plus:
            maxAspectRatio = 9.0 / 15.0
        case .iPhoneXRor11:
            maxAspectRatio = 9.0 / 18
        case .iPhoneXor11Pro:
            maxAspectRatio = 9.0 / 18
        case .iPhoneXSMaxOr11ProMax:
            maxAspectRatio = 9.0 / 18
        case .iPhone12and13ProOr12and13:
            maxAspectRatio = 9.0 / 18
        case .iPhone12Mini:
            maxAspectRatio = 9.0 / 17.5
        case .iPhone12and13ProMAX:
            maxAspectRatio = 9.0 / 18
        default:
            print("error")
        }
        
        let playableHeight = size.width / maxAspectRatio!
        let playableMargin = (size.height-playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        currentHeight = playableRect.maxY
        currentWidth = playableRect.maxX
        super.init(size: size)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        settingsBtn.position = CGPoint(x: currentWidth - 100, y: currentHeight - 100)
        settingsBtn.zPosition = 2
        startButton.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        startButton.zPosition = 20
        startButton.name = "startGame"
        let upMove = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2 + 30), duration: 0.5)
        let downMove = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2 - 10), duration: 0.8)
        startButton.run(SKAction.repeatForever(SKAction.sequence([upMove, downMove])))
        
        bgTint.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bgTint.zPosition = 1
        
        bg.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        bg.zPosition = -1
        self.addChild(settingsBtn)
        self.addChild(bgTint)
        self.addChild(bg)
        self.addChild(startButton)
        debugDrawPlayableArea()
        updateUX()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchesNode = self.nodes(at: location)
            for node in touchesNode {
                if node.name == "circle" {
                    score += 1
                    randomCirclePosition()
                    gameOver()
                    print(score)
                }
                
                if node.name == "startGame" {
                    settingsBtn.removeFromParent()
                    self.addChild(countdownLabel)
                    startButton.removeFromParent()
                    bgTint.removeFromParent()
                    startCounter()
                    snitch.setScale(0.5)
                    snitch.position = randomCirclePosition()
                    snitch.name = "circle"
                    self.addChild(snitch)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        boundsCheckCircle()
    }
    
    func startCounter() {
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementCounter), userInfo: nil, repeats: true)
    }
    
    @objc func incrementCounter() {
        counter += 1
        countdownLabel.text = "\(timeString(time: TimeInterval(counter)))"
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func gameOver() {
        if score == 10 {
            if counter <= 7 {
                appDelegate.isWin = true
                NotificationCenter.default.post(name: kWinNotification, object: nil)
                print("You WIN!!!🥳")
            } else {
                appDelegate.isWin = false
                NotificationCenter.default.post(name: kWinNotification, object: nil)
                print("You LOSE!!!📛")
            }
        }
    }
    
    func randomCirclePosition() -> CGPoint {
        snitch.position = CGPoint(
            x: CGFloat.random(
                min: playableRect.minX,
                max: playableRect.maxX),
            y: CGFloat.random(
                min: playableRect.minY,
                max: playableRect.maxY))
        return snitch.position
    }
    
    func boundsCheckCircle() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        if snitch.position.x <= bottomLeft.x {
            snitch.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if snitch.position.x >= topRight.x {
            snitch.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if snitch.position.y <= bottomLeft.y {
            snitch.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if snitch.position.y >= topRight.y {
            snitch.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func updateUX() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8/SE 2nd gen")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X or iPhone 11 Pro")
            case 2688:
                print("iPhone XS MAX or iPhone 11 Pro MAX")
            case 1792:
                print("iPhone XR or iPhone 11")
            case 2532:
                print("iPhone 12/13 Pro or 12/13")
            case 2778:
                print("iPhone 12/13 Pro MAX")
            default:
                print("unknown")
            }
            
        }
    }
}
        extension UIScreen {
            enum SizeType: CGFloat {
                case Unknown = 0.0
                case iPhone4 = 960.0
                case iPhone5 = 1136.0
                case iPhone6to8 = 1334.0
                case iPhone6to8Plus = 2208.0
//                case iPhone6to8Plus = 1920.0
                case iPhoneXor11Pro = 2436.0
                case iPhoneXSMaxOr11ProMax = 2688.0
                case iPhoneXRor11 = 1792.0
                case iPhone12and13ProOr12and13 = 2532.0
                case iPhone12and13ProMAX = 2778.0
                case iPhone12Mini = 2340.0
            }
            
            var sizeType: SizeType {
                let height = nativeBounds.height
                guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
                return sizeType
            }
            
        }
