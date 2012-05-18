//
//  Bear.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "Bear.h"
#import "GameLayer.h"

@implementation Bear

// make a new bear on the specified game layer at the given location
-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p
{
    // first, set up basic variables
    layer = _layer;
    
    id = ID_BEAR;
    
    animationFrame = 0;
    ticksPerFrame = 4;
    direction = 1;
    jumping = false;
    falling = true;
    dying = false;
    
    stallingBoy = false;
    
    lastFacing = 1;
    
    pawSprite = [CCSprite spriteWithFile: @"Art/paw_backlayer.png"];
    //pawSprite.position = ccp( p.x + 60, p.y + 20 );
    [layer addChild:pawSprite];
    [layer reorderChild:pawSprite z:0.8];
    pawSprite.visible = NO;
    
    jumpCharge = 0.0f;
    jumpCharging = false;
    
    footRestLeft = 21;
    footRestRight = 35;
    
    sighing = false;
    sighingInterval = 5;
    sighingAnimationFrame = 0;
    sighingAnimation = [[NSMutableArray alloc] init];
    [sighingAnimation addObject:@"bear_0008.png"];
    [sighingAnimation addObject:@"bear_0009.png"];
    [sighingAnimation addObject:@"bear_0011.png"];
    [sighingAnimation addObject:@"bear_0012.png"];
    [sighingAnimation addObject:@"bear_0013.png"];
    
    sighingAnimationTimers = [[NSMutableArray alloc] init];
    [sighingAnimationTimers addObject:@"10"];
    [sighingAnimationTimers addObject:@"20"];
    [sighingAnimationTimers addObject:@"10"];
    [sighingAnimationTimers addObject:@"10"];
    [sighingAnimationTimers addObject:@"10"];

    
    platform = NULL;
    
    walkSpeed = 168.0f; // 4 meters per second, where the bear is 2 meters tall, and 2 x 84 pixels tall.
    
    jumpPower = 17 * 42.0f;
    
    // next, set up the bear sprite
    
    // Create a batch node -- just a big image which is prepared to 
    // be carved up into smaller images as needed
    CCSpriteBatchNode *bearSheetBatch = [CCSpriteBatchNode batchNodeWithFile:@"Art/Bear.png" capacity:4];
    
    // Add the batch node to parent (it won't draw anything itself, but 
    // needs to be there so that it's in the rendering pipeline)
    [layer addChild:bearSheetBatch];
    
    // Load sprite frames, which are just a bunch of named rectangle 
    // definitions that go along with the image in a sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Art/Bear.plist"];
    
    // Create a sprite, using the name of a frame in our frame cache.
    sprite = [CCSprite spriteWithSpriteFrameName:@"bear_0002.png"];
    
    // Set an anchor point to center the sprite
    sprite.anchorPoint = ccp(0.336,0.40);
    boxWidth = 36.0f;
    boxHeight = 84.0f;
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
//    //172 high
//    //92 fat
//    
//    //33.6%
//    //60%
//    
//    // Add the bear sprite to the body
//    bodyDef.userData = sprite;
//    
//    // Call the body factory which allocates memory for the body
//    // and adds it to the world
//    bearBody = layer->world->CreateBody(&bodyDef);
//    
//    CCLOG(@"I have created the bearbody");
//    
//    // Define a bounding box for the bear
//    b2PolygonShape dynamicBox;
//    //fat box
//    //dynamicBox.SetAsBox(46.0 / PTM_RATIO, 84.0 / PTM_RATIO);
//    //thin box
//    dynamicBox.SetAsBox(36.0 / PTM_RATIO, 84.0 / PTM_RATIO);
//    
//    // Define a fixture for density, friction, and the shape, and add it to the body
//    b2FixtureDef fixtureDef;
//	fixtureDef.shape = &dynamicBox;	
//	fixtureDef.density = 1.0f;
//	fixtureDef.friction = 0.3f;
//    //fixtureDef.restitution = 1.0f;
//	bearBody->CreateFixture(&fixtureDef);
//    
//    // Bear can't rotate
//    bearBody->SetFixedRotation(true);
    
    
    return self;
}

-(void) update: (ccTime) dt
{
    //[self animate];
}

