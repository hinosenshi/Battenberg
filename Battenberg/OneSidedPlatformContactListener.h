//
//  OneSidedPlatformContactListener.h
//  Battenberg
//
//  Created by Matthew Carlin on 4/9/12.
//  Copyright 2012 Expression Games. All rights reserved.
//

#import "Box2D.h"
#import "cocos2d.h"

class OneSidedPlatformContactListener : public b2ContactListener
{
public:
    OneSidedPlatformContactListener();
    void* userData;
    void BeginContact(b2Contact* contact); // When we first contact
	void EndContact(b2Contact* contact); // When we end contact
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);    
};

