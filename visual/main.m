//
//  main.m
//  Fx
//
//  Created by tehis on 17/03/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "View.h"

#define WIDTH				800
#define HEIGHT				600
#define FRAME_RATE			25
#define K_RATE				4400


@interface App : NSApplication
	View* window;
	NSTimer* timer;
	NSTimer* somTimer;
@end

@implementation App
- (id) init
{
	self = [super init];

	[self setDelegate: self];
	
	return self;
}

- (void) dealloc
{
	[timer invalidate];
	[timer release];
	
	[somTimer invalidate];
	[somTimer release];

	[window release];
	
	[super dealloc];
}

- (void) applicationWillFinishLaunching: (NSNotification*) notification
{
	window = [[View alloc] initWithFrame: NSMakeRect(1440,0,WIDTH,HEIGHT)];
}

- (void) update : (id) object
{
	[window drawFrame];
	if ([window done] == 1) 
	{
		[super terminate: self];
	}
}

- (void) trainSom : (id) object
{
	[window trainSom];
}

- (void) applicationDidFinishLaunching: (NSNotification*) notification
{
	timer = [[NSTimer scheduledTimerWithTimeInterval: (1.0f / FRAME_RATE) target: self selector:@selector(update:) userInfo:self repeats:YES] retain];
	somTimer = [[NSTimer scheduledTimerWithTimeInterval: (1.0f / K_RATE) target: self selector:@selector(trainSom:) userInfo:self repeats:YES] retain];
	[window makeKeyAndOrderFront: nil];
}

	
@end

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
