//
//  GameScene.swift
//  SceneKit
//
//  Created by Felipe Marques Ramos on 10/04/15.
//  Copyright (c) 2015 Felipe Marques Ramos. All rights reserved.
//

import SpriteKit


//mascaras para categoria de node - serve para tratar colisoes depois
let projectileCategory:UInt32 =  0x1 << 0;
let obstacleCategory:UInt32 =  0x1 << 1


//AS MATEMAGICA TUDO

//FUNCOES VETORIAIS BASICAS

func vetAdd(a:CGPoint, b:CGPoint) -> CGPoint{
    return CGPointMake(a.x + b.x, a.y + b.y)
}

func vetSub(a:CGPoint, b:CGPoint) ->CGPoint{
    return CGPointMake(a.x - b.x, a.y - b.y)
}

func vetMult(a:CGPoint, b:CGFloat) -> CGPoint{
    return CGPointMake(a.x * b, a.y * b)
}

func vetLength(a:CGPoint) -> CGFloat{
    return sqrt(a.x * a.x + a.y * a.y)
}

//vetor de norma 1
func vetNorma(a:CGPoint) -> CGPoint{
    var length = vetLength(a)
    return CGPointMake(a.x / length, a.y / length)
}

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    var lastSpawnTimeInterval:NSTimeInterval?
    
    //tempo desde o ultimo update; simula um game loop
    var lastUpdateTimeInterval:NSTimeInterval = 0.0
    
    
    //numero de inimigos na tela
    var obstaclesOnScreen:Int = 0
    
    //numero de inimigos destruidos
    var obstaclesDestroyed = 0
    
    
    //MARK: Actors
    var title:SKLabelNode!
    var score:SKLabelNode!
    var player:SKSpriteNode!
    var obstacle:SKSpriteNode!
    var projectile:SKSpriteNode!
    var reset:SKSpriteNode!
    
    //MARK: Control
    var yObstacle: CGFloat!
    var points: Int = 0
    
    
    
    //delegate para colisao
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody, secondBody:SKPhysicsBody
        
        //descobre qual corpo é qual
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //faz a magia acontecer
        if firstBody.categoryBitMask == projectileCategory && secondBody.categoryBitMask == obstacleCategory{
            if (firstBody.node != nil){
                self.projectileHit(firstBody.node as! SKSpriteNode, obstacle: secondBody.node as! SKSpriteNode)
            }
        }
    }
    

    
    
    
    //MARK: VC LifeCycle
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        

        self.physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
        
        //Find actors
        for child in self.children{
            if child.name == "title"{
                self.title = child as! SKLabelNode
            }
            else if child.name == "score"{
                self.score = child as! SKLabelNode
                //self.score.alpha = 0
            }
            else if child.name == "player"{
                self.player = child as! SKSpriteNode
//                self.player.alpha = 0
                //self.player.physicsBody?.restitution = 1.0
                //self.player.physicsBody?.mass=10
            }
//            else if child.name == "obstacle"{
//                self.obstacle = child as! SKSpriteNode
//                obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.size)
////                self.obstacle.alpha = 0
//                yObstacle = self.obstacle.position.y
//                obstacle.physicsBody?.restitution = 1.0
//                obstacle.physicsBody?.dynamic=true
//                obstacle.physicsBody?.categoryBitMask = obstacleCategory
//                obstacle.physicsBody?.contactTestBitMask = projectileCategory
//                
//            }
            else if child.name == "projectile"{
                self.projectile = child as! SKSpriteNode
            }
            else if child.name == "reset"{
                self.obstacle = child as! SKSpriteNode
            }
        }
        
