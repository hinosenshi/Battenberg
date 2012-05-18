//
//  Platform.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "Platform.h"
#import "GameLayer.h"
#import "WorldObject.h"

@implementation Platform


-(id) initPlatformWithLayer: (GameLayer*) _layer location: (CGPoint) _p width:(float)_width
{
    return [self initSomePlatformWithLayer:_layer type:S_PLATFORM location:_p width:_width];
}

-(id) initTwoSidedPlatformWithLayer: (GameLayer*) _layer location: (CGPoint) _p width:(float)_width
{
    return [self initSomePlatformWithLayer:_layer type:S_TWO_SIDED_PLATFORM location:_p width:_width];
}

// add a platform to the specified GameLayer with given location and width
-(id) initSomePlatformWithLayer: (GameLayer*) _layer type:(int)_type location: (CGPoint) _p width:(float)_width
{
    layer = _layer;
    
    p = _p;
    width = _width;
    type = _type;
    
    // start with left end cap
    CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_cap_LEFT.png"];
    platformSprite.position = ccp( p.x + 12.5, p.y - 12.5 );
    
    [layer addChild:platformSprite];
    [layer reorderChild:platformSprite z:-1];
    
    // now add random pieces of platform until reaching the end
    int i = 25;
    while(i < width)
    {
        float builder = (float)rand()/(float)RAND_MAX;
        if(width - i > 25)
        {
            if(builder < 0.3)
            {
                // 25 wide piece
                CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_25x25.png"];
                platformSprite.position = ccp( p.x + 12.5 + i, p.y - 12.5 );
                [layer addChild:platformSprite];
                [layer reorderChild:platformSprite z:-1];
                i += 25;
            }
            else if(builder < 0.9)
            {
                // 50 wide piece
                CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_25x50.png"];
                platformSprite.position = ccp( p.x + 25 + i, p.y - 12.5 );
                [layer addChild:platformSprite];
                [layer reorderChild:platformSprite z:-1];
                i += 50;
            }
            else
            {
                // 50 wide wuffle piece
                CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_25x50_wuffle.png"];
                platformSprite.position = ccp( p.x + 21 + i, p.y - 74.5 ); // positioned to correctly fit the wuffle
                [layer addChild:platformSprite];
                [layer reorderChild:platformSprite z:-1];
                i += 50;
            }
        }
        else 
        {
            // end with right end cap
            CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_cap.png"];
            platformSprite.position = ccp( p.x + 12.5 + i, p.y - 12.5 );
            [layer addChild:platformSprite];
            [layer reorderChild:platformSprite z:-1];
            i += 25;
        }
    }
    
    return self;
}

// add a floor to the specified GameLayer with given location and width
-(id) initFloorWithLayer: (GameLayer*) _layer location: (CGPoint) _p width:(float)_width
{
    layer = _layer;
    
    p = _p;
    width = _width;
    type = S_FLOOR;
    
    // done creating a representation in the physics system.
    // now add sprites into the layer to match the physical floor
    
    // tile the floor with floor tiling
    int i = 0;
    while(i < width)
    {
        CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/floortiles_512x512.png"];
        platformSprite.position = ccp( p.x + 256 + i, p.y + 256 - 15 );
        [layer addChild:platformSprite];
        [layer reorderChild:platformSprite z:-1];
        i += 512;
    }
    
    return self;
}

// add a wall to the specified GameLayer with given location and height
-(id) initWallWithLayer: (GameLayer*) _layer location: (CGPoint) _p height:(float)_height left:(bool)_left
{
    layer = _layer;
    p = _p;
    height = _height;
    left = _left;
    type = S_WALL;
    
    
//    if(left)
//    {
//        CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_cap_wall_LEFT.png"];
//        platformSprite.position = ccp( p.x, p.y );
//        [layer addChild:platformSprite];
//        [layer reorderChild:platformSprite z:-1];
//    }
//    else 
//    {
//        CCSprite* platformSprite = [CCSprite spriteWithFile: @"Art/plat_cap_wall.png"];
//        platformSprite.position = ccp( p.x, p.y );
//        [layer addChild:platformSprite];
//        [layer reorderChild:platformSprite z:-1];
//    }
    
    int i = 0;
    while(i <= height)
    {
        int wallHeight = p.y + i;
        //CCLOG(@"WALLLLL %f %d", height, wallHeight);
        CCSprite* wallSprite = [CCSprite spriteWithFile: @"Art/Wall.png"];
        wallSprite.anchorPoint = ccp(0.5,0);
        wallSprite.position = ccp( p.x, wallHeight );
        
        if(i + 49 > height)
        {
            [wallSprite setTextureRect:CGRectMake(0,0,50,49 - (i + 49 - height))];
        }
        
        [layer addChild:wallSprite];
        [layer reorderChild:wallSprite z:-1.2];
        i += 49;
    }

    
    return self;
}

