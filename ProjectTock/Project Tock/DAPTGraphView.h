//
//  DAPTGraphView.h
//  Project Tock
//
//  Created by David Attaie on 04/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPTGraphView : UIView

-(void)plotWithPoints:(NSArray *)points setUpperScale:(NSString *)upper andCount:(int)count;
-(void)cleanGraph;

@end
