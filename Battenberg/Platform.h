//
//  Platform.h
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Globals.h"
#import "WorldObject.h"

@class GameLayer;

const int S_PLATFORM = 1;
const int S_TWO_SIDED_PLATFORM = 2;
const int S_FLOOR = 3;
const int S_WALL = 4;
const int S_SLANTED_PLATFORM = 5;

@interface Platform : NSObject
{
@public

    GameLayer *layer;
    
    bool jumping;
    
    CGPoint p;
    CGPoint p2;
    
    float width;
    float height;
    
    bool left;
    
    int type;
}

-(id) initPlatformWithLayer: (GameLayer*) _layer location: (CGPoint) _p width:(float)_width;
-(id) initTwoSidedPlatformWithLayer: (GameLayer*) _layer location: (CGPoint) _p width:(float)_width;
-(id) initFloorWithLayer: (GameLayer*) _layer location: (CGPoint) _p width:(float)_width;
-(id) initWallWithLayer: (GameLayer*) _layer location: (CGPoint) _p height:(float)_height left:(bool)_left;
-(id) initSlantedPlatformWithLayer: (GameLayer*) _layer fromStart: (CGPoint) _p1 toEnd: (CGPoint) _p2;

-(bool) collisionWith: (WorldObject*) object time:(ccTime)dt;
-(void) drawBoundingBox;

@end
