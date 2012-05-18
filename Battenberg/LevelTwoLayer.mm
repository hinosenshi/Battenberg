//
//  LevelTwoLayer.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "LevelTwoLayer.h"
#import "CCTouchDispatcher.h"
#import "OneSidedPlatformContactListener.h"
#import "Globals.h"

// LevelTwoLayer implementation
@implementation LevelTwoLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelTwoLayer *layer = [LevelTwoLayer node];
	
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
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(167, 202, 187, 255) width:3072 height:1536];
        [self addChild:colorLayer z:-1];
		
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) buildLevel
{
    
}

-(void) draw
{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) tick: (ccTime) dt
{

}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	//delete world;
	//world = NULL;
	
	//delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
