//
//  DAPTStopWatchViewController.m
//  Project Tock
//
//  Created by David Attaie on 03/05/2014.
//  Copyright (c) 2014 David Attaie. All rights reserved.
//

#import "DAPTStopWatchViewController.h"
#import "DAPTGraphController.h"
#import "DAPTTableViewCell.h"
#import "DAPTTimerSession.h"
#import "DAPTClockView.h"
#import "DAPTHelpers.h"

@interface DAPTStopWatchViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DAPTGraphController *graphController;
@property (nonatomic, strong) DAPTTimerSession *timerSession;
@property (nonatomic, strong) DAPTTimerSession *lapTimerSession;
@property (nonatomic, weak) DAPTClockView *clockView;
@property (nonatomic, weak) DAPTClockView *lapClockView;
@property (nonatomic, weak) UIButton *startStopButton;
@property (nonatomic, weak) UIButton *lapResetButton;
@property (nonatomic, weak) UITableView *lapsTableView;
@property (nonatomic, strong) NSMutableArray *laps;
@property (nonatomic) BOOL isRunning;

@end

@implementation DAPTStopWatchViewController

static NSString * reusableCellIdentifier = @"com.projecttock.reusableIdentifier";

-(id)init
{
	self = [super init];
	if (self) {
		_laps = [NSMutableArray new];
	}
	return self;
}

-(void)dealloc
{
	_timerSession = nil;
	_lapTimerSession = nil;
	_laps = nil;
	_graphController = nil;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	//primary clock and timer
	[self setupClock];
	[self setupTimerSession];
	
	//lap clock and timer
	[self setupLapClock];
	[self setupLapTimerSession];
	
	//additional view setup
	[self setupStartStopButton];
	[self setupLapResetButton];
	[self setupGraph];
	[self setupLapsTableView];
	
	[self updateClockView:self.clockView withTimerSession:self.timerSession];
}

//------------------------------------------------------------------

#pragma mark - Setup Sessions

//------------------------------------------------------------------

-(void)setupTimerSession
{
	DAPTTimerSession *timerSession = [DAPTTimerSession new];
	[timerSession resetTimer];
	[self setTimerSession:timerSession];
}

-(void)setupLapTimerSession
{
	DAPTTimerSession *timerSession = [DAPTTimerSession new];
	[timerSession resetTimer];
	[self setLapTimerSession:timerSession];
}

//------------------------------------------------------------------

#pragma mark - Setup Clocks

//------------------------------------------------------------------

-(void)setupClock
{
	DAPTClockView *clockView = [[DAPTClockView alloc] initWithFontSize:55 andFontColor:[UIColor blackColor]];
	[clockView setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetWidth(clockView.frame)/2,
								   CGRectGetMidY(self.view.bounds) - CGRectGetHeight(clockView.frame),
								   CGRectGetWidth(clockView.frame),
								   CGRectGetHeight(clockView.frame))];
	[self.view addSubview:clockView];
	[self setClockView:clockView];
}

-(void)setupLapClock
{
	DAPTClockView *lapClockView = [[DAPTClockView alloc] initWithFontSize:25 andFontColor:[UIColor darkGrayColor]];
	[lapClockView setFrame:CGRectMake(CGRectGetMaxX(self.clockView.frame) - CGRectGetWidth(lapClockView.frame),
									  CGRectGetMinY(self.clockView.frame) - CGRectGetHeight(lapClockView.frame),
									  CGRectGetWidth(lapClockView.frame),
									  CGRectGetHeight(lapClockView.frame))];
	[self.view addSubview:lapClockView];
	[self setLapClockView:lapClockView];
}

//------------------------------------------------------------------

#pragma mark - Setup Other View Objects

//------------------------------------------------------------------

-(void)setupGraph
{
	DAPTGraphController *graphController = [DAPTGraphController new];
	[graphController setupViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150)];//setup view
	[self.view addSubview:graphController.view];
	[self setGraphController:graphController];
}

