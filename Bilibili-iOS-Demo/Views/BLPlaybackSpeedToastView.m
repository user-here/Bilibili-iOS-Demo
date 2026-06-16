#import "BLPlaybackSpeedToastView.h"

@implementation BLPlaybackSpeedToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.58];
        self.layer.cornerRadius = 18.0;
        self.layer.masksToBounds = YES;
        self.alpha = 0.0;
        self.userInteractionEnabled = NO;

        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:17.0 weight:UIImageSymbolWeightSemibold];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:@"forward.fill"] imageWithConfiguration:configuration]];
        icon.translatesAutoresizingMaskIntoConstraints = NO;
        icon.tintColor = [UIColor whiteColor];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:icon];

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = @"正在 3倍速播放";
        label.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];

        [NSLayoutConstraint activateConstraints:@[
            [self.heightAnchor constraintEqualToConstant:36.0],
            [icon.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14.0],
            [icon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [icon.widthAnchor constraintEqualToConstant:18.0],
            [icon.heightAnchor constraintEqualToConstant:18.0],
            [label.leadingAnchor constraintEqualToAnchor:icon.trailingAnchor constant:8.0],
            [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
            [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
    }
    return self;
}

- (void)setVisible:(BOOL)visible animated:(BOOL)animated {
    CGFloat targetAlpha = visible ? 1.0 : 0.0;
    if (animated) {
        [UIView animateWithDuration:0.16 animations:^{
            self.alpha = targetAlpha;
        }];
    } else {
        self.alpha = targetAlpha;
    }
}

@end
