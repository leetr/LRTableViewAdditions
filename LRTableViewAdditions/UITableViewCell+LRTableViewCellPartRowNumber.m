#import "UITableViewCell+LRTableViewCellPartRowNumber.h"

#import <objc/runtime.h>

const char * kLRTableViewCellPartRowNumber = "LRTableViewCellPartRowNumber";

@implementation UITableViewCell (LRTableViewCellPartRowNumber)

- (NSNumber *)partRowNumber
{
    return objc_getAssociatedObject(self, kLRTableViewCellPartRowNumber);
}

- (void)setPartRowNumber:(NSNumber *)partRowNumber
{
    objc_setAssociatedObject(self, kLRTableViewCellPartRowNumber, partRowNumber, OBJC_ASSOCIATION_COPY);
}

@end
