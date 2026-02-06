//
//  WakeObserver.h
//
//  Created by Clem on 18.10.09.
//

#import <Cocoa/Cocoa.h>

@class Controller;

@interface WakeObserver : NSObject {
	Controller *controller;
}

- (id) initWithController:(Controller *)ctrl;
- (void) receiveWakeNote: (NSNotification*) note;

@end
