//
//  GameLayer.m
//  Battenberg
//
//  Created by Matthew Carlin on 4/6/12.
//  Copyright 2012 Expression Games. All rights reserved.
//

#import "GameLayer.h"
#import "Bear.h"
#import "Boy.h"
#import "Platform.h"
#import "Control.h"

// GameLayer implementation
@implementation GameLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		screenSize = [CCDirector sharedDirector].winSize;
		
        CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return [control ccTouchBegan:touch withEvent:event];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [control ccTouchMoved:touch withEvent:event];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [control ccTouchEnded:touch withEvent:event];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
