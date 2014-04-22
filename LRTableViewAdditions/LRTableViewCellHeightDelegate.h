//
//  Created by Denis Smirnov on 2014-04-20.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//
//  If a custom table view cell implements this protocol,
//  LRTableViewPart will use to to get cell's height

@import Foundation;

@protocol LRTableViewCellHeightDelegate <NSObject>

@optional

- (CGFloat)cellHeight;

@end
