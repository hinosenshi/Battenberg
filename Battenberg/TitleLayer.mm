//
//  TitleLayer.m
//  Battenberg
//
//  Created by Matthew Carlin on 4/6/12.
//  Copyright 2012 Expression Games. All rights reserved.
//

#import "TitleLayer.h"
#import "LevelOneLayer.h"

CCSprite *titleScreenSprite;

// TitleLayer implementation
@implementation TitleLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleLayer *layer = [TitleLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

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
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
        CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
                
        // titleScreenSprite
        titleScreenSprite = [CCSprite spriteWithFile: @"Art/Title.png"];
        titleScreenSprite.position = ccp( 512, 384 );
        [self addChild:titleScreenSprite];
        [self reorderChild:titleScreenSprite z:0];
        
        CCMenu * titleMenu = [CCMenu menuWithItems:nil];
        
        CCMenuItemImage *newGameMenuItem = [CCMenuItemImage itemFromNormalImage:@"Art/newGame.png"
            selectedImage: @"Art/newGame_selected.png"
            target:self
            selector:@selector(startNewGame)];
        
        [titleMenu addChild:newGameMenuItem];
        
        titleMenu.position = ccp( 372, 194 );
        [self addChild:titleMenu];
        [self reorderChild:titleMenu z:5];
        
		
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) startNewGame
{
    CCLOG(@"Starting a new game.");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[LevelOneLayer scene]]];
}

-(void) draw
{
    
}

-(void) tick: (ccTime) dt
{
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        //if(location.y > 700)
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
//	for( UITouch *touch in touches ) {
//		CGPoint location = [touch locationInView: [touch view]];
//	}
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
