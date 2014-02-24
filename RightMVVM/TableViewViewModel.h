//
// TableViewViewModel
// Created by dlebedev on 23.02.14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <Foundation/Foundation.h>

@protocol TableViewViewModel <NSObject>

- (NSUInteger)numberOfRowsInSection:(NSInteger)section;
- (NSUInteger)numberOfSections;
- (id)rowForIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *)titleForHeaderAtIndexPath:(NSIndexPath *)indexPath;

@end