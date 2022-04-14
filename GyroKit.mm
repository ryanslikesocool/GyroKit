#import <CoreMotion/CoreMotion.h>
#import "UnityAppController.h"

@protocol RotationDelegate <NSObject>
-(void) rotationUpdated:(double)x y:(double)y z:(double)z;
@end

// --------------------------------------------------------------------------------------

@interface GyroMotion : NSObject

@property (strong, nonatomic) CMMotionManager *motionManager;

-(void) setRotationDelegate:(id<RotationDelegate>) rotationDelegate;
-(void) startTracking;
-(void) stopTracking;

@end

// --------------------------------------------------------------------------------------

@implementation GyroMotion : NSObject

@synthesize motionManager;

bool _tracking;

id __rotationDelegate = nil;

static GyroMotion *_instance;
+(GyroMotion*) instance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[GyroMotion alloc] init];
	});
	return _instance;
}

-(id) init
{
	self = [super init];
	if (self)
	{
		// Instantiate the motion manager, and assign self as the delegate.
		self.motionManager = [[CMMotionManager alloc] init];

		NSLog(@"GyroMotion init complete");
	}

	return self;
}

-(void) startTracking
{
	if (_tracking == false)
	{
		if(motionManager.isDeviceMotionAvailable) {
			NSLog(@"Motion is available. Started tracking motion");
			[motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
											   withHandler:^(CMDeviceMotion *motion, NSError *error)
			 {
				if (motion)
				{
					if (__rotationDelegate)
					{
						[__rotationDelegate rotationUpdated:motion.rotationRate.x
														  y:motion.rotationRate.y
														  z:motion.rotationRate.z];
					}
				}
			}];

			_tracking = true;

		} else {
			NSLog(@"Motion is not available");
		}
	}
}

-(void) stopTracking
{
	if (_tracking)
	{
		NSLog(@"Stopped tracking motion");

		[motionManager stopDeviceMotionUpdates];

		_tracking = false;
	}
}

-(void) setRotationDelegate:(id<RotationDelegate>) rotationDelegate {
	__rotationDelegate = rotationDelegate;
	NSLog(@"Set the rotation delegate");
}

-(void) setUpdateInterval:(double)dt {
	motionManager.deviceMotionUpdateInterval = dt;
}

-(bool) isDeviceMotionAvailable {
	if (motionManager.isDeviceMotionAvailable)
		return true;
	else
		return false;
}

@end

// C Link --------------------------------------------------------------------------------------

extern "C" {
typedef void (*RotationDelegateCallback)(double x, double y, double z);
RotationDelegateCallback rotationDelegate = NULL;

@interface RotationDelegateUnityBridge : NSObject<RotationDelegate>
@end
static RotationDelegateUnityBridge *_rotationDelegate = nil;

bool isDeviceMotionAvailable() {
	return [[GyroMotion instance] isDeviceMotionAvailable];
}

void startTracking() {
	[[GyroMotion instance] startTracking];
}

void stopTracking() {
	[[GyroMotion instance] stopTracking];
}

void setRotationDelegate(RotationDelegateCallback callback) {
	if (!_rotationDelegate) {
		_rotationDelegate = [[RotationDelegateUnityBridge alloc] init];
	}

	[[GyroMotion instance] setRotationDelegate:_rotationDelegate];

	rotationDelegate = callback;
}

void setUpdateInterval(double dt) {
	[[GyroMotion instance] setUpdateInterval:dt];
}

@implementation RotationDelegateUnityBridge
-(void) rotationUpdated: (double)x y:(double)y z:(double)z {
	if (rotationDelegate != NULL) {
		rotationDelegate(x, y, z);
	}
}
@end
}
