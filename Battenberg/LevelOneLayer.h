//
//  LevelOneLayer.h
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "CCTouchDispatcher.h"
#import "GameLayer.h"
#import "Laser.h"


@interface Overlayer: CCLayer
{
@public
    Control *control;
    
    CCMenu *controlMenu;
    CCMenuItemImage *cakeMenuItem;
    CCMenuItemImage *computerMenuItem;
}

-(id) init;
-(void) initializeMenusWithControl: (Control *) _control;
-(void) testCake;
-(void) testComputer;
-(void) showThrowingButton;
-(void) hideThrowingButton;

@end


// interface
@interface LevelOneLayer : GameLayer
{
@public
    CCSprite *backgroundSprite;
    
    float gravity;
    float friction;
    
    NSMutableArray *platforms;
    
    NSMutableArray *items;
    
    NSMutableArray *mirrors;
    
    NSMutableArray *lasers;
    
    Overlayer *overlay;
}

// returns a CCScene that contains the LevelOneLayer as the only child
+(CCScene *) scene;
-(void) update: (ccTime) dt;
-(void) updateGravity: (ccTime) dt;
-(void) updatePositions: (ccTime) dt;
-(void) doCollisions: (ccTime) dt;
-(void) pushObjects: (ccTime) dt;
-(void) animate;

-(void) buildLevel;
-(void) buildPartA;
-(void) buildPartB;
-(void) buildPartC;
-(void) buildPartD;

@end
