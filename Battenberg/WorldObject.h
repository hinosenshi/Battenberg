//
//  WorldObject.h
//  Battenberg
//
//  Created by Matthew Carlin on 4/24/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Globals.h"

@class GameLayer;
@class Platform;

const int ID_BOY = 1;
const int ID_BEAR = 2;
const int ID_CAKE = 3;

@interface WorldObject : NSObject
{
@public
    
    CCSprite *sprite;
    GameLayer *layer;
    
    int id;
    
    int animationFrame;
    int ticksPerFrame;
    int direction;
    
    bool falling;
    bool jumping;
    bool dying;
    bool ignoreCollision;
    
    int lastFacing;
    
    float boxWidth;
    float boxHeight;
    
    float footRestLeft;
    float footRestRight;
    
    float x;
    float y;
    float vx;
    float vy;
    
    float mass;
    
    Platform *platform;
}

-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p;
-(void) update: (ccTime) dt;
-(void) drawBoundingBox;
-(void) animate;
-(void) faceLeft;
-(void) faceRight;
-(void) stand;
//-(void) faceUpsideDown;
//-(void) faceRightsideUp;
-(bool) boundingBoxHitWithX:(float)_x Y:(float)_y;
-(bool) collideWith: (WorldObject*) object;

@end
