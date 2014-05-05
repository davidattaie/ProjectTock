//
//  DAPTTableViewCell.h
//  Project Tock
//
//  Created by David Attaie on 05/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPTTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) UILabel *lapLabel;
@property (nonatomic, weak, readonly) UILabel *timeLabel;

@end
