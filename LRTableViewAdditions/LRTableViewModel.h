//
//  Created by Denis Smirnov on 2014-04-21.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

@import UIKit;

#import "LRTableViewSection.h"

@interface LRTableViewModel : NSObject <UITableViewDelegate, UITableViewDataSource, LRTableViewSectionDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void)addSection:(LRTableViewSection *)section;
- (void)removeSection:(LRTableViewSection *)section;
- (void)removeSection:(LRTableViewSection *)section withAnimation:(UITableViewRowAnimation)animation;
- (void)removeAllSections;

- (BOOL)containsSection:(LRTableViewSection *)section;

@end
