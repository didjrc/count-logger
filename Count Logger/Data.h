//
//  Data.h
//  Count Logger
//
//  Created by Jonathan Reid Chinen on 6/7/16.
//  Copyright © 2016 Jonathan Chinen. All rights reserved.
//
//  Handles properties for Data from Pebble to iPhone

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (readonly) uint32_t packetId;
@property (readonly) uint64_t timestamp;
@property (readonly) BOOL connectionStatus;
@property (readonly) uint32_t clicks; //count value of # of clicks from Pebble

- (instancetype)initWithBytes:(const UInt8 *const)bytes andLength:(NSUInteger)length;
- (void)log;

@end
