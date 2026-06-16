#import <UIKit/UIKit.h>

@interface BLHotVideoCellView : UIView

@property (nonatomic, copy) void (^moreTapped)(void);

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views timeText:(NSString *)timeText duration:(NSString *)duration tag:(NSString *)tag colors:(NSArray<UIColor *> *)colors;

@end