-(void)setupStartStopButton
{
	UIButton *startStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[startStopButton setBackgroundColor:[UIColor greenColor]];
	[startStopButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
										 CGRectGetMaxY(self.clockView.frame),
										 80,
										 80)];
	[startStopButton setTitle:@"Start" forState:UIControlStateNormal];;
	[startStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[startStopButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
	[startStopButton addTarget:self action:@selector(toggleStartStopClock:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:startStopButton];
	[self setStartStopButton:startStopButton];
}

-(void)setupLapResetButton
{
	UIButton *lapResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[lapResetButton setBackgroundColor:[UIColor blackColor]];
	[lapResetButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) + 20,
										CGRectGetMaxY(self.clockView.frame),
										80,
										80)];
	[lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
	[lapResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[lapResetButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
	[lapResetButton addTarget:self action:@selector(toggleLapReset:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:lapResetButton];
	[self setLapResetButton:lapResetButton];
}

-(void)setupLapsTableView
{
	UITableView *lapsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
																			   CGRectGetMaxY(self.startStopButton.frame) + 5,
																			   CGRectGetWidth(self.view.bounds),
																			   CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.startStopButton.frame) - 5)
															  style:UITableViewStylePlain];
	[lapsTableView setDataSource:self];
	[lapsTableView setDelegate:self];
	[lapsTableView setSeparatorInset:UIEdgeInsetsZero];
	[lapsTableView registerClass:[DAPTTableViewCell class] forCellReuseIdentifier:reusableCellIdentifier];
	[self.view addSubview:lapsTableView];
	[self setLapsTableView:lapsTableView];
}

//------------------------------------------------------------------

#pragma mark - Update Functions

//------------------------------------------------------------------

-(void)updateTime
{
	[self.timerSession calculateUpdate];
	[self updateClockView:self.clockView withTimerSession:self.timerSession];
	
	[self.lapTimerSession calculateUpdate];
	[self updateClockView:self.lapClockView withTimerSession:self.lapTimerSession];
	
	if (self.isRunning) {
		[self performSelector:@selector(updateTime) withObject:nil afterDelay:0.03];
	}
}

-(void)updateClockView:(DAPTClockView *)clockView withTimerSession:(DAPTTimerSession *)timerSession
{
	[clockView setTime:timerSession.time.hour
			   minutes:timerSession.time.minute
			   seconds:timerSession.time.second
		   miliSeconds:timerSession.time.milisecond];
}

//------------------------------------------------------------------

#pragma mark - Button Actions

//------------------------------------------------------------------

-(void)toggleStartStopClock:(id)sender
{
	if (self.isRunning) {
		self.isRunning = NO;
		[self.startStopButton setHighlighted:NO];
		[self.lapResetButton setSelected:NO];
		[self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
		[self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
		[self.startStopButton setBackgroundColor:[UIColor greenColor]];
		[self.lapTimerSession stop];
		[self.timerSession stop];
	}else{
		self.isRunning = YES;
		[self.startStopButton setHighlighted:YES];
		[self.lapResetButton setSelected:YES];
		[self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
		[self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
		[self.startStopButton setBackgroundColor:[UIColor redColor]];
		[self updateTime];
		[self.lapTimerSession start];
		[self.timerSession start];
	}
}

-(void)toggleLapReset:(id)sender
{
	if (self.isRunning) {
		[self addLap];
	}else{
		[self reset];
	}
}

-(void)addLap
{
	DAPTTimeValue lapTime = self.lapTimerSession.time;
	[self.laps addObject:[NSValue value:&lapTime withObjCType:@encode(DAPTTimeValue)]];
	
	[self.graphController updateGraphViewWithArray:[DAPTHelpers last10Objects:self.laps] andCount:(int)self.laps.count];
	
	//update laps table view
	[self.lapsTableView reloadData];
	
	//scroll to last element in table view
	NSIndexPath *lastElement = [NSIndexPath indexPathForRow:self.laps.count - 1 inSection:0];
	[self.lapsTableView scrollToRowAtIndexPath:lastElement atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
	//reset timer and update clock
	[self.lapTimerSession resetTimer];
	[self updateClockView:self.lapClockView withTimerSession:self.lapTimerSession];
}

-(void)reset
{
	[self.laps removeAllObjects];
	[self.lapsTableView reloadData];
	[self.timerSession resetTimer];
	[self.lapTimerSession resetTimer];
	[self updateClockView:self.clockView withTimerSession:self.timerSession];
	[self updateClockView:self.lapClockView withTimerSession:self.lapTimerSession];
	[self.graphController cleanGraph];
}

//------------------------------------------------------------------

#pragma mark - UITableView Delegate and Data Source

//------------------------------------------------------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DAPTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	DAPTTimeValue time;
	[[self.laps objectAtIndex:indexPath.row] getValue:&time];
	
	NSString *formatLap = [DAPTHelpers lapStringForTime:time];
	
	[cell.lapLabel setText:[NSString stringWithFormat:@"Lap %i", (int)(indexPath.row + 1)]];
	[cell.timeLabel setText:formatLap];
	
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.laps.count;
}

@end
