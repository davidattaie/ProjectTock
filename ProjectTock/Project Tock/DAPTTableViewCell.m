//
//  DAPTTableViewCell.m
//  Project Tock
//
//  Created by David Attaie on 05/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTTableViewCell.h"

@interface DAPTTableViewCell()

@property (nonatomic, weak, readwrite) UILabel *lapLabel;
@property (nonatomic, weak, readwrite) UILabel *timeLabel;

@end

@implementation DAPTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLapLabel];
		[self setupTimeLabel];
    }
    return self;
}

-(void)setupLapLabel
{
	UILabel *lapLabel = [UILabel new];
	[lapLabel setFrame:CGRectMake(5,
								  0,
								  150,
								  CGRectGetHeight(self.bounds))];
	[lapLabel setTextAlignment:NSTextAlignmentLeft];
	[lapLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
	[self addSubview:lapLabel];
	[self setLapLabel:lapLabel];
}

-(void)setupTimeLabel
{
	UILabel *timeLabel = [UILabel new];
	[timeLabel setFrame:CGRectMake(CGRectGetWidth(self.bounds) - 155,
								  0,
								  150,
								  CGRectGetHeight(self.bounds))];
	[timeLabel setTextAlignment:NSTextAlignmentRight];
	[timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
	[self addSubview:timeLabel];
	[self setTimeLabel:timeLabel];
}
@end
