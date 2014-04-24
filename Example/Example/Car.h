@import Foundation;

@interface Car : NSObject

@property (nonatomic, copy) NSString *make;
@property (nonatomic, copy) NSString *model;

+ (instancetype)carWithMake:(NSString *)make model:(NSString *)model;

@end
