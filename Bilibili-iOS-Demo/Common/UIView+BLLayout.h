#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BLLayout)

+ (UILabel *)bl_labelWithText:(nullable NSString *)text
                         font:(UIFont *)font
                        color:(UIColor *)color;

+ (UIView *)bl_separatorView;

+ (UIButton *)bl_buttonWithTitle:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
