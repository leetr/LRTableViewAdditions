//
//  Created by Denis Smirnov on 2014-04-19.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

@import UIKit;

#import "LRTableViewCellDelegate.h"

#define LRTableViewCellHeightDynamic -1

@class LRTableViewPart;

typedef void (^PartCellSelected)(LRTableViewPart *part, NSIndexPath *indexPath, NSInteger partRow);
typedef void (^PartCellViewSelected)(LRTableViewPart *part, NSIndexPath *indexPath, NSInteger partRow, UIView *view);

@protocol LRTableViewPartDelegate <NSObject>

- (void)beginUpdatesForTableViewPart:(LRTableViewPart *)part;
- (void)endUpdatesForTableViewPart:(LRTableViewPart *)part;
- (void)tableViewPart:(LRTableViewPart *)part insertRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;
- (void)tableViewPart:(LRTableViewPart *)part deleteRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;
- (void)tableViewPart:(LRTableViewPart *)part reloadRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;

@optional

- (NSInteger)tableViewPart:(LRTableViewPart *)part rowNumberForCell:(UITableViewCell *)cell;

@end

@interface LRTableViewPart : NSObject <LRTableViewCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *nibName;
@property (nonatomic, assign) UITableViewCellStyle cellStyle;
@property (nonatomic) NSDictionary *cellBindings;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation;
@property (nonatomic, assign) id<LRTableViewPartDelegate> delegate;
@property (nonatomic, strong) PartCellSelected onCellSelected;
@property (nonatomic, strong) PartCellViewSelected onCellViewSelected;

+ (LRTableViewPart *)partWithCellStyle:(UITableViewCellStyle)style;
+ (LRTableViewPart *)partWithCellIdentifier:(NSString *)identifier;
+ (LRTableViewPart *)partWithCellIdentifier:(NSString *)identifier nibName:(NSString *)nibName;

- (NSInteger)numberOfRows;
- (UITableViewCell *)cellForRow:(NSInteger)row;
- (CGFloat)heightForRow:(NSInteger)row;
- (void)didSelectRow:(NSInteger)row indexPath:(NSIndexPath *)indexPath;
- (void)observeObject:(NSObject *)object forKeyPath:(NSString *)keyPath;
- (void)stopObserving;

- (void)setOnCellSelected:(void(^)(LRTableViewPart *part, NSIndexPath *indexPath, NSInteger partRow))onPartCellSelected;
- (void)setOnCellViewSelected:(void(^)(LRTableViewPart *part, NSIndexPath *indexPath, NSInteger partRow, UIView *view))onViewSelected;

@end
