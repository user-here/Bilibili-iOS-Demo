#import "BLVideoDetailViewController.h"
#import "BLVideoPlayerView.h"
#import "BLPlaybackSettingsPanelView.h"
#import "BLPausedCompactPlayerBarView.h"
#import "BLSharePanelView.h"

static UIColor *BLVideoDetailPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

@interface BLVideoRecommendationRow : UIView
@end

@implementation BLVideoRecommendationRow

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views duration:(NSString *)duration colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];

        UIView *cover = [[UIView alloc] init];
        cover.translatesAutoresizingMaskIntoConstraints = NO;
        cover.backgroundColor = colors.firstObject ?: [UIColor colorWithWhite:0.85 alpha:1.0];
        cover.layer.cornerRadius = 4.0;
        cover.layer.masksToBounds = YES;
        [self addSubview:cover];

        UILabel *mark = [self labelWithText:[title substringToIndex:MIN(1, title.length)] font:[UIFont systemFontOfSize:28.0 weight:UIFontWeightHeavy] color:[[UIColor whiteColor] colorWithAlphaComponent:0.88]];
        mark.textAlignment = NSTextAlignmentCenter;
        [cover addSubview:mark];

        UILabel *durationLabel = [self labelWithText:duration font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
        durationLabel.textAlignment = NSTextAlignmentRight;
        [cover addSubview:durationLabel];

        UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithRed:0.14 green:0.14 blue:0.16 alpha:1.0]];
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];

        UILabel *authorLabel = [self labelWithText:author font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.56 alpha:1.0]];
        [self addSubview:authorLabel];

        UILabel *statLabel = [self labelWithText:views font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.56 alpha:1.0]];
        [self addSubview:statLabel];

        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        more.translatesAutoresizingMaskIntoConstraints = NO;
        [more setTitle:@"⋮" forState:UIControlStateNormal];
        [more setTitleColor:[UIColor colorWithWhite:0.58 alpha:1.0] forState:UIControlStateNormal];
        more.titleLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightRegular];
        [self addSubview:more];

        [NSLayoutConstraint activateConstraints:@[
            [self.heightAnchor constraintEqualToConstant:110.0],
            [cover.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
            [cover.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [cover.widthAnchor constraintEqualToConstant:152.0],
            [cover.heightAnchor constraintEqualToConstant:86.0],
            [mark.centerXAnchor constraintEqualToAnchor:cover.centerXAnchor],
            [mark.centerYAnchor constraintEqualToAnchor:cover.centerYAnchor],
            [durationLabel.trailingAnchor constraintEqualToAnchor:cover.trailingAnchor constant:-6.0],
            [durationLabel.bottomAnchor constraintEqualToAnchor:cover.bottomAnchor constant:-5.0],
            [titleLabel.leadingAnchor constraintEqualToAnchor:cover.trailingAnchor constant:12.0],
            [titleLabel.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-6.0],
            [titleLabel.topAnchor constraintEqualToAnchor:cover.topAnchor constant:2.0],
            [authorLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
            [authorLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10.0],
            [authorLabel.trailingAnchor constraintLessThanOrEqualToAnchor:more.leadingAnchor constant:-6.0],
            [statLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
            [statLabel.topAnchor constraintEqualToAnchor:authorLabel.bottomAnchor constant:5.0],
            [more.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12.0],
            [more.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [more.widthAnchor constraintEqualToConstant:28.0],
            [more.heightAnchor constraintEqualToConstant:40.0]
        ]];
    }
    return self;
}

- (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end

@interface BLVideoActionItemView : UIControl

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(NSString *)normalImage
                selectedImage:(NSString *)selectedImage;
- (void)setActive:(BOOL)active;
- (void)setTitleText:(NSString *)title;
- (void)setIconTransform:(CGAffineTransform)transform;

@end

@interface BLVideoActionItemView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *normalImage;
@property (nonatomic, copy) NSString *selectedImage;
@property (nonatomic, assign) BOOL active;
@end

@implementation BLVideoActionItemView

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(NSString *)normalImage
                selectedImage:(NSString *)selectedImage {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _normalImage = [normalImage copy];
        _selectedImage = [selectedImage copy];

        UIStackView *stack = [[UIStackView alloc] init];
        stack.translatesAutoresizingMaskIntoConstraints = NO;
        stack.axis = UILayoutConstraintAxisVertical;
        stack.alignment = UIStackViewAlignmentCenter;
        stack.spacing = 6.0;
        stack.userInteractionEnabled = NO;
        [self addSubview:stack];

        self.iconView = [[UIImageView alloc] init];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        [stack addArrangedSubview:self.iconView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.48 alpha:1.0];
        [stack addArrangedSubview:self.titleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
            [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [self.iconView.widthAnchor constraintEqualToConstant:34.0],
            [self.iconView.heightAnchor constraintEqualToConstant:34.0]
        ]];
        [self setActive:NO];
    }
    return self;
}

- (void)setActive:(BOOL)active {
    _active = active;
    NSString *imageName = active ? self.selectedImage : self.normalImage;
    self.iconView.image = [UIImage imageNamed:imageName];
    self.titleLabel.textColor = active ? BLVideoDetailPink() : [UIColor colorWithWhite:0.48 alpha:1.0];
}

- (void)setTitleText:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setIconTransform:(CGAffineTransform)transform {
    self.iconView.transform = transform;
}

@end

static CGFloat const BLVideoDetailIntermediatePlayerHeight = 118.0;
static CGFloat const BLVideoDetailCompactPlayerHeight = 62.0;
static CGFloat const BLVideoDetailCollapseDistance = 240.0;

@interface BLVideoDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) UIView *playerHeaderView;
@property (nonatomic, strong) BLVideoPlayerView *playerView;
@property (nonatomic, strong) BLPausedCompactPlayerBarView *compactPlayerBarView;
@property (nonatomic, strong) BLPlaybackSettingsPanelView *settingsPanelView;
@property (nonatomic, strong) BLSharePanelView *sharePanelView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, strong) BLVideoActionItemView *likeActionView;
@property (nonatomic, strong) BLVideoActionItemView *dislikeActionView;
@property (nonatomic, strong) BLVideoActionItemView *coinActionView;
@property (nonatomic, strong) BLVideoActionItemView *favoriteActionView;
@property (nonatomic, strong) BLVideoActionItemView *shareActionView;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIView *interestSectionView;
@property (nonatomic, strong) NSLayoutConstraint *playerHeaderHeightConstraint;
@property (nonatomic, assign) CGFloat expandedPlayerHeight;
@property (nonatomic, assign) BOOL compactPlayerVisible;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger dislikeCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL disliked;
@property (nonatomic, assign) BOOL coined;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL interestSectionHasShown;
- (NSString *)countTextForValue:(NSInteger)value fallback:(NSString *)fallback;
@end

@implementation BLVideoDetailViewController

- (instancetype)initWithVideoURL:(NSURL *)videoURL title:(NSString *)title author:(NSString *)author {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _videoURL = videoURL;
        _videoTitle = title;
        _author = author;
        _likeCount = 1995;
        _dislikeCount = 0;
        _favoriteCount = 383;
        _shareCount = 117;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self buildView];
    [self.playerView loadURL:self.videoURL autoplay:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView.playerCore pause];
}

