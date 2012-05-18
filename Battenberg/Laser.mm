//
//  Laser.mm
//  Battenberg
//
//  Created by Matthew Carlin on 4/30/12.
//  Copyright Expression Games 2012. All rights reserved.
//

#import "Laser.h"
#import "GameLayer.h"
#import "WorldObject.h"
#import "Platform.h"

@implementation Laser

// add a platform to the specified GameLayer with given location and width
-(id) initLaserWithLayer: (GameLayer*) _layer location: (CGPoint) _p rotation: (int) _rotation Platforms: (NSMutableArray*) _platforms Mirrors: (NSMutableArray*) _mirrors
{
    layer = _layer;
    
    p = _p;
    
    platforms = _platforms;
    mirrors = _mirrors;
    
    rotation = _rotation;

    CCSprite* deviceSprite = [CCSprite spriteWithFile: @"Art/LaserDevice.png"];
    deviceSprite.anchorPoint = ccp(0,0.5);
    deviceSprite.position = ccp( p.x, p.y );
    
    if(rotation % 90 != 0)
    {
        [NSException raise:@"Invalid laser direction" format:@""];
    }
    
    deviceSprite.rotation = rotation;
    
    [layer addChild:deviceSprite];
    [layer reorderChild:deviceSprite z:2];
    
    
    //make some beams
//    Beam *beam1 = [[Beam alloc] initBeamWithOrigin:ccp(p.x + 64, p.y) destination:ccp(p.x + 64 + 512, p.y)];
    
    //Beam *beam1 = [[Beam alloc] initBeamWithOrigin:ccp(p.x - 128, p.y) destination:ccp(0, p.y)];
    //head = beam1;
    
//    Beam *beam2 = [[Beam alloc] initBeamWithParent:beam1 destination:ccp(p.x + 64 + 512, p.y - 100)];
//    Beam *beam3 = [[Beam alloc] initBeamWithParent:beam2 destination:ccp(p.x + 64 + 256, p.y - 100)];
//    Beam *beam4 = [[Beam alloc] initBeamWithParent:beam3 destination:ccp(p.x + 64 + 256, p.y - 512)];
//    head = beam1;
//    beam1->next = beam2;
//    beam2->next = beam3;
//    beam3->next = beam4;
    

    
    return self;
}

