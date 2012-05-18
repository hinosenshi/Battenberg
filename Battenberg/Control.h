//
//  Control.h
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "CCTouchDispatcher.h"
#import "GameLayer.h"
#import "LevelOneLayer.h"
#import "Bear.h"
#import "Boy.h"
#import "Cake.h"

@class Overlay;

@interface ObjPoint : NSObject
{
@public
    float x;
    float y;
    ObjPoint *next;
    bool dead;
}
- (id) initWithX:(float)_x Y:(float)_y;
@end

@interface Control : NSObject
{
    GameLayer* layer;
    Bear* bear;
    Boy* boy;
    
    bool leftTouch;
    bool rightTouch;
    bool jumpingGesture;
    
    NSMutableArray *drawPoints;
    NSMutableArray *jumpPoints;
    ObjPoint *targetPoint;
    bool draggingTouch;
    
    NSDate *lastBearMoveTime;
    
    NSDate *lastTapTime;
    
    int numTouches;
    NSUInteger mainTouchHash;
    
@public
    Overlayer *overlay;
    
    //float jumpValueX = 0.0f;
    //float jumpValueY = 0.0f;
}

- (id) initWithLayer: (GameLayer*) the_layer;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)drawControl;
- (void)updateControl;
- (bool)rejectMenuLocation: (CGPoint) location;
- (void)makeCake;
- (void)throwBoy;

@end