// add a slanted platform to the specified GameLayer from point p1 to point p2
-(id) initSlantedPlatformWithLayer: (GameLayer*) _layer fromStart: (CGPoint) _p1 toEnd: (CGPoint) _p2
{
    layer = _layer;
    p = _p1;
    p2 = _p2;
    type = S_SLANTED_PLATFORM;
        
    // back of staircase
    CCSprite* stairBackSprite = [CCSprite spriteWithFile: @"Art/stair_225x225_BACK.png"];
    stairBackSprite.position = ccp( p.x + 10 + 225/2.0f, p.y - 225/2.0f + 10 );
    stairBackSprite.flipX = YES;
    [layer addChild:stairBackSprite];
    [layer reorderChild:stairBackSprite z:-1];
    
    //front of staircase
    CCSprite* stairFrontSprite = [CCSprite spriteWithFile: @"Art/stair_225x225_FRONT.png"];
    stairFrontSprite.position = ccp( p.x + 10 + 225/2.0f, p.y - 225/2.0f + 10 );
    stairFrontSprite.flipX = YES;
    [layer addChild:stairFrontSprite];
    [layer reorderChild:stairFrontSprite z:2];
    
    return self;
}




-(bool) collisionWith: (WorldObject*) object time:(ccTime)dt
{
    if(type == S_FLOOR || type == S_PLATFORM || type == S_TWO_SIDED_PLATFORM)
    {
        if(object->footRestLeft != 0)
        {
            if(object->lastFacing == 1 && (object->x + object->footRestRight < p.x || object->x - object->footRestLeft > p.x + width))
            {
                return false;
            }
            
            if(object->lastFacing == -1 && (object->x + object->footRestLeft < p.x || object->x - object->footRestRight > p.x + width))
            {
                return false;
            }
        }
        
        if(object->x + object->boxWidth < p.x || object->x - object->boxWidth > p.x + width)
        {
            return false;
        }
        
        if(object->y - object->boxHeight >= p.y 
           && object->y + object->vy * dt - object->boxHeight <= p.y 
           && object->vy <= 0)
        {
            object->falling = false;
            object->vy = 0;
            object->y = p.y + object->boxHeight;
            object->platform = self;
            object->jumping = false;
            
            return true;
        }
        
    }
    
    if(type == S_TWO_SIDED_PLATFORM)
    {
        if(object->y + object->boxHeight <= p.y 
           && object->y + object->vy * dt + object->boxHeight >= p.y 
           && object->vy >= 0)
        {
            object->vy = 0;
            object->y = p.y - object->boxHeight;
            
            return false;
        }
    }
    
    if(type == S_SLANTED_PLATFORM)
    {
        if(object->x < p.x || object->x > p2.x)
        {
            return false;
        }
        
        float target = p.y + (object->x - p.x)/(p2.x - p.x) * (p2.y - p.y);
        if(object->boxHeight == 84.0f)
        {
            //CCLOG(@"%f",target);
        }
        
        if(object->platform == self)
        {
            object->y = target + object->boxHeight;
            return true;
        }
        else
        {
            object->platform = NULL;
            object->falling = true;
        }
        
        if(object->y - object->boxHeight >= target 
           && object->y + object->vy * dt - object->boxHeight <= target 
           && object->vy <= 0)
        {
            object->falling = false;
            object->vy = 0;
            object->y = target + object->boxHeight;
            object->platform = self;
            object->jumping = false;
            
            return true;
        }

        
        //this.y1 + (bugsby.X - this.x1)/(this.x2 - this.x1) * (this.y2 - this.y1);
    }
    
    if(type == S_WALL)
    {
        if(object->y + object->boxHeight <= p.y || object->y - object->boxHeight >= p.y + height)
        {
            return false;
        }
        
        if(object->x + object->boxWidth <= p.x 
           && object->x + object->vx * dt + object->boxWidth >= p.x 
           && object->vx >= 0)
        {
            object->vx = 0;
            object->x = p.x - object->boxWidth;
            
            return false;
        }

        if(object->x - object->boxWidth >= p.x 
           && object->x + object->vx * dt - object->boxWidth <= p.x 
           && object->vx <= 0)
        {
            object->vx = 0;
            object->x = p.x + object->boxWidth;
            
            return false;
        }
        
        if(object->x - object->boxWidth < p.x 
                && object->x + object->boxWidth > p.x 
                && object->x <= p.x)
        {
            object->vx = 0;
            object->x = p.x - object->boxWidth;
            
            return false;
        }
        
        if(object->x - object->boxWidth < p.x 
           && object->x + object->boxWidth > p.x 
           && object->x >= p.x)
        {
            object->vx = 0;
            object->x = p.x + object->boxWidth;
            
            return false;
        }
    }
    
    return false;
}

-(void) drawBoundingBox
{
    glColor4f(0.0f,1.0f,0.0f,1.0f);
    glEnable(GL_LINE_SMOOTH);
    if(type == S_FLOOR || type == S_PLATFORM || type == S_TWO_SIDED_PLATFORM)
    {
        ccDrawLine( ccp(p.x, p.y), ccp(p.x + width, p.y) );
    }
    else if(type == S_WALL)
    {
        ccDrawLine( ccp(p.x, p.y), ccp(p.x, p.y + height) );
    }
    else if(type == S_SLANTED_PLATFORM)
    {
        ccDrawLine( ccp(p.x, p.y), ccp(p2.x, p2.y) );
    }
}


@end
