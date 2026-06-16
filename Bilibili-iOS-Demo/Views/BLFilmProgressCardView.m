#import "BLFilmProgressCardView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLFilmProgressCardView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSLayoutConstraint *progressWidthConstraint;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation BLFilmProgressCardView

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle progress:(CGFloat)progress colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.progress = MAX(0.0, MIN(1.0, progress));

        self.coverView = [[UIView alloc] init];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        self.coverView.layer.cornerRadius = 4.0;
        self.coverView.layer.masksToBounds = YES;
        [self addSubview:self.coverView];

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.20 green:0.32 blue:0.46 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.58 green:0.20 blue:0.24 alpha:1.0];
        self.coverView.backgroundColor = startColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.coverView.layer insertSublayer:self.gradientLayer atIndex:0];

        UILabel *markLabel = [self labelWithText:[title substringToIndex:MIN(1, title.length)] font:[UIFont systemFontOfSize:30.0 weight:UIFontWeightHeavy] color:[[UIColor whiteColor] colorWithAlphaComponent:0.88]];
        markLabel.textAlignment = NSTextAlignmentCenter;
        [self.coverView addSubview:markLabel];

        UIView *progressTrack = [[UIView alloc] init];
        progressTrack.translatesAutoresizingMaskIntoConstraints = NO;
        progressTrack.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.38];
        progressTrack.layer.cornerRadius = 2.0;
        progressTrack.layer.masksToBounds = YES;
        [self.coverView addSubview:progressTrack];

        UIView *progressFill = [[UIView alloc] init];
        progressFill.translatesAutoresizingMaskIntoConstraints = NO;
        progressFill.backgroundColor = [UIColor whiteColor];
        progressFill.layer.cornerRadius = 2.0;
        progressFill.layer.masksToBounds = YES;
        [progressTrack addSubview:progressFill];

        UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1.0]];
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:titleLabel];

        UILabel *subtitleLabel = [self labelWithText:subtitle font:[UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
        subtitleLabel.numberOfLines = 1;
        subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:subtitleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [self.widthAnchor constraintEqualToConstant:104.0],
            [self.coverView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.coverView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.coverView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.coverView.heightAnchor constraintEqualToConstant:138.0],
            [markLabel.centerXAnchor constraintEqualToAnchor:self.coverView.centerXAnchor],
            [markLabel.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor constant:-4.0],
            [markLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.coverView.leadingAnchor constant:10.0],
            [markLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.coverView.trailingAnchor constant:-10.0],
            [progressTrack.leadingAnchor constraintEqualToAnchor:self.coverView.leadingAnchor constant:8.0],
            [progressTrack.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:-8.0],
            [progressTrack.bottomAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:-8.0],
            [progressTrack.heightAnchor constraintEqualToConstant:4.0],
            [progressFill.leadingAnchor constraintEqualToAnchor:progressTrack.leadingAnchor],
            [progressFill.topAnchor constraintEqualToAnchor:progressTrack.topAnchor],
            [progressFill.bottomAnchor constraintEqualToAnchor:progressTrack.bottomAnchor],
            [titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [titleLabel.topAnchor constraintEqualToAnchor:self.coverView.bottomAnchor constant:7.0],
            [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:2.0],
            [subtitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        self.progressWidthConstraint = [progressFill.widthAnchor constraintEqualToAnchor:progressTrack.widthAnchor multiplier:self.progress];
        self.progressWidthConstraint.active = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.coverView.bounds;
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
