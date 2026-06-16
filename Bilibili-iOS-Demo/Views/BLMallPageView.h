#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMallPageView : UIView

@property (nonatomic, copy, nullable) void (^searchTapped)(void);
@property (nonatomic, copy, nullable) void (^couponTapped)(void);

@end

NS_ASSUME_NONNULL_END
