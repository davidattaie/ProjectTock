//
//  DAPTHelpers.m
//  Project Tock
//
//  Created by David Attaie on 04/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTHelpers.h"

@implementation DAPTHelpers

+(NSString *)formattedTimeStringForTime:(int)time
{
	if (time < 10)
	{
		return [NSString stringWithFormat:@"0%i", time];
	}
	
	return [NSString stringWithFormat:@"%i", time];
}

+(NSArray *)last10Objects:(NSArray *)array
{
	if (array.count < 10) {
		return array;
	}
	
	NSArray *newArray = [array subarrayWithRange:NSMakeRange(array.count-10, 10)];
	return newArray;
}

+(NSString *)lapStringForTime:(DAPTTimeValue)time
{
	return [NSString stringWithFormat:@"%@:%@:%@.%@",
			[DAPTHelpers formattedTimeStringForTime:time.hour],
			[DAPTHelpers formattedTimeStringForTime:time.minute],
			[DAPTHelpers formattedTimeStringForTime:time.second],
			[DAPTHelpers formattedTimeStringForTime:time.milisecond]];
}

+(NSString *)highestValuesFortime:(DAPTTimeValue)time
{
	if (time.hour > 0) {
		return [NSString stringWithFormat:@"%@h %@m", [DAPTHelpers formattedTimeStringForTime:time.hour],
				[DAPTHelpers formattedTimeStringForTime:time.minute]];
	}
	
	if (time.minute > 0) {
		return [NSString stringWithFormat:@"%@m %@s", [DAPTHelpers formattedTimeStringForTime:time.minute],
				[DAPTHelpers formattedTimeStringForTime:time.second]];
	}
	
	return [NSString stringWithFormat:@"%@s %@ms", [DAPTHelpers formattedTimeStringForTime:time.second],
			[DAPTHelpers formattedTimeStringForTime:time.milisecond]];
}

@end
