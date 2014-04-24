//
//  Created by Denis Smirnov on 2014-04-19.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

#import "LRTableViewPart.h"
#import "LRObservedObject.h"
#import "LRTableViewUtilities.h"
#import "UITableViewCell+LRTableViewCellPartRowNumber.h"
#import "LRTableViewCellHeightDelegate.h"

@implementation LRTableViewPart {
    
    LRObservedObject *_observing;
    UITableViewCell *_cachedCellForHeightCalc;
}

#pragma mark - Class Mathods

+ (LRTableViewPart *)partWithCellStyle:(UITableViewCellStyle)style
{
    LRTableViewPart *part = [[LRTableViewPart alloc] init];
    part.cellStyle = style;
    
    return part;
}

+ (LRTableViewPart *)partWithCellIdentifier:(NSString *)identifier
{
    return [self partWithCellIdentifier:identifier nibName:nil];
}

+ (LRTableViewPart *)partWithCellIdentifier:(NSString *)identifier nibName:(NSString *)nibName
{
    NSAssert(identifier, @"identifier cannot be nil");
    
    LRTableViewPart *part = [[LRTableViewPart alloc] init];
    part.cellIdentifier = identifier;
    part.nibName = nibName;
    
    return part;
}

#pragma mark - Memory Management

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _observing = [[LRObservedObject alloc] init];
        _cellStyle = UITableViewCellStyleDefault;                   // default cell style
        _cellHeight = 44;                                           // default cell height
        _rowAnimation = UITableViewRowAnimationNone;                // default row animation
    }
    
    return self;
}

- (void)dealloc
{
    [_observing.object removeObserver:self forKeyPath:_observing.keyPath];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!([keyPath isEqualToString:_observing.keyPath] && object == _observing.object)) {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
        return;
    }
    
    if (change != nil) {
        
        NSKeyValueChange kind = [[change valueForKey:NSKeyValueChangeKindKey] intValue];
        NSIndexSet *indexes = [change valueForKey:NSKeyValueChangeIndexesKey];
        
        switch (kind) {
                
            case NSKeyValueChangeSetting: {
                
                if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewPartDelegate)]) {
                    
                    NSObject *old = [change valueForKey:NSKeyValueChangeOldKey];
                    NSObject *new = [change valueForKey:NSKeyValueChangeNewKey];
                    
                    if (![new isKindOfClass:[NSNull class]] && [old isKindOfClass:[NSNull class]] && ![new isKindOfClass:[NSArray class]]) { //object was set
                        
                        indexes = [[NSIndexSet alloc] initWithIndex:0];
                        [self.delegate tableViewPart:self insertRowsInIndexSet:indexes withRowAnimation:self.rowAnimation];
                    }
                    else if ([new isKindOfClass:[NSNull class]] && ![old isKindOfClass:[NSNull class]] && ![old isKindOfClass:[NSArray class]]) { //object was nilled out
                        
                        indexes = [[NSIndexSet alloc] initWithIndex:0];
                        [self.delegate tableViewPart:self deleteRowsInIndexSet:indexes withRowAnimation:self.rowAnimation];
                    }
                    else if (![new isKindOfClass:[NSNull class]] && ![old isKindOfClass:[NSNull class]] && ![new isKindOfClass:[NSArray class]] && ![old isKindOfClass:[NSArray class]]) { //object was replaced
                        
                        indexes = [[NSIndexSet alloc] initWithIndex:0];
                        [self.delegate tableViewPart:self reloadRowsInIndexSet:indexes withRowAnimation:self.rowAnimation];
                    }
                }
            } break;
                
            case NSKeyValueChangeInsertion:
                
                if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewPartDelegate)]) {
                    
                    [self.delegate tableViewPart:self insertRowsInIndexSet:indexes withRowAnimation:self.rowAnimation];
                }
                break;
                
            case NSKeyValueChangeRemoval:
                
                if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewPartDelegate)]) {
                    
                    [self.delegate tableViewPart:self deleteRowsInIndexSet:indexes withRowAnimation:self.rowAnimation];
                }
                break;
             
            case NSKeyValueChangeReplacement:
                
                if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(LRTableViewPartDelegate)]) {
                    
                    [self.delegate tableViewPart:self reloadRowsInIndexSet:indexes withRowAnimation:self.rowAnimation];
                }
                break;
                
            default: //
                [_tableView reloadData];
                break;
        }
    }
}

#pragma mark - 

- (void)stopObserving
{
    if (_observing && _observing.object && _observing.keyPath) {
        
        [_observing.object removeObserver:self forKeyPath:_observing.keyPath];
        
        _observing.object = nil;
        _observing.keyPath = nil;
    }
}

- (void)observeObject:(NSObject *)object forKeyPath:(NSString *)keyPath
{
    [self stopObserving];
    
    _observing.object = object;
    _observing.keyPath = keyPath;
    
    [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"LRTableViewPart"];
}

- (NSInteger)numberOfRows
{
    if (!_observing.object) {
        
        return 0;
    }
    
    NSObject *obj = [_observing.object valueForKeyPath:_observing.keyPath];
    BOOL isArray = ([obj isKindOfClass:[NSArray class]]);
    
    NSInteger numRows = (!isArray) ? ((obj) ? 1 : 0) : [(NSArray *)obj count];
    
    return numRows;
}

