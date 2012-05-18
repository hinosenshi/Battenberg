//
//  GameLayer.h
//  Battenberg
//
//  Created by Matthew Carlin on 4/6/12.
//  Copyright 2012 Expression Games. All rights reserved.
//

#import "cocos2d.h"
#import "GLES-Render.h"
#import "CCTouchDispatcher.h"
#import "Globals.h"

@class Boy;
@class Bear;
@class Cake;
@class Control;

@interface GameLayer : CCLayer {

@public
    Control* control;
    CGSize screenSize;
	//GLESDebugDraw *m_debugDraw;
    Bear *bear;
    Boy *boy;
    
    CGRect worldBoundary;
    CCFollow *following;
}

@end


