//
//  Splash.m
//  CatchEm
//
//  Created by Brian Stacks on 8/26/15.
//  Copyright (c) 2015 Brian Stacks. All rights reserved.
//

#import "Splash.h"
#import "MainMenu.h"

@implementation Splash


-(id)initWithSize:(CGSize)size{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blueColor];
        
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"catchemLogo.png"];
        logo.size =CGSizeMake(screenWidth, screenHeight);
        logo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        logo.name = @"nextButton";
        [self addChild:logo];
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(goTo:)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    return self;
}


-(void)goTo:(NSTimer *)timer{
    SKScene *myScene = [[MainMenu alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
    [self.view presentScene:myScene transition:transition];
}
@end
