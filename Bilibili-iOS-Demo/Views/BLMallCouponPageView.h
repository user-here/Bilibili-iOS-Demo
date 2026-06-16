#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMallCouponPageView : UIView

@property (nonatomic, copy, nullable) void (^closeTapped)(void);
@property (nonatomic, copy, nullable) void (^searchTapped)(void);

@end

NS_ASSUME_NONNULL_END
