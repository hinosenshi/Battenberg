//
//  LevelTwoLayer.h
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "CCTouchDispatcher.h"

// interface
@interface LevelTwoLayer : CCLayer
{
	//b2World* world;
	//GLESDebugDraw *m_debugDraw;
}

// returns a CCScene that contains the LevelTwoLayer as the only child
+(CCScene *) scene;

@end