- (void)populateCell:(UITableViewCell *)cell forRow:(NSInteger)row
{
    if (self.cellBindings != nil) {
        
        NSObject *obj = [_observing.object valueForKeyPath:_observing.keyPath];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            
            obj = [(NSArray *)obj objectAtIndex:row];
        }
        
        for (NSString *cellKeyPath in self.cellBindings) {
            
            NSString *dataKeyPath = [self.cellBindings valueForKeyPath:cellKeyPath];
            
            if ([dataKeyPath isEqualToString:@"[object]"]) {
                
                [cell setValue:obj forKeyPath:cellKeyPath];
            }
            else if ([dataKeyPath hasPrefix:@"[value]"]) {
                
                [cell setValue:[dataKeyPath substringFromIndex:7] forKeyPath:cellKeyPath];
            }
            else if ([dataKeyPath hasPrefix:@"[string]"]) {
                
                [cell setValue:[dataKeyPath substringFromIndex:8] forKeyPath:cellKeyPath];
            }
            else if ([dataKeyPath hasPrefix:@"[int]"]) {
                
#warning TODO: review this int parsing
                
                NSString *parsed = [dataKeyPath substringFromIndex:5];
                NSNumber *num = [NSNumber numberWithInt:[parsed intValue]];
                
                [cell setValue:num forKey:cellKeyPath];
            }
            else if ([dataKeyPath hasPrefix:@"[float]"]) {
                
                NSString *parsed = [dataKeyPath substringFromIndex:7];
                NSNumber *num = [NSNumber numberWithFloat:[parsed floatValue]];
                [cell setValue:num forKey:cellKeyPath];
            }
            else {
                
                NSString *value = [obj valueForKeyPath:dataKeyPath];
                
                if (value && ![value isKindOfClass:[NSNull class]]) {
                    
                    if (value && [value isKindOfClass:[NSString class]] && [value hasPrefix:@"[image]"]) {
                        
                        UIImage *image = [UIImage imageNamed:[value substringFromIndex:7]];
                        [cell setValue:image forKeyPath:cellKeyPath];
                    }
                    else {
                        
                        [cell setValue:value forKeyPath:cellKeyPath];
                    }
                }
            }
        }
    }
    
    cell.partRowNumber = @(row);
}

- (UITableViewCell *)partCellForIdentifier:(NSString *)cellIdentifier nibName:(NSString *)nibName
{
    UITableViewCell *cell = nil;
    
    if (cellIdentifier && cellIdentifier.length > 0) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (cell) {
        
        return cell;
    }
    
    if (nibName && nibName.length > 0) {
        
        UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        
        if (nib) {
            
            [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
    }
    
    return cell;
}

- (UITableViewCell *)partCell
{
    UITableViewCell *cell = [self partCellForIdentifier:self.cellIdentifier nibName:self.nibName];
    
    if (cell) {
        
        return cell;
    }
    
    NSString *identifier = [LRTableViewUtilities cellStyleToString:self.cellStyle];
    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:identifier];
    }

    return cell;
}

- (UITableViewCell *)cellFromNibNamed:(NSString *)nibName
{
    if (!nibName || nibName.length == 0) {
        
        return nil;
    }
        
    UINib *nib = [UINib nibWithNibName:self.nibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:self.cellIdentifier];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    return cell;
}

//
- (UITableViewCell *)cellForRow:(NSInteger)row
{
    UITableViewCell *cell = [self partCell];
    
    [self populateCell:cell forRow:row];
    
    if ([cell respondsToSelector:@selector(setDelegate:)] ){
        
        [cell setValue:self forKey:@"delegate"];
    }
    
    return cell;
}

//
- (CGFloat)heightForRow:(NSInteger)row
{
    if (self.cellHeight == LRTableViewCellHeightDynamic) {
        
        if (_cachedCellForHeightCalc == nil) {
            
            _cachedCellForHeightCalc = [self partCell];
        }
        
        [self populateCell:_cachedCellForHeightCalc forRow:row];
        
        if ([_cachedCellForHeightCalc conformsToProtocol:@protocol(LRTableViewCellHeightDelegate)]
             && [_cachedCellForHeightCalc respondsToSelector:@selector(cellHeight)]) {
            
            return [(UITableViewCell<LRTableViewCellHeightDelegate> *)_cachedCellForHeightCalc cellHeight];
        }
        else {
            [_cachedCellForHeightCalc layoutSubviews];
            
            return _cachedCellForHeightCalc.frame.size.height;
        }
    }
    else {
        
        return self.cellHeight;
    }
    
    return 44;
}

//
- (void)didSelectRow:(NSInteger)row indexPath:(NSIndexPath *)indexPath
{
    if (self.onPartCellSelected != nil) {
        
        self.onPartCellSelected(self, indexPath, row);
    }
}

#pragma mark - LRTableViewCellDelegate

- (void)tableViewCell:(UITableViewCell *)cell didSelectView:(UIView *)view
{
    if (self.onPartCellViewSelected != nil) {
        
        self.onPartCellViewSelected(self,
                                    [self.tableView indexPathForCell:cell],
                                    [cell.partRowNumber integerValue],
                                    view);
    }
}

@end
