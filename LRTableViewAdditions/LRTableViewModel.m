//
//  Created by Denis Smirnov on 2014-04-21.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

#import "LRTableViewModel.h"

@implementation LRTableViewModel {
    
    NSMutableArray *_sections;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _sections = [[NSMutableArray alloc] init];
}

- (void)removeAllSections
{
    int numSections = _sections.count;
    
    if (numSections > 0) {
        
        for (LRTableViewSection *section in _sections) {
            
            section.tableView = nil;
            section.delegate = nil;
        }
        
        [_sections removeAllObjects];
        
        NSRange range = NSMakeRange(0, numSections);

        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

- (void)removeSection:(LRTableViewSection *)section
{
    [self removeSection:section withAnimation:UITableViewRowAnimationNone];
}

- (void)removeSection:(LRTableViewSection *)section withAnimation:(UITableViewRowAnimation)animation
{
    int sectionIndex = [_sections indexOfObject:section];
    
    if (_sections.count > sectionIndex) {
        
        LRTableViewSection *section = [_sections objectAtIndex:sectionIndex];
        section.tableView = nil;
        section.delegate = nil;
        
        [_sections removeObjectAtIndex:sectionIndex];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

- (void)addSection:(LRTableViewSection *)section
{
    [self addSection:section withAnimation:UITableViewRowAnimationNone];
}

- (void)addSection:(LRTableViewSection *)section withAnimation:(UITableViewRowAnimation)animation
{
    if (section != nil) {
        
        section.tableView = self.tableView;
        section.delegate = self;
        
        [_sections addObject:section];
        
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:(_sections.count - 1)] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

- (BOOL)containsSection:(LRTableViewSection *)section
{
    return [_sections containsObject:section];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(LRTableViewSection *)[_sections objectAtIndex:section] numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRTableViewSection *section = (LRTableViewSection *)[_sections objectAtIndex:indexPath.section];
    return [section cellForRow:indexPath.row];
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRTableViewSection *section = (LRTableViewSection *)[_sections objectAtIndex:indexPath.section];
    return [section heightForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRTableViewSection *section = (LRTableViewSection *)[_sections objectAtIndex:indexPath.section];
    [section didSelectRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionNum
{
    LRTableViewSection *section = (LRTableViewSection *)[_sections objectAtIndex:sectionNum];
    return section.headerTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionNum
{
    LRTableViewSection *section = (LRTableViewSection *)[_sections objectAtIndex:sectionNum];
    return section.headerView;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionNum
{
    LRTableViewSection *section = (LRTableViewSection *)[_sections objectAtIndex:sectionNum];
    
    if (section.headerView == nil && section.headerTitle == nil) {
        
        return 0;
    }
    
    if (section.headerView != nil) {
        
        return section.headerView.frame.size.height;
    }
    else {
        
        return 22;
    }
}

- (NSArray *)indexPathArrayForSection:(LRTableViewSection *)section fromIndexSet:(NSIndexSet *)indexset
{
    int sectionNum = [_sections indexOfObject:section];
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [indexset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:sectionNum];
        [indexPaths addObject:indexPath];
    }];
    
    return indexPaths;
}

#pragma mark - LRTableViewSectionDelegate

- (void)tableViewSection:(LRTableViewSection *)section insertRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation
{
    if (section != nil && indexset != nil) {
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self indexPathArrayForSection:section fromIndexSet:indexset] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

- (void)tableViewSection:(LRTableViewSection *)section deleteRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation
{
    if (section != nil && indexset != nil) {
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[self indexPathArrayForSection:section fromIndexSet:indexset] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

- (void)tableViewSection:(LRTableViewSection *)section reloadRowsInIndexSet:(NSIndexSet *)indexset withRowAnimation:(UITableViewRowAnimation)animation
{
    if (section != nil && indexset != nil) {
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[self indexPathArrayForSection:section fromIndexSet:indexset] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

@end
