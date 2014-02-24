//
// FeedViewController
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "FeedViewController.h"
#import "FeedViewModel.h"
#import "TweetDetailsViewController.h"
#import "TweetDetailsViewModel.h"
#import "SVProgressHUD.h"
#import "FeedTableViewCell.h"

static NSString *const FeedCellIdentifier = @"FeedCell";

@interface FeedViewController ()

@property (strong, nonatomic, readwrite) FeedViewModel *viewModel;

@end

@implementation FeedViewController

#pragma mark - Public

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor grayColor]];

    [self.tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:FeedCellIdentifier];

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:nil
                                                                                   action:nil];
    refreshButton.rac_command = self.viewModel.fetchTimelineCommand;

    self.navigationItem.rightBarButtonItem = refreshButton;

    @weakify(self);

    RAC(self.navigationItem, title) = RACObserve(self.viewModel, title);

    [self.viewModel.viewModelDidUpdateSignal subscribeNext:^(id _) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    [RACObserve(self.viewModel, state) subscribeNext:^(NSNumber *state) {
        @strongify(self);
        switch ((ViewModelState)state.integerValue) {
            case ViewModelStateLoading: {
                [SVProgressHUD show];
            }
                break;
            case ViewModelStateNormal:
                [SVProgressHUD dismiss];
                break;
            case ViewModelStateError:
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:@"Eror"
                                            message:@"Something bad happened:("
                                           delegate:nil
                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil]
                        show];
                break;
            case ViewModelStateCustom:
                break;
        }
    }];
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier
                                                            forIndexPath:indexPath];

    NSDictionary *model = [self.viewModel rowForIndexPath:indexPath];
    [cell setRow:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

#pragma mark - <UITableViewDelegate>

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel tweetAtIndexPathIsReplyOrRetweet:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailsViewModel *vm = [self.viewModel tweetViewModelForIndexPath:indexPath];

    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

@end