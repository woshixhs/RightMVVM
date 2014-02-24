//
// FeedTableViewCell
// Created by dlebedev on 24.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "FeedTableViewCell.h"

@interface FeedTableViewCell ()
@end

@implementation FeedTableViewCell

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.detailTextLabel.textColor = [UIColor grayColor];
    self.textLabel.numberOfLines = 3;

    return self;
}

#pragma mark - Public

- (void)setRow:(NSDictionary *)row {
    self.textLabel.text = row[@"text"];
    self.detailTextLabel.text = row[@"created_at"];
}

@end