#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLProfileHeaderView : UIView

@property (nonatomic, copy, nullable) void (^backgroundTapped)(void);

- (void)updateBackgroundImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
