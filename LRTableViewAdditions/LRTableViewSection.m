//
//  Created by Denis Smirnov on 2014-04-21.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

#import "LRTableViewSection.h"

@implementation LRTableViewSection {
    
    NSMutableArray *_parts;
}

#pragma mark - Convenience Methods

+ (LRTableViewSection *)sectionWithParts:(NSArray *)parts
{
    LRTableViewSection *section = [[LRTableViewSection alloc] init];
    
    for (LRTableViewPart *part in parts) {
        
        [section addPart:part];
    }
    
    return section;
}

#pragma mark - Memory Managements

- (id)init
{
    self = [super init];
    
    if (self) {
        _parts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Property override

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    for (LRTableViewPart *part in _parts) {
        
        part.tableView = _tableView;
    }
}

#pragma mark -

- (void)addPart:(LRTableViewPart *)part
{
    NSAssert(part, @"cannot add nil parts");
    
    part.tableView = self.tableView;
    part.delegate = self;
    
    [_parts addObject:part];
}

- (void)removeAllParts
{
    for (LRTableViewPart *part in _parts) {
        
        part.tableView = nil;
        [part stopObserving];
    }
    
#warning TODO: might crash here
    [_parts removeAllObjects];
}

- (LRTableViewPart *)partForRow:(NSInteger)row
{
    int partIndex = 0;
    int sumRows = 0;
    
    LRTableViewPart *part = (LRTableViewPart *)[_parts objectAtIndex:partIndex];
    
    while (row >= (sumRows += [part numberOfRows]) && partIndex < _parts.count) {
        
        part = (LRTableViewPart *)[_parts objectAtIndex:++partIndex];
    }
    return part;
}

- (NSInteger)rowOffsetForPart:(LRTableViewPart *)part
{
    int offset = 0;
    
    for (LRTableViewPart *_part in _parts) {
        
        if ([_part isEqual:part]) {
            
            break;
        }
        else {
            
            offset += [_part numberOfRows];
        }
    }
    
    return offset;
}

- (NSInteger)numberOfRows
{
    int num = 0;
    
    for (LRTableViewPart *part in _parts) {
        
        num += [part numberOfRows];
    }
    
    return num;
}

- (UITableViewCell *)cellForRow:(NSInteger)row
{
    LRTableViewPart *part = [self partForRow:row];
    int rowOffset = [self rowOffsetForPart:part];
    
    return [part cellForRow:(row - rowOffset)];
}

- (CGFloat)heightForRow:(NSInteger)row
{
    LRTableViewPart *part = [self partForRow:row];
    int rowOffset = [self rowOffsetForPart:part];
    
    return [part heightForRow:(row - rowOffset)];
}

- (NSString *)headerTitle
{
    if (self.hideHeaderWhenEmpty && [self isEmpty]) {
            
        return nil;
    }
    else {
        
        return _headerTitle;
    }
}

- (UIView *)headerView
{
    if (self.hideHeaderWhenEmpty && [self isEmpty]) {
        
        return nil;
    }
    else {
        
        return _headerView;
    }
}

- (BOOL)isEmpty
{
    for (LRTableViewPart *part in _parts) {
        
        if (part.numberOfRows > 0) {
            
            return NO;
        }
    }
    
    return YES;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRTableViewPart *part = [self partForRow:indexPath.row];
    int rowOffset = [self rowOffsetForPart:part];
    
    [part didSelectRow:(indexPath.row - rowOffset) indexPath:indexPath];
}

- (NSIndexSet *)indexSet:(NSIndexSet *)indexset offsetForPart:(LRTableViewPart *)part
{
    NSMutableIndexSet *newSet = [[NSMutableIndexSet alloc] init];
    int rowOffset = [self rowOffsetForPart:part];
    
    [indexset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [newSet addIndex:(idx + rowOffset)];
    }];
    
    return newSet;
}

#pragma mark - LRTableViewPartDelegate

- (NSInteger)tableViewPart:(LRTableViewPart *)part rowNumberForCell:(UITableViewCell *)cell
{
    if (part && cell) {
        
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        
        if (path) {
            
            int rowOffset = [self rowOffsetForPart:part];
            
            return path.row - rowOffset;
        }
        
        return -1;
    }
    
    return -1;
}

- (void)beginUpdatesForTableViewPart:(LRTableViewPart *)part
{
    if (part != nil && self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewSectionDelegate)]) {
        
        [self.delegate beginUpdatesForTableViewSection:self];
    }
}

- (void)endUpdatesForTableViewPart:(LRTableViewPart *)part
{
    if (part != nil && self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewSectionDelegate)]) {
        
        [self.delegate endUpdatesForTableViewSection:self];
    }
}

- (void)tableViewPart:(LRTableViewPart *)part insertRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation
{
    if (part != nil && indexset != nil && self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewSectionDelegate)]) {
        
        [self.delegate tableViewSection:self insertRowsInIndexSet:[self indexSet:indexset offsetForPart:part] withRowAnimation:animation];
    }
}

- (void)tableViewPart:(LRTableViewPart *)part deleteRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation
{
    if (part != nil && indexset != nil && self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewSectionDelegate)]) {
        
        [self.delegate tableViewSection:self deleteRowsInIndexSet:[self indexSet:indexset offsetForPart:part] withRowAnimation:animation];
    }
}

- (void)tableViewPart:(LRTableViewPart *)part reloadRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation
{
    if (part != nil && indexset != nil && self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewSectionDelegate)]) {
        
        [self.delegate tableViewSection:self reloadRowsInIndexSet:[self indexSet:indexset offsetForPart:part] withRowAnimation:animation];
    }
}

@end