-(void) raycast
{
    bool casting = true;
    float rotationRadians = rotation * M_PI / 180;
    CGPoint origin = ccp(p.x + roundf(cos(rotationRadians) * 128), p.y + roundf(-1 * sin(rotationRadians) * 128));
    CGPoint destination = ccp(p.x + roundf(cos(rotationRadians) * 5128), p.y + roundf(-1 * sin(rotationRadians) * 5128));
    Beam *newBeam = [[Beam alloc] initBeamWithOrigin:origin destination:destination];
    head = newBeam;
    
    CCLOG(@"Origin: %f %f Destination: %f %f", origin.x, origin.y, destination.x, destination.y);

    while(casting)
    {
        // need walls, floors and mirrors. hmm. slanted platforms fuck this up. 
        // they're glorified ladders, so can be skipped.
        float minDistance = 5000.0f;
        Platform *platformMatch = NULL;
        Mirror *mirrorMatch = NULL;
        
        if(newBeam->rotation == 180)
        {
            for(Platform *platform in platforms)
            {
                if(platform->type == S_WALL)
                {
                    if(newBeam->origin.x > platform->p.x && newBeam->destination.x <= platform->p.x
                       && newBeam->origin.y > platform->p.y && newBeam->origin.y < platform->p.y + platform->height)
                    {
                        if(origin.x - platform->p.x < minDistance)
                        {
                            platformMatch = platform;
                            minDistance = origin.x - platform->p.x;
                            mirrorMatch = NULL;
                        }
                    }
                }
            }
            for(Mirror *mirror in mirrors)
            {
                if(newBeam->origin.x > mirror->location.x && newBeam->destination.x <= mirror->location.x
                       && newBeam->origin.y > mirror->location.y - mirror->radius && newBeam->origin.y < mirror->location.y + mirror->radius)
                {
                    if(origin.x - mirror->location.x < minDistance)
                    {
                        mirrorMatch = mirror;
                        minDistance = origin.x - mirror->location.x;
                        platformMatch = NULL;
                    }
                }
            }
        }
        else if(newBeam->rotation == 0)
        {
            for(Platform *platform in platforms)
            {
                if(platform->type == S_WALL)
                {
                    if(newBeam->origin.x < platform->p.x && newBeam->destination.x >= platform->p.x
                       && newBeam->origin.y > platform->p.y && newBeam->origin.y < platform->p.y + platform->height)
                    {
                        if(platform->p.x - origin.x < minDistance)
                        {
                            platformMatch = platform;
                            minDistance = platform->p.x - origin.x;
                        }
                    }
                }
            }
            for(Mirror *mirror in mirrors)
            {
                if(newBeam->origin.x < mirror->location.x && newBeam->destination.x >= mirror->location.x
                   && newBeam->origin.y > mirror->location.y - mirror->radius && newBeam->origin.y < mirror->location.y + mirror->radius)
                {
                    if(mirror->location.x - origin.x < minDistance)
                    {
                        mirrorMatch = mirror;
                        minDistance = mirror->location.x - origin.x;
                        platformMatch = NULL;
                    }
                }
            }
        }
        else if(newBeam->rotation == 90)
        {
            for(Platform *platform in platforms)
            {
                if(platform->type == S_PLATFORM || platform->type == S_TWO_SIDED_PLATFORM || platform->type == S_FLOOR)
                {
                    if(newBeam->origin.y > platform->p.y && newBeam->destination.y <= platform->p.y
                       && newBeam->origin.x > platform->p.x && newBeam->origin.x < platform->p.x + platform->width)
                    {
                        if(origin.y - platform->p.y < minDistance)
                        {
                            platformMatch = platform;
                            minDistance = origin.y - platform->p.y;
                        }
                    }
                }
            }
            for(Mirror *mirror in mirrors)
            {
                if(newBeam->origin.y > mirror->location.y && newBeam->destination.y <= mirror->location.y
                   && newBeam->origin.x > mirror->location.x - mirror->radius && newBeam->origin.x < mirror->location.x + mirror->radius)
                {
                    if(origin.y - mirror->location.y < minDistance)
                    {
                        mirrorMatch = mirror;
                        minDistance = origin.y - mirror->location.y;
                        platformMatch = NULL;
                    }
                }
            }
        }
        else if(newBeam->rotation == 270)
        {
            for(Platform *platform in platforms)
            {
                if(platform->type == S_PLATFORM || platform->type == S_TWO_SIDED_PLATFORM || platform->type == S_FLOOR)
                {
                    if(newBeam->origin.y < platform->p.y && newBeam->destination.y >= platform->p.y
                       && newBeam->origin.x > platform->p.x && newBeam->origin.x < platform->p.x + platform->width)
                    {
                        if(platform->p.y - origin.y < minDistance)
                        {
                            platformMatch = platform;
                            minDistance = platform->p.y - origin.y;
                        }
                    }
                }
            }
            for(Mirror *mirror in mirrors)
            {
                if(newBeam->origin.y < mirror->location.y && newBeam->destination.y >= mirror->location.y
                   && newBeam->origin.x > mirror->location.x - mirror->radius && newBeam->origin.x < mirror->location.x + mirror->radius)
                {
                    if(mirror->location.y - origin.y < minDistance)
                    {
                        mirrorMatch = mirror;
                        minDistance = mirror->location.y - origin.y;
                        platformMatch = NULL;
                    }
                }
            }
        }
        
        if(mirrorMatch != NULL && platformMatch != NULL)
        {
            [NSException raise:@"Algorithm found both Mirror and Platform at minimum distance. That shouldn't happen." format:@""];
        }
        
        if(platformMatch != NULL)
        {
            if(newBeam->rotation == 0 || newBeam->rotation == 180)
            {
                newBeam->destination.x = platformMatch->p.x;
            }
            else if(newBeam->rotation == 90 || newBeam->rotation == 270)
            {
                newBeam->destination.y = platformMatch->p.y;
            }
            
            casting = false;
        }
        else if(mirrorMatch != NULL)
        {

            if(newBeam->rotation == 0 || newBeam->rotation == 180)
            {
                newBeam->destination.x = mirrorMatch->location.x;
            }
            else if(newBeam->rotation == 90 || newBeam->rotation == 270)
            {
                newBeam->destination.y = mirrorMatch->location.y;
            }
            
            if((mirrorMatch->rotation == 90 || mirrorMatch->rotation == 270) && newBeam->rotation == 180)
            {
                rotationRadians = 90 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 90 || mirrorMatch->rotation == 270) && newBeam->rotation == 0)
            {
                rotationRadians = 270 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 0 || mirrorMatch->rotation == 180) && newBeam->rotation == 180)
            {
                rotationRadians = 270 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 0 || mirrorMatch->rotation == 180) && newBeam->rotation == 0)
            {
                rotationRadians = 90 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 90 || mirrorMatch->rotation == 270) && newBeam->rotation == 90)
            {
                rotationRadians = 180 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 90 || mirrorMatch->rotation == 270) && newBeam->rotation == 270)
            {
                rotationRadians = 0 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 0 || mirrorMatch->rotation == 180) && newBeam->rotation == 90)
            {
                rotationRadians = 0 * M_PI / 180;
            }
            else if((mirrorMatch->rotation == 0 || mirrorMatch->rotation == 180) && newBeam->rotation == 270)
            {
                rotationRadians = 180 * M_PI / 180;
            }
            
            origin = ccp(mirrorMatch->location.x, mirrorMatch->location.y);
            destination = ccp(mirrorMatch->location.x + roundf(cos(rotationRadians) * 5000), mirrorMatch->location.y + roundf(-1 * sin(rotationRadians) * 5000));
            Beam *nextBeam = [[Beam alloc] initBeamWithOrigin:origin destination:destination];
            newBeam->next = nextBeam;
            newBeam = nextBeam;
        }
        else 
        {
            casting = false;
        }
    }
    
    
    //CCLOG(@"Adjusted Origin: %f %f Destination: %f %f", head->origin.x, head->origin.y, head->destination.x, head->destination.y);
    CCLOG(@"Done.");
    
    [self makeSprites];
}

