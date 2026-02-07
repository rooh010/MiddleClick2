//
//  MultitouchBridge.m
//  MiddleClick2
//
//  Objective-C bridge - keeps the C callback and device management in ObjC
//  where it's proven to work, and forwards events to Swift.
//

#import "MultitouchBridge.h"
#import "MultitouchSupport.h"

NSString *const MultitouchCallbackNotification = @"MultitouchCallbackNotification";
NSString *const MultitouchFingerCountKey = @"fingerCount";
NSString *const MultitouchFingerDataKey = @"fingerData";
NSString *const MultitouchTimestampKey = @"timestamp";

// Global state for callback
static MultitouchBridge *sharedBridge = nil;

// Plain C callback function - exactly like the original working code
int callback(int device, Finger *data, int nFingers, double timestamp, int frame) {
    if (sharedBridge) {
        // Post notification with finger data
        NSDictionary *userInfo = @{
            MultitouchFingerCountKey: @(nFingers),
            MultitouchTimestampKey: @(timestamp),
            MultitouchFingerDataKey: [NSValue valueWithPointer:data]
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:MultitouchCallbackNotification
                                                            object:nil
                                                          userInfo:userInfo];
    }
    return 0;
}

@implementation MultitouchBridge {
    NSMutableArray *_deviceList;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBridge = [[MultitouchBridge alloc] init];
    });
    return sharedBridge;
}

- (BOOL)startMonitoring {
    NSLog(@"MultitouchBridge: Starting monitoring...");

    // Get device list - exactly like original Controller.m
    // CFBridgingRelease transfers ownership to ARC
    _deviceList = (NSMutableArray *)CFBridgingRelease(MTDeviceCreateList());

    if ([_deviceList count] == 0) {
        NSLog(@"MultitouchBridge: No devices found!");
        return NO;
    }

    NSLog(@"MultitouchBridge: Found %lu device(s)", (unsigned long)[_deviceList count]);

    // Register callbacks for each device
    for (int i = 0; i < [_deviceList count]; i++) {
        MTRegisterContactFrameCallback((__bridge MTDeviceRef)[_deviceList objectAtIndex:i], callback);
        MTDeviceStart((__bridge MTDeviceRef)[_deviceList objectAtIndex:i], 0);
    }

    NSLog(@"MultitouchBridge: Monitoring started successfully");
    return YES;
}

- (void)stopMonitoring {
    NSLog(@"MultitouchBridge: Stopping monitoring...");

    for (int i = 0; i < [_deviceList count]; i++) {
        MTDeviceStop((__bridge MTDeviceRef)[_deviceList objectAtIndex:i]);
        MTUnregisterContactFrameCallback((__bridge MTDeviceRef)[_deviceList objectAtIndex:i], callback);
    }

    _deviceList = nil;

    NSLog(@"MultitouchBridge: Monitoring stopped");
}

- (void)restartDevices {
    NSLog(@"MultitouchBridge: Restarting devices...");

    for (int i = 0; i < [_deviceList count]; i++) {
        MTDeviceStop((__bridge MTDeviceRef)[_deviceList objectAtIndex:i]);
    }

    [NSThread sleepForTimeInterval:0.1];

    for (int i = 0; i < [_deviceList count]; i++) {
        MTRegisterContactFrameCallback((__bridge MTDeviceRef)[_deviceList objectAtIndex:i], callback);
        MTDeviceStart((__bridge MTDeviceRef)[_deviceList objectAtIndex:i], 0);
    }

    NSLog(@"MultitouchBridge: Devices restarted");
}

- (NSInteger)deviceCount {
    return [_deviceList count];
}

@end
