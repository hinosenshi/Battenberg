//
//  OneSidedPlatformContactListener.m
//  Battenberg
//
//  Created by Matthew Carlin on 4/9/12.
//  Copyright 2012 Expression Games. All rights reserved.
//

#import "OneSidedPlatformContactListener.h"


OneSidedPlatformContactListener::OneSidedPlatformContactListener(){};

void OneSidedPlatformContactListener::BeginContact(b2Contact* contact)
{ 
    /* handle begin event */ 
}



void OneSidedPlatformContactListener::EndContact(b2Contact* contact)
{ 
    /* handle end event */ 
}



void OneSidedPlatformContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
    b2Fixture* fixtureA = contact->GetFixtureA();
    b2Fixture* fixtureB = contact->GetFixtureB();
    
    b2Body* bodyA = fixtureA->GetBody();
    b2Body* bodyB = fixtureB->GetBody();
    
    b2Vec2 positionA = bodyA->GetPosition();
    b2Vec2 positionB = bodyB->GetPosition();
    
    //CCLOG(@"Positions of contact: %0.2f %02.f",positionA.y * 32,positionB.y * 32);
    
    b2Vec2 velocityB = bodyB->GetLinearVelocity();
    
    
    if(velocityB.y > 0)
    {
        //contact->SetEnabled(false);
    }
}



void OneSidedPlatformContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{ 
    /* handle post-solve event */ 
}
