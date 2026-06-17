#import "UIView+BLLayout.h"
#import "BLTheme.h"

@implementation UIView (BLLayout)

+ (UILabel *)bl_labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textColor = color;
    return label;
}

+ (UIView *)bl_separatorView {
    UIView *sep = [[UIView alloc] init];
    sep.translatesAutoresizingMaskIntoConstraints = NO;
    sep.backgroundColor = BLSeparatorColor();
    [NSLayoutConstraint activateConstraints:@[
        [sep.heightAnchor constraintEqualToConstant:0.5]
    ]];
    return sep;
}

+ (UIButton *)bl_buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end
