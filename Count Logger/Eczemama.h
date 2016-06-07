//
//  Eczemama.h
//  Count Logger
//
//  Created by Jonathan Reid Chinen on 6/7/16.
//  Copyright © 2016 Jonathan Chinen. All rights reserved.
//

#import <PebbleKit/PebbleKit.h>

extern NSUUID *EczemamaAppUUID;
extern NSString *const EczemamaDataUpdatedNotification;

//creates object Tricorder for datalogging
@interface Eczemama : NSObject <PBDataLoggingServiceDelegate>

@property (readonly) NSMutableArray *recordedData;
@property (readonly) NSInteger crcMismatches;
@property (readonly) NSInteger duplicatePackets;
@property (readonly) NSInteger outOfOrderPackets;
@property (readonly) NSInteger missingPackets;

+ (instancetype)sharedEczemama;

- (NSString *)connectionStatus;
- (uint32_t)latestPacketId;
- (NSString *)latestPacketTime;
- (NSUInteger)numberOfLogs;
- (void)resetData;

@end