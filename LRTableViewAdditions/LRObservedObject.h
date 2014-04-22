//
//  Created by Denis Smirnov on 2014-04-19.
//  Copyright (c) 2014 Leetr Inc. All rights reserved.
//

@import Foundation;

@interface LRObservedObject : NSObject

@property (nonatomic, weak) NSObject *object;
@property (nonatomic, copy) NSString *keyPath;

@end
