//
//  Boy.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "Boy.h"
#import "GameLayer.h"

@implementation Boy

//static int walkingFootfall[] = { 0, 5, -17, -1, 1, -17 };
static int walkingFootfall[] = { 0, 6, 21, 47, 49, 63 };

// make a new boy on the specified game layer at the given location
-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p
{    

    // first, set up basic variables
    layer = _layer;
    
    id = ID_BOY;
    
    animationFrame = 0;
    ticksPerFrame = 4;
    direction = 1;
    
    jumping = false;
    falling = true;
    dying = false;
    
    platform = NULL;
    
    walkSpeed = 88.0f;
    
    jumpPower = 17 * 42.0f;
    
    // next, set up the boy sprite
    
    // Create a batch node -- just a big image which is prepared to 
    // be carved up into smaller images as needed
    CCSpriteBatchNode *boySheetBatch = [CCSpriteBatchNode batchNodeWithFile:@"Art/Boy.png" capacity:12];
    
    // Add the batch node to parent (it won't draw anything itself, but 
    // needs to be there so that it's in the rendering pipeline)
    [layer addChild:boySheetBatch];
    
    // Load sprite frames, which are just a bunch of named rectangle 
    // definitions that go along with the image in a sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Art/Boy.plist"];
    
    // Create a sprite, using the name of a frame in our frame cache.
    sprite = [CCSprite spriteWithSpriteFrameName:@"boywalk0002.png"];
    
    // Set an anchor point to center the sprite
    sprite.anchorPoint = ccp(0.57,0.28);
    boxWidth = 22.0f;
    boxHeight = 50.0f;
    mass = boxWidth * boxHeight * 4;
    
    // Add the sprite as a child of the sheet, so that it knows where to get its image data.
    [layer addChild:sprite];
    [layer reorderChild:sprite z:0.9];
    
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
//    // Add the bear sprite to the body
//    bodyDef.userData = sprite;
//    
//    // Call the body factory which allocates memory for the body
//    // and adds it to the world
//    boyBody = layer->world->CreateBody(&bodyDef);
//    
//    // Define a bounding box for the bear
//    b2PolygonShape dynamicBox;
//    //fat box
//    //dynamicBox.SetAsBox(32.0 / PTM_RATIO, 50.0 / PTM_RATIO);
//    //thin box
//    dynamicBox.SetAsBox(22.0 / PTM_RATIO, 50.0 / PTM_RATIO);
//    
//    // Define a fixture for density, friction, and the shape, and add it to the body
//    b2FixtureDef fixtureDef;
//	fixtureDef.shape = &dynamicBox;	
//	fixtureDef.density = 1.0f;
//	fixtureDef.friction = 0.3f;
//    //fixtureDef.restitution = 1.0f;
//	boyBody->CreateFixture(&fixtureDef);
//    
//    // Bear can't rotate
//    boyBody->SetFixedRotation(true);
    
    
    return self;
}

-(void) update: (ccTime) dt
{
    //[self animate];
}

float superjustment = 0.0f;

-(void) animate
{
    //int adjustment = walkingFootfall[(int) (animationFrame / ticksPerFrame)];
    //CCLOG(@"Frame: %d, Adjustment: %d",(int) (animationFrame / ticksPerFrame), adjustment);
    sprite.position = ccp(x, y);
    
    if(dying)
    {
        if(sprite.rotation > -110)
        {
            sprite.rotation = -110;
        }
        else 
        {
            sprite.rotation += -10;
        }
    }
    
    if(direction != 0 && !falling)
    {
        animationFrame += 1;
        if(animationFrame >= 6 * ticksPerFrame)
        {
            animationFrame = 0;
//            superjustment += 88.0f;
//            if(superjustment > 500)
//                superjustment = 0.0f;
            
            
        }
        
        // cast and hope it works
        int walkNumber = (int) (animationFrame / ticksPerFrame) + 2;
        NSString *walkValue = @"boywalk000";
        NSString *fullWalkValue = [walkValue stringByAppendingString:[NSString stringWithFormat:@"%d",walkNumber]];
        NSString *ultraWalkValue = [fullWalkValue stringByAppendingString:@".png"];
        //[walkValue appendString:[NSString stringWithFormat:@"%d",walkNumber]];
        
        //CCLOG(ultraWalkValue);
        
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                            spriteFrameByName:ultraWalkValue];
        [sprite setDisplayFrame:frame];
    }
    else if(direction == 0 && !falling)
    {
        animationFrame += 1;
        if(animationFrame >= 4 * ticksPerFrame)
        {
            animationFrame = 4 * ticksPerFrame - 1;
        }
        
        
        // cast and hope it works
        int walkNumber = (int) (animationFrame / ticksPerFrame) + 8;
        NSString *walkValue = @"boywalk00";
        NSString *fullWalkValue = [walkValue stringByAppendingString:[NSString stringWithFormat:@"%02d",walkNumber]];
        NSString *ultraWalkValue = [fullWalkValue stringByAppendingString:@".png"];
        //[walkValue appendString:[NSString stringWithFormat:@"%d",walkNumber]];        
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:ultraWalkValue];
        [sprite setDisplayFrame:frame];
    }
    else if(falling)
    {
        animationFrame = 0;
        
        if(vy > 0)
        {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                    spriteFrameByName:@"boywalk0012.png"];
            [sprite setDisplayFrame:frame];
        }
        else 
        {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                    spriteFrameByName:@"boywalk0005.png"];
            [sprite setDisplayFrame:frame];
        }
    }
        
    //sprite.position = ccp(350 + adjustment, y);
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


-(void) faceLeft
{
    direction = -1;
    sprite.flipX = YES;
    sprite.anchorPoint = ccp(0.43,0.28);
}

-(void) faceRight
{
    direction = 1;
    sprite.flipX = NO;
    sprite.anchorPoint = ccp(0.57,0.28);
}

//-(void) faceUpsideDown
//{
//    sprite.flipY = YES;
//    if(direction == 1)
//    {
//        sprite.anchorPoint = ccp(0.57,0.72);
//    }
//    else
//    {
//        sprite.anchorPoint = ccp(0.43,0.72);
//    }
//}
//
//-(void) faceRightsideUp
//{
//    sprite.flipY = NO;
//    if(direction == 1)
//    {
//        sprite.anchorPoint = ccp(0.57,0.28);
//    }
//    else
//    {
//        sprite.anchorPoint = ccp(0.43,0.28);
//    }
//}

-(void) stand
{
    direction = 0;
}

@end
