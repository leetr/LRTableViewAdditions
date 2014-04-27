@import Foundation;

@interface LRObservedObject : NSObject

@property (nonatomic, weak) NSObject *object;
@property (nonatomic, copy) NSString *keyPath;

@end
