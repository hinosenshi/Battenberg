//
//  LevelOneLayer.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "LevelOneLayer.h"
#import "CCTouchDispatcher.h"
#import "LevelBuilder.h"
#import "OneSidedPlatformContactListener.h"
#import "Bear.h"
#import "Boy.h"
#import "Cake.h"
#import "Control.h"
#import "Platform.h"
#import "Laser.h"

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

bool debugDraw = false;

NSDate *startTime;

// LevelOneLayer implementation
@implementation LevelOneLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    
    Overlayer *overlay = [Overlayer node];
    [scene addChild:overlay z:1];
    
	
	// 'layer' is an autorelease object.
	LevelOneLayer *layer = [[LevelOneLayer alloc] initWithOverlay:overlay];
    
    [overlay initializeMenusWithControl:layer->control];
    
    [layer setPositionInPixels:ccp(0,100)];
    //layer.scaleY = 0.5;
	
	// add layer as a child to scene
	[scene addChild: layer z:0];
    
	
	// return the scene
	return scene;
}


// on "init" you need to initialize your instance
-(id) initWithOverlay: (Overlayer *) _overlay
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        //let's say world is 7 * swidth and 3 * sheight
        
//        for(int i = 0; i < 7 * SWIDTH; i++)
//        {
//            CCLayerColor* colorLayer1 = [CCLayerColor layerWithColor:ccc4(137, 172, 157, 255) width:512 height:3 * SHEIGHT];
//            CCLayerColor* colorLayer2 = [CCLayerColor layerWithColor:ccc4(167, 202, 187, 255) width:512 height:3 * SHEIGHT];
//            
//            colorLayer1.position = ccp(1024 * i, 0);
//            colorLayer2.position = ccp(1024 * i + 512, 0);
//        
//            [self addChild:colorLayer1 z:-2];
//            [self addChild:colorLayer2 z:-1];
//        }

        gravity = -9.8f * 84.0f * 1.25f;  // 9.8 m/s^2, and a meter is 84 pix, and I'm scaling it up by 25%
        friction = 0.55f;

        platforms = [[NSMutableArray alloc] init];
        items = [[NSMutableArray alloc] init];
        lasers = [[NSMutableArray alloc] init];
        mirrors = [[NSMutableArray alloc] init];

        bear = [[Bear alloc] initWithLayer:self location:ccp(150,150)];
        boy = [[Boy alloc] initWithLayer:self location:ccp(80,50)];
        
        startTime = [[NSDate date] retain];
        
        control = [[Control alloc] initWithLayer:self];

        
        [self buildLevel];
        
        [items addObject:bear];
        [items addObject:boy];
        
        float margin = 50.0f;
        worldBoundary = CGRectMake(-1 * margin,-1 * margin - 100,7 * SWIDTH + 2 * margin,3 * SHEIGHT + 2 * margin);
        following = [CCFollow actionWithTarget:bear->sprite
                                 worldBoundary:worldBoundary];
        [self runAction:following];
        
        //[self buildOverlay];
        
        
		overlay = _overlay;
        
        glClearColor(167 / 255.0f, 202 / 255.0f, 187 / 255.0f, 1);
		
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) buildOverlay
{
}

//-(void) buildLevel
//{
//    //floor
//    [platforms addObject:[[Platform alloc] initFloorWithLayer:self location:ccp(0,0) width:1024]];
//    
//    //ceiling
//    [platforms addObject:[[Platform alloc] initTwoSidedPlatformWithLayer:self location:ccp(0, 768) width:1024]];
//    
//    //left wall
//    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(0, 0) height:768 left:true]];
//    
//    //right wall
//    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(1024, 0) height:768 left:false]];
//    
//    //laser!
//    laser = [[Laser alloc] initLaserWithLayer:self location:ccp(56,512)];
//
//}