- (void)buildView {
    self.playerHeaderView = [[UIView alloc] init];
    self.playerHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerHeaderView.backgroundColor = [UIColor blackColor];
    self.playerHeaderView.clipsToBounds = YES;
    [self.view addSubview:self.playerHeaderView];

    self.playerView = [[BLVideoPlayerView alloc] init];
    [self.playerView setVideoGravity:AVLayerVideoGravityResizeAspect];
    __weak typeof(self) weakSelf = self;
    self.playerView.closeTapped = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.playerView.settingsTapped = ^{
        [weakSelf showSettingsPanel];
    };
    [self.playerHeaderView addSubview:self.playerView];

    self.compactPlayerBarView = [[BLPausedCompactPlayerBarView alloc] init];
    self.compactPlayerBarView.alpha = 0.0;
    self.compactPlayerBarView.hidden = YES;
    self.compactPlayerBarView.backTapped = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.compactPlayerBarView.homeTapped = ^{
        [weakSelf expandPausedPlayerAnimated:YES playWhenFinished:NO];
    };
    self.compactPlayerBarView.continueTapped = ^{
        [weakSelf expandPausedPlayerAnimated:YES playWhenFinished:YES];
    };
    self.compactPlayerBarView.settingsTapped = ^{
        [weakSelf showSettingsPanel];
    };
    [self.playerHeaderView addSubview:self.compactPlayerBarView];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self buildToastView];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 0.0;
    [self.scrollView addSubview:stack];

    [stack addArrangedSubview:[self tabBarSection]];
    [stack addArrangedSubview:[self authorSection]];
    self.interestSectionView = [self interestSection];
    self.interestSectionView.hidden = YES;
    [stack addArrangedSubview:self.interestSectionView];
    [stack addArrangedSubview:[self titleSection]];
    [stack addArrangedSubview:[self actionSection]];
    [stack addArrangedSubview:[self topicSection]];
    [stack addArrangedSubview:[self separator]];
    for (UIView *row in [self recommendationRows]) {
        [stack addArrangedSubview:row];
        [stack addArrangedSubview:[self separator]];
    }

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    self.expandedPlayerHeight = CGRectGetWidth(UIScreen.mainScreen.bounds) * 9.0 / 16.0;
    self.playerHeaderHeightConstraint = [self.playerHeaderView.heightAnchor constraintEqualToConstant:self.expandedPlayerHeight];
    [NSLayoutConstraint activateConstraints:@[
        [self.playerHeaderView.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [self.playerHeaderView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.playerHeaderView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        self.playerHeaderHeightConstraint,

        [self.playerView.topAnchor constraintEqualToAnchor:self.playerHeaderView.topAnchor],
        [self.playerView.leadingAnchor constraintEqualToAnchor:self.playerHeaderView.leadingAnchor],
        [self.playerView.trailingAnchor constraintEqualToAnchor:self.playerHeaderView.trailingAnchor],
        [self.playerView.bottomAnchor constraintEqualToAnchor:self.playerHeaderView.bottomAnchor],

        [self.compactPlayerBarView.topAnchor constraintEqualToAnchor:self.playerHeaderView.topAnchor],
        [self.compactPlayerBarView.leadingAnchor constraintEqualToAnchor:self.playerHeaderView.leadingAnchor],
        [self.compactPlayerBarView.trailingAnchor constraintEqualToAnchor:self.playerHeaderView.trailingAnchor],
        [self.compactPlayerBarView.bottomAnchor constraintEqualToAnchor:self.playerHeaderView.bottomAnchor],

        [self.scrollView.topAnchor constraintEqualToAnchor:self.playerHeaderView.bottomAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [stack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [stack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat targetExpandedHeight = CGRectGetWidth(self.view.bounds) * 9.0 / 16.0;
    if (fabs(self.expandedPlayerHeight - targetExpandedHeight) > 0.5) {
        self.expandedPlayerHeight = targetExpandedHeight;
        if (!self.compactPlayerVisible) {
            self.playerHeaderHeightConstraint.constant = targetExpandedHeight;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    if (![self canCollapsePlayerForCurrentState]) {
        if (self.compactPlayerVisible) {
            [self setCompactProgress:0.0 animated:YES];
        }
        return;
    }
    CGFloat progress = MIN(1.0, MAX(0.0, scrollView.contentOffset.y / BLVideoDetailCollapseDistance));
    [self setCompactProgress:progress animated:NO];
}

- (void)setCompactProgress:(CGFloat)progress animated:(BOOL)animated {
    CGFloat firstStageProgress = MIN(1.0, progress / 0.72);
    CGFloat secondStageProgress = MIN(1.0, MAX(0.0, (progress - 0.72) / 0.28));
    CGFloat targetHeight = self.expandedPlayerHeight - (self.expandedPlayerHeight - BLVideoDetailIntermediatePlayerHeight) * firstStageProgress;
    targetHeight -= (BLVideoDetailIntermediatePlayerHeight - BLVideoDetailCompactPlayerHeight) * secondStageProgress;
    BOOL compactVisible = progress >= 0.98;
    CGFloat videoScaleProgress = MIN(1.0, progress / 0.55);
    CGFloat videoScale = 1.0 - 0.38 * videoScaleProgress;
    CGFloat videoFadeProgress = MIN(1.0, MAX(0.0, (progress - 0.45) / 0.45));
    CGFloat compactTextProgress = MIN(1.0, MAX(0.0, (progress - 0.25) / 0.35));
    CGFloat pinkProgress = MIN(1.0, MAX(0.0, (progress - 0.62) / 0.30));
    self.compactPlayerVisible = compactVisible;
    self.compactPlayerBarView.hidden = (progress <= 0.01);

    void (^changes)(void) = ^{
        self.playerHeaderHeightConstraint.constant = targetHeight;
        self.playerView.transform = CGAffineTransformMakeScale(videoScale, videoScale);
        self.playerView.alpha = 1.0 - videoFadeProgress;
        self.compactPlayerBarView.alpha = compactTextProgress;
        [self.compactPlayerBarView setPinkProgress:pinkProgress];
        [self.view layoutIfNeeded];
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.playerView.hidden = compactVisible;
        self.compactPlayerBarView.hidden = !compactVisible && progress <= 0.01;
    };

    if (compactVisible) {
        self.compactPlayerBarView.hidden = NO;
    } else {
        self.playerView.hidden = NO;
    }
    if (animated) {
        [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:changes completion:completion];
    } else {
        changes();
        completion(YES);
    }
}

- (BOOL)canCollapsePlayerForCurrentState {
    BLPlayerPlaybackState state = self.playerView.playerCore.playbackState;
    return state == BLPlayerPlaybackStatePaused ||
           state == BLPlayerPlaybackStateFailed ||
           state == BLPlayerPlaybackStateEnded;
}

- (void)expandPausedPlayerAnimated:(BOOL)animated playWhenFinished:(BOOL)playWhenFinished {
    self.playerView.hidden = NO;
    self.compactPlayerBarView.hidden = NO;
    void (^changes)(void) = ^{
        [self.scrollView setContentOffset:CGPointZero animated:NO];
        self.playerHeaderHeightConstraint.constant = self.expandedPlayerHeight;
        self.playerView.transform = CGAffineTransformIdentity;
        self.playerView.alpha = 1.0;
        self.compactPlayerBarView.alpha = 0.0;
        [self.compactPlayerBarView setPinkProgress:0.0];
        [self.view layoutIfNeeded];
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.compactPlayerVisible = NO;
        self.compactPlayerBarView.hidden = YES;
        if (playWhenFinished) {
            [self.playerView.playerCore play];
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:changes completion:completion];
    } else {
        changes();
        completion(YES);
    }
}

- (void)showSettingsPanel {
    [self buildSettingsPanelIfNeeded];
    [self.settingsPanelView setSelectedRate:self.playerView.playbackRate];
    self.settingsPanelView.hidden = NO;
    self.settingsPanelView.alpha = 0.0;
    [self.settingsPanelView.superview layoutIfNeeded];
    [self.settingsPanelView setPanelVerticalOffset:CGRectGetHeight(self.settingsPanelView.bounds) * 0.62];
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.settingsPanelView.alpha = 1.0;
        [self.settingsPanelView setPanelVerticalOffset:0.0];
    } completion:nil];
}

- (void)dismissSettingsPanel {
    if (self.settingsPanelView.hidden) {
        return;
    }
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.settingsPanelView.alpha = 0.0;
        [self.settingsPanelView setPanelVerticalOffset:CGRectGetHeight(self.settingsPanelView.bounds) * 0.62];
    } completion:^(BOOL finished) {
        self.settingsPanelView.hidden = YES;
        [self.settingsPanelView setPanelVerticalOffset:0.0];
    }];
}

- (void)buildSettingsPanelIfNeeded {
    if (self.settingsPanelView != nil) {
        return;
    }
    self.settingsPanelView = [[BLPlaybackSettingsPanelView alloc] init];
    self.settingsPanelView.hidden = YES;

    __weak typeof(self) weakSelf = self;
    self.settingsPanelView.dismissRequested = ^{
        [weakSelf dismissSettingsPanel];
    };
    self.settingsPanelView.rateSelected = ^(float rate) {
        [weakSelf.playerView setPlaybackRate:rate];
        [weakSelf.settingsPanelView setSelectedRate:rate];
    };

    [self.view addSubview:self.settingsPanelView];
    [NSLayoutConstraint activateConstraints:@[
        [self.settingsPanelView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.settingsPanelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.settingsPanelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.settingsPanelView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)showSharePanel {
    [self buildSharePanelIfNeeded];
    self.sharePanelView.hidden = NO;
    self.sharePanelView.alpha = 0.0;
    [self.sharePanelView.superview layoutIfNeeded];
    [self.sharePanelView setPanelVerticalOffset:CGRectGetHeight(self.sharePanelView.bounds) * 0.42];
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.sharePanelView.alpha = 1.0;
        [self.sharePanelView setPanelVerticalOffset:0.0];
    } completion:nil];
}

- (void)dismissSharePanel {
    if (self.sharePanelView.hidden) {
        return;
    }
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sharePanelView.alpha = 0.0;
        [self.sharePanelView setPanelVerticalOffset:CGRectGetHeight(self.sharePanelView.bounds) * 0.42];
    } completion:^(BOOL finished) {
        self.sharePanelView.hidden = YES;
        [self.sharePanelView setPanelVerticalOffset:0.0];
    }];
}

- (void)buildSharePanelIfNeeded {
    if (self.sharePanelView != nil) {
        return;
    }
    self.sharePanelView = [[BLSharePanelView alloc] init];
    self.sharePanelView.hidden = YES;

    __weak typeof(self) weakSelf = self;
    self.sharePanelView.dismissRequested = ^{
        [weakSelf dismissSharePanel];
    };
    self.sharePanelView.optionSelected = ^(NSString *title) {
        weakSelf.shareCount += 1;
        [weakSelf.shareActionView setActive:YES];
        [weakSelf.shareActionView setTitleText:[weakSelf countTextForValue:weakSelf.shareCount fallback:@"分享"]];
        [weakSelf showToast:@"已分享"];
        [weakSelf dismissSharePanel];
    };

    [self.view addSubview:self.sharePanelView];
    [NSLayoutConstraint activateConstraints:@[
        [self.sharePanelView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.sharePanelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.sharePanelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.sharePanelView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)buildToastView {
    self.toastLabel = [[UILabel alloc] init];
    self.toastLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.toastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.72];
    self.toastLabel.textColor = [UIColor whiteColor];
    self.toastLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    self.toastLabel.textAlignment = NSTextAlignmentCenter;
    self.toastLabel.layer.cornerRadius = 18.0;
    self.toastLabel.layer.masksToBounds = YES;
    self.toastLabel.alpha = 0.0;
    [self.view addSubview:self.toastLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.toastLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.toastLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-96.0],
        [self.toastLabel.heightAnchor constraintEqualToConstant:36.0],
        [self.toastLabel.widthAnchor constraintGreaterThanOrEqualToConstant:154.0]
    ]];
}

- (void)showToast:(NSString *)message {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToast) object:nil];
    [self.view bringSubviewToFront:self.toastLabel];
    self.toastLabel.text = [NSString stringWithFormat:@"  %@  ", message];
    self.toastLabel.alpha = 0.0;
    [UIView animateWithDuration:0.16 animations:^{
        self.toastLabel.alpha = 1.0;
    }];
    [self performSelector:@selector(hideToast) withObject:nil afterDelay:1.0];
}

- (void)hideToast {
    [UIView animateWithDuration:0.18 animations:^{
        self.toastLabel.alpha = 0.0;
    }];
}

- (UIView *)tabBarSection {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];

    UILabel *intro = [self labelWithText:@"简介" font:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium] color:BLVideoDetailPink()];
    [view addSubview:intro];
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = BLVideoDetailPink();
    line.layer.cornerRadius = 1.5;
    [view addSubview:line];

    UILabel *comment = [self labelWithText:@"评论 239" font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.42 alpha:1.0]];
    [view addSubview:comment];

    UIView *danmakuBox = [[UIView alloc] init];
    danmakuBox.translatesAutoresizingMaskIntoConstraints = NO;
    danmakuBox.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    danmakuBox.layer.cornerRadius = 18.0;
    danmakuBox.layer.borderWidth = 1.0;
    danmakuBox.layer.borderColor = [UIColor colorWithWhite:0.88 alpha:1.0].CGColor;
    [view addSubview:danmakuBox];
    UILabel *danmakuText = [self labelWithText:@"点我发弹幕" font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.56 alpha:1.0]];
    [danmakuBox addSubview:danmakuText];
    UILabel *danmakuIcon = [self labelWithText:@"弹" font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold] color:[UIColor colorWithWhite:0.32 alpha:1.0]];
    danmakuIcon.textAlignment = NSTextAlignmentCenter;
    [danmakuBox addSubview:danmakuIcon];

    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:58.0],
        [intro.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16.0],
        [intro.topAnchor constraintEqualToAnchor:view.topAnchor constant:14.0],
        [line.leadingAnchor constraintEqualToAnchor:intro.leadingAnchor],
        [line.topAnchor constraintEqualToAnchor:intro.bottomAnchor constant:13.0],
        [line.widthAnchor constraintEqualToConstant:34.0],
        [line.heightAnchor constraintEqualToConstant:3.0],
        [comment.leadingAnchor constraintEqualToAnchor:intro.trailingAnchor constant:62.0],
        [comment.centerYAnchor constraintEqualToAnchor:intro.centerYAnchor],
        [danmakuBox.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16.0],
        [danmakuBox.centerYAnchor constraintEqualToAnchor:intro.centerYAnchor],
        [danmakuBox.widthAnchor constraintEqualToConstant:176.0],
        [danmakuBox.heightAnchor constraintEqualToConstant:36.0],
        [danmakuText.leadingAnchor constraintEqualToAnchor:danmakuBox.leadingAnchor constant:18.0],
        [danmakuText.centerYAnchor constraintEqualToAnchor:danmakuBox.centerYAnchor],
        [danmakuIcon.trailingAnchor constraintEqualToAnchor:danmakuBox.trailingAnchor constant:-14.0],
        [danmakuIcon.centerYAnchor constraintEqualToAnchor:danmakuBox.centerYAnchor],
        [danmakuIcon.widthAnchor constraintEqualToConstant:24.0]
    ]];
    return view;
}

