#import "LRTableViewUtilities.h"

@implementation LRTableViewUtilities

+ (NSString *)cellStyleToString:(UITableViewCellStyle)style
{
    switch (style) {
            
        case UITableViewCellStyleDefault:
            
            return @"UITableViewCellStyleDefault";
            
        case UITableViewCellStyleSubtitle:
            
            return @"UITableViewCellStyleSubtitle";
            
        case UITableViewCellStyleValue1:
            
            return @"UITableViewCellStyleValue1";
            
            
        case UITableViewCellStyleValue2:
            
            return @"UITableViewCellStyleValue2";
            
        default:
            break;
    }
    
    return @"";
}

@end
