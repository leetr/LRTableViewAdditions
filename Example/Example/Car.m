#import "Car.h"

@implementation Car

+ (instancetype)carWithMake:(NSString *)make model:(NSString *)model
{
    Car *car = [[Car alloc] init];
    
    car.make = make;
    car.model = model;
    
    return car;
}

@end
