//
//  Eczemama.m
//  Count Logger
//
//  Created by Jonathan Reid Chinen on 6/7/16.
//  Copyright © 2016 Jonathan Chinen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Eczemama.h"

#import "AppDelegate.h"
#import "Data.h"


NSUUID *EczemamaAppUUID;
NSString *const EczemamaDataUpdatedNotification = @"tricorderUpdated";

@interface Eczemama ()

@property NSMutableArray *packetIds;

@end

@implementation Eczemama

//+ (void)load {
//	EczemamaAppUUID = [[NSUUID alloc] initWithUUIDString:@"8956c2d3-c9d5-4826-a7ca-df4943c514de"];
//}

+ (instancetype)sharedEczemama {
	static Eczemama *sharedEczemama = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedEczemama = [[self alloc] init];
	});
	return sharedEczemama;
}

- (instancetype)init {
	if (self = [super init]) {
		_recordedData = [[NSMutableArray alloc] init];
		_packetIds = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSString *)connectionStatus {
	return self.latestData.connectionStatus ? @"Connected" : @"Disconnected";
}

- (uint32_t)latestPacketId {
	return self.latestData.packetId;
}

- (NSString *)latestPacketTime {
	if (_recordedData.count == 0) {
		return @"N/A";
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, h:mm:ss.SSS"];
	return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.latestData.timestamp / 1000]];
}

- (NSUInteger)numberOfLogs {
	return _recordedData.count;
}

- (Data *)latestData {
	return _recordedData.firstObject;
}

- (void)resetData {
	_crcMismatches = 0;
	_duplicatePackets = 0;
	_outOfOrderPackets = 0;
	_missingPackets = 0;
	[_recordedData removeAllObjects];
	[_packetIds removeAllObjects];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:EczemamaDataUpdatedNotification object:self];
}

#pragma mark - PBDataLoggingServiceDelegate

- (BOOL)dataLoggingService:(PBDataLoggingService *)service
			 hasByteArrays:(const UInt8 *const)bytes
			 numberOfItems:(UInt16)numberOfItems
	 forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
	for (NSUInteger i = 0; i < numberOfItems; i++) {
		const uint8_t *logBytes = &bytes[i * session.itemSize];
		
		Data *data = [[Data alloc] initWithBytes:logBytes andLength:session.itemSize];
		[data log];
		
		if (data.packetId == 1) {
			[self resetData];
		}
		
		if (data.packetId < self.latestPacketId) {
			_outOfOrderPackets++;
		}
		
		if ([_packetIds containsObject:@(data.packetId)]) {
			_duplicatePackets++;
		}
		
		[_packetIds addObject:@(data.packetId)];
		
		[_recordedData insertObject:data atIndex:0];
	}
	
	_missingPackets = [[_packetIds valueForKeyPath:@"@max.self"] intValue] - (_recordedData.count - _duplicatePackets);
	
	return YES;
}

- (void)dataLoggingService:(PBDataLoggingService *)service
		  sessionDidFinish:(PBDataLoggingSessionMetadata *)session {
	[[NSNotificationCenter defaultCenter] postNotificationName:EczemamaDataUpdatedNotification object:self];
}

@end
