//
//  Created by Denis Smirnov on 2014-04-21.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

#import "UIViewController+LRTableViewAdditions.h"
#import <objc/runtime.h>

const char * kLRTableViewModelKey = "LRTableViewModelKey";

@implementation UIViewController (LRTableViewAdditions)

- (LRTableViewModel *)tableViewModel
{
    LRTableViewModel *model = objc_getAssociatedObject(self, kLRTableViewModelKey);
    
    return model;
}

- (void)setTableViewModel:(LRTableViewModel *)tableViewModel
{
    objc_setAssociatedObject(self, kLRTableViewModelKey, tableViewModel, OBJC_ASSOCIATION_RETAIN);
}

@end
