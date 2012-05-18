//
//  WorldObject.mm
//  Battenberg
//
//  Created by Matthew Carlin on 4/24/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "WorldObject.h"
#import "GameLayer.h"

@implementation WorldObject

// make a new cake on the specified game layer at the given location
-(id) initWithLayer: (GameLayer*) _layer location: (CGPoint) p
{
    footRestLeft = 0;
    footRestRight = 0;
    
    ignoreCollision = false;
    
    return self;
}

-(bool) collideWith:(WorldObject *)object
{
    if(self->ignoreCollision || object->ignoreCollision)
    {
        return false;
    }
    
    if(self == object)
    {
        return false;
    }
    
    if(self->x > object->x
       || self->y + self->boxHeight < object->y - object->boxHeight
       || self->y - self->boxHeight > object->y + object->boxHeight)
    {
        return false;
    }
    
    if(self->x + self->boxWidth < object->x - object->boxWidth)
    {
        return false;
    }
    
    //fake static friction
    if(fabsf(self->vx) < 0.25 && self->mass / object->mass > 2.0)
    {
        float diff = (self->x + self->boxWidth) - (object->x - object->boxWidth);
        object->x += diff;
        return true;
    }
    if(fabsf(object->vx) < 0.25 && object->mass / self->mass > 2.0)
    {
        float diff = (self->x + self->boxWidth) - (object->x - object->boxWidth);
        self->x -= diff;
        return true;
    }
       
    
    // skipped through all the short cases? do the actual collision
    float diff = (self->x + self->boxWidth) - (object->x - object->boxWidth);
    self->x -= diff/2;
    object->x += diff/2;
    
    float m1 = self->mass;
    float m2 = object->mass;
    
    float u1 = self->vx;
    float u2 = object->vx;
    
    float v1 = (u1 * (m1 - m2) + 2 * m2 * u2) / (m1 + m2);
    float v2 = (u2 * (m2 - m1) + 2 * m1 * u1) / (m1 + m2);
    
    self->vx = v1;
    object->vx = v2;
    
    return true;
    
}

-(bool) boundingBoxHitWithX:(float)_x Y:(float)_y
{
    if(_x > self->x - self->boxWidth
       && _x < self->x + self->boxWidth
       && _y < self->y + self->boxHeight
       && _y > self->y - self->boxHeight)
    {
        return true;
    }
    
    return false;
}

@end
