//
//  GameScene.swift
//  SceneKit
//
//  Created by Felipe Marques Ramos on 10/04/15.
//  Copyright (c) 2015 Felipe Marques Ramos. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    
    //MARK: Actors
    var title:SKLabelNode!
    var score:SKLabelNode!
    var player:SKSpriteNode!
    var obstacle:SKSpriteNode!
    var reset:SKSpriteNode!
    
    //MARK: Control
    var yObstacle: CGFloat!
    var points: Int = 0
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        contact.bodyA.applyImpulse(CGVectorMake(0, 0))
        println("skndsini")
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
                self.score.alpha = 0
            }
            else if child.name == "player"{
                self.player = child as! SKSpriteNode
//                self.player.alpha = 0
                self.player.physicsBody?.restitution = 1.0
                //self.player.physicsBody?.mass=10
            }
            else if child.name == "obstacle"{
                self.obstacle = child as! SKSpriteNode
//                self.obstacle.alpha = 0
                yObstacle = self.obstacle.position.y
                obstacle.physicsBody?.restitution = 1.0
            }
            else if child.name == "reset"{
                self.obstacle = child as! SKSpriteNode
            }
        }
        
//        self.physicsBody?.affectedByGravity=true
        
        obstacle.physicsBody?.mass = 0.002
        
        
        

        player.physicsBody!.applyImpulse(CGVectorMake(100, 500))
        player.physicsBody?.applyAngularImpulse(100)
        
        //Physics
//        physicsWorld.gravity = CGVectorMake(0, )
        physicsBody?.friction = 0
        physicsBody?.restitution = 1
        
        
        
        
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        self.didMoveToView(self.view!)
        
//        for child in self.children{
//            if child .isKindOfClass(SKSpriteNode){
////                child
//            }
//        }
        
//        for touch in (touches as! Set<UITouch>) {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