//
//-(void) buildLevel
//{
//    //floor
//    [platforms addObject:[[Platform alloc] initFloorWithLayer:self location:ccp(0,0) width:2048]];
//    
//    //ceiling
//    [platforms addObject:[[Platform alloc] initTwoSidedPlatformWithLayer:self location:ccp(0, 768) width:1024]];
//    [platforms addObject:[[Platform alloc] initTwoSidedPlatformWithLayer:self location:ccp(1024, 2304) width:1024]];
//    
//    //left wall
//    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(0, 0) height:768 left:true]];
//    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(1024, 768) height:1536 left:true]];
//    
//    //right wall
//    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(2048, 0) height:2304 left:false]];
//
//    //platforms
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(400, 200) width:400]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1000, 200) width:400]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1600, 200) width:200]];
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(700, 400) width:400]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1300, 400) width:400]];
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1000, 600) width:400]];
//    
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 400) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1800, 600) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 800) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1800, 1000) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 1200) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1800, 1400) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 1600) width:100]];
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1300, 1800) width:400]];
//    
//    //laser = [[Laser alloc] initLaserWithLayer:self location:ccp(56,512)];
//    
//}



-(void) buildLevel
{
    
    
 
    //build general outline of the level
    
    //floor
    [platforms addObject:[[Platform alloc] initFloorWithLayer:self location:ccp(0,0) width:4 * SWIDTH]];
    
    //ceiling
    [platforms addObject:[[Platform alloc] initTwoSidedPlatformWithLayer:self location:ccp(0, 3 * SHEIGHT) width:7 * SWIDTH]];
    
    //left wall
    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(0, 0) height:3 * SHEIGHT left:true]];

    
    
    //part A, with the help text and the simple jump,laser,cake
    [self buildPartA];
    
    
    
    
    
    
    
    //right wall
    //[platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(2048, 0) height:2304 left:false]];
    
    //platforms
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(400, 200) width:400]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1000, 200) width:400]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1600, 200) width:200]];
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(700, 400) width:400]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1300, 400) width:400]];
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1000, 600) width:400]];
//    
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 400) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1800, 600) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 800) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1800, 1000) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 1200) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1800, 1400) width:100]];
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1900, 1600) width:100]];
//    
//    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1300, 1800) width:400]];
    
    //laser = [[Laser alloc] initLaserWithLayer:self location:ccp(56,512)];
    
    //this should be done after all the lasers, platforms and mirrors have been set up.
    for(Laser *laser in lasers)
    {
        [laser raycast];
    }
}


