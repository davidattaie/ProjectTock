//
//  DAPTGraphController.m
//  Project Tock
//
//  Created by David Attaie on 05/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTGraphController.h"
#import "DAPTHelpers.h"

@interface DAPTGraphController()

@property (nonatomic, strong, readwrite) DAPTGraphView *view;

@end

@implementation DAPTGraphController

-(void)dealloc
{
	_view = nil;
}

-(void)setupViewWithFrame:(CGRect)frame
{
	DAPTGraphView *graphView = [DAPTGraphView new];
	[graphView setFrame:frame];
	[graphView setBackgroundColor:[UIColor clearColor]];
	[self setView:graphView];
}

-(void)updateGraphViewWithArray:(NSArray *)array andCount:(int)count
{
	NSMutableArray *pointsArray = [[NSMutableArray alloc] init];
	
	DAPTTimeValue largestTime = {0,0,0,0};
	for (int i = 0;i < array.count; i++) {
		DAPTTimeValue time;
		[[array objectAtIndex:i] getValue:&time];
		if (time.duration > largestTime.duration) {
			largestTime = time;
		}
	}
	
	for (int i = 0;i < array.count; i++) {
		DAPTTimeValue time;
		[[array objectAtIndex:i] getValue:&time];
		
		double scaledY = time.duration/largestTime.duration * 100;
		
		float tenthOfGraphWidth = (CGRectGetWidth(self.view.bounds)/10);
		CGPoint currentPoint = CGPointMake(i * tenthOfGraphWidth + (tenthOfGraphWidth/2),
										   CGRectGetHeight(self.view.bounds) - scaledY - 20);
		NSValue *pointValue = [NSValue valueWithCGPoint:currentPoint];
		[pointsArray addObject:pointValue];
	}
	
	[self.view plotWithPoints:[pointsArray copy]
				setUpperScale:[DAPTHelpers highestValuesFortime:largestTime]
					 andCount:count];
}

-(void)cleanGraph
{
	[self.view cleanGraph];
}
@end
