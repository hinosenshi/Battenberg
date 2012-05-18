//
//  Control.mm
//  Battenberg
//
//  Created by Matthew Carlin on 3/19/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "Control.h"

@implementation ObjPoint
- (id) initWithX:(float)_x Y:(float)_y
{
    x = _x;
    y = _y;
    return self;
}
@end

@implementation Control

-(id) initWithLayer: (GameLayer*) the_layer
{
    layer = the_layer;
    bear = layer->bear;
    boy = layer->boy;
    
    leftTouch = false;
    rightTouch = false;
    jumpingGesture = false;
    
    drawPoints = NULL;
    targetPoint = NULL;
    draggingTouch = false;
    
    lastBearMoveTime = [[NSDate date] retain];
    lastTapTime = NULL;
    
    numTouches = 0;
    mainTouchHash = -1;
    
    return self;
}

-(bool)rejectMenuLocation: (CGPoint) location
{
    if(location.y < 100)
    {
        return true;
    }
    
    return false;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // always do these things
    CGPoint location = [touch locationInView: [touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL: location];
    
//    if([self rejectMenuLocation:location])
//    {
//        return false;
//    }
    
    location.x = location.x - layer.position.x;
    location.y = location.y - layer.position.y;

    numTouches += 1;

    if(numTouches == 1)
    {
        mainTouchHash = [touch hash];
    }
    
    
    // conditional on the number of touches
    if(numTouches == 1)
    {
        // dragging touch
        if(location.x > bear->x - 2 * bear->boxWidth
           && location.x < bear->x + 2 * bear->boxWidth
           && location.y < bear->y + 2 * bear->boxHeight
           && location.y > bear->y - 2 * bear->boxHeight) // this check should be in a function in world object
        {
            draggingTouch = true;
            targetPoint = [[ObjPoint alloc] initWithX:location.x Y:location.y];
            drawPoints = [[NSMutableArray alloc] init];
            
            [drawPoints addObject:targetPoint];
        }
    }
    
    return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // always do these things
    CGPoint location = [touch locationInView: [touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL: location];
    
//    if([self rejectMenuLocation:location])
//    {
//        return;
//    }
    
    location.x = location.x - layer.position.x;
    location.y = location.y - layer.position.y;
    
    CGPoint oldLocation = [touch previousLocationInView:touch.view];
    oldLocation = [[CCDirector sharedDirector] convertToGL:oldLocation];
    oldLocation.x = oldLocation.x - layer.position.x;
    oldLocation.y = oldLocation.y - layer.position.y;
    
    if(mainTouchHash == -1)
    {
        mainTouchHash = [touch hash];
    }
    
    if([touch hash] != mainTouchHash)
    {
        return;
    }
    
    
    // conditional on the number of touches
    if(numTouches == 1)
    {
    
        if(draggingTouch)
        {
            targetPoint = [[ObjPoint alloc] initWithX:location.x Y:location.y];
            
            ObjPoint *oldPoint = [drawPoints lastObject];
            
            if(oldPoint != NULL)
            {
                oldPoint->next = targetPoint;
            }
            
            [drawPoints addObject:targetPoint];
        }
        
        if(!bear->jumping)
        {   
            if(!bear->jumpCharging && location.y < oldLocation.y && bear->platform != NULL && !bear->jumping)
            {
                bear->jumpCharging = true;
                bear->jumpChargeStartY = oldLocation.y;
                bear->jumpChargeMinY = oldLocation.y;
                bear->jumpChargeMinX = oldLocation.x;
            }
            
            if(bear->jumpCharging && location.y < bear->jumpChargeStartY)
            {
                float chargeValue = (bear->jumpChargeStartY - location.y) / 100.0f;
                if(bear->jumpCharge < chargeValue)
                {
                    bear->jumpChargeMinY = location.y;
                    bear->jumpChargeMinX = location.x;
                    bear->jumpCharge = chargeValue;
                }  
                if(bear->jumpCharge > 1.0f) bear->jumpCharge = 1.0f;
            }
            else if(bear->jumpCharging 
                    && bear->jumpCharge > 0.25f 
                    && location.y > bear->jumpChargeStartY 
                    && location.y > oldLocation.y + 5)
            {
                if(location.x == bear->jumpChargeMinX)
                {
                    bear->vy = bear->jumpPower * bear->jumpCharge;
                }
                else
                {
                    float proportion = 1.5f * (location.y - bear->jumpChargeMinY) / (float)(location.x - bear->jumpChargeMinX);
                    int direction = 1;
                    
                    if(proportion < 0)
                    {
                        proportion *= -1;
                        direction = -1;
                        [bear faceLeft];
                    }
                    else 
                    {
                        [bear faceRight];
                    }
                    bear->vy = bear->jumpPower * bear->jumpCharge;
                    bear->vx += direction * (1.0f / (proportion + 1.0f)) * bear->jumpPower * bear->jumpCharge;
                    
                    //CCLOG(@"JUUUMPING! %f %f %f %f", proportion, bear->jumpCharge, bear->vx, bear->vy);
                    
                    targetPoint = NULL;
                    drawPoints = NULL;
                    draggingTouch = false;
                }
                
                bear->jumpCharge = 0.0f;
                bear->jumpCharging = false;
                
                bear->jumping = true;
                bear->falling = true;
                
                // move bear here too
                lastBearMoveTime = [[NSDate date] retain];
            }
            else
            {
                bear->jumpCharge = 0.0f;
                bear->jumpCharging = false;
            }
            
            
            
        }
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // always do these things
    
    numTouches -= 1;
    
    if([touch hash] == mainTouchHash)
    {
        mainTouchHash = -1;
    }
    
    CGPoint location = [touch locationInView: [touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL: location];
    location.x = location.x - layer.position.x;
    location.y = location.y - layer.position.y;
    
    // conditional on the number of touches
    if(numTouches == 0)
    {
        leftTouch = false;
        rightTouch = false;
        jumpingGesture = false;
        
        bear->jumpCharge = 0.0f;
        bear->jumpCharging = false;
        
        //drawPoints = NULL;
        
        draggingTouch = false;
        
        if(lastTapTime != NULL)
        {
            NSTimeInterval timeInterval = -1 * [lastTapTime timeIntervalSinceNow];
            
            //CCLOG(@"Target %f %f %f", timeInterval, location.x, location.y);
            
            if(timeInterval < 0.250f)
            {
                targetPoint = [[ObjPoint alloc] initWithX:location.x Y:location.y];
                drawPoints = [[NSMutableArray alloc] init];
                [drawPoints addObject:targetPoint];
            }
        }
        
        lastTapTime = [[NSDate date] retain];
    }
}

- (void)drawControl
{    
    if(drawPoints != NULL && drawPoints.count > 0)
    {
        glColor4f(0.5f,0.5f,0.6f,1.0f);
        glEnable(GL_LINE_SMOOTH);
        ObjPoint *lastPoint = NULL;
        ObjPoint *firstPoint = [drawPoints objectAtIndex:0];
        bool dash = false;
        
        
        ccDrawLine(ccp(bear->x, bear->y), ccp(firstPoint->x, firstPoint->y));
        
        for(ObjPoint *point in drawPoints)
        {
            if(lastPoint != NULL)
            {
                if(!dash)
                {
                    ccDrawLine(ccp(lastPoint->x, lastPoint->y), ccp(point->x, point->y));
                    //dash = true;
                }
                else 
                {
                    dash = false;
                }
            }
            
            lastPoint = point;
        }
    }
    
    if(targetPoint != NULL)
    {
        float radius = 5.0f;
        glColor4f(0.0f,0.7f,0.0f,1.0f);
        glLineWidth(2.0f);
        for(int i = 0; i < 20; i++)
        {
            for(int j = 1; j <= 3; j++)
            {
                if(j % 2 == 0) glColor4f(0.7f,0.0f,0.0f,1.0f);
                else glColor4f(0.9f,0.9f,0.9f,1.0f);
                
                ccDrawLine(ccp(targetPoint->x + j * radius * cos(i / 20.0f * 2 * M_PI), targetPoint->y + j * radius * sin(i / 20.0f * 2 * M_PI)), 
                            ccp(targetPoint->x + j * radius * cos((i + 1) / 20.0f * 2 * M_PI), targetPoint->y + j * radius * sin((i + 1) / 20.0f * 2 * M_PI)));
            }
        }
    }
}

- (void)updateControl
{        
    [bear stand];
    
    if(boy->x > bear->x - 3 * bear->boxWidth && boy->x < bear->x + 3 * bear->boxWidth
       && boy->y > bear->y - bear->boxHeight && boy->y < bear->y + bear->boxHeight)
    {
        [overlay showThrowingButton];
    }
    else 
    {
        [overlay hideThrowingButton];
    }
    
    if(drawPoints != NULL && drawPoints.count > 0)
    {
        ObjPoint *currentTarget = [drawPoints objectAtIndex:0];
        
        while(currentTarget != NULL)
        {
            if(bear->x + bear->boxWidth < currentTarget->x)
            {
                [bear faceRight];
                if(bear->vx < bear->walkSpeed)
                {
                    bear->vx = bear->walkSpeed;
                }
                lastBearMoveTime = [[NSDate date] retain];
                currentTarget = NULL;

            }
            else if(bear->x - bear->boxWidth > currentTarget->x)
            {
                [bear faceLeft];
                if(bear->vx > -1 * bear->walkSpeed)
                {
                    bear->vx = -1 * bear->walkSpeed;
                }
                lastBearMoveTime = [[NSDate date] retain];
                currentTarget = NULL;
            }
            else
            {
                currentTarget->dead = true;
                currentTarget = currentTarget->next;
            }
        }
    }
    else 
    {
        [bear stand];
        if(!draggingTouch)
        {
            targetPoint = NULL;
            drawPoints = NULL;
        }
    }
    
    //wipe out extra points
    NSMutableArray *newDrawPoints = [[NSMutableArray alloc] init];
    for(ObjPoint *point in drawPoints)
    {        
        if(!point->dead) [newDrawPoints addObject:point];
    }
    drawPoints = newDrawPoints;

    NSTimeInterval timeInterval = -1 * [lastBearMoveTime timeIntervalSinceNow];
    
    if(timeInterval > bear->sighingInterval && bear->sighing == false)
    {
        bear->sighing = true;
        bear->sighingAnimationFrame = 0;
        bear->animationFrame = 0;
        bear->sighingInterval *= 2;
        if(bear->sighingInterval > 20) bear->sighingInterval = 20;
    }
    else if(bear->sighing == true)
    {
        lastBearMoveTime = [[NSDate date] retain];
    }
    
    
    
//    if(boy->y < bear->y - 200 && !boy->jumping && !boy->falling)
//    {
//        if(boy->x < bear->x) 
//        {
//            [boy faceRight];
//        }
//        else 
//        {
//            [boy faceLeft];
//        }
//        boy->vy = boy->jumpPower;
//        boy->jumping = true;
//        boy->falling = true;
//    }
    
    if(!boy->falling)
    {
        if(boy->x + boy->boxWidth < bear->x - 200)
        {
            [boy faceRight];
        }
        else if(boy->x - boy->boxWidth > bear->x + 200)
        {
            [boy faceLeft];
        }
        else 
        {
            float randomWalk = (float)rand()/(float)RAND_MAX;
            if(randomWalk > 0.994)
            {
                if(boy->direction == 0)
                {
                    [boy faceLeft];
                }
                else 
                {
                    [boy stand];
                }
            }
            else if(randomWalk > 0.975)
            {
                if(boy->direction == 1)
                {//96.1
                    
                    [boy faceLeft];
                }
                else if(self->layer->boy->direction == -1)
                {
                    [boy faceRight];
                }
            }
        }
        
        if(boy->direction == 1)
        {
            if(boy->vx < boy->walkSpeed)
            {
                boy->vx = boy->walkSpeed;
            }
        }
        else if(boy->direction == -1)
        {
            if(boy->vx > -1 * boy->walkSpeed)
            {
                boy->vx = -1 * boy->walkSpeed;
            }
        }
    }
}

-(void) makeCake
{
    CCLOG(@"I AM HERE");
    
    LevelOneLayer *l1layer = (LevelOneLayer *) self->layer;
    
    [l1layer->items addObject:[[Cake alloc] initWithLayer:layer location:ccp(bear->x, bear->y + 400)]];
}

-(void) throwBoy
{
    if(!boy->falling)
    {
        if(boy->x > bear->x - 3 * bear->boxWidth && boy->x < bear->x + 3 * bear->boxWidth
           && boy->y > bear->y - bear->boxHeight && boy->y < bear->y + bear->boxHeight)
        {
            boy->falling = true;
            
            boy->vy = 1.3 * bear->jumpPower;
            if(bear->lastFacing == 1)
            {
                boy->vx = 1.3 * bear->jumpPower;
                
                if(boy->x < bear->x + 2 * bear->boxWidth)
                {
                    boy->x = bear->x + 2 * bear->boxWidth;
                }
                
            }
            else if(bear->lastFacing == -1)
            {
                boy->vx = -1.3 * bear->jumpPower;
                
                if(boy->x > bear->x - 2 * bear->boxWidth)
                {
                    boy->x = bear->x - 2 * bear->boxWidth;
                }
                
            }
            
            
        }
    }
}

@end
