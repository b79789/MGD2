//
//  GameScene.m
//  CatchEm
//
//  Created by Brian Stacks on 8/5/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "GameScene.h"


@interface GameScene ()
@property (nonatomic) SKSpriteNode * myBasket;
@property (nonatomic) SKSpriteNode * myBirds;
@property (nonatomic) SKSpriteNode * myBackground;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self addInitialSprites];
    
    
}

-(void)addInitialSprites{
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudyBG.jpg"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.physicsBody.dynamic=NO;
    [self addChild:background];
    SKSpriteNode*myBasket = [SKSpriteNode spriteNodeWithImageNamed:@"stacks-basket.png"];
    myBasket.name=@"myBasket";
    myBasket.size= CGSizeMake(200, 200);
    myBasket.position = CGPointMake(CGRectGetMidX(self.frame), 100);
    myBasket.physicsBody.dynamic=NO;
    [self addChild:myBasket];
    SKSpriteNode*myBirdy = [SKSpriteNode spriteNodeWithImageNamed:@"birdy_green.png"];
    myBirdy.name=@"myBirdy";
    myBirdy.position = CGPointMake(CGRectGetMidX(self.frame), 256);
    [self addChild:myBirdy];
    SKSpriteNode*myScoreNum = [SKSpriteNode spriteNodeWithImageNamed:@"scoreNumber.png"];
    myScoreNum.name=@"myScoreNum";
    myScoreNum.size=CGSizeMake(60, 60);
    myScoreNum.position = CGPointMake(CGRectGetMidX(self.frame), 500);
    [self addChild:myScoreNum];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node.name isEqualToString:@"myBasket"]) {
            [self runAction:[SKAction playSoundFileNamed:@"catch.mp3" waitForCompletion:NO]];
        }else if ([node.name isEqualToString:@"myBirdy"]){
            [self runAction:[SKAction playSoundFileNamed:@"birds_cardinal.mp3" waitForCompletion:NO]];
        }else if ([node.name isEqualToString:@"myScoreNum"]){
            [self runAction:[SKAction playSoundFileNamed:@"hit.mp3" waitForCompletion:NO]];
        }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
