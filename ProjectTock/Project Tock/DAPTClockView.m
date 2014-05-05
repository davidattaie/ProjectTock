//
//  DAPTClockView.m
//  Project Tock
//
//  Created by David Attaie on 03/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTClockView.h"
#import "DAPTHelpers.h"

@interface DAPTClockView()

@property (nonatomic, weak) UILabel *hoursLabel;
@property (nonatomic, weak) UILabel *minutesLabel;
@property (nonatomic, weak) UILabel *secondsLabel;
@property (nonatomic, weak) UILabel *miliSecondsLabel;
@property (nonatomic) int fontSize;
@property (nonatomic, strong) UIColor *fontColor;

@end

@implementation DAPTClockView

-(id)initWithFontSize:(int)fontSize andFontColor:(UIColor *)color
{
	self = [super init];
	if (self) {
		_fontSize = fontSize;
		_fontColor = color;
		[self setupHoursLabel];
		[self setupMinutesLabel];
		[self setupSecondsLabel];
		[self setupMiliSecondsLabel];
		[self setFrame:CGRectMake(0, 0, CGRectGetMaxX(self.miliSecondsLabel.frame), CGRectGetMaxY(self.hoursLabel.frame))];
	}
	return self;
}

-(void)dealloc
{
	_fontColor = nil;
}

//------------------------------------------------------------------

#pragma mark - Update View

//------------------------------------------------------------------

-(void)setTime:(int)hours minutes:(int)minutes seconds:(int)seconds miliSeconds:(int)miliSeconds
{
	[self.hoursLabel setText:[DAPTHelpers formattedTimeStringForTime:hours]];
	[self.minutesLabel setText:[DAPTHelpers formattedTimeStringForTime:minutes]];
	[self.secondsLabel setText:[DAPTHelpers formattedTimeStringForTime:seconds]];
	[self.miliSecondsLabel setText:[DAPTHelpers formattedTimeStringForTime:miliSeconds]];
}

//------------------------------------------------------------------

#pragma mark - Generic Label Helpers

//------------------------------------------------------------------

-(UILabel *)createClockLabel
{
	UILabel *clockLabel =  [UILabel new];
	[clockLabel setTextColor:self.fontColor];
	[clockLabel setTextAlignment:NSTextAlignmentCenter];
	[clockLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:self.fontSize]];
	[clockLabel setText:@"00"];
	[clockLabel sizeToFit];
	[self addSubview:clockLabel];
	return clockLabel;
}

-(UILabel *)spacingLabel
{
	//hours break
	UILabel *spacingLabel = [self createClockLabel];
	[spacingLabel setText:@":"];
	[spacingLabel sizeToFit];
	[self addSubview:spacingLabel];
	return spacingLabel;
}

//------------------------------------------------------------------

#pragma mark - Setup Content Labels

//------------------------------------------------------------------

-(void)setupHoursLabel
{
	[self setHoursLabel:[self createClockLabel]];
	[self.hoursLabel setFrame:CGRectMake(0,
										 0,
										 CGRectGetWidth(self.hoursLabel.frame),
										 CGRectGetHeight(self.hoursLabel.frame))];
}

-(void)setupMinutesLabel
{
	//add spacing Label between Minutes and Hours
	UILabel *spacingLabel = [self spacingLabel];
	[spacingLabel setFrame:CGRectMake(CGRectGetMaxX(self.hoursLabel.frame),
									  CGRectGetMinY(self.hoursLabel.frame),
									  CGRectGetWidth(spacingLabel.frame),
									  CGRectGetHeight(spacingLabel.frame))];
	
	//then update minutes
	[self setMinutesLabel:[self createClockLabel]];
	[self.minutesLabel setFrame:CGRectMake(CGRectGetMaxX(spacingLabel.frame),
										 CGRectGetMinY(spacingLabel.frame),
										 CGRectGetWidth(self.minutesLabel.frame),
										 CGRectGetHeight(self.minutesLabel.frame))];
}

-(void)setupSecondsLabel
{
	UILabel *spacingLabel = [self spacingLabel];
	[spacingLabel setFrame:CGRectMake(CGRectGetMaxX(self.minutesLabel.frame),
									  CGRectGetMinY(self.minutesLabel.frame),
									  CGRectGetWidth(spacingLabel.frame),
									  CGRectGetHeight(spacingLabel.frame))];
	
	//then update seconds
	[self setSecondsLabel:[self createClockLabel]];
	[self.secondsLabel setFrame:CGRectMake(CGRectGetMaxX(spacingLabel.frame),
										 CGRectGetMinY(spacingLabel.frame),
										 CGRectGetWidth(self.secondsLabel.frame),
										 CGRectGetHeight(self.secondsLabel.frame))];
}

-(void)setupMiliSecondsLabel
{
	UILabel *spacingLabel = [self spacingLabel];
	[spacingLabel setFrame:CGRectMake(CGRectGetMaxX(self.secondsLabel.frame),
									  CGRectGetMinY(self.secondsLabel.frame),
									  CGRectGetWidth(spacingLabel.frame),
									  CGRectGetHeight(spacingLabel.frame))];
	[spacingLabel setText:@"."];//milliseconds always uses a . 
	
	//then update miliseconds label
	
	[self setMiliSecondsLabel:[self createClockLabel]];
	[self.miliSecondsLabel setFrame:CGRectMake(CGRectGetMaxX(spacingLabel.frame),
										 CGRectGetMinY(spacingLabel.frame),
										 CGRectGetWidth(self.miliSecondsLabel.frame),
										 CGRectGetHeight(self.miliSecondsLabel.frame))];
}

@end
