#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLPublishPageView : UIView

@property (nonatomic, copy, nullable) void (^closeTapped)(void);

- (void)activate;
- (void)deactivate;

@end

NS_ASSUME_NONNULL_END
