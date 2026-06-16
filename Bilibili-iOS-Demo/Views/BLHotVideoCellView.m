#import "BLHotVideoCellView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLHotText(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

@interface BLHotVideoThumbView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *durationLabel;
@end

@implementation BLHotVideoThumbView

- (instancetype)initWithDuration:(NSString *)duration colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.24 green:0.38 blue:0.60 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.10 green:0.12 blue:0.16 alpha:1.0];
        self.backgroundColor = startColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];

        UILabel *mark = [self labelWithText:@"热门" font:[UIFont systemFontOfSize:28.0 weight:UIFontWeightBold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.88]];
        mark.textAlignment = NSTextAlignmentCenter;
        [self addSubview:mark];

        self.durationLabel = [self labelWithText:duration font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular] color:[UIColor whiteColor]];
        self.durationLabel.textAlignment = NSTextAlignmentCenter;
        self.durationLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.46];
        self.durationLabel.layer.cornerRadius = 3.0;
        self.durationLabel.layer.masksToBounds = YES;
        [self addSubview:self.durationLabel];

        [NSLayoutConstraint activateConstraints:@[
            [mark.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [mark.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [mark.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:12.0],
            [mark.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-12.0],
            [self.durationLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-6.0],
            [self.durationLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-6.0],
            [self.durationLabel.widthAnchor constraintEqualToConstant:48.0],
            [self.durationLabel.heightAnchor constraintEqualToConstant:24.0]
        ]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
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

@implementation BLHotVideoCellView

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views timeText:(NSString *)timeText duration:(NSString *)duration tag:(NSString *)tag colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];

        BLHotVideoThumbView *thumb = [[BLHotVideoThumbView alloc] initWithDuration:duration colors:colors];
        [self addSubview:thumb];

        UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:BLHotText()];
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:titleLabel];

        UILabel *tagLabel = [self pillLabelWithText:(tag.length > 0 ? tag : @"人气飙升") textColor:[UIColor colorWithRed:0.74 green:0.42 blue:0.24 alpha:1.0] borderColor:[UIColor colorWithRed:0.92 green:0.64 blue:0.42 alpha:1.0] fontSize:12.0];
        tagLabel.hidden = tag.length == 0;
        [self addSubview:tagLabel];

        UIStackView *authorRow = [[UIStackView alloc] init];
        authorRow.translatesAutoresizingMaskIntoConstraints = NO;
        authorRow.axis = UILayoutConstraintAxisHorizontal;
        authorRow.spacing = 6.0;
        authorRow.alignment = UIStackViewAlignmentCenter;
        [self addSubview:authorRow];

        UILabel *upBadge = [self pillLabelWithText:@"UP" textColor:[UIColor colorWithWhite:0.58 alpha:1.0] borderColor:[UIColor colorWithWhite:0.70 alpha:1.0] fontSize:10.0];
        [authorRow addArrangedSubview:upBadge];
        UILabel *authorLabel = [self labelWithText:author font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.56 alpha:1.0]];
        authorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [authorRow addArrangedSubview:authorLabel];

        UIStackView *statsRow = [[UIStackView alloc] init];
        statsRow.translatesAutoresizingMaskIntoConstraints = NO;
        statsRow.axis = UILayoutConstraintAxisHorizontal;
        statsRow.spacing = 7.0;
        statsRow.alignment = UIStackViewAlignmentCenter;
        [self addSubview:statsRow];

        UIImageView *playIcon = [self iconViewWithName:@"play.rectangle" pointSize:16.0];
        [statsRow addArrangedSubview:playIcon];
        UILabel *statsLabel = [self labelWithText:[NSString stringWithFormat:@"%@观看 · %@", views, timeText] font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.56 alpha:1.0]];
        statsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [statsRow addArrangedSubview:statsLabel];

        UIButton *more = [UIButton buttonWithType:UIButtonTypeSystem];
        more.translatesAutoresizingMaskIntoConstraints = NO;
        [more setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
        more.tintColor = [UIColor colorWithWhite:0.66 alpha:1.0];
        [more addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:more];

        [NSLayoutConstraint activateConstraints:@[
            [self.heightAnchor constraintEqualToConstant:164.0],
            [thumb.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
            [thumb.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [thumb.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.47],
            [thumb.heightAnchor constraintEqualToAnchor:thumb.widthAnchor multiplier:0.56],

            [titleLabel.leadingAnchor constraintEqualToAnchor:thumb.trailingAnchor constant:14.0],
            [titleLabel.topAnchor constraintEqualToAnchor:thumb.topAnchor constant:4.0],
            [titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-28.0],

            [tagLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
            [tagLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:6.0],
            [tagLabel.heightAnchor constraintEqualToConstant:22.0],

            [authorRow.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
            [authorRow.trailingAnchor constraintLessThanOrEqualToAnchor:titleLabel.trailingAnchor],
            [authorRow.bottomAnchor constraintEqualToAnchor:statsRow.topAnchor constant:-2.0],

            [statsRow.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
            [statsRow.trailingAnchor constraintLessThanOrEqualToAnchor:more.leadingAnchor constant:-8.0],
            [statsRow.bottomAnchor constraintEqualToAnchor:thumb.bottomAnchor constant:-2.0],
            [playIcon.widthAnchor constraintEqualToConstant:18.0],
            [playIcon.heightAnchor constraintEqualToConstant:18.0],

            [more.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12.0],
            [more.centerYAnchor constraintEqualToAnchor:statsRow.centerYAnchor],
            [more.widthAnchor constraintEqualToConstant:24.0],
            [more.heightAnchor constraintEqualToConstant:32.0]
        ]];
    }
    return self;
}

- (void)moreButtonTapped {
    if (self.moreTapped) {
        self.moreTapped();
    }
}

- (UILabel *)pillLabelWithText:(NSString *)text textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor fontSize:(CGFloat)fontSize {
    UILabel *label = [self labelWithText:text font:[UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular] color:textColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 1.0;
    label.layer.borderColor = borderColor.CGColor;
    label.layer.cornerRadius = 3.0;
    label.layer.masksToBounds = YES;
    [label.widthAnchor constraintGreaterThanOrEqualToConstant:25.0].active = YES;
    [label.heightAnchor constraintEqualToConstant:15.0].active = YES;
    return label;
}

- (UIImageView *)iconViewWithName:(NSString *)name pointSize:(CGFloat)pointSize {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = [UIColor colorWithWhite:0.58 alpha:1.0];
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
