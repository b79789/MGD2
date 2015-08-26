//
//  GameScene.m
//  CatchEm
//
//  Created by Brian Stacks on 8/5/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "GameOver2.h"

// add some properties to call for spriteNodes and sounds
@interface GameScene ()<SKPhysicsContactDelegate>
{
    NSArray *scoreTextures;
    SKSpriteNode *score;
    SKLabelNode *hudScore;
    SKView *spriteView;
    NSInteger scoreCount;
    NSInteger countDownTimer;
    SKLabelNode *countDown;
}
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
        [self createHUD];
        [self addChild: [self myPause]];
        _sound1 = [SKAction playSoundFileNamed:@"wet-catch.mp3" waitForCompletion:NO];
        _sound2 = [SKAction playSoundFileNamed:@"catch.mp3" waitForCompletion:NO];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SpriteAnimation"];
        SKTexture *firework1 = [atlas textureNamed:@"firework1.png"];
        SKTexture *firework2 = [atlas textureNamed:@"firework2.png"];
        SKTexture *firework3 = [atlas textureNamed:@"firework3.png"];
        SKTexture *firework4 = [atlas textureNamed:@"firework4.png"];
        //SKTexture *scoreNumber = [atlas textureNamed:@"score.png"];
        scoreTextures = @[firework1,firework2,firework3,firework4];
        hudScore.text=@"Score = 0";
        CGPoint location = CGPointMake (CGRectGetMidX(self.view.frame),CGRectGetMidY(self.view.frame));
        [self createTimerWithDuration:20 position:location andSize:24.0];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    self.scaleMode = SKSceneScaleModeAspectFit;
    spriteView = view;
    
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
    
    SKAction * actionMove = [SKAction moveToY:-10 duration:6];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [_myEgg runAction:[SKAction sequence:@[_sound1, actionMove, actionMoveDone]]];
    
    
}

-(void)createHUD{
    hudScore = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    hudScore.position= CGPointMake(CGRectGetMidX(self.frame), self.size.height-50);
    hudScore.fontColor= [SKColor blackColor];
    hudScore.name=@"theScore";
    hudScore.fontSize= 46;
    [self addChild:hudScore];

}

// method for detecting collisions
-(void)didBeginContact:(SKPhysicsContact *)contact
{
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
        [self keepScore:10];
        
        if(scoreCount==100){
            [self gameOver];
        }else if (countDownTimer == 0){
            [self gameOver2];
        }
        
    }else {
        
    }
    
}



-(void)keepScore:(NSInteger)points{
    scoreCount += points;
    SKLabelNode *scoreLabel =(SKLabelNode*)[self childNodeWithName:@"theScore"];
    scoreLabel.text =[NSString stringWithFormat:@"Score = %ld", (long)scoreCount];
}

-(void)makeScore{
    SKAction *myAction=[SKAction animateWithTextures:scoreTextures
                                      timePerFrame:0.1f
                                            resize:YES
                                           restore:NO];
    
    [score runAction:myAction completion:^{
        [score removeFromParent];
    }];
    
    return;

}

// method invoked when egg and basket collide
-(void)egg:(SKSpriteNode *)egg didCollideWithBasket:(SKSpriteNode *)basket{
    
    SKTexture *myTexture = scoreTextures[0];
    score = [SKSpriteNode spriteNodeWithTexture:myTexture];
    score.position = basket.position;
    [self addChild:score];
    [self makeScore];
    SKSpriteNode *child = (SKSpriteNode*)basket;
    
    [child removeFromParent];
    [self runAction:_sound2];
}

-(IBAction)paused{
    if(!spriteView.paused){
        spriteView.paused = YES;
    }else{
        spriteView.paused = NO;
    }
}

-(SKSpriteNode *) myPause{
    SKSpriteNode *myPauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"Pause.png"];
    myPauseButton.position = CGPointMake(self.frame.size.width-40, self.frame.size.height-40);
    myPauseButton.name = @"myPauseButton";
    return myPauseButton;
}


// method that handles touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"myPauseButton"]) {
        [self paused];
        NSLog(@"Hit Pause");
    }else{
        //nothing
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
     /* Called when a touch moves */
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat yPosition = CGRectGetMinY(self.frame)+20;
    _myBasket.position = CGPointMake(touchPoint.x , yPosition);
    
    
}

-(void)gameOver{
    SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition flipVerticalWithDuration:0.5];
    [self.view presentScene:gameOverScene transition:doors];
}

-(void)gameOver2{
    SKScene * gameOverScene = [[GameOver2 alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition flipVerticalWithDuration:0.5];
    [self.view presentScene:gameOverScene transition:doors];
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

- (void) createTimerWithDuration:(NSInteger)seconds position:(CGPoint)position andSize:(CGFloat)size {
    countDown = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedMedium"];
    countDown.position = CGPointMake(CGRectGetMinX(self.frame)+50, self.size.height-50);;
    countDown.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    countDown.fontColor =[SKColor blackColor];
    countDown.fontSize = 46;
    [self addChild: countDown];
    countDownTimer = seconds;
    SKAction *updateLabel = [SKAction runBlock:^{
        countDown.text = [NSString stringWithFormat:@"Time: %ld", countDownTimer];
        --countDownTimer;
    }];
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *updateLabelAndWait = [SKAction sequence:@[updateLabel, wait]];
    [self runAction:[SKAction repeatAction:updateLabelAndWait count:seconds] completion:^{
        countDown.text = @"Ran Out Of Time";
    }];
}


@end
