//
//  MultitouchBridge.h
//  MiddleClick2
//
//  Objective-C bridge that handles device registration and C callbacks,
//  forwarding touch events to Swift via NotificationCenter.
//

#ifndef MultitouchBridge_h
#define MultitouchBridge_h

#import <Foundation/Foundation.h>

@interface MultitouchBridge : NSObject

+ (instancetype)shared;
- (BOOL)startMonitoring;
- (void)stopMonitoring;
- (void)restartDevices;
- (NSInteger)deviceCount;

@end

// Notification posted when touch data arrives
extern NSString *const MultitouchCallbackNotification;
extern NSString *const MultitouchFingerCountKey;
extern NSString *const MultitouchFingerDataKey;
extern NSString *const MultitouchTimestampKey;

#endif /* MultitouchBridge_h */