- (UIView *)authorSection {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];

    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.backgroundColor = [UIColor colorWithRed:0.80 green:0.90 blue:0.92 alpha:1.0];
    avatar.layer.cornerRadius = 25.0;
    [view addSubview:avatar];

    UILabel *avatarText = [self labelWithText:@"UP" font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightBold] color:[UIColor colorWithWhite:0.22 alpha:1.0]];
    avatarText.textAlignment = NSTextAlignmentCenter;
    [avatar addSubview:avatarText];

    UILabel *name = [self labelWithText:self.author font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:[UIColor colorWithRed:0.14 green:0.14 blue:0.16 alpha:1.0]];
    [view addSubview:name];

    UILabel *meta = [self labelWithText:@"606粉丝   100视频" font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    [view addSubview:meta];

    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.followButton.backgroundColor = BLVideoDetailPink();
    self.followButton.layer.cornerRadius = 20.0;
    [self.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    [self.followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.followButton];

    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:78.0],
        [avatar.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16.0],
        [avatar.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [avatar.widthAnchor constraintEqualToConstant:50.0],
        [avatar.heightAnchor constraintEqualToConstant:50.0],
        [avatarText.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [avatarText.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [name.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:14.0],
        [name.topAnchor constraintEqualToAnchor:avatar.topAnchor constant:3.0],
        [meta.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [meta.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:5.0],
        [self.followButton.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16.0],
        [self.followButton.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [self.followButton.widthAnchor constraintEqualToConstant:96.0],
        [self.followButton.heightAnchor constraintEqualToConstant:40.0],
        [name.trailingAnchor constraintLessThanOrEqualToAnchor:self.followButton.leadingAnchor constant:-12.0]
    ]];
    return view;
}

- (UIView *)interestSection {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];

    UILabel *title = [self labelWithText:@"你可能感兴趣" font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold] color:[UIColor colorWithRed:0.14 green:0.14 blue:0.16 alpha:1.0]];
    [view addSubview:title];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightRegular];
    [closeButton setImage:[[UIImage systemImageNamed:@"xmark"] imageWithConfiguration:config] forState:UIControlStateNormal];
    closeButton.tintColor = [UIColor colorWithWhite:0.36 alpha:1.0];
    [closeButton addTarget:self action:@selector(closeInterestSectionTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [view addSubview:scrollView];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 14.0;
    [scrollView addSubview:stack];

    NSArray *items = @[
        @[@"鸣哇频道", @"60万粉丝 52视频", [UIColor colorWithRed:0.98 green:0.83 blue:0.88 alpha:1.0]],
        @[@"鸣潮先行公约", @"106.4万粉丝 331视频", [UIColor colorWithRed:0.80 green:0.90 blue:0.66 alpha:1.0]],
        @[@"鬼叔怪谈", @"225.9万粉丝 214视频", [UIColor colorWithRed:0.74 green:0.76 blue:0.84 alpha:1.0]],
        @[@"风景收集站", @"48万粉丝 86视频", [UIColor colorWithRed:0.72 green:0.86 blue:0.92 alpha:1.0]]
    ];
    for (NSArray *item in items) {
        [stack addArrangedSubview:[self interestCardWithName:item[0] meta:item[1] color:item[2]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:250.0],
        [title.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:view.topAnchor constant:12.0],
        [closeButton.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-18.0],
        [closeButton.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:38.0],
        [closeButton.heightAnchor constraintEqualToConstant:38.0],
        [scrollView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
        [scrollView.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:14.0],
        [scrollView.heightAnchor constraintEqualToConstant:190.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:16.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-16.0],
        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.heightAnchor]
    ]];
    return view;
}

- (UIView *)interestCardWithName:(NSString *)name meta:(NSString *)meta color:(UIColor *)color {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;

    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.backgroundColor = color;
    avatar.layer.cornerRadius = 27.0;
    [card addSubview:avatar];

    UILabel *mark = [self labelWithText:[name substringToIndex:MIN(1, name.length)] font:[UIFont systemFontOfSize:22.0 weight:UIFontWeightHeavy] color:[UIColor whiteColor]];
    mark.textAlignment = NSTextAlignmentCenter;
    [avatar addSubview:mark];

    UILabel *nameLabel = [self labelWithText:name font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold] color:BLVideoDetailPink()];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:nameLabel];

    UILabel *metaLabel = [self labelWithText:meta font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.55 alpha:1.0]];
    metaLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:metaLabel];

    UIButton *follow = [UIButton buttonWithType:UIButtonTypeCustom];
    follow.translatesAutoresizingMaskIntoConstraints = NO;
    follow.layer.cornerRadius = 15.0;
    follow.layer.borderWidth = 1.0;
    follow.layer.borderColor = BLVideoDetailPink().CGColor;
    [follow setTitle:@"+ 关注" forState:UIControlStateNormal];
    [follow setTitleColor:BLVideoDetailPink() forState:UIControlStateNormal];
    [follow setTitle:@"已关注" forState:UIControlStateSelected];
    [follow setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    follow.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    [follow addTarget:self action:@selector(interestFollowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:follow];

    [NSLayoutConstraint activateConstraints:@[
        [card.widthAnchor constraintEqualToConstant:146.0],
        [avatar.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [avatar.topAnchor constraintEqualToAnchor:card.topAnchor constant:16.0],
        [avatar.widthAnchor constraintEqualToConstant:54.0],
        [avatar.heightAnchor constraintEqualToConstant:54.0],
        [mark.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [mark.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [nameLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:10.0],
        [nameLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-10.0],
        [nameLabel.topAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:8.0],
        [metaLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:8.0],
        [metaLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-8.0],
        [metaLabel.topAnchor constraintEqualToAnchor:nameLabel.bottomAnchor constant:4.0],
        [metaLabel.bottomAnchor constraintLessThanOrEqualToAnchor:follow.topAnchor constant:-8.0],
        [follow.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [follow.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-12.0],
        [follow.widthAnchor constraintEqualToConstant:82.0],
        [follow.heightAnchor constraintEqualToConstant:30.0]
    ]];
    return card;
}

- (void)interestFollowButtonTapped:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1.0];
        button.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        button.backgroundColor = [UIColor clearColor];
        button.layer.borderColor = BLVideoDetailPink().CGColor;
    }
}

- (void)followButtonTapped {
    self.followed = !self.followed;
    if (self.followed) {
        self.followButton.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1.0];
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (!self.interestSectionHasShown) {
            self.interestSectionHasShown = YES;
            self.interestSectionView.hidden = NO;
            self.interestSectionView.alpha = 0.0;
            [UIView animateWithDuration:0.24 animations:^{
                self.interestSectionView.alpha = 1.0;
                [self.view layoutIfNeeded];
            }];
        }
    } else {
        self.followButton.backgroundColor = BLVideoDetailPink();
        [self.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)closeInterestSectionTapped {
    [UIView animateWithDuration:0.2 animations:^{
        self.interestSectionView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.interestSectionView.hidden = YES;
    }];
}

- (UIView *)titleSection {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];

    UILabel *tag = [self labelWithText:@"活动" font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:BLVideoDetailPink()];
    tag.textAlignment = NSTextAlignmentCenter;
    tag.backgroundColor = [[UIColor colorWithRed:1.0 green:0.90 blue:0.94 alpha:1.0] colorWithAlphaComponent:0.85];
    tag.layer.cornerRadius = 4.0;
    tag.layer.masksToBounds = YES;
    [view addSubview:tag];

    UILabel *title = [self labelWithText:self.videoTitle font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold] color:[UIColor colorWithRed:0.12 green:0.12 blue:0.14 alpha:1.0]];
    title.numberOfLines = 2;
    [view addSubview:title];

    UILabel *stat = [self labelWithText:@"▻ 9万   ▤ 100   2026年5月31日 09:06   5人正在看" font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.56 alpha:1.0]];
    stat.numberOfLines = 1;
    [view addSubview:stat];

    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:92.0],
        [tag.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16.0],
        [tag.topAnchor constraintEqualToAnchor:view.topAnchor constant:6.0],
        [tag.widthAnchor constraintEqualToConstant:42.0],
        [tag.heightAnchor constraintEqualToConstant:24.0],
        [title.leadingAnchor constraintEqualToAnchor:tag.trailingAnchor constant:10.0],
        [title.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-22.0],
        [title.topAnchor constraintEqualToAnchor:tag.topAnchor constant:-1.0],
        [stat.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16.0],
        [stat.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16.0],
        [stat.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:10.0]
    ]];
    return view;
}

