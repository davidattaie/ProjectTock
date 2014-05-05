//
//  DAPTTimerSession.m
//  Project Tock
//
//  Created by David Attaie on 03/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTTimerSession.h"

@interface DAPTTimerSession()

@property (nonatomic, readwrite) DAPTTimeValue time;

@property (nonatomic) double lastSavedTime;
@property (nonatomic) CFAbsoluteTime startTime;
@property (nonatomic) BOOL isRunning;

@end

@implementation DAPTTimerSession

-(void)resetTimer
{
	[self start];
	self.lastSavedTime = 0;
	DAPTTimeValue time = self.time;
	time.duration = 0;
	time.hour = 0;
	time.minute = 0;
	time.second = 0;
	time.milisecond = 0;
	self.time = time;
}

-(void)stop
{
	CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
	double difference = now - self.startTime; //difference in seconds
	self.lastSavedTime += difference;
	self.isRunning = NO;
}

-(void)start
{
	self.startTime = CFAbsoluteTimeGetCurrent();
	self.isRunning = YES;
}

-(void)calculateUpdate
{
	if (self.isRunning) {
		CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
		double difference = now - self.startTime + self.lastSavedTime; //difference in seconds
		
		//break down values
		DAPTTimeValue time = self.time;
		time.hour = floor(difference/60/24);
		time.minute = (int)floor(difference/60) % 60;
		time.second = (int)floor(difference) % 60;
		time.milisecond =  (int)floor(((difference - time.second) * 100)) % 100;
		time.duration = difference;
		self.time = time;
	}

}

@end
