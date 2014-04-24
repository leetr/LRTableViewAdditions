//
//  Created by Denis Smirnov on 2014-04-21.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

@import UIKit;

#import "LRTableViewPart.h"

@class LRTableViewSection;

@protocol LRTableViewSectionDelegate <NSObject>

- (void)tableViewSection:(LRTableViewSection *)section insertRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;
- (void)tableViewSection:(LRTableViewSection *)section deleteRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;
- (void)tableViewSection:(LRTableViewSection *)section reloadRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;

@end

@interface LRTableViewSection : NSObject <LRTableViewPartDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *headerView;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, assign) BOOL hideHeaderWhenEmpty;
@property (nonatomic, assign) id<LRTableViewSectionDelegate> delegate;
@property (nonatomic, assign) int tag;
@property (nonatomic, readonly) NSArray *parts;

+ (LRTableViewSection *)sectionWithParts:(NSArray *)parts;

- (NSInteger)numberOfRows;
- (CGFloat)heightForRow:(NSInteger)row;

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)addPart:(LRTableViewPart *)part;
- (void)removeAllParts;

- (NSInteger)rowOffsetForPart:(LRTableViewPart *)part;
- (LRTableViewPart *)partForRow:(NSInteger)row;
- (UITableViewCell *)cellForRow:(NSInteger)row;

@end