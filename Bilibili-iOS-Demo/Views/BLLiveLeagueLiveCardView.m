#import "BLLiveLeagueLiveCardView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLLiveLeagueText(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

static UIColor *BLLiveLeagueBadgePink(void) {
    return [UIColor colorWithRed:0.90 green:0.28 blue:0.54 alpha:1.0];
}

@interface BLLiveLeagueLiveCardView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *anchorLabel;
@property (nonatomic, strong) UILabel *viewersLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@end

@implementation BLLiveLeagueLiveCardView

- (instancetype)initWithAnchor:(NSString *)anchor title:(NSString *)title viewers:(NSString *)viewers badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.coverView = [[UIView alloc] init];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        self.coverView.layer.cornerRadius = 4.0;
        self.coverView.layer.masksToBounds = YES;
        [self addSubview:self.coverView];

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.12 green:0.18 blue:0.30 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.34 green:0.42 blue:0.56 alpha:1.0];
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.coverView.layer insertSublayer:self.gradientLayer atIndex:0];

        UIView *shade = [[UIView alloc] init];
        shade.translatesAutoresizingMaskIntoConstraints = NO;
        shade.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.26];
        [self.coverView addSubview:shade];

        if (badge.length > 0) {
            UILabel *badgeLabel = [self labelWithText:badge font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular] color:[UIColor whiteColor]];
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.backgroundColor = BLLiveLeagueBadgePink();
            badgeLabel.layer.cornerRadius = 3.0;
            badgeLabel.layer.masksToBounds = YES;
            [self.coverView addSubview:badgeLabel];
            [NSLayoutConstraint activateConstraints:@[
                [badgeLabel.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor],
                [badgeLabel.topAnchor constraintEqualToAnchor:self.coverView.topAnchor],
                [badgeLabel.widthAnchor constraintEqualToConstant:88.0],
                [badgeLabel.heightAnchor constraintEqualToConstant:32.0]
            ]];
        }

        self.centerLabel = [self labelWithText:[title containsString:@"预告"] ? @"LPL" : @"峡谷直播" font:[UIFont systemFontOfSize:30.0 weight:UIFontWeightBold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.86]];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        [self.coverView addSubview:self.centerLabel];

        self.anchorLabel = [self labelWithText:anchor font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor whiteColor]];
        self.anchorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.coverView addSubview:self.anchorLabel];

        UIImageView *eyeIcon = [self iconViewWithName:@"eye" pointSize:17.0];
        [self.coverView addSubview:eyeIcon];

        self.viewersLabel = [self labelWithText:viewers font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor whiteColor]];
        self.viewersLabel.textAlignment = NSTextAlignmentRight;
        [self.coverView addSubview:self.viewersLabel];

        self.titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:BLLiveLeagueText()];
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

            [self.centerLabel.centerXAnchor constraintEqualToAnchor:self.coverView.centerXAnchor],
            [self.centerLabel.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor],
            [self.centerLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.coverView.leadingAnchor constant:12.0],
            [self.centerLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.coverView.trailingAnchor constant:-12.0],

            [self.anchorLabel.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor constant:10.0],
            [self.anchorLabel.bottomAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:-9.0],
            [self.anchorLabel.trailingAnchor constraintLessThanOrEqualToAnchor:eyeIcon.leadingAnchor constant:-8.0],

            [self.viewersLabel.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:-10.0],
            [self.viewersLabel.centerYAnchor constraintEqualToAnchor:self.anchorLabel.centerYAnchor],
            [eyeIcon.trailingAnchor constraintEqualToAnchor:self.viewersLabel.leadingAnchor constant:-4.0],
            [eyeIcon.centerYAnchor constraintEqualToAnchor:self.anchorLabel.centerYAnchor],
            [eyeIcon.widthAnchor constraintEqualToConstant:20.0],
            [eyeIcon.heightAnchor constraintEqualToConstant:20.0],

            [self.titleLabel.topAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:9.0],
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