//        self.physicsBody?.affectedByGravity=true
        
        //obstacle.physicsBody?.mass = 0.002
        
        
        for index in 1...5{
            self.createObstacle()
        }

        //player.physicsBody!.applyImpulse(CGVectorMake(100, 500))
        //player.physicsBody?.applyAngularImpulse(100)
        
        //Physics
        physicsWorld.gravity = CGVectorMake(0, 0)
        //physicsBody?.friction = 0
        //physicsBody?.restitution = 1
        
        
        
        
    }
    
    
    //cria BLOCOS INIMIGOS DO MAL
    func createObstacle(){
        let obstacle:SKSpriteNode = SKSpriteNode(imageNamed: "obstacle")
        
        let largura:Float = Float(self.frame.size.width)
        
        //voce nao vai acreditar o saco que foi converter CGFloat pra UInt32...
        let x:Float = Float(arc4random()) % largura
        
        let altura:Float = Float(0.2 * self.frame.size.height)
        let y:Float = (Float(arc4random()) % altura) + Float(0.6 * self.frame.size.height)
        
        obstacle.position = CGPointMake(CGFloat(x), CGFloat(y))
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = projectileCategory
        obstacle.physicsBody?.collisionBitMask = 0
        
        self.addChild(obstacle)
        obstaclesOnScreen++
        
    }

    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        self.didMoveToView(self.view!)
//        
////        for child in self.children{
////            if child .isKindOfClass(SKSpriteNode){
//////                child
////            }
////        }
//        
////        for touch in (touches as! Set<UITouch>) {
////            let location = touch.locationInNode(self)
////            
////            let sprite = SKSpriteNode(imageNamed:"Spaceship")
////            
////            sprite.xScale = 0.5
////            sprite.yScale = 0.5
////            sprite.position = location
////            
////            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
////            
////            sprite.runAction(SKAction.repeatActionForever(action))
////            
////            self.addChild(sprite)
////        }
//        
//    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 1 - Choose one of the touches to work with
        var touch:UITouch = touches.first as! UITouch
        var location:CGPoint = touch.locationInNode(self)
        
        // 2 - Set up initial location of projectile
        var projectile:SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
        projectile.position = self.player.position;
        
        // 3- Determine offset of location to projectile
        var offset:CGPoint = vetSub(location, projectile.position)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody!.dynamic = true
        projectile.physicsBody!.categoryBitMask = projectileCategory
        projectile.physicsBody!.contactTestBitMask = obstacleCategory
        projectile.physicsBody!.collisionBitMask = 0
        projectile.physicsBody!.usesPreciseCollisionDetection = true
        
        // 4 - Bail out if you are shooting down or backwards
        //if (offset.x <= 0) return;
        
        // 5 - OK to add now - we've double checked position
        self.addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        var direction:CGPoint = vetNorma(offset)
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        var shootAmount:CGPoint = vetMult(direction, 2000)
        
        // 8 - Add the shoot amount to the current position
        var realDest:CGPoint = vetAdd(shootAmount, projectile.position)
        
        // 9 - Create the actions
        let velocity = 480.0/1.0
        let realMoveDuration = self.size.width.native / velocity
        let actionMove:SKAction = SKAction.moveTo(realDest, duration: realMoveDuration)
        let actionMoveDone:SKAction = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
    //metodo para quando o projetil acerta o obstaculo
    func projectileHit(projectile:SKSpriteNode, obstacle:SKSpriteNode) {
        println("Hit")
        projectile.removeFromParent()
        obstacle.removeFromParent()
        obstaclesOnScreen--
        obstaclesDestroyed++
    }
   
    
    //update do game loop
    override func update(currentTime: CFTimeInterval) {
        var timeSinceLast = currentTime - self.lastUpdateTimeInterval
        self.lastUpdateTimeInterval = currentTime;
        if (timeSinceLast > 1) { // more than a second since last update
            timeSinceLast = 1.0 / 60.0;
            self.lastUpdateTimeInterval = currentTime;
        }
        
        //aqui vão os comandos a serem executados a cada ciclo de atualização
        //println("UPDATE")
        while(obstaclesOnScreen < 5){
            self.createObstacle()
        }
        self.score.text = String(format: "%d",obstaclesDestroyed)
    }
}
