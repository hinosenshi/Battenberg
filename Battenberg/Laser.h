//
//  Laser.h
//  Battenberg
//
//  Created by Matthew Carlin on 4/30/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Globals.h"
#import "WorldObject.h"

@class GameLayer;


@interface Beam : NSObject
{
@public
    
    Beam *next;
    int rotation;
    CGPoint origin;
    CGPoint destination;
}

-(id) initBeamWithOrigin: (CGPoint)_origin destination:(CGPoint)_destination;
-(id) initBeamWithParent: (Beam*)parent destination:(CGPoint)_destination;

-(int) distance;

-(bool) collisionWith: (WorldObject*) object time:(ccTime)dt;

@end



@interface Mirror : NSObject
{
@public
    
    float radius;
    int rotation;
    CGPoint location;
}

-(id) initMirrorWithLayer: (GameLayer*) _layer location: (CGPoint)_location rotation: (int) _rotation;

@end


@interface Laser : NSObject
{
@public
    
    GameLayer *layer;
    
    NSMutableArray *beamSprites;
    
    NSMutableArray *platforms;
    NSMutableArray *mirrors;
    
    CGPoint p;
    
    int rotation;
    
    Beam *head;
    Beam *tail;
}

-(id) initLaserWithLayer: (GameLayer*) _layer location: (CGPoint) _p rotation: (int) _rotation Platforms: (NSMutableArray*) _platforms Mirrors: (NSMutableArray*) _mirrors;

-(bool) collisionWith: (WorldObject*) object time:(ccTime)dt;
-(void) makeSprites;
-(void) raycast;
-(void) drawBoundingBox;
-(void) rotateBeam;

@end