- (UIView *)actionSection {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    [view addSubview:stack];

    self.likeActionView = [[BLVideoActionItemView alloc] initWithTitle:@"1995" normalImage:@"bl_like_before" selectedImage:@"bl_like_after"];
    [self.likeActionView addTarget:self action:@selector(likeActionTapped) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:self.likeActionView];

    self.dislikeActionView = [[BLVideoActionItemView alloc] initWithTitle:@"不喜欢" normalImage:@"bl_like_before" selectedImage:@"bl_like_after"];
    [self.dislikeActionView setIconTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [self.dislikeActionView addTarget:self action:@selector(dislikeActionTapped) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:self.dislikeActionView];

    self.coinActionView = [[BLVideoActionItemView alloc] initWithTitle:@"51" normalImage:@"bl_coin_before" selectedImage:@"bl_coin_after"];
    [self.coinActionView addTarget:self action:@selector(coinActionTapped) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:self.coinActionView];

    self.favoriteActionView = [[BLVideoActionItemView alloc] initWithTitle:[self countTextForValue:self.favoriteCount fallback:@"收藏"] normalImage:@"bl_favorite_before" selectedImage:@"bl_favorite_after"];
    [self.favoriteActionView addTarget:self action:@selector(favoriteActionTapped) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:self.favoriteActionView];

    self.shareActionView = [[BLVideoActionItemView alloc] initWithTitle:[self countTextForValue:self.shareCount fallback:@"分享"] normalImage:@"bl_share_before" selectedImage:@"bl_share_after"];
    [self.shareActionView addTarget:self action:@selector(shareActionTapped) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:self.shareActionView];

    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:82.0],
        [stack.topAnchor constraintEqualToAnchor:view.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]
    ]];
    return view;
}

