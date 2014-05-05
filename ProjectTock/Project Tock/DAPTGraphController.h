//
//  DAPTGraphController.h
//  Project Tock
//
//  Created by David Attaie on 05/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPTTimerSession.h"
#import "DAPTGraphView.h"

@interface DAPTGraphController : NSObject

@property (nonatomic, strong, readonly) DAPTGraphView *view;

-(void)setupViewWithFrame:(CGRect)frame;
-(void)updateGraphViewWithArray:(NSArray *)array andCount:(int)count;
-(void)cleanGraph;

@end