-(void) animate
{
    // real
    // sprite.position = ccp(x, y);
    
    sprite.position = ccp(x, y - boxHeight * (jumpCharge / 4.0f));
    [sprite setScaleY:(1.0f - (jumpCharge / 4.0f))];
    
    if(dying)
    {
        // should have a dying frame here
        if(sprite.rotation > -70)
        {
            sprite.rotation = -70;
        }
        else 
        {
            sprite.rotation += -5;
        }
        
        return;
    }
    
    if(stallingBoy)
    {
        CCLOG(@"Stalling the boy");
        pawSprite.position = ccp(x + 40, y + 20);
        pawSprite.visible = YES;
        [layer reorderChild:pawSprite z:0.95];
    }
    else 
    {
        pawSprite.visible = NO;
        [layer reorderChild:pawSprite z:0.8];
    }
    
    
    if(sighing)
    {
        animationFrame += 1;
        NSString *sighingTickString = [sighingAnimationTimers objectAtIndex:sighingAnimationFrame];
        
        int sighingTicks = [sighingTickString intValue];

        if(animationFrame >= sighingTicks)
        {
            animationFrame = 0;
            sighingAnimationFrame += 1;
            
            if(sighingAnimationFrame > 4)
            {
                sighing = false;
                sighingAnimationFrame = 0;
            }
        }

        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:[sighingAnimation objectAtIndex:sighingAnimationFrame]];
        [sprite setDisplayFrame:frame];
        
        return;
    }
    
    
    if(direction != 0)
    {
        animationFrame += 1;
        if(animationFrame >= 4 * ticksPerFrame)
        {
            animationFrame = 0;
        }
        
        // cast and hope it works
        int walkNumber = (int) (animationFrame / ticksPerFrame) + 2;
        NSString *walkValue = @"bear_00";
        NSString *fullWalkValue = [walkValue stringByAppendingString:[NSString stringWithFormat:@"%02d",walkNumber]];
        NSString *ultraWalkValue = [fullWalkValue stringByAppendingString:@".png"];
        //[walkValue appendString:[NSString stringWithFormat:@"%d",walkNumber]];
        
        //CCLOG(ultraWalkValue);
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:ultraWalkValue];
        [sprite setDisplayFrame:frame];
    }
    else
    {
        animationFrame += 1;
        if(animationFrame >= 5 * ticksPerFrame)
        {
            animationFrame = 0;
        }
        
        // cast and hope it works
        int walkNumber = (int) (animationFrame / ticksPerFrame) + 14;
        NSString *walkValue = @"bear_00";
        NSString *fullWalkValue = [walkValue stringByAppendingString:[NSString stringWithFormat:@"%02d",walkNumber]];
        NSString *ultraWalkValue = [fullWalkValue stringByAppendingString:@".png"];
        //[walkValue appendString:[NSString stringWithFormat:@"%d",walkNumber]];
        
        //CCLOG(ultraWalkValue);
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:ultraWalkValue];
        [sprite setDisplayFrame:frame];

    }
}

-(void) drawBoundingBox
{
    glColor4f(1.0f,1.0f - jumpCharge,1.0f - jumpCharge,1.0f);
    glEnable(GL_LINE_SMOOTH);
    ccDrawLine( ccp(x + boxWidth, y + boxHeight), ccp(x + boxWidth, y - boxHeight) );
    ccDrawLine( ccp(x - boxWidth, y + boxHeight), ccp(x - boxWidth, y - boxHeight) );
    ccDrawLine( ccp(x + boxWidth, y + boxHeight), ccp(x - boxWidth, y + boxHeight) );
    ccDrawLine( ccp(x + boxWidth, y - boxHeight), ccp(x - boxWidth, y - boxHeight) );
}


-(void) faceLeft
{
    direction = -1;
    lastFacing = -1;
    sprite.flipX = YES;
    sprite.anchorPoint = ccp(0.664,0.40);
}

-(void) faceRight
{
    direction = 1;
    lastFacing = 1;
    sprite.flipX = NO;
    sprite.anchorPoint = ccp(0.336,0.40);
}
//
//-(void) faceUpsideDown
//{
//    sprite.flipY = YES;
//    if(direction == 1)
//    {
//        sprite.anchorPoint = ccp(0.664,0.60);
//    }
//    else
//    {
//        sprite.anchorPoint = ccp(0.336,0.60);
//    }
//}
//
//-(void) faceRightsideUp
//{
//    sprite.flipY = NO;
//    if(direction == 1)
//    {
//        sprite.anchorPoint = ccp(0.336,0.40);
//    }
//    else
//    {
//        sprite.anchorPoint = ccp(0.664,0.40);
//    }
//}

-(void) stand
{
    direction = 0;
}

@end
