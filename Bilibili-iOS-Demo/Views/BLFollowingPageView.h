#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLFollowingPageView : UIView

@property (nonatomic, copy, nullable) void (^videoSelected)(NSURL *URL, NSString *title, NSString *author);

- (void)activate;
- (void)deactivate;

@end

NS_ASSUME_NONNULL_END
