#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLProfileTabBarView : UIView

@property (nonatomic, copy, nullable) void (^tabSelected)(NSInteger index);

- (void)selectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
