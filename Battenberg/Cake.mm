//
//  Cake.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "Cake.h"
#import "GameLayer.h"

@implementation Cake

// make a new cake on the specified game layer at the given location
-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p
{
    // first, set up basic variables
    layer = _layer;
    
    id = ID_CAKE;
    
    animationFrame = 0;
    ticksPerFrame = 4;
    
    platform = NULL;
    
    falling = true;
    dying = false;
    
    // next, set up the cake sprite
    
    // Create a batch node -- just a big image which is prepared to 
    // be carved up into smaller images as needed
    CCSpriteBatchNode *cakeSheetBatch = [CCSpriteBatchNode batchNodeWithFile:@"Art/Cake.png" capacity:12];
    
    // Add the batch node to parent (it won't draw anything itself, but 
    // needs to be there so that it's in the rendering pipeline)
    [layer addChild:cakeSheetBatch];
    
    // Load sprite frames, which are just a bunch of named rectangle 
    // definitions that go along with the image in a sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Art/Cake.plist"];
    
    // Create a sprite, using the name of a frame in our frame cache.
    sprite = [CCSprite spriteWithSpriteFrameName:@"cake0001.png"];
    
    // Set an anchor point to center the sprite
    sprite.anchorPoint = ccp(0.496,0.197);
    
    // this is plate width
    //boxWidth = 46.0f;
    
    //this is more like cake width
    boxWidth = 26.0f;
    boxHeight = 32.0f;
    mass = boxWidth * boxHeight * 4;
    
    // Add the sprite as a child of the sheet, so that it knows where to get its image data.
    [layer addChild:sprite];
    [layer reorderChild:sprite z:1];
    
    x = p.x;
    y = p.y;
    vx = 0;
    vy = 0;
    
    
    // now, add a definition of the bear to the physics system
    
//    // Define a body.
//    b2BodyDef bodyDef;
//    bodyDef.type = b2_dynamicBody;
//    
//    // Position the body
//    bodyDef.position.Set(p.x / PTM_RATIO, p.y / PTM_RATIO);
//    
//    // Add the cake sprite to the body
//    bodyDef.userData = sprite;
//    
//    // Call the body factory which allocates memory for the body
//    // and adds it to the world
//    cakeBody = layer->world->CreateBody(&bodyDef);
//    
//    // Define a bounding box for the bear
//    b2PolygonShape dynamicBox;
//    dynamicBox.SetAsBox(46.0 / PTM_RATIO, 32.0 / PTM_RATIO);
//    
//    // Define a fixture for density, friction, and the shape, and add it to the body
//    b2FixtureDef fixtureDef;
//	fixtureDef.shape = &dynamicBox;	
//	fixtureDef.density = 1.0f;
//	fixtureDef.friction = 0.3f;
//    //fixtureDef.restitution = 1.0f;
//	cakeBody->CreateFixture(&fixtureDef);
//    
//    // Cake can't rotate
//    cakeBody->SetFixedRotation(true);
    
    
    return self;
}

-(void) update: (ccTime) dt
{    
    //[self animate];
}

-(void) animate
{
    sprite.position = ccp(x, y);
    
    animationFrame += 1;
    if(animationFrame >= 6 * ticksPerFrame)
    {
        animationFrame = 0;
    }
    
    // cast and hope it works
    int walkNumber = (int) (animationFrame / ticksPerFrame) + 1;
    NSString *walkValue = @"cake000";
    NSString *fullWalkValue = [walkValue stringByAppendingString:[NSString stringWithFormat:@"%d",walkNumber]];
    NSString *ultraWalkValue = [fullWalkValue stringByAppendingString:@".png"];
    
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                        spriteFrameByName:ultraWalkValue];
    [sprite setDisplayFrame:frame];
}

-(void) drawBoundingBox
{
    glColor4f(1.0f,0.0f,0.0f,1.0f);
    glEnable(GL_LINE_SMOOTH);
    ccDrawLine( ccp(x + boxWidth, y + boxHeight), ccp(x + boxWidth, y - boxHeight) );
    ccDrawLine( ccp(x - boxWidth, y + boxHeight), ccp(x - boxWidth, y - boxHeight) );
    ccDrawLine( ccp(x + boxWidth, y + boxHeight), ccp(x - boxWidth, y + boxHeight) );
    ccDrawLine( ccp(x + boxWidth, y - boxHeight), ccp(x - boxWidth, y - boxHeight) );
}


//-(void) faceUpsideDown
//{
//    sprite.flipY = YES;
//}
//
//-(void) faceRightsideUp
//{
//    sprite.flipY = NO;
//}


@end
