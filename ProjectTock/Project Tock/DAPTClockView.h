//
//  DAPTClockView.h
//  Project Tock
//
//  Created by David Attaie on 03/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPTClockView : UIView

-(id)initWithFontSize:(int)fontSize andFontColor:(UIColor *)color;
-(void)setTime:(int)hours minutes:(int)minutes seconds:(int)seconds miliSeconds:(int)miliSeconds;

@end