- (void)likeActionTapped {
    if (self.liked) {
        self.liked = NO;
        self.likeCount = MAX(0, self.likeCount - 1);
        [self.likeActionView setActive:NO];
        [self updateLikeDislikeTitles];
        [self showToast:@"已取消点赞"];
        return;
    }

    self.liked = YES;
    self.likeCount += 1;
    if (self.disliked) {
        self.disliked = NO;
        self.dislikeCount = MAX(0, self.dislikeCount - 1);
        [self.dislikeActionView setActive:NO];
    }
    [self.likeActionView setActive:YES];
    [self updateLikeDislikeTitles];
    [self showToast:@"已点赞，感谢推荐"];
}

- (void)dislikeActionTapped {
    if (self.disliked) {
        self.disliked = NO;
        self.dislikeCount = MAX(0, self.dislikeCount - 1);
        [self.dislikeActionView setActive:NO];
        [self updateLikeDislikeTitles];
        [self showToast:@"已取消不喜欢"];
        return;
    }

    self.disliked = YES;
    self.dislikeCount += 1;
    if (self.liked) {
        self.liked = NO;
        self.likeCount = MAX(0, self.likeCount - 1);
        [self.likeActionView setActive:NO];
    }
    [self.dislikeActionView setActive:YES];
    [self updateLikeDislikeTitles];
    [self showToast:@"已减少此类推荐"];
}

