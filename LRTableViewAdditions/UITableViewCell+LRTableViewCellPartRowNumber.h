//
//  Created by Denis Smirnov on 2014-04-20.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//
//  Notes: The extension is used to keep track of the row number
//         in a particular LRTableViewPart

@import UIKit;

@interface UITableViewCell (LRTableViewCellPartRowNumber)

@property (nonatomic, strong) NSNumber *partRowNumber;

@end
