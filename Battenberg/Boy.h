//
//  Boy.h
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

@interface Boy : WorldObject
{
@public
    float walkSpeed;
    
    float jumpPower;
}

-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p;
-(void) update: (ccTime) dt;
-(void) drawBoundingBox;
-(void) animate;
-(void) faceLeft;
-(void) faceRight;
-(void) stand;

@end
