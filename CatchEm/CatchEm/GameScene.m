//
//  GameScene.m
//  CatchEm
//
//  Created by Brian Stacks on 8/5/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "GameScene.h"

// add some properties to call for spriteNodes
@interface GameScene ()<SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * myBasket;
@property (nonatomic) SKSpriteNode * myEgg;
@property (nonatomic) SKSpriteNode * myScoreNum;
@end
// create categories for collisions
static const uint32_t categoryOne =  0x1 << 0;
static const uint32_t categoryTwo =  0x1 << 1;

@implementation GameScene


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self addInitialSprite];
        [self createBasketNode];
        [self createBirdNode];
        [self createScoreNode];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
}

//creates the initial background for scene and adds to scene
-(void)addInitialSprite{
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.physicsBody.dynamic=NO;
    [self addChild:background];
}

// creates basket for scene
-(void)createBasketNode{
    _myBasket = [SKSpriteNode spriteNodeWithImageNamed:@"stacks-basket.png"];
    _myBasket.name=@"myBasket";
    //_myBasket.size= CGSizeMake(200, 100);
    _myBasket.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+50);
    _myBasket.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_myBasket.size];
    _myBasket.physicsBody.dynamic = YES;
    _myBasket.physicsBody.categoryBitMask = categoryOne;
    _myBasket.physicsBody.contactTestBitMask = categoryTwo;
    _myBasket.physicsBody.collisionBitMask = 0;
    [self addChild:_myBasket];
}

// creates bird for scene
-(void)createBirdNode{
    _myEgg = [SKSpriteNode spriteNodeWithImageNamed:@"egg.png"];
    _myEgg.name=@"egg";
    _myEgg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _myEgg.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_myEgg.size];
    _myEgg.physicsBody.dynamic = YES;
    _myEgg.physicsBody.categoryBitMask = categoryTwo;
    _myEgg.physicsBody.contactTestBitMask = categoryOne;
    _myEgg.physicsBody.collisionBitMask = 0;
    [self addChild:_myEgg];
}

// creates score visual for scene
-(void)createScoreNode{
    _myScoreNum = [SKSpriteNode spriteNodeWithImageNamed:@"scoreNumber.png"];
    _myScoreNum.name=@"myScoreNum";
    _myScoreNum.size=CGSizeMake(60, 60);
    _myScoreNum.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+150);
    [self addChild:_myScoreNum];
}

// method for detecting collisions
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact detected");
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & categoryOne) != 0 &&
        (secondBody.categoryBitMask & categoryTwo) != 0)
    {
        [self birdy:(SKSpriteNode *)firstBody.node didCollideWithBasket:(SKSpriteNode *)secondBody.node];
    }else{
        
    }

    
}

// method invoked when bird and basket collide
-(void)birdy:(SKSpriteNode *)birdy didCollideWithBasket:(SKSpriteNode *)basket{
    [_myEgg removeFromParent];
    NSLog(@"collided");
}

// method that handles touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
    
    //add actions for when a node is touched
        if ([node.name isEqualToString:@"myBasket"]) {
            [self runAction:[SKAction playSoundFileNamed:@"catch.mp3" waitForCompletion:NO]];
        }else if ([node.name isEqualToString:@"egg"]){
            [self runAction:[SKAction playSoundFileNamed:@"wet-catch.mp3" waitForCompletion:NO]];
            SKAction *fallDown = [SKAction moveByX:0 y:-1000 duration: 2];
            [_myEgg runAction:fallDown];
        }else if ([node.name isEqualToString:@"myScoreNum"]){
            [self runAction:[SKAction playSoundFileNamed:@"hit.mp3" waitForCompletion:NO]];
        }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
