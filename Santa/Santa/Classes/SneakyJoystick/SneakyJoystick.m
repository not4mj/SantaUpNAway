//
//  joystick.m
//  SneakyJoystick
//
//  Created by Nick Pannuto.
//  2/15/09 verion 0.1
//  
//  WIKI: http://wiki.github.com/sneakyness/SneakyJoystick/
//  HTTP SRC: http://github.com/sneakyness/SneakyJoystick.git
//  GIT: git://github.com/sneakyness/SneakyJoystick.git
//  Email: SneakyJoystick@Sneakyness.com 
//  IRC: #cocos2d-iphone irc.freenode.net

#import "SneakyJoystick.h"
#import "Constants.h"

#define SJ_PI 3.14159265359f
#define SJ_PI_X_2 6.28318530718f
#define SJ_RAD2DEG 180.0f/SJ_PI
#define SJ_DEG2RAD SJ_PI/180.0f

@interface SneakyJoystick(hidden)
- (void)updateVelocity:(CGPoint)point;
- (void)setTouchRadius;
@end

@implementation SneakyJoystick

@synthesize
gameDelegate,
stickPosition,
degrees,
velocity,
autoCenter,
isDPad,
hasDeadzone,
numberOfDirections,
joystickRadius,
thumbRadius,
deadRadius,
arrow,
isEnabled;

- (void) dealloc
{
	[super dealloc];
}

-(id)initWithRect:(CGRect)rect
{
	self = [super init];
	if(self){
		stickPosition = CGPointZero;
		degrees = 0.0f;
		velocity = CGPointZero;
		autoCenter = YES;
		isDPad = NO;
		hasDeadzone = NO;
		numberOfDirections = 4;
		isEnabled = YES;
		self.joystickRadius = rect.size.width/2;
		self.thumbRadius = 32.0f;
		self.deadRadius = 0.0f;
		
        
        arrow = [Arrow arrow];
        arrow.position = ccp(0, 0);
        [self addChild:arrow];
    
         
        
		//Cocos node stuff
		position_ = rect.origin;
}
	return self;
}

- (void) onEnterTransitionDidFinish
{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
#endif
}

- (void) onExit
{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
#endif
}


-(void)updateVelocity:(CGPoint)point
{
//NSLog(@"point x %f y%f",point.x,point.y);
	// Calculate distance and angle from the center.
	float dx = point.x;
	float dy = point.y;
//NSLog(@"dx %f dy%f",dx,dy);
	float dSq = dx * dx + dy * dy;
	
	if(dSq <= deadRadiusSq){
		velocity = CGPointZero;
		degrees = 0.0f;
		stickPosition = point;
        [self.gameDelegate stopUpdate];
		return;
	}

	float angle = atan2f(dy, dx); // in radians
	if(angle < 0){
		angle+= SJ_PI_X_2;
	}
    
	float cosAngle;
	float sinAngle;
	
    CGFloat offsetAngle = 45 * SJ_DEG2RAD;
	if(isDPad)
    {
		float anglePerSector = 360.0f / 4 * SJ_DEG2RAD;
		angle = roundf((angle - offsetAngle)/anglePerSector) * anglePerSector;
        angle += offsetAngle;
	}
	
	cosAngle = cosf(angle);
	sinAngle = sinf(angle);
	
	// NOTE: Velocity goes from -1.0 to 1.0.
	if (dSq > joystickRadiusSq || isDPad) {
		dx = cosAngle * joystickRadius * 0.6;
		dy = sinAngle * joystickRadius * 0.6;
	}
	
	velocity = CGPointMake(dx/joystickRadius, dy/joystickRadius);
	degrees = angle * SJ_RAD2DEG;
//NSLog(@"degrees %f",degrees);
	// Update the thumb's position
	stickPosition = ccp(dx, dy);
    
    //EMoveDirection sneakyJoystickDirection;
    if (degrees >= 0 &&  degrees < 90)
    {
        CCAnimate *animate = [CCAnimate actionWithAnimation:arrow.animationUpperRight];
        [arrow runAction:animate];

        [self.gameDelegate updateJoystikDirection:MoveDirectionUpperRight];
    }
    else if (degrees >= 90 &&  degrees < 180)
    { 
        CCAnimate *animate = [CCAnimate actionWithAnimation:arrow.animationLowerRight];
        [arrow runAction:animate];

        [self.gameDelegate updateJoystikDirection:MoveDirectionUpperLeft];
    }
    else if (degrees >= 180 &&  degrees < 270)
    {
        CCAnimate *animate = [CCAnimate actionWithAnimation:arrow.animationLowerLeft];
        [arrow runAction:animate];

        [self.gameDelegate updateJoystikDirection:MoveDirectionLowerLeft];
    }
    else 
    {
        CCAnimate *animate = [CCAnimate actionWithAnimation:arrow.animationUpperLeft];
        [arrow runAction:animate];

        [self.gameDelegate updateJoystikDirection:MoveDirectionLowerRight];
    }
}

- (void) setIsDPad:(BOOL)b
{
	isDPad = b;
	if(isDPad){
		hasDeadzone = YES;
		self.deadRadius = 10.0f;
	}
}

- (void) setJoystickRadius:(float)r
{
	joystickRadius = r;
	joystickRadiusSq = r*r;
}

- (void) setThumbRadius:(float)r
{
	thumbRadius = r;
	thumbRadiusSq = r*r;
}

- (void) setDeadRadius:(float)r
{
	deadRadius = r;
	deadRadiusSq = r*r;
}

#pragma mark Touch Delegate

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isEnabled)
    {
        
        CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        //if([background containsPoint:[background convertToNodeSpace:location]]){
        location = [self convertToNodeSpace:location];
        
        //Do a fast rect check before doing a circle hit check:
        //if(location.x < -joystickRadius || location.x > joystickRadius || location.y < -joystickRadius || location.y > joystickRadius)
        if(location.x > 150 || location.y > 140 )
        {
            return NO;
        }else{
            [gameDelegate moveMapBack];
            //float dSq = location.x*location.x + location.y*location.y;
            //if(joystickRadiusSq > dSq){
			[self updateVelocity:location];
			return YES;
            //}
        }
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isEnabled)
    {
    
        CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        location = [self convertToNodeSpace:location];
        [self updateVelocity:location];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isEnabled)
    {
        CCAnimate *animate = [CCAnimate actionWithAnimation:arrow.animationNone];
        [arrow runAction:animate];
        
        CGPoint location = CGPointZero;
        if(!autoCenter){
            CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
            location = [self convertToNodeSpace:location];
        }
        [self updateVelocity:location];
        [self.gameDelegate stopUpdate];  
    }
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isEnabled)
    {
       [self ccTouchEnded:touch withEvent:event]; 
    }
}
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
#endif

@end