- (void)coinActionTapped {
    if (self.coined) {
        [self showToast:@"已经投过币了"];
        return;
    }
    self.coined = YES;
    [self.coinActionView setActive:YES];
    [self showToast:@"已投币，感谢支持"];
}

- (void)favoriteActionTapped {
    self.favorited = !self.favorited;
    self.favoriteCount = self.favorited ? self.favoriteCount + 1 : MAX(0, self.favoriteCount - 1);
    [self.favoriteActionView setActive:self.favorited];
    [self.favoriteActionView setTitleText:[self countTextForValue:self.favoriteCount fallback:@"收藏"]];
    [self showToast:self.favorited ? @"已收藏" : @"已取消收藏"];
}

- (void)shareActionTapped {
    [self showSharePanel];
}

- (void)updateLikeDislikeTitles {
    [self.likeActionView setTitleText:self.likeCount > 0 ? [NSString stringWithFormat:@"%ld", (long)self.likeCount] : @"喜欢"];
    [self.dislikeActionView setTitleText:self.dislikeCount > 0 ? [NSString stringWithFormat:@"%ld", (long)self.dislikeCount] : @"不喜欢"];
}

- (NSString *)countTextForValue:(NSInteger)value fallback:(NSString *)fallback {
    return value > 0 ? [NSString stringWithFormat:@"%ld", (long)value] : fallback;
}

- (UIView *)actionItem:(NSString *)symbol title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 6.0;

    UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.0 weight:UIImageSymbolWeightSemibold]]];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.tintColor = [UIColor colorWithWhite:0.36 alpha:1.0];
    [stack addArrangedSubview:icon];

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.48 alpha:1.0]];
    [stack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [icon.widthAnchor constraintEqualToConstant:32.0],
        [icon.heightAnchor constraintEqualToConstant:32.0]
    ]];
    return stack;
}

- (UIView *)topicSection {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *topic = [UIButton buttonWithType:UIButtonTypeCustom];
    topic.translatesAutoresizingMaskIntoConstraints = NO;
    topic.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    topic.layer.cornerRadius = 18.0;
    [topic setTitle:@"拍同款 | 动物总动员 〉" forState:UIControlStateNormal];
    [topic setTitleColor:[UIColor colorWithWhite:0.38 alpha:1.0] forState:UIControlStateNormal];
    topic.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    [view addSubview:topic];
    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:56.0],
        [topic.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16.0],
        [topic.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [topic.widthAnchor constraintEqualToConstant:210.0],
        [topic.heightAnchor constraintEqualToConstant:36.0]
    ]];
    return view;
}

- (NSArray<UIView *> *)recommendationRows {
    return @[
        [[BLVideoRecommendationRow alloc] initWithTitle:@"藏马熊单靠咬合力把一整头牛从深坑中拉出来" author:@"Linightly" views:@"4万  ·  7" duration:@"0:09" colors:@[[UIColor colorWithRed:0.42 green:0.34 blue:0.26 alpha:1.0], [UIColor colorWithRed:0.72 green:0.62 blue:0.42 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"在大猩猩面前，最强壮的人类也只是像个玩具" author:@"跳跳虎2020" views:@"7.2万  ·  40" duration:@"0:13" colors:@[[UIColor colorWithRed:0.20 green:0.22 blue:0.20 alpha:1.0], [UIColor colorWithRed:0.48 green:0.52 blue:0.42 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"路边捡到棕熊宝宝" author:@"Uu糯米熊-" views:@"21.8万  ·  177" duration:@"0:59" colors:@[[UIColor colorWithRed:0.64 green:0.62 blue:0.58 alpha:1.0], [UIColor colorWithRed:0.32 green:0.28 blue:0.22 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"黑熊一家路边玩耍，镜头记录温柔瞬间" author:@"动物观察站" views:@"12.3万  ·  91" duration:@"1:12" colors:@[[UIColor colorWithRed:0.24 green:0.32 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.54 green:0.64 blue:0.42 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"海边日落延时摄影，每一秒都像壁纸" author:@"海风剪辑室" views:@"8.6万  ·  128" duration:@"2:36" colors:@[[UIColor colorWithRed:0.93 green:0.50 blue:0.36 alpha:1.0], [UIColor colorWithRed:0.32 green:0.48 blue:0.72 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"深夜食堂复刻：一碗热汤面如何治愈加班人" author:@"阿泽会做饭" views:@"15.4万  ·  304" duration:@"4:18" colors:@[[UIColor colorWithRed:0.78 green:0.42 blue:0.20 alpha:1.0], [UIColor colorWithRed:0.96 green:0.78 blue:0.45 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"把老旧房间改造成游戏工作台，只花了三天" author:@"改造计划A" views:@"6.1万  ·  87" duration:@"6:05" colors:@[[UIColor colorWithRed:0.20 green:0.24 blue:0.32 alpha:1.0], [UIColor colorWithRed:0.42 green:0.62 blue:0.78 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"新手也能看懂的相机参数：光圈快门 ISO 一次讲清" author:@"影像小课" views:@"23.7万  ·  562" duration:@"8:42" colors:@[[UIColor colorWithRed:0.12 green:0.12 blue:0.14 alpha:1.0], [UIColor colorWithRed:0.86 green:0.86 blue:0.82 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"周末城市骑行路线推荐：避开人流的五个角落" author:@"骑车去远方" views:@"3.9万  ·  45" duration:@"3:27" colors:@[[UIColor colorWithRed:0.28 green:0.56 blue:0.42 alpha:1.0], [UIColor colorWithRed:0.72 green:0.84 blue:0.62 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"一分钟看完一部冷门科幻短片，结尾反转很妙" author:@"片单收藏夹" views:@"18.2万  ·  233" duration:@"1:00" colors:@[[UIColor colorWithRed:0.28 green:0.22 blue:0.50 alpha:1.0], [UIColor colorWithRed:0.62 green:0.44 blue:0.86 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"键盘声音对比：青轴、茶轴、银轴到底差在哪" author:@"数码桌面控" views:@"9.8万  ·  176" duration:@"5:11" colors:@[[UIColor colorWithRed:0.18 green:0.20 blue:0.22 alpha:1.0], [UIColor colorWithRed:0.64 green:0.68 blue:0.72 alpha:1.0]]],
        [[BLVideoRecommendationRow alloc] initWithTitle:@"用 20 张照片记录一场突如其来的夏雨" author:@"街头取景器" views:@"5.5万  ·  69" duration:@"2:09" colors:@[[UIColor colorWithRed:0.30 green:0.42 blue:0.54 alpha:1.0], [UIColor colorWithRed:0.70 green:0.82 blue:0.90 alpha:1.0]]]
    ];
}

- (UIView *)separator {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    [view.heightAnchor constraintEqualToConstant:1.0].active = YES;
    return view;
}

- (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end
