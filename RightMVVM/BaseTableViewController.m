//
// BaseTableViewController
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "FeedViewModel.h"
#import "FeedViewController.h"
#import "BaseTableViewController.h"

@interface BaseTableViewController ()


@end

@implementation BaseTableViewController

- (id)initWithViewModel:(id)viewModel {
    self = [super init];
    if (!self) return nil;

    _viewModel = viewModel;

    RACSignal *presented = [[RACSignal
            merge:@[
                    [[self rac_signalForSelector:@selector(viewDidAppear:)] mapReplace:@YES],
                    [[self rac_signalForSelector:@selector(viewWillDisappear:)] mapReplace:@NO]
            ]]
            setNameWithFormat:@"%@ presented", self];

    RACSignal *appActive = [[[RACSignal
            merge:@[
                    [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] mapReplace:@YES],
                    [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] mapReplace:@NO]
            ]]
            startWith:@YES]
            setNameWithFormat:@"%@ appActive", self];

    RAC(self, viewModel.active) = [[[RACSignal
            combineLatest:@[presented, appActive]]
            and]
            setNameWithFormat:@"%@ active", self];

    return self;
}
@end