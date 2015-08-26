//
//  GameOverScene.m
//  CatchEm
//
//  Created by Brian Stacks on 8/18/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "GameOverScene.h"
#import "MainMenu.h"

@interface GameOverScene()
@property BOOL contentCreated;
@end

@implementation GameOverScene
{
    SKSpriteNode * myButton;
}
// create content when view is initialized
- (void)didMoveToView: (SKView *) view
{
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self createSceneContents];
        }
    return self;
}

// create the content
- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    endGameLabel.text =@"You Win!! Game Over";
    endGameLabel.fontSize = 42;
    endGameLabel.fontColor=[SKColor redColor];
    endGameLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+150);
    NSString *string1=@"Credits For Development";
    NSString *string2=@"Brian Stacks";
    NSString *string3=@"Credits For Images";
    NSString *string4=@"OpenGameArt.org ";

    SKLabelNode *endGameLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    endGameLabel2.text =string1;
    endGameLabel2.fontSize = 42;
    endGameLabel2.fontColor=[SKColor redColor];
    endGameLabel2.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+75);
    SKLabelNode *endGameLabel3 = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    endGameLabel3.text =string2;
    endGameLabel3.fontSize = 42;
    endGameLabel3.fontColor=[SKColor redColor];
    endGameLabel3.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    SKLabelNode *endGameLabel4 = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    endGameLabel4.text =string3;
    endGameLabel4.fontSize = 42;
    endGameLabel4.fontColor=[SKColor redColor];
    endGameLabel4.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-75);
    SKLabelNode *endGameLabel5 = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    endGameLabel5.text =string4;
    endGameLabel5.fontSize = 42;
    endGameLabel5.fontColor=[SKColor redColor];
    endGameLabel5.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-150);
    
    myButton = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton.png"];
    myButton.name=@"myButton";
    myButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-225);
    
    
    [self addChild:endGameLabel];
    [self addChild:endGameLabel2];
    [self addChild:endGameLabel3];
    [self addChild:endGameLabel4];
    [self addChild:endGameLabel5];
    [self addChild:myButton];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"myButton"]) {
        SKScene *myScene = [[MainMenu alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
        [self.view presentScene:myScene transition:transition];
    }else{
        //nothing
    }
}


@end
