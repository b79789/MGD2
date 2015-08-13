//
//  GameScene.m
//  CatchEm
//
//  Created by Brian Stacks on 8/5/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "GameScene.h"

// add some properties to call for spriteNodes and sounds
@interface GameScene ()<SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * myBasket;
@property (nonatomic) SKSpriteNode * myEgg;
@property (nonatomic) SKSpriteNode * myScoreNum;
@property (nonatomic) NSTimeInterval spawnTimeInterval;
@property (nonatomic) NSTimeInterval updateTimeInterval;
@property (strong, nonatomic) SKAction * sound1;
@property (strong, nonatomic) SKAction * sound2;
@end
// create categories for collisions
static const uint32_t categoryOne =  0x1 << 0;
static const uint32_t categoryTwo =  0x1 << 1;
// random number helpers
static inline CGFloat randomFloat()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat randomBetween(CGFloat low, CGFloat high)
{
    return randomFloat() * (high - low) + low;
}

@implementation GameScene

//initial scene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self addInitialSprite];
        [self createBasketNode];
        _sound1 = [SKAction playSoundFileNamed:@"wet-catch.mp3" waitForCompletion:NO];
        _sound2 = [SKAction playSoundFileNamed:@"catch.mp3" waitForCompletion:NO];
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
    CGFloat yPosition = CGRectGetMinY(self.frame)+20;
    _myBasket.position = CGPointMake(CGRectGetMidX(self.frame), yPosition);
    _myBasket.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_myBasket.size];
    _myBasket.physicsBody.dynamic = YES;
    _myBasket.physicsBody.categoryBitMask = categoryOne;
    _myBasket.physicsBody.contactTestBitMask = categoryTwo;
    _myBasket.physicsBody.collisionBitMask = 0;
    [self addChild:_myBasket];
}



// creates score visual for scene
/*
-(void)createScoreNode{
    _myScoreNum = [SKSpriteNode spriteNodeWithImageNamed:@"scoreNumber.png"];
    _myScoreNum.name=@"myScoreNum";
    _myScoreNum.size=CGSizeMake(60, 60);
    _myScoreNum.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+150);
    [self addChild:_myScoreNum];
}
*/
-(void)makeEggsFall{
    _myEgg = [SKSpriteNode spriteNodeWithImageNamed:@"egg.png"];
    _myEgg.name=@"egg";
    _myEgg.position = CGPointMake(randomBetween(50, self.size.width),self.size.height-50);
    _myEgg.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_myEgg.size];
    _myEgg.physicsBody.dynamic = YES;
    _myEgg.physicsBody.categoryBitMask = categoryTwo;
    _myEgg.physicsBody.contactTestBitMask = categoryOne;
    _myEgg.physicsBody.collisionBitMask = 0;

    [self addChild:_myEgg];
    

    SKAction * actionMove = [SKAction moveToY:-50 duration:6];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [_myEgg runAction:[SKAction sequence:@[_sound1, actionMove, actionMoveDone]]];
    
    
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
        [self egg:(SKSpriteNode *)firstBody.node didCollideWithBasket:(SKSpriteNode *)secondBody.node];
    }else{
        // do nothing
    }

    
}


// method invoked when egg and basket collide
-(void)egg:(SKSpriteNode *)egg didCollideWithBasket:(SKSpriteNode *)basket{
    
    SKSpriteNode *child = (SKSpriteNode*)basket;
    
    [child removeFromParent];
    [self runAction:_sound2];
    NSLog(@"collided");
}

// method that handles touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
     /* Called when a touch moves */
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat yPosition = CGRectGetMinY(self.frame)+20;
    _myBasket.position = CGPointMake(touchPoint.x , yPosition);
    
    
}

// method for last update
- (void)timeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.spawnTimeInterval += timeSinceLast;
    if (self.spawnTimeInterval > 1) {
        self.spawnTimeInterval = 0;
        [self makeEggsFall];
    }
}

// standard update method
-(void)update:(CFTimeInterval)currentTime {

    CFTimeInterval timeSinceLast = currentTime - self.updateTimeInterval;
    self.updateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 30.0;
        self.updateTimeInterval = currentTime;
    }
    
    [self timeSinceLastUpdate:timeSinceLast];

}

@end
