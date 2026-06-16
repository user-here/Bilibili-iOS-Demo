#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLProfileSpacePageView : UIView

@property (nonatomic, copy, nullable) void (^closeTapped)(void);
@property (nonatomic, copy, nullable) void (^chooseBackgroundTapped)(void);

- (void)setProfileBackgroundImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
