#import "BLLiveBeautyLiveCardView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLLiveBeautyText(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

@interface BLLiveBeautyLiveCardView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *anchorLabel;
@property (nonatomic, strong) UILabel *viewersLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *portraitLabel;
@end

@implementation BLLiveBeautyLiveCardView

- (instancetype)initWithAnchor:(NSString *)anchor title:(NSString *)title viewers:(NSString *)viewers colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        self.coverView = [[UIView alloc] init];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        self.coverView.layer.cornerRadius = 4.0;
        self.coverView.layer.masksToBounds = YES;
        [self addSubview:self.coverView];

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.72 green:0.36 blue:0.46 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.18 green:0.15 blue:0.18 alpha:1.0];
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.coverView.layer insertSublayer:self.gradientLayer atIndex:0];

        UIView *shade = [[UIView alloc] init];
        shade.translatesAutoresizingMaskIntoConstraints = NO;
        shade.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.22];
        [self.coverView addSubview:shade];

        self.portraitLabel = [self labelWithText:[anchor substringToIndex:MIN(1, anchor.length)] font:[UIFont systemFontOfSize:42.0 weight:UIFontWeightSemibold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.86]];
        self.portraitLabel.textAlignment = NSTextAlignmentCenter;
        [self.coverView addSubview:self.portraitLabel];

        self.anchorLabel = [self labelWithText:anchor font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor whiteColor]];
        self.anchorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.coverView addSubview:self.anchorLabel];

        UIImageView *eyeIcon = [self iconViewWithName:@"eye" pointSize:17.0];
        [self.coverView addSubview:eyeIcon];

        self.viewersLabel = [self labelWithText:viewers font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor whiteColor]];
        self.viewersLabel.textAlignment = NSTextAlignmentRight;
        [self.coverView addSubview:self.viewersLabel];

        self.titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:BLLiveBeautyText()];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [self.coverView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.coverView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.coverView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.coverView.heightAnchor constraintEqualToAnchor:self.coverView.widthAnchor multiplier:0.56],

            [shade.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor],
            [shade.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor],
            [shade.bottomAnchor constraintEqualToAnchor:self.coverView.bottomAnchor],
            [shade.heightAnchor constraintEqualToConstant:42.0],

            [self.portraitLabel.centerXAnchor constraintEqualToAnchor:self.coverView.centerXAnchor],
            [self.portraitLabel.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor constant:-6.0],
            [self.portraitLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.coverView.leadingAnchor constant:14.0],
            [self.portraitLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.coverView.trailingAnchor constant:-14.0],

            [self.anchorLabel.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor constant:10.0],
            [self.anchorLabel.bottomAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:-9.0],
            [self.anchorLabel.trailingAnchor constraintLessThanOrEqualToAnchor:eyeIcon.leadingAnchor constant:-8.0],

            [self.viewersLabel.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:-10.0],
            [self.viewersLabel.centerYAnchor constraintEqualToAnchor:self.anchorLabel.centerYAnchor],
            [eyeIcon.trailingAnchor constraintEqualToAnchor:self.viewersLabel.leadingAnchor constant:-4.0],
            [eyeIcon.centerYAnchor constraintEqualToAnchor:self.anchorLabel.centerYAnchor],
            [eyeIcon.widthAnchor constraintEqualToConstant:20.0],
            [eyeIcon.heightAnchor constraintEqualToConstant:20.0],

            [self.titleLabel.topAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:10.0],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.heightAnchor constraintEqualToConstant:164.0]
        ]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.coverView.bounds;
}

- (UIImageView *)iconViewWithName:(NSString *)name pointSize:(CGFloat)pointSize {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = [UIColor whiteColor];
    return imageView;
}

- (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textColor = color;
    return label;
}

@end
