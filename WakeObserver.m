//
//  WakeObserver.m
//
//  Created by Clem on 18.10.09.
//

#import "WakeObserver.h"
#import "Controller.h"


@implementation WakeObserver

- (id) initWithController:(Controller *)ctrl
{
	self = [super init];
	if (self != nil)
	{
		controller = [ctrl retain];
	}
	return self;
}

- (void) dealloc
{
	[controller release];
	[super dealloc];
}

- (void) receiveWakeNote: (NSNotification*) note
{
	NSLog(@"Received wake notification: %@", [note name]);

	// Restart multitouch devices after a short delay to ensure system is ready
	[self performSelector:@selector(restartDevices) withObject:nil afterDelay:0.5];
}

- (void) restartDevices
{
	[controller restartMultitouchDevices];
}


@end
