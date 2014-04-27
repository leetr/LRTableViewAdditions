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
