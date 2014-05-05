//
//  DAPTTimerSession.h
//  Project Tock
//
//  Created by David Attaie on 03/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import <Foundation/Foundation.h>

struct DAPTTimeValue{
	int hour;
	int minute;
	int second;
	int milisecond;
	double duration;
};
typedef struct DAPTTimeValue DAPTTimeValue;

@interface DAPTTimerSession : NSObject

@property (nonatomic, readonly) DAPTTimeValue time;

-(void)resetTimer;
-(void)calculateUpdate;
-(void)stop;
-(void)start;

@end
