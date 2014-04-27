@import UIKit;

@protocol LRTableViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell didSelectView:(UIView *)view;

@end
