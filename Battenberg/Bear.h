//
//  Bear.h
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

@interface Bear : WorldObject
{
@public
    float walkSpeed;
    
    float jumpPower;
    
    float jumpCharge;
    bool jumpCharging;
    float jumpChargeStartY;
    float jumpChargeMinY;
    float jumpChargeMinX;
    
    bool stallingBoy;
    
    CCSprite *pawSprite;
    
    bool sighing;
    int sighingInterval;
    int sighingAnimationFrame;
    NSMutableArray *sighingAnimation;
    NSMutableArray *sighingAnimationTimers;
}

-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p;
-(void) update: (ccTime) dt;
-(void) drawBoundingBox;
-(void) animate;
-(void) faceLeft;
-(void) faceRight;
-(void) stand;
-(void) faceUpsideDown;
-(void) faceRightsideUp;

@end
