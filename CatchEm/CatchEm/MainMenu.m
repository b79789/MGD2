//
//  MainMenu.m
//  CatchEm
//
//  Created by Brian Stacks on 8/26/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

@implementation MainMenu

-(id)initWithSize:(CGSize)size{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:@"MainMenu.png"];
        menu.size =CGSizeMake(screenWidth, screenHeight);
        menu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        menu.name = @"MainMenu";
        [self addChild:menu];
        
        SKSpriteNode *start = [SKSpriteNode spriteNodeWithImageNamed:@"startButton.png"];
        start.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)- 225);
        start.name = @"Start";
        [self addChild:start];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if next button touched, start transition to next scene
    if ([node.name isEqualToString:@"Start"]) {
        SKScene *myScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
        [self.view presentScene:myScene transition:transition];
    }
}
@end
