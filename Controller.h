//
//  Controller.h
//  MiddleClick
//
//  Created by Alex Galonsky on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Controller : NSObject {
	NSMutableArray *deviceList;
}

- (void) start;
- (void) restartMultitouchDevices;
- (void)setMode:(BOOL)click;
- (BOOL)getClickMode;

@end
