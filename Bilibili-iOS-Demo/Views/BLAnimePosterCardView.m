#import "BLAnimePosterCardView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLAnimePosterCardView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation BLAnimePosterCardView

- (instancetype)initWithRank:(NSString *)rank title:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors {
    return [self initWithRank:rank title:title subtitle:subtitle badge:badge colors:colors cardWidth:104.0 coverHeight:138.0];
}

- (instancetype)initWithRank:(NSString *)rank title:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors cardWidth:(CGFloat)cardWidth coverHeight:(CGFloat)coverHeight {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        self.coverView = [[UIView alloc] init];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        self.coverView.layer.cornerRadius = 4.0;
        self.coverView.layer.masksToBounds = YES;
        [self addSubview:self.coverView];

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.90 green:0.38 blue:0.28 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.22 green:0.26 blue:0.52 alpha:1.0];
        self.coverView.backgroundColor = startColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.coverView.layer insertSublayer:self.gradientLayer atIndex:0];

        UILabel *rankLabel = [self labelWithText:rank font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightBold] color:[UIColor whiteColor]];
        rankLabel.textAlignment = NSTextAlignmentCenter;
        rankLabel.backgroundColor = [self colorForRank:rank];
        rankLabel.layer.cornerRadius = 8.0;
        rankLabel.layer.masksToBounds = YES;
        [self.coverView addSubview:rankLabel];

        UILabel *badgeLabel = [self labelWithText:badge font:[UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.22];
        badgeLabel.layer.cornerRadius = 8.0;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.hidden = (badge.length == 0);
        [self.coverView addSubview:badgeLabel];

        UILabel *mainMark = [self labelWithText:[title substringToIndex:MIN(1, title.length)] font:[UIFont systemFontOfSize:32.0 weight:UIFontWeightHeavy] color:[[UIColor whiteColor] colorWithAlphaComponent:0.86]];
        mainMark.textAlignment = NSTextAlignmentCenter;
        [self.coverView addSubview:mainMark];

        UILabel *episodeLabel = [self labelWithText:@"更新至37话" font:[UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
        episodeLabel.textAlignment = NSTextAlignmentRight;
        [self.coverView addSubview:episodeLabel];

        UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0]];
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:titleLabel];

        UILabel *subtitleLabel = [self labelWithText:subtitle font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
        subtitleLabel.numberOfLines = 1;
        subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:subtitleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [self.widthAnchor constraintEqualToConstant:cardWidth],
            [self.coverView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.coverView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.coverView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.coverView.heightAnchor constraintEqualToConstant:coverHeight],
            [rankLabel.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor constant:4.0],
            [rankLabel.topAnchor constraintEqualToAnchor:self.coverView.topAnchor constant:4.0],
            [rankLabel.widthAnchor constraintEqualToConstant:22.0],
            [rankLabel.heightAnchor constraintEqualToConstant:18.0],
            [badgeLabel.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:-5.0],
            [badgeLabel.topAnchor constraintEqualToAnchor:self.coverView.topAnchor constant:5.0],
            [badgeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:32.0],
            [badgeLabel.heightAnchor constraintEqualToConstant:18.0],
            [mainMark.centerXAnchor constraintEqualToAnchor:self.coverView.centerXAnchor],
            [mainMark.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor],
            [mainMark.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.coverView.leadingAnchor constant:12.0],
            [mainMark.trailingAnchor constraintLessThanOrEqualToAnchor:self.coverView.trailingAnchor constant:-12.0],
            [episodeLabel.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:-6.0],
            [episodeLabel.bottomAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:-6.0],
            [episodeLabel.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor constant:6.0],
            [titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [titleLabel.topAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:7.0],
            [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:2.0],
            [subtitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.coverView.bounds;
}

- (UIColor *)colorForRank:(NSString *)rank {
    NSInteger value = rank.integerValue;
    if (value == 1) {
        return [UIColor colorWithRed:0.98 green:0.77 blue:0.20 alpha:1.0];
    }
    if (value == 2) {
        return [UIColor colorWithRed:0.34 green:0.66 blue:0.92 alpha:1.0];
    }
    if (value == 3) {
        return [UIColor colorWithRed:0.98 green:0.48 blue:0.34 alpha:1.0];
    }
    return [UIColor colorWithWhite:0.40 alpha:0.72];
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
