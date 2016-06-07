//
//  Data.m
//  Count Logger
//
//  Created by Jonathan Reid Chinen on 6/7/16.
//  Copyright © 2016 Jonathan Chinen. All rights reserved.
//
//  Handles properties for Data from Pebble to iPhone

#import "Data.h"

static NSUInteger const DataLength = 31;

@implementation Data

- (instancetype)initWithBytes:(const UInt8 *const)bytes andLength:(NSUInteger)length {
	if (self = [super init]) {
		if (length != DataLength) {
			NSLog(@"TricorderData size mismatch: got %lu but expected %lu", (unsigned long)length, (unsigned long)DataLength);
			return nil;
		}
		
		NSMutableData *data = [NSMutableData dataWithBytes:bytes length:length];
		
		const void *subdataBytes;
		NSRange range = {0, 0};
		
		range.location += range.length;
		range.length = 4;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_packetId = CFSwapInt32LittleToHost(*(uint32_t*)subdataBytes);
		
		range.location += range.length;
		range.length = 4;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_timestamp = CFSwapInt64LittleToHost(*(uint64_t*)subdataBytes) * 1000;
		
		range.location += range.length;
		range.length = 2;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_timestamp += CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);
		
		range.location += range.length;
		range.length = 1;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_clicks = CFSwapInt32LittleToHost(*(uint32_t*)subdataBytes);
		
		[data replaceBytesInRange:range withBytes:NULL length:range.length];
		
	}
	
	return self;
}

- (void)log {
	NSLog(@"=========================================================================");
	NSLog(@"packet_id:\t\t\t%d", _packetId);
	NSLog(@"timestamp:\t\t\t%llu", _timestamp);
	NSLog(@"crc32_pebble:\t\t\t%d", _clicks);
}

@end
