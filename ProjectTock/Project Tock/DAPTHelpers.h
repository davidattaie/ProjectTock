//
//  DAPTHelpers.h
//  Project Tock
//
//  Created by David Attaie on 04/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPTTimerSession.h"

@interface DAPTHelpers : NSObject

+(NSString *)formattedTimeStringForTime:(int)time;
+(NSArray *)last10Objects:(NSArray *)array;
+(NSString *)lapStringForTime:(DAPTTimeValue)time;
+(NSString *)highestValuesFortime:(DAPTTimeValue)time;

@end
