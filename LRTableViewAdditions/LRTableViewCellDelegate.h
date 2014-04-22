//
//  Created by Denis Smirnov on 2014-04-20.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

@import UIKit;

@protocol LRTableViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell didSelectView:(UIView *)view;

@end
