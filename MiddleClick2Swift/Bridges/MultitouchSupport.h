//
//  MultitouchSupport.h
//  MiddleClick2
//
//  C bridging header for private MultitouchSupport framework
//  Ported from Controller.m:24-58
//

#ifndef MultitouchSupport_h
#define MultitouchSupport_h

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

// Multitouch point structures
typedef struct {
    float x, y;
} mtPoint;

typedef struct {
    mtPoint pos;
    mtPoint vel;
} mtReadout;

// Finger data structure
typedef struct {
    int frame;
    double timestamp;
    int identifier;
    int state;
    int foo3;
    int foo4;
    mtReadout normalized;
    float size;
    int zero1;
    float angle;
    float majorAxis;
    float minorAxis;
    mtReadout mm;
    int zero2[2];
    float unk2;
} Finger;

// Multitouch device reference
typedef void* MTDeviceRef;

// Callback function type
typedef int (*MTContactCallbackFunction)(int, Finger*, int, double, int);

#ifdef __cplusplus
extern "C" {
#endif

// MultitouchSupport framework functions
MTDeviceRef MTDeviceCreateDefault(void);
CFMutableArrayRef MTDeviceCreateList(void);
void MTRegisterContactFrameCallback(MTDeviceRef, MTContactCallbackFunction);
void MTUnregisterContactFrameCallback(MTDeviceRef, MTContactCallbackFunction);
void MTDeviceStart(MTDeviceRef, int);
void MTDeviceStop(MTDeviceRef);
BOOL MTDeviceIsBuiltIn(MTDeviceRef) __attribute__((weak_import));

#ifdef __cplusplus
}
#endif

// Objective-C bridge for device management and callbacks
#import "MultitouchBridge.h"

#endif /* MultitouchSupport_h */