-(void) makeSprites
{
    NSMutableArray *newBeamSprites = [[NSMutableArray alloc] init];
    
    if(beamSprites != Nil)
    {
        for(CCSprite *beamSprite in beamSprites)
        {
            [beamSprite removeFromParentAndCleanup:YES];
        }
    }
    
    Beam *beam = head;
    Beam *lastBeam = Nil;
    while(beam != Nil)
    {
        CCLOG(@"+beam at origin: %f,%f destination: %f,%f", beam->origin.x, beam->origin.y, beam->destination.x, beam->destination.y);
        CCSprite *beamSprite = [CCSprite spriteWithFile: @"Art/LaserBeam.png"];
        beamSprite.anchorPoint = ccp(0,0.50);
        
        
        
        int adjustmentX = 0;
        int adjustmentY = 0;

        if(beam->rotation == 0) adjustmentX = 4;
        if(beam->rotation == 90) adjustmentY = -4;
        if(beam->rotation == 180) adjustmentX = -4;
        if(beam->rotation == 270) adjustmentY = 4;
        float beamX = beam->origin.x + adjustmentX;// + cos(rotationRadians) * (beam->distance - distance + 512);
        float beamY = beam->origin.y + adjustmentY;// + sin(rotationRadians) * (beam->distance - distance + 512);
        beamSprite.position = ccp(beamX, beamY);
        
        [beamSprite setTextureRect:CGRectMake(0,0,[beam distance] - 8,512)];
    
        beamSprite.rotation = beam->rotation;
        [layer addChild:beamSprite];
        [layer reorderChild:beamSprite z:2];
        [newBeamSprites addObject:beamSprite];
        
        if(lastBeam != Nil && beam->rotation != lastBeam->rotation)
        {
            CCSprite *cornerSprite = [CCSprite spriteWithFile: @"Art/LaserCorner.png"];
            
            cornerSprite.position = beam->origin;
            if((beam->rotation == 90 && lastBeam->rotation == 0)
               || (beam->rotation == 180 && lastBeam-> rotation == 270))
            {
                cornerSprite.rotation = 0;
            }
            else if((beam->rotation == 180 && lastBeam->rotation == 90)
                    || (beam->rotation == 270 && lastBeam-> rotation == 0))
            {
                cornerSprite.rotation = 90;
            }
            else if((beam->rotation == 270 && lastBeam->rotation == 180)
                    || (beam->rotation == 0 && lastBeam-> rotation == 90))
            {
                cornerSprite.rotation = 180;
            }
            else if((beam->rotation == 0 && lastBeam->rotation == 270)
                    || (beam->rotation == 90 && lastBeam-> rotation == 180))
            {
                cornerSprite.rotation = 270;
            }
            [layer addChild:cornerSprite];
            [layer reorderChild:cornerSprite z:2];
            [newBeamSprites addObject:cornerSprite];
            
//            CCSprite *mirrorSprite = [CCSprite spriteWithFile: @"Art/Mirror.png"];
//            mirrorSprite.position = cornerSprite.position;
//            mirrorSprite.rotation = cornerSprite.rotation;
//            [layer addChild:mirrorSprite];
//            [layer reorderChild:mirrorSprite z:1];
//            [newBeamSprites addObject:mirrorSprite];


        }
        
        lastBeam = beam;
        beam = beam->next;
    }
    
    beamSprites = newBeamSprites;
}

