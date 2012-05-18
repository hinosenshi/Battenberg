//
//  LevelBuilder.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "LevelBuilder.h"

@implementation LevelBuilder

+(void) addCardTableToLayer: (GameLayer*) layer location: (CGPoint) p
{
    CCSprite* tableSprite = [CCSprite spriteWithFile: @"Art/cardtable.png"];
    tableSprite.position = ccp( p.x, p.y );
    tableSprite.anchorPoint = ccp(0.6,0.068);
    [layer addChild:tableSprite];
    [layer reorderChild:tableSprite z:-0.8];
}

+(void) addFilingCabinetToLayer: (GameLayer*) layer location: (CGPoint) p
{
    CCSprite* sprite = [CCSprite spriteWithFile: @"Art/filingcab_rainwbowinning.png"];
    sprite.position = ccp( p.x, p.y );
    sprite.anchorPoint = ccp(0.459,0.032);
    [layer addChild:sprite];
    [layer reorderChild:sprite z:-0.9];
}

+(void) addComputerToLayer: (GameLayer*) layer location: (CGPoint) p
{
    CCSprite* sprite = [CCSprite spriteWithFile: @"Art/terminal_with_cord.png"];
    sprite.position = ccp( p.x, p.y );
    sprite.anchorPoint = ccp(0.459,0.032);
    [layer addChild:sprite];
    [layer reorderChild:sprite z:-0.9];
}


@end
