//  If a custom table view cell implements this protocol,
//  LRTableViewPart will use to to get cell's height

@import Foundation;

@protocol LRTableViewCellHeightDelegate <NSObject>

@optional

- (CGFloat)cellHeight;

@end
