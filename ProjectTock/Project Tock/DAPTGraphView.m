//
//  DAPTGraphView.m
//  Project Tock
//
//  Created by David Attaie on 04/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTGraphView.h"

@interface DAPTGraphView()

@property (nonatomic) int count;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, weak) UILabel *upperScale;

@end

@implementation DAPTGraphView

-(void)dealloc
{
	_points = nil;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	if (!self.upperScale) {
		UILabel *upperScale =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 135, 64, 20)];
		[upperScale setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15]];
		[self addSubview:upperScale];
		[self setUpperScale:upperScale];
	}
	
	if(!self.points){
		[self.backgroundColor setFill];
		CGContextFillRect(currentContext, rect);
		[self.upperScale setText:nil];
	}else{
		//draw guide lines
		[[UIColor lightGrayColor] setStroke];
		CGContextSetLineWidth(currentContext,0.1f);
		for (int i = 0; i < 10; i++) {
			float yPos = (CGRectGetHeight(self.bounds) - 120) + (i * 10);
			CGContextMoveToPoint(currentContext,0, yPos);
			CGContextAddLineToPoint(currentContext, CGRectGetWidth(self.bounds), yPos);
			CGContextStrokePath(currentContext);
		}
		
		[[UIColor blackColor] set];
		CGContextSetLineWidth(currentContext,1.0f);
		
		for (int i = 0; i < self.points.count; i++) {
			NSValue *pointValue = self.points[i];
			CGPoint point = [pointValue CGPointValue];
			if (i == 0) {
				CGContextMoveToPoint(currentContext,point.x, point.y);
			}else{
				CGContextAddLineToPoint(currentContext, point.x, point.y);
			}
			NSString *lap;
			if (self.count > 10) {
				lap = [NSString stringWithFormat:@"%i", self.count-9+i];
			}else{
				lap = [NSString stringWithFormat:@"%i", i+1];
			}
			
			[lap drawAtPoint:CGPointMake(point.x, CGRectGetHeight(self.bounds) - 30) withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15]}];
		}
		
		CGContextStrokePath(currentContext);
	}
}

-(void)plotWithPoints:(NSArray *)points setUpperScale:(NSString *)upper andCount:(int)count
{
	self.count = count;
	self.points = points;
	[self.upperScale setText:upper];
	[self setNeedsDisplay];
}

-(void)cleanGraph
{
	self.points = nil;
	[self setNeedsDisplay];
}


@end
