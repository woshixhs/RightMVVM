//
// BaseTableViewController
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <Foundation/Foundation.h>

@class FeedViewModel;


@interface BaseTableViewController : UITableViewController

@property (strong, nonatomic, readonly) FeedViewModel *viewModel;

- (id)initWithViewModel:(id)viewModel;

@end