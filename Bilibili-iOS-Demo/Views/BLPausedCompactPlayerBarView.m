#import "BLPausedCompactPlayerBarView.h"

static UIColor *BLPausedBarPink(void) {
    return [UIColor colorWithRed:0.93 green:0.38 blue:0.58 alpha:1.0];
}

@implementation BLPausedCompactPlayerBarView
{
    UIView *_pinkBackgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor blackColor];

    _pinkBackgroundView = [[UIView alloc] init];
    _pinkBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _pinkBackgroundView.backgroundColor = BLPausedBarPink();
    _pinkBackgroundView.alpha = 0.0;
    [self addSubview:_pinkBackgroundView];

    UIButton *backButton = [self iconButton:@"chevron.left" pointSize:30.0];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];

    UIButton *homeButton = [self iconButton:@"house" pointSize:27.0];
    [homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:homeButton];

    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [continueButton setTitle:@"  继续播放" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightRegular];
    UIImageSymbolConfiguration *playConfig = [UIImageSymbolConfiguration configurationWithPointSize:28.0 weight:UIImageSymbolWeightSemibold];
    [continueButton setImage:[[UIImage systemImageNamed:@"play.fill"] imageWithConfiguration:playConfig] forState:UIControlStateNormal];
    continueButton.tintColor = [UIColor whiteColor];
    [continueButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];

    UIButton *settingsButton = [self iconButton:@"ellipsis" pointSize:27.0];
    settingsButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    [settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingsButton];

    [NSLayoutConstraint activateConstraints:@[
        [_pinkBackgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_pinkBackgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_pinkBackgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_pinkBackgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [backButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18.0],
        [backButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [backButton.widthAnchor constraintEqualToConstant:44.0],
        [backButton.heightAnchor constraintEqualToConstant:44.0],

        [homeButton.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:18.0],
        [homeButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [homeButton.widthAnchor constraintEqualToConstant:44.0],
        [homeButton.heightAnchor constraintEqualToConstant:44.0],

        [continueButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [continueButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [continueButton.heightAnchor constraintEqualToConstant:54.0],
        [continueButton.widthAnchor constraintGreaterThanOrEqualToConstant:190.0],

        [settingsButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-22.0],
        [settingsButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [settingsButton.widthAnchor constraintEqualToConstant:44.0],
        [settingsButton.heightAnchor constraintEqualToConstant:44.0]
    ]];
}

- (void)setPinkProgress:(CGFloat)progress {
    _pinkBackgroundView.alpha = MIN(1.0, MAX(0.0, progress));
}

- (UIButton *)iconButton:(NSString *)symbol pointSize:(CGFloat)pointSize {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    [button setImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:configuration] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    return button;
}

- (void)backButtonTapped {
    if (self.backTapped) {
        self.backTapped();
    }
}

- (void)homeButtonTapped {
    if (self.homeTapped) {
        self.homeTapped();
    }
}

- (void)continueButtonTapped {
    if (self.continueTapped) {
        self.continueTapped();
    }
}

- (void)settingsButtonTapped {
    if (self.settingsTapped) {
        self.settingsTapped();
    }
}

@end