-(void) buildPartA
{
    CCLabelTTF *label = NULL;
    CCSprite* sprite = NULL;

    // section 1 help text
    label = [CCLabelTTF labelWithString:@"One finger to move the bear." fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( 512, 384);
    
    label = [CCLabelTTF labelWithString:@"Double tap or drag." fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( 512, 384 - 32);
    
    label = [CCLabelTTF labelWithString:@"The boy does his own thing." fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( 512, 384 - 64);
    
    sprite = [CCSprite spriteWithFile: @"Art/1Finger.png"];
    sprite.position = ccp( 240, 300 );
    [self addChild:sprite];
    [self reorderChild:sprite z:-1.8];
    
    
    
    // section 2 jump help text
    label = [CCLabelTTF labelWithString:@"Two fingers to jump." fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( SWIDTH + 312, 384);
    
    sprite = [CCSprite spriteWithFile: @"Art/2Finger.png"];
    sprite.position = ccp( SWIDTH + 40, 300 );
    [self addChild:sprite];
    [self reorderChild:sprite z:-1.8];
    
    // section 2 platform and cake
    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(SWIDTH + 200, 200) width:400]];
    [items addObject:[[Cake alloc] initWithLayer:self location:ccp(SWIDTH + 300, 250)]];
    
    // section 2 cake help text
    label = [CCLabelTTF labelWithString:@"Use cake to stall the boy." fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( SWIDTH + 600, 300);
    
    
    
    // section 3 throw boy help text
    label = [CCLabelTTF labelWithString:@"When the boy is nearby, use" fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( 2 * SWIDTH + 400, 300);
    
    label = [CCLabelTTF labelWithString:@"three fingers to throw him." fontName:@"American Typewriter" fontSize:32];
    [self addChild:label z:0];
    [label setColor:ccc3(128,128,128)];
    label.position = ccp( 2 * SWIDTH + 400, 300 - 32);

    
    sprite = [CCSprite spriteWithFile: @"Art/3Finger.png"];
    sprite.position = ccp( 2 * SWIDTH + 28, 300 );
    [self addChild:sprite];
    [self reorderChild:sprite z:-1.8];
    
    // section 3 wall and platform
    [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(2 * SWIDTH + 600, 0) height:200 left:true]];
    [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(2 * SWIDTH + 200, 200) width:400]];

    // section 3 laser and mirror
    [lasers addObject: [[Laser alloc] initLaserWithLayer:self location:ccp(2 * SWIDTH + 580,150) rotation: 180 Platforms:platforms Mirrors:mirrors]];
    //[lasers addObject: [[Laser alloc] initLaserWithLayer:self location:ccp(780,350) rotation: 180 Platforms:platforms Mirrors:mirrors]];
    [mirrors addObject: [[Mirror alloc] initMirrorWithLayer:self location:ccp(2 * SWIDTH + 232, 150) rotation: 270]];
    //[mirrors addObject: [[Mirror alloc] initMirrorWithLayer:self location:ccp(100, 350) rotation: 270]];
    //[mirrors addObject: [[Mirror alloc] initMirrorWithLayer:self location:ccp(100, 250) rotation: 180]];
    //[mirrors addObject: [[Mirror alloc] initMirrorWithLayer:self location:ccp(600, 250) rotation: 270]];
    //[mirrors addObject: [[Mirror alloc] initMirrorWithLayer:self location:ccp(600, 550) rotation: 270]];

}

-(void) buildPartB
{
    
}

-(void) buildPartC
{
    
}

-(void) buildPartD
{
    
}



-(void) draw
{        
    // adjust to bounding box states
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

    
    
    glColor4f(0.5f,0.5f,0.6f,1.0f);
    glEnable(GL_LINE_SMOOTH);
    //ccDrawLine( ccp(1024, 0), ccp(1024, 1536) );
    //ccDrawLine( ccp(2048, 0), ccp(2048, 1536) );
    //ccDrawLine( ccp(1024, 0), ccp(1024, 768) );
	
    for(WorldObject *item in items)
    {
        [item drawBoundingBox];
    }
    
    //it's summer. it's summer! it's summer! summer project time! go go go go go!
    for(Platform *platform in platforms)
    {
        [platform drawBoundingBox];
    }
    
    [control drawControl];
    
    
//    const GLfloat squareVertices[] = {
//        0, 0,
//        512, 0,
//        0,  768,
//        512,  768};
//    glColor4f(167 / 255.0f, 202 / 255.0f, 187 / 255.0f, 1);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glDisableClientState(GL_VERTEX_ARRAY);

    
    // restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

-(void) tick: (ccTime) dt
{
    [self update: dt];
    
    [self animate];
    
    //[laser rotateBeam];
}

-(void) update: (ccTime) dt
{
    [control updateControl];

    [self doCollisions: dt];
    [self updatePositions: dt];
    [self updateGravity: dt];
    [self pushObjects: dt];
    
    NSTimeInterval timeInterval = -1 * [startTime timeIntervalSinceNow];
    
    if(boy->falling)
    {
        [self runAction:[CCFollow actionWithTarget:boy->sprite
                                     worldBoundary:worldBoundary]];
    }
    else 
    {
        [self runAction:[CCFollow actionWithTarget:bear->sprite
                                     worldBoundary:worldBoundary]];
    }
}

-(void) updateGravity: (ccTime) dt
{    
    for(WorldObject *item in items)
    {
        if(item->falling)
        {
            item->vy += gravity * dt;
        }
    }
}

-(void) updatePositions: (ccTime) dt
{
    //updates (includes items, bear, and boy)
    for(WorldObject *item in items)
    {
        item->x += item->vx * dt;
        item->y += item->vy * dt;
        
        if(item->platform != NULL && item->dying == false) 
        {
            item->vx *= friction;   
        }
    }
    
    // bear specific updates
    if(bear->y < -1000)
    {
        bear->x = 80;
        bear->y = 150;
        bear->vx = 0;
        bear->vy = 0;
        bear->dying = false;
        bear->sprite.rotation = 0;
    }

    // boy specific updates
    if(boy->y < -1000)
    {
        boy->x = 150;
        boy->y = 150;
        boy->vx = 0;
        boy->vy = 0;
        boy->dying = false;
        boy->sprite.rotation = 0;
    }
}

-(void) doCollisions:(ccTime)dt
{
    for(WorldObject *item in items)
    {
        if(!item->dying)
        {
            for(Laser *laser in lasers)
            {
                if([laser collisionWith:item time:dt])
                {
                    //kill the item
                    item->dying = true;
                    item->falling = true;
                    item->vy = -126.0f;
                }   
            }           
        }
    }
    
    for(WorldObject *item in items)
    {
        if(item->platform && item->platform->type != S_SLANTED_PLATFORM)
        {
            item->platform = NULL;
        }
    }
    
    for(Platform *platform in platforms)
    {
        for(WorldObject *item in items)
        {
            if(!item->dying)
            {
                [platform collisionWith:item time:dt];
            }
        }
    }

    for(WorldObject *item in items)
    {
        if(item->platform == NULL)
        {
            item->falling = true;
        }
    }
}

-(void) pushObjects:(ccTime)dt
{
    bear->stallingBoy = false;
    
    for(WorldObject *item in items)
    {
        for(WorldObject *item2 in items)
        {
            bool result = [item collideWith:item2];
            
            if(result)
            {
                if((item->id == ID_BEAR && item2->id == ID_BOY)
                   
                   || (item->id == ID_BOY && item2->id == ID_BEAR))
                {
                    if(bear->direction == 0 && bear->lastFacing == 1 && boy->x > bear->x && !bear->sighing)
                    {
                        bear->stallingBoy = true;
                    }
                    
                    if(bear->direction == 0 && bear->lastFacing == -1 && boy->x < bear->x && !bear->sighing)
                    {
                        bear->stallingBoy = true;
                    }
                }
            }
        }
    }
}

-(void) animate
{
    for(WorldObject *item in items)
    {
        [item animate];
    }
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end


@implementation Overlayer

-(id) init
{
    if ((self = [super init]))
    {
    }
    return self;
}

-(void) initializeMenusWithControl:(Control *)_control
{
    control = _control;
    control->overlay = self;
    
    CCSprite* overlaySprite = [CCSprite spriteWithFile: @"Art/UI_bottom_bar.png"];
    overlaySprite.anchorPoint = ccp(0,0);
    overlaySprite.position = ccp( 0 , 0 );
    [self addChild:overlaySprite];
    [self reorderChild:overlaySprite z:1.2];
    
    controlMenu = [CCMenu menuWithItems:nil];
    
    cakeMenuItem = [CCMenuItemImage itemFromNormalImage:@"Art/UI_cake_button.png"
                                                              selectedImage: @"Art/UI_cake_button_DOWN.png"
                                                                     target:control
                                                                   selector:@selector(makeCake)];
    
    cakeMenuItem.anchorPoint = ccp(0,0);
    cakeMenuItem.position = ccp( 13, 13 );
    [controlMenu addChild:cakeMenuItem];
    
    
    computerMenuItem = [CCMenuItemImage itemFromNormalImage:@"Art/UI_computer_button.png"
                                                           selectedImage: @"Art/UI_computer_button_DOWN.png"
                                                                  target:control
                                                                selector:@selector(throwBoy)];
    
    computerMenuItem.anchorPoint = ccp(0,0);
    computerMenuItem.position = ccp( 113, 13 );
    computerMenuItem.visible = NO;
    [controlMenu addChild:computerMenuItem];
    
    
    controlMenu.position = ccp( 0, 0 );
    [self addChild:controlMenu];
    [self reorderChild:controlMenu z:1.3];
}

-(void) testCake
{
    CCLOG(@"CAKE TESTED.");
}

-(void) testComputer
{
    CCLOG(@"BRRRP. FIZZ.");
}

-(void) showThrowingButton
{
    computerMenuItem.visible = YES;
}

-(void) hideThrowingButton
{
    computerMenuItem.visible = NO;
}

@end
