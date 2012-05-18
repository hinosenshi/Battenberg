//
//  LevelBuilder.h
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameLayer.h"
#import "Globals.h"

@interface LevelBuilder
{
    
}

+(void) addCardTableToLayer: (GameLayer*) layer location: (CGPoint) p;
+(void) addFilingCabinetToLayer: (GameLayer*) layer location: (CGPoint) p;
+(void) addComputerToLayer: (GameLayer*) layer location: (CGPoint) p;

@end