-(void) rotateBeam
{
//    bool triggerDivide = false;
//    
//    for(CCSprite *beamSprite in beams)
//    {
//        beamSprite.rotation += 10;
//        if((int) beamSprite.rotation % 360 == 0)
//        {
//            triggerDivide = true;
//            float width = [beamSprite boundingBox].size.width;
//            CCLOG(@"Width: %f",width);
//        }
//    }
//    
//    if(triggerDivide)
//    {
//        NSMutableArray *newBeams = [[NSMutableArray alloc] init];
//        
//        for(CCSprite *beamSprite in beams)
//        {
//            int width = [beamSprite boundingBox].size.width;
//            if(width >= 64)
//            {
//                CCSprite *newSprite1 = [CCSprite spriteWithFile: @"Art/LaserBeam.png"];
//                newSprite1.anchorPoint = ccp(0,0.50);
//                newSprite1.position = ccp( beamSprite.position.x, beamSprite.position.y );
//                newSprite1.rotation = 0;
//                [newSprite1 setTextureRect:CGRectMake(0,0,width / 2,512)];
//                [layer addChild:newSprite1];
//                [layer reorderChild:newSprite1 z:2];
//                
//                CCSprite *newSprite2 = [CCSprite spriteWithFile: @"Art/LaserBeam.png"];
//                newSprite2.anchorPoint = ccp(0,0.50);
//                newSprite2.position = ccp( beamSprite.position.x + width / 2, beamSprite.position.y );
//                newSprite2.rotation = 0;
//                [newSprite2 setTextureRect:CGRectMake(0,0,width / 2,512)];
//                [layer addChild:newSprite2];
//                [layer reorderChild:newSprite2 z:2];
//                
//                [newBeams addObject:newSprite1];
//                [newBeams addObject:newSprite2];
//                
//                [beamSprite removeFromParentAndCleanup:YES];
//            }
//        }
//        
//        beams = newBeams;
//    }
    
}

-(bool) collisionWith: (WorldObject*) object time:(ccTime)dt
{
    return [head collisionWith:object time:dt];
}

-(void) drawBoundingBox
{
}


@end



@implementation Beam

-(id) initBeamWithParent:(Beam *)parent destination:(CGPoint)_destination
{
    return [self initBeamWithOrigin:parent->destination destination:_destination];
}

-(id) initBeamWithOrigin: (CGPoint)_origin destination:(CGPoint)_destination
{    
    origin = _origin;
    destination = _destination;
    next = Nil;
    
    if((origin.x == destination.x && origin.y == destination.y)
       || (origin.x != destination.x && origin.y != destination.y))
    {
        CCLOG(@"Origin: %f,%f Destination: %f,%f",origin.x,origin.y,destination.x,destination.y);
        [NSException raise:@"Invalid laser direction" format:@""];
    }
    
    if(origin.x < destination.x)
    {
        rotation = 0;
    }
    else if(origin.x > destination.x)
    {
        rotation = 180;
    }
    else if(origin.y < destination.y)
    {
        rotation = 270;
    }
    else if(origin.y > destination.y)
    {
        rotation = 90;
    }
    
    return self;
}

-(int) distance
{
    if(origin.x < destination.x)
    {
        return destination.x - origin.x;
    }
    else if(origin.x > destination.x)
    {
        return origin.x - destination.x;
    }
    else if(origin.y < destination.y)
    {
        return destination.y - origin.y;
    }
    else if(origin.y > destination.y)
    {
        return origin.y - destination.y;
    }
}

-(bool) collisionWith: (WorldObject*) object time:(ccTime)dt
{
    //cross the laser line with the box.
    //easy since for now, lasers are horizontal or vertical
    if((rotation == 90 || rotation == 270)
       && object->y + object->boxHeight > MIN(origin.y,destination.y)
       && object->y - object->boxHeight < MAX(origin.y,destination.y)
       && origin.x > object->x - object->boxWidth
       && origin.x < object->x + object->boxWidth)
    {
        return true;
    }
    else if((rotation == 0 || rotation == 180)
            && object->x + object->boxWidth > MIN(origin.x,destination.x)
            && object->x - object->boxWidth < MAX(origin.x,destination.x)
            && origin.y > object->y - object->boxHeight
            && origin.y < object->y + object->boxHeight)
    {
           return true;
    }
    //else look at the next
    else if(next != Nil)
    {
        return [next collisionWith:object time:dt];
    }
    else return false;
}

@end


@implementation Mirror

-(id) initMirrorWithLayer: (GameLayer*) _layer location: (CGPoint)_location rotation: (int) _rotation
{
    radius = 20.0f;
    
    if(rotation % 90 != 0)
    {
        [NSException raise:@"Invalid laser direction" format:@""];
    }
    
    rotation = _rotation % 360;
    location = _location;
    
    CCSprite *mirrorSprite = [CCSprite spriteWithFile: @"Art/Mirror.png"];
    mirrorSprite.position = location;
    mirrorSprite.rotation = rotation;
    [_layer addChild:mirrorSprite];
    [_layer reorderChild:mirrorSprite z:1];
    
    return self;
}

@end
