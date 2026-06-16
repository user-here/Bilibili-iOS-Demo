#import "BLProfileHeaderView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLProfilePink(void) { return [UIColor colorWithRed:0.93 green:0.36 blue:0.56 alpha:1.0]; }
static UIColor *BLProfileText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }
static UIColor *BLProfileSubText(void) { return [UIColor colorWithWhite:0.55 alpha:1.0]; }

@interface BLProfileHeaderView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) CAGradientLayer *defaultGradientLayer;
@end

@implementation BLProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.defaultGradientLayer.frame = self.backgroundImageView.bounds;
}

- (void)updateBackgroundImage:(UIImage *)image {
    self.backgroundImageView.image = image;
    self.defaultGradientLayer.hidden = YES;
}

- (void)buildView {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self addSubview:self.backgroundImageView];

    self.defaultGradientLayer = [CAGradientLayer layer];
    self.defaultGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0.08 green:0.33 blue:0.34 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.21 green:0.63 blue:0.67 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.93 green:0.96 blue:0.92 alpha:1.0].CGColor
    ];
    self.defaultGradientLayer.startPoint = CGPointMake(0.0, 0.0);
    self.defaultGradientLayer.endPoint = CGPointMake(1.0, 1.0);
    [self.backgroundImageView.layer addSublayer:self.defaultGradientLayer];

    UILabel *tvMark = [self label:@"bili" size:46.0 weight:UIFontWeightHeavy color:[[UIColor whiteColor] colorWithAlphaComponent:0.86]];
    tvMark.textAlignment = NSTextAlignmentCenter;
    tvMark.layer.cornerRadius = 22.0;
    tvMark.layer.borderWidth = 5.0;
    tvMark.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72].CGColor;
    tvMark.layer.masksToBounds = YES;
    [self.backgroundImageView addSubview:tvMark];

    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    changeButton.translatesAutoresizingMaskIntoConstraints = NO;
    changeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    changeButton.layer.cornerRadius = 10.0;
    changeButton.tintColor = [UIColor whiteColor];
    [changeButton setImage:[UIImage systemImageNamed:@"tshirt"] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(backgroundButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundImageView addSubview:changeButton];

    UIView *profile = [[UIView alloc] init];
    profile.translatesAutoresizingMaskIntoConstraints = NO;
    profile.backgroundColor = [UIColor whiteColor];
    [self addSubview:profile];

    UIView *avatar = [self avatarView];
    [profile addSubview:avatar];

    UIStackView *stats = [[UIStackView alloc] init];
    stats.translatesAutoresizingMaskIntoConstraints = NO;
    stats.axis = UILayoutConstraintAxisHorizontal;
    stats.distribution = UIStackViewDistributionFillEqually;
    [profile addSubview:stats];
    [stats addArrangedSubview:[self stat:@"1" title:@"粉丝"]];
    [stats addArrangedSubview:[self stat:@"241" title:@"关注"]];
    [stats addArrangedSubview:[self stat:@"0" title:@"获赞"]];

    UIButton *edit = [UIButton buttonWithType:UIButtonTypeSystem];
    edit.translatesAutoresizingMaskIntoConstraints = NO;
    edit.layer.cornerRadius = 4.0;
    edit.layer.borderWidth = 1.4;
    edit.layer.borderColor = BLProfilePink().CGColor;
    [edit setTitle:@"编辑资料" forState:UIControlStateNormal];
    [edit setTitleColor:BLProfilePink() forState:UIControlStateNormal];
    edit.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    [profile addSubview:edit];

    UILabel *name = [self label:@"阿狸爱吃狐狸" size:23.0 weight:UIFontWeightRegular color:BLProfilePink()];
    [profile addSubview:name];
    UILabel *vip = [self pill:@"年度大会员" color:BLProfilePink()];
    [profile addSubview:vip];
    UILabel *badge = [self label:@"□ 粉丝勋章   ✚ 成就勋章" size:14.0 weight:UIFontWeightRegular color:BLProfileSubText()];
    [profile addSubview:badge];
    UILabel *level = [self label:@"LV5  28695/28800" size:15.0 weight:UIFontWeightSemibold color:[UIColor colorWithRed:0.76 green:0.39 blue:0.16 alpha:1.0]];
    [profile addSubview:level];
    UIView *levelLine = [[UIView alloc] init];
    levelLine.translatesAutoresizingMaskIntoConstraints = NO;
    levelLine.backgroundColor = [UIColor colorWithRed:0.87 green:0.47 blue:0.18 alpha:1.0];
    [profile addSubview:levelLine];
    UILabel *bio = [self label:@"这个人很神秘，什么都没有写" size:17.0 weight:UIFontWeightRegular color:BLProfileSubText()];
    [profile addSubview:bio];
    UILabel *ip = [self label:@"IP 属地：湖南    + 添加学校信息" size:15.0 weight:UIFontWeightRegular color:BLProfileSubText()];
    [profile addSubview:ip];
    UIButton *detail = [UIButton buttonWithType:UIButtonTypeSystem];
    detail.translatesAutoresizingMaskIntoConstraints = NO;
    [detail setTitle:@"详情" forState:UIControlStateNormal];
    [detail setTitleColor:[UIColor colorWithRed:0.20 green:0.47 blue:0.53 alpha:1.0] forState:UIControlStateNormal];
    detail.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    [profile addSubview:detail];

    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.backgroundImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.backgroundImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.backgroundImageView.heightAnchor constraintEqualToConstant:220.0],
        [tvMark.centerXAnchor constraintEqualToAnchor:self.backgroundImageView.centerXAnchor],
        [tvMark.centerYAnchor constraintEqualToAnchor:self.backgroundImageView.centerYAnchor constant:-12.0],
        [tvMark.widthAnchor constraintEqualToConstant:112.0],
        [tvMark.heightAnchor constraintEqualToConstant:84.0],
        [changeButton.trailingAnchor constraintEqualToAnchor:self.backgroundImageView.trailingAnchor constant:-18.0],
        [changeButton.bottomAnchor constraintEqualToAnchor:self.backgroundImageView.bottomAnchor constant:-16.0],
        [changeButton.widthAnchor constraintEqualToConstant:54.0],
        [changeButton.heightAnchor constraintEqualToConstant:54.0],
        [profile.topAnchor constraintEqualToAnchor:self.backgroundImageView.bottomAnchor],
        [profile.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [profile.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [profile.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [avatar.leadingAnchor constraintEqualToAnchor:profile.leadingAnchor constant:18.0],
        [avatar.topAnchor constraintEqualToAnchor:profile.topAnchor constant:-52.0],
        [avatar.widthAnchor constraintEqualToConstant:112.0],
        [avatar.heightAnchor constraintEqualToConstant:112.0],
        [stats.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:34.0],
        [stats.trailingAnchor constraintEqualToAnchor:profile.trailingAnchor constant:-18.0],
        [stats.topAnchor constraintEqualToAnchor:profile.topAnchor constant:16.0],
        [stats.heightAnchor constraintEqualToConstant:54.0],
        [edit.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:44.0],
        [edit.trailingAnchor constraintEqualToAnchor:profile.trailingAnchor constant:-18.0],
        [edit.topAnchor constraintEqualToAnchor:stats.bottomAnchor constant:8.0],
        [edit.heightAnchor constraintEqualToConstant:38.0],
        [name.leadingAnchor constraintEqualToAnchor:profile.leadingAnchor constant:18.0],
        [name.trailingAnchor constraintLessThanOrEqualToAnchor:profile.trailingAnchor constant:-18.0],
        [name.topAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:16.0],
        [vip.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [vip.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:9.0],
        [vip.widthAnchor constraintEqualToConstant:102.0],
        [vip.heightAnchor constraintEqualToConstant:24.0],
        [badge.leadingAnchor constraintEqualToAnchor:vip.trailingAnchor constant:10.0],
        [badge.centerYAnchor constraintEqualToAnchor:vip.centerYAnchor],
        [badge.trailingAnchor constraintLessThanOrEqualToAnchor:profile.trailingAnchor constant:-16.0],
        [level.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [level.topAnchor constraintEqualToAnchor:vip.bottomAnchor constant:13.0],
        [levelLine.leadingAnchor constraintEqualToAnchor:level.leadingAnchor],
        [levelLine.topAnchor constraintEqualToAnchor:level.bottomAnchor constant:5.0],
        [levelLine.widthAnchor constraintEqualToConstant:132.0],
        [levelLine.heightAnchor constraintEqualToConstant:3.0],
        [bio.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [bio.topAnchor constraintEqualToAnchor:levelLine.bottomAnchor constant:17.0],
        [detail.trailingAnchor constraintEqualToAnchor:profile.trailingAnchor constant:-22.0],
        [detail.centerYAnchor constraintEqualToAnchor:bio.centerYAnchor],
        [ip.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [ip.topAnchor constraintEqualToAnchor:bio.bottomAnchor constant:18.0]
    ]];
}

- (void)backgroundButtonTapped {
    if (self.backgroundTapped) {
        self.backgroundTapped();
    }
}

- (UIView *)avatarView {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *ring = [[UIView alloc] init];
    ring.translatesAutoresizingMaskIntoConstraints = NO;
    ring.layer.cornerRadius = 56.0;
    ring.layer.borderWidth = 5.0;
    ring.layer.borderColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.72 alpha:1.0].CGColor;
    ring.backgroundColor = [UIColor colorWithRed:0.87 green:0.95 blue:0.97 alpha:1.0];
    [container addSubview:ring];
    UILabel *face = [self label:@"狸" size:40.0 weight:UIFontWeightHeavy color:[UIColor colorWithWhite:0.22 alpha:1.0]];
    face.translatesAutoresizingMaskIntoConstraints = NO;
    face.textAlignment = NSTextAlignmentCenter;
    face.backgroundColor = [UIColor colorWithRed:0.88 green:0.80 blue:0.68 alpha:1.0];
    face.layer.cornerRadius = 36.0;
    face.layer.masksToBounds = YES;
    [container addSubview:face];
    UILabel *vip = [self pill:@"大" color:BLProfilePink()];
    vip.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightHeavy];
    [container addSubview:vip];
    [NSLayoutConstraint activateConstraints:@[
        [ring.topAnchor constraintEqualToAnchor:container.topAnchor],
        [ring.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [ring.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [ring.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [face.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [face.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [face.widthAnchor constraintEqualToConstant:72.0],
        [face.heightAnchor constraintEqualToConstant:72.0],
        [vip.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:3.0],
        [vip.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [vip.widthAnchor constraintEqualToConstant:36.0],
        [vip.heightAnchor constraintEqualToConstant:36.0]
    ]];
    return container;
}

- (UIView *)stat:(NSString *)number title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 3.0;
    [stack addArrangedSubview:[self label:number size:21.0 weight:UIFontWeightRegular color:BLProfileText()]];
    [stack addArrangedSubview:[self label:title size:15.0 weight:UIFontWeightRegular color:BLProfileSubText()]];
    return stack;
}

- (UILabel *)pill:(NSString *)text color:(UIColor *)color {
    UILabel *label = [self label:text size:14.0 weight:UIFontWeightSemibold color:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = color;
    label.layer.cornerRadius = 13.0;
    label.layer.masksToBounds = YES;
    return label;
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.72;
    return label;
}

@end
