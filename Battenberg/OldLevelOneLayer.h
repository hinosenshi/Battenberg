
/*
 // on "init" you need to initialize your instance
 -(id) init
 {
 // always call "super" init
 // Apple recommends to re-assign "self" with the "super" return value
 if( (self=[super init])) {
 
 CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(167, 202, 187, 255) width:3072 height:1536];
 [self addChild:colorLayer z:-1];
 
 // background sprite
 //backgroundSprite = [CCSprite spriteWithFile: @"Art/bg.png"];
 //backgroundSprite.position = ccp( 3072 / 2.0, 1536 / 2.0 );
 //[self addChild:backgroundSprite];
 //[self reorderChild:backgroundSprite z:-1];
 
 // Define the gravity vector.
 //b2Vec2 gravity;
 //gravity.Set(0.0f, -40.0f);
 
 gravity = -9.8f * 84.0f * 1.25f;  // 9.8 m/s^2, and a meter is 84 pix, and I'm scaling it up by 25%
 friction = 0.85f;
 
 // Do we want to let bodies sleep?
 // This will speed up the physics simulation
 bool doSleep = true;
 
 platforms = [[NSMutableArray alloc] init];
 
 [self buildLevel];
 
 
 //bear = [[Bear alloc] initWithLayer:self location:ccp(80,1350)];
 //boy = [[Boy alloc] initWithLayer:self location:ccp(350,1450)];
 bear = [[Bear alloc] initWithLayer:self location:ccp(80,150)];
 boy = [[Boy alloc] initWithLayer:self location:ccp(350,50)];
 
 boyStartTime = [[NSDate date] retain];
 
 control = [[Control alloc] initWithLayer:self];
 
 //so much cake
 items = [[NSMutableArray alloc] init];
 [items addObject:bear];
 [items addObject:boy];
 //        [items addObject:[[Cake alloc] initWithLayer:self location:ccp(80, 1350)]];
 //        [items addObject:[[Cake alloc] initWithLayer:self location:ccp(1280, 1350)]];
 //        [items addObject:[[Cake alloc] initWithLayer:self location:ccp(1680, 1350)]];
 //        [items addObject:[[Cake alloc] initWithLayer:self location:ccp(800, 100)]];
 //        [items addObject:[[Cake alloc] initWithLayer:self location:ccp(150, 100)]];
 //        [items addObject:[[Cake alloc] initWithLayer:self location:ccp(2800, 100)]];
 
 
 
 float margin = 100.0f;
 [self runAction:[CCFollow actionWithTarget:bear->sprite
 worldBoundary:CGRectMake(-1 * margin,-1 * margin,3072 + margin,1536 + 200)]];
 
 
 
 CCLabelTTF *label = [CCLabelTTF labelWithString:@"Test Engine" fontName:@"American Typewriter" fontSize:32];
 [self addChild:label z:0];
 [label setColor:ccc3(128,128,128)];
 label.position = ccp( screenSize.width/2, screenSize.height-50);
 
 [self schedule: @selector(tick:)];
 }
 return self;
 }

 */






/*-(void) buildLevel
 {
 //floor
 [platforms addObject:[[Platform alloc] initFloorWithLayer:self location:ccp(0,0) width:3072/scale]];
 
 [LevelBuilder addCardTableToLayer:self location:ccp(320,0)];
 [LevelBuilder addCardTableToLayer:self location:ccp(820,0)];
 [LevelBuilder addFilingCabinetToLayer:self location:ccp(620,0)];
 [LevelBuilder addComputerToLayer:self location:ccp(1200,0)];
 [LevelBuilder addComputerToLayer:self location:ccp(1100,1236)];
 
 //ceiling
 [platforms addObject:[[Platform alloc] initTwoSidedPlatformWithLayer:self location:ccp(0, 1536/scale) width:3072/scale]];
 
 //left wall
 [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(0, 0) height:1536/scale left:true]];
 
 //right wall
 [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(3072/scale, 0) height:1536/scale left:false]];
 
 //leftmost two platforms
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(0, 1236/scale) width:400/scale]];
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(0, 668/scale) width:350/scale]];
 
 //middle platform with chemistry set
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(390/scale, 986/scale) width:500/scale]];
 
 [LevelBuilder addCardTableToLayer:self location:ccp(510,986)];
 
 //platform with computer A
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(860/scale, 1236/scale) width:400/scale]];
 
 //descending 1
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(370/scale, 450/scale) width:350/scale]];
 
 //descending 2
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(740/scale, 250/scale) width:250/scale]];
 
 //guarded platform with computer B
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(1200/scale, 450/scale) width:600/scale]];
 [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(1200/scale, 450/scale) height:32/scale left:true]];
 [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(1800/scale, 450/scale) height:32/scale left:false]];
 
 //stairway down to the bottom right
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(2000/scale, 450/scale) width:200/scale]];
 [platforms addObject:[[Platform alloc] initWallWithLayer:self location:ccp(2000/scale, 450/scale) height:32/scale left:true]];
 [platforms addObject:[[Platform alloc] initSlantedPlatformWithLayer:self fromStart:ccp(2200/scale,450/scale) toEnd:ccp(2425/scale,225/scale)]];
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(2425/scale, 225/scale) width:200/scale]];
 [platforms addObject:[[Platform alloc] initSlantedPlatformWithLayer:self fromStart:ccp(2625/scale,225/scale) toEnd:ccp(2850/scale,0)]];
 
 //ascending to computer
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(2400/scale, 675/scale) width:200/scale]];
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(2650/scale, 925/scale) width:200/scale]];
 
 //platform with computer C
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(2125/scale, 1175/scale) width:400/scale]];
 
 //final platform outside the level
 [platforms addObject:[[Platform alloc] initPlatformWithLayer:self location:ccp(3072/scale, 1175/scale) width:600/scale]];
 }
 */

