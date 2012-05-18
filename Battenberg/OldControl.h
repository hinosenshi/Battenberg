////
////  Control.mm
////  Battenberg
////
////  Created by Matthew Carlin on 3/19/12.
////  Copyright Expression Games 2012. All rights reserved.
////
//
//#import "Control.h"
//
//@implementation Control
//
//-(id) initWithLayer: (GameLayer*) the_layer
//{
//    layer = the_layer;
//    bear = layer->bear;
//    boy = layer->boy;
//    
//    NSLog(@"here i am");
//    
//    leftTouch = false;
//    rightTouch = false;
//    jumpingGesture = false;
//    
//    return self;
//}
//
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    CGPoint location = [touch locationInView: [touch view]];
//    
//    location = [[CCDirector sharedDirector] convertToGL: location];
//    
//    
////    if(location.y > 700 && location.x < 100)
////    {
////        boy->walkSpeed += -0.1f;
////        CCLOG(@"Boy walk speed: %0.2f", boy->walkSpeed);
////        return false;
////    }
////    
////    if(location.y > 700 && location.x > 924)
////    {
////        boy->walkSpeed += 0.1f;
////        CCLOG(@"Boy walk speed: %0.2f", boy->walkSpeed);
////        return false;
////    }
////    
////    if(location.y > 700 && location.x > 412 && location.x < 612)
////    {
////        if(boy->direction == 1)
////        {
////            [boy faceLeft];
////        }
////        else if(boy->direction == -1)
////        {
////            [boy faceRight];
////        }
////        return false;
////    }
//    
//    location.x = location.x - layer.position.x;
//    location.y = location.y - layer.position.y;
//
//    if(location.x > bear->x + bear->boxWidth)
//    {
//        leftTouch = false;
//        rightTouch = true;
//    }
//    else if(location.x < bear->x - bear->boxWidth)
//    {
//        rightTouch = false;
//        leftTouch = true;
//    }
//    
//    return true;
//}
//
//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    CGPoint location = [touch locationInView: [touch view]];
//    
//    location = [[CCDirector sharedDirector] convertToGL: location];
//    location.x = location.x - layer.position.x;
//    location.y = location.y - layer.position.y;
//    
//    CGPoint oldLocation = [touch previousLocationInView:touch.view];
//    oldLocation = [[CCDirector sharedDirector] convertToGL:oldLocation];
//    oldLocation.x = oldLocation.x - layer.position.x;
//    oldLocation.y = oldLocation.y - layer.position.y;
//    
//    if(location.x > bear->x + bear->boxWidth)
//    {
//        leftTouch = false;
//        rightTouch = true;
//    }
//    else if(location.x < bear->x - bear->boxWidth)
//    {
//        rightTouch = false;
//        leftTouch = true;
//    }
//    
//    // float distance = (float) sqrt((location.x - oldLocation.x) * (location.x - oldLocation.x)
//    //                              + (location.y - oldLocation.y) * (location.y - oldLocation.y));
//    // if(distance > 10 && location.y > oldLocation.y + 2)
//    if(location.y > oldLocation.y + 10 && bear->platform != NULL && !bear->jumping)
//    {
//        //jumpValueX = 30.0f * (location.x - oldLocation.x) / distance;
//        //jumpValueY = 30.0f * (location.y - oldLocation.y) / distance;
//        //CCLOG(@"Jumpvalues %0.2f %0.2f",distance,location.y - oldLocation.y);
//        jumpingGesture = true;
//    }
//}
//
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    leftTouch = false;
//    rightTouch = false;
//    jumpingGesture = false;
//}
//
//- (void)updateControl
//{    
//    if(leftTouch)
//    {
//        [bear faceLeft];
//        bear->vx = -1 * bear->walkSpeed;
//    }
//    else if(rightTouch)
//    {
//        [bear faceRight];
//        bear->vx = bear->walkSpeed;
//    }
//    else
//    {
//        [bear stand];
//    }
//
//    if(!bear->jumping && jumpingGesture)
//    {
//        bear->vy = bear->jumpPower;
//        jumpingGesture = false;
//        bear->jumping = true;
//        bear->falling = true;
//    }
//
////    if(bear->jumping && bear->vy == 0) //should be platform contact
////    {
////        bear->jumping = false;
////    }
////    
//    float randomWalk = (float)rand()/(float)RAND_MAX;
//    if(randomWalk > 1.994)
//    {
//        if(boy->direction == 0)
//        {
//            [boy faceLeft];
//        }
//        else 
//        {
//            [boy stand];
//        }
//    }
//    else if(randomWalk > 1.975)
//    {
//        if(boy->direction == 1)
//        {//96.1
//            
//            [boy faceLeft];
//        }
//        else if(self->layer->boy->direction == -1)
//        {
//            [boy faceRight];
//        }
//    }
//    
//    if(boy->direction == 1)
//    {
//        boy->vx = boy->walkSpeed;
//    }
//    else if(boy->direction == -1)
//    {
//        boy->vx = -1 * boy->walkSpeed;
//    }
//
//}
//
//@end
