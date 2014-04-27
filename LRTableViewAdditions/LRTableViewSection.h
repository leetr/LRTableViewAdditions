@import UIKit;

#import "LRTableViewPart.h"

@class LRTableViewSection;

@protocol LRTableViewSectionDelegate <NSObject>

- (void)beginUpdatesForTableViewSection:(LRTableViewSection *)section;
- (void)endUpdatesForTableViewSection:(LRTableViewSection *)section;

- (void)tableViewSection:(LRTableViewSection *)section insertRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;
- (void)tableViewSection:(LRTableViewSection *)section deleteRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;
- (void)tableViewSection:(LRTableViewSection *)section reloadRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation;

@end

@interface LRTableViewSection : NSObject <LRTableViewPartDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) UIView *headerView;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, assign) BOOL hideHeaderWhenEmpty;
@property (nonatomic, assign) id<LRTableViewSectionDelegate> delegate;
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
