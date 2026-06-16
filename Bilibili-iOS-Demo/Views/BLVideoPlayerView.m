#import "BLVideoPlayerView.h"
#import "BLPlayerRenderView.h"
#import "BLPlaybackSpeedToastView.h"

static UIColor *BLVideoPlayerPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

@interface BLVideoPlayerView ()
@property (nonatomic, strong) BLPlayerRenderView *renderView;
@property (nonatomic, strong) UIView *danmakuContainerView;
@property (nonatomic, strong) UIView *topOverlay;
@property (nonatomic, strong) UIView *bottomOverlay;
@property (nonatomic, strong) UIButton *toggleOverlayButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIView *volumePanelView;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIProgressView *bufferProgressView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) BLPlaybackSpeedToastView *speedToastView;
@property (nonatomic, strong) BLPlayerCore *playerCore;
@property (nonatomic, assign) BOOL draggingProgress;
@property (nonatomic, assign) BOOL controlsVisible;
@property (nonatomic, assign) float playbackRate;
@property (nonatomic, assign) float rateBeforeLongPress;
@property (nonatomic, assign) BOOL longPressAccelerating;
@end

@implementation BLVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor blackColor];
        self.playerCore = [[BLPlayerCore alloc] init];
        self.controlsVisible = YES;
        _playbackRate = 1.0;
        self.rateBeforeLongPress = 1.0;
        [self buildView];
        [self bindPlayerCore];
    }
    return self;
}

- (void)loadURL:(NSURL *)URL autoplay:(BOOL)autoplay {
    self.renderView.player = self.playerCore.player;
    [self.playerCore loadURL:URL autoplay:autoplay];
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    self.renderView.videoGravity = videoGravity;
}

- (void)setPlaybackRate:(float)rate {
    _playbackRate = MAX(0.1, rate);
    if (!self.longPressAccelerating) {
        [self.playerCore setRate:_playbackRate];
    }
}

- (void)buildView {
    self.renderView = [[BLPlayerRenderView alloc] init];
    self.renderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.renderView.videoGravity = AVLayerVideoGravityResizeAspect;
    [self addSubview:self.renderView];

    self.danmakuContainerView = [[UIView alloc] init];
    self.danmakuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.danmakuContainerView.userInteractionEnabled = NO;
    [self addSubview:self.danmakuContainerView];

    self.toggleOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toggleOverlayButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toggleOverlayButton addTarget:self action:@selector(toggleControlsTapped) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(videoLongPressed:)];
    longPress.minimumPressDuration = 0.35;
    longPress.cancelsTouchesInView = YES;
    [self.toggleOverlayButton addGestureRecognizer:longPress];
    [self addSubview:self.toggleOverlayButton];

    self.topOverlay = [[UIView alloc] init];
    self.topOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    self.topOverlay.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topOverlay];

    UIButton *backButton = [self iconButton:@"chevron.left" pointSize:24.0];
    [backButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topOverlay addSubview:backButton];

    UILabel *watchingLabel = [self labelWithText:@"5人正在看" font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[[UIColor whiteColor] colorWithAlphaComponent:0.92]];
    [self.topOverlay addSubview:watchingLabel];

    self.settingsButton = [self iconButton:@"ellipsis" pointSize:24.0];
    self.settingsButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topOverlay addSubview:self.settingsButton];

    self.stateLabel = [self labelWithText:@"加载中" font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.stateLabel];

    self.speedToastView = [[BLPlaybackSpeedToastView alloc] init];
    [self addSubview:self.speedToastView];

    self.bottomOverlay = [[UIView alloc] init];
    self.bottomOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.28];
    [self addSubview:self.bottomOverlay];

    self.playButton = [self iconButton:@"pause.fill" pointSize:20.0];
    [self.playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomOverlay addSubview:self.playButton];

    self.bufferProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.bufferProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bufferProgressView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    self.bufferProgressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.16];
    [self.bottomOverlay addSubview:self.bufferProgressView];

    self.progressSlider = [[UISlider alloc] init];
    self.progressSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressSlider.minimumValue = 0.0;
    self.progressSlider.maximumValue = 1.0;
    self.progressSlider.minimumTrackTintColor = BLVideoPlayerPink();
    self.progressSlider.maximumTrackTintColor = [UIColor clearColor];
    [self.progressSlider setThumbTintColor:[UIColor whiteColor]];
    [self.progressSlider addTarget:self action:@selector(progressDragBegan:) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self action:@selector(progressDragChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(progressDragEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self.bottomOverlay addSubview:self.progressSlider];

    self.timeLabel = [self labelWithText:@"00:00 / 00:00" font:[UIFont monospacedDigitSystemFontOfSize:12.0 weight:UIFontWeightRegular] color:[[UIColor whiteColor] colorWithAlphaComponent:0.92]];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomOverlay addSubview:self.timeLabel];

    self.muteButton = [self iconButton:@"speaker.wave.2.fill" pointSize:18.0];
    [self.muteButton addTarget:self action:@selector(volumeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomOverlay addSubview:self.muteButton];

    UIButton *danmakuButton = [self textButton:@"弹"];
    danmakuButton.layer.borderWidth = 1.0;
    danmakuButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72].CGColor;
    [self.bottomOverlay addSubview:danmakuButton];

    self.volumePanelView = [[UIView alloc] init];
    self.volumePanelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.volumePanelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.62];
    self.volumePanelView.layer.cornerRadius = 18.0;
    self.volumePanelView.layer.masksToBounds = YES;
    self.volumePanelView.alpha = 0.0;
    self.volumePanelView.hidden = YES;
    [self addSubview:self.volumePanelView];

    UIImageView *volumeIcon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:@"speaker.wave.2.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:16.0 weight:UIImageSymbolWeightSemibold]]];
    volumeIcon.translatesAutoresizingMaskIntoConstraints = NO;
    volumeIcon.tintColor = [UIColor whiteColor];
    volumeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.volumePanelView addSubview:volumeIcon];

    self.volumeSlider = [[UISlider alloc] init];
    self.volumeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.volumeSlider.minimumValue = 0.0;
    self.volumeSlider.maximumValue = 1.0;
    self.volumeSlider.value = self.playerCore.volume;
    self.volumeSlider.minimumTrackTintColor = BLVideoPlayerPink();
    self.volumeSlider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.24];
    [self.volumeSlider setThumbTintColor:[UIColor whiteColor]];
    self.volumeSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.volumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.volumePanelView addSubview:self.volumeSlider];

    [NSLayoutConstraint activateConstraints:@[
        [self.renderView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.renderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.renderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.renderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [self.danmakuContainerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.danmakuContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.danmakuContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.danmakuContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [self.toggleOverlayButton.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.toggleOverlayButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.toggleOverlayButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.toggleOverlayButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [self.topOverlay.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
        [self.topOverlay.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.topOverlay.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.topOverlay.heightAnchor constraintEqualToConstant:48.0],
        [backButton.leadingAnchor constraintEqualToAnchor:self.topOverlay.leadingAnchor constant:8.0],
        [backButton.centerYAnchor constraintEqualToAnchor:self.topOverlay.centerYAnchor],
        [backButton.widthAnchor constraintEqualToConstant:40.0],
        [backButton.heightAnchor constraintEqualToConstant:40.0],
        [watchingLabel.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:6.0],
        [watchingLabel.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [watchingLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.settingsButton.leadingAnchor constant:-8.0],
        [self.settingsButton.trailingAnchor constraintEqualToAnchor:self.topOverlay.trailingAnchor constant:-8.0],
        [self.settingsButton.centerYAnchor constraintEqualToAnchor:self.topOverlay.centerYAnchor],
        [self.settingsButton.widthAnchor constraintEqualToConstant:40.0],
        [self.settingsButton.heightAnchor constraintEqualToConstant:40.0],

        [self.stateLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.stateLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.speedToastView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.speedToastView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:48.0],

        [self.bottomOverlay.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.bottomOverlay.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.bottomOverlay.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.bottomOverlay.heightAnchor constraintEqualToConstant:54.0],
        [self.playButton.leadingAnchor constraintEqualToAnchor:self.bottomOverlay.leadingAnchor constant:8.0],
        [self.playButton.centerYAnchor constraintEqualToAnchor:self.bottomOverlay.centerYAnchor constant:4.0],
        [self.playButton.widthAnchor constraintEqualToConstant:36.0],
        [self.playButton.heightAnchor constraintEqualToConstant:36.0],

        [self.timeLabel.leadingAnchor constraintEqualToAnchor:self.playButton.trailingAnchor constant:4.0],
        [self.timeLabel.centerYAnchor constraintEqualToAnchor:self.playButton.centerYAnchor],
        [self.timeLabel.widthAnchor constraintEqualToConstant:88.0],
        [self.muteButton.trailingAnchor constraintEqualToAnchor:self.bottomOverlay.trailingAnchor constant:-8.0],
        [self.muteButton.centerYAnchor constraintEqualToAnchor:self.playButton.centerYAnchor],
        [self.muteButton.widthAnchor constraintEqualToConstant:34.0],
        [self.muteButton.heightAnchor constraintEqualToConstant:34.0],
        [danmakuButton.trailingAnchor constraintEqualToAnchor:self.muteButton.leadingAnchor constant:-6.0],
        [danmakuButton.centerYAnchor constraintEqualToAnchor:self.playButton.centerYAnchor],
        [danmakuButton.widthAnchor constraintEqualToConstant:32.0],
        [danmakuButton.heightAnchor constraintEqualToConstant:28.0],

        [self.bufferProgressView.leadingAnchor constraintEqualToAnchor:self.timeLabel.trailingAnchor constant:8.0],
        [self.bufferProgressView.trailingAnchor constraintEqualToAnchor:danmakuButton.leadingAnchor constant:-8.0],
        [self.bufferProgressView.centerYAnchor constraintEqualToAnchor:self.playButton.centerYAnchor],
        [self.progressSlider.leadingAnchor constraintEqualToAnchor:self.bufferProgressView.leadingAnchor constant:-2.0],
        [self.progressSlider.trailingAnchor constraintEqualToAnchor:self.bufferProgressView.trailingAnchor constant:2.0],
        [self.progressSlider.centerYAnchor constraintEqualToAnchor:self.bufferProgressView.centerYAnchor],

        [self.volumePanelView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0],
        [self.volumePanelView.bottomAnchor constraintEqualToAnchor:self.bottomOverlay.topAnchor constant:-8.0],
        [self.volumePanelView.widthAnchor constraintEqualToConstant:44.0],
        [self.volumePanelView.heightAnchor constraintEqualToConstant:172.0],
        [volumeIcon.centerXAnchor constraintEqualToAnchor:self.volumePanelView.centerXAnchor],
        [volumeIcon.bottomAnchor constraintEqualToAnchor:self.volumePanelView.bottomAnchor constant:-12.0],
        [volumeIcon.widthAnchor constraintEqualToConstant:18.0],
        [volumeIcon.heightAnchor constraintEqualToConstant:18.0],
        [self.volumeSlider.centerXAnchor constraintEqualToAnchor:self.volumePanelView.centerXAnchor],
        [self.volumeSlider.centerYAnchor constraintEqualToAnchor:self.volumePanelView.centerYAnchor constant:-20.0],
        [self.volumeSlider.widthAnchor constraintEqualToConstant:118.0],
        [self.volumeSlider.heightAnchor constraintEqualToConstant:30.0]
    ]];
}

- (void)bindPlayerCore {
    __weak typeof(self) weakSelf = self;
    self.playerCore.stateChanged = ^(BLPlayerPlaybackState state) {
        [weakSelf updateForState:state];
    };
    self.playerCore.progressChanged = ^(NSTimeInterval currentTime, NSTimeInterval duration, CGFloat bufferProgress) {
        [weakSelf updateCurrentTime:currentTime duration:duration bufferProgress:bufferProgress];
    };
    self.playerCore.errorOccurred = ^(NSError *error) {
        weakSelf.stateLabel.text = @"播放失败";
        weakSelf.stateLabel.hidden = NO;
    };
}

- (void)playButtonTapped {
    if (self.playerCore.playbackState == BLPlayerPlaybackStatePlaying || self.playerCore.playbackState == BLPlayerPlaybackStateBuffering) {
        [self.playerCore pause];
    } else {
        [self.playerCore play];
    }
}

- (void)volumeButtonTapped {
    [self setVolumePanelVisible:self.volumePanelView.hidden animated:YES];
}

- (void)volumeSliderChanged:(UISlider *)slider {
    [self.playerCore setVolume:slider.value];
    [self updateVolumeButtonIcon];
}

- (void)progressDragBegan:(UISlider *)slider {
    self.draggingProgress = YES;
}

- (void)progressDragChanged:(UISlider *)slider {
    NSTimeInterval target = self.playerCore.duration * slider.value;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self formatTime:target], [self formatTime:self.playerCore.duration]];
}

- (void)progressDragEnded:(UISlider *)slider {
    NSTimeInterval target = self.playerCore.duration * slider.value;
    __weak typeof(self) weakSelf = self;
    [self.playerCore seekToTime:target completion:^(BOOL finished) {
        weakSelf.draggingProgress = NO;
    }];
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (void)settingsButtonTapped {
    if (self.settingsTapped) {
        self.settingsTapped();
    }
}

- (void)videoLongPressed:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.longPressAccelerating = YES;
        self.rateBeforeLongPress = self.playerCore.preferredRate;
        [self.playerCore setRate:3.0];
        [self.speedToastView setVisible:YES animated:YES];
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateFailed) {
        self.longPressAccelerating = NO;
        [self.playerCore setRate:self.rateBeforeLongPress > 0.0 ? self.rateBeforeLongPress : self.playbackRate];
        [self.speedToastView setVisible:NO animated:YES];
    }
}

- (void)toggleControlsTapped {
    [self setControlsVisible:!self.controlsVisible animated:YES];
}

- (void)setControlsVisible:(BOOL)visible animated:(BOOL)animated {
    self.controlsVisible = visible;
    CGFloat alpha = visible ? 1.0 : 0.0;
    void (^changes)(void) = ^{
        self.topOverlay.alpha = alpha;
        self.bottomOverlay.alpha = alpha;
        if (!visible) {
            self.volumePanelView.alpha = 0.0;
        }
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.topOverlay.userInteractionEnabled = visible;
        self.bottomOverlay.userInteractionEnabled = visible;
        if (!visible) {
            self.volumePanelView.hidden = YES;
        }
    };
    if (visible) {
        self.topOverlay.userInteractionEnabled = YES;
        self.bottomOverlay.userInteractionEnabled = YES;
    }
    if (animated) {
        [UIView animateWithDuration:0.18 animations:changes completion:completion];
    } else {
        changes();
        completion(YES);
    }
}

- (void)setVolumePanelVisible:(BOOL)visible animated:(BOOL)animated {
    if (visible && !self.controlsVisible) {
        [self setControlsVisible:YES animated:YES];
    }
    self.volumePanelView.hidden = NO;
    self.volumeSlider.value = self.playerCore.volume;
    CGFloat targetAlpha = visible ? 1.0 : 0.0;
    void (^changes)(void) = ^{
        self.volumePanelView.alpha = targetAlpha;
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.volumePanelView.hidden = !visible;
    };
    if (animated) {
        [UIView animateWithDuration:0.16 animations:changes completion:completion];
    } else {
        changes();
        completion(YES);
    }
}

- (void)updateVolumeButtonIcon {
    NSString *symbol = @"speaker.wave.2.fill";
    if (self.playerCore.isMuted || self.playerCore.volume <= 0.01) {
        symbol = @"speaker.slash.fill";
    } else if (self.playerCore.volume < 0.5) {
        symbol = @"speaker.wave.1.fill";
    }
    [self.muteButton setImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:18.0 weight:UIImageSymbolWeightSemibold]] forState:UIControlStateNormal];
}

- (void)updateForState:(BLPlayerPlaybackState)state {
    BOOL playing = (state == BLPlayerPlaybackStatePlaying || state == BLPlayerPlaybackStateBuffering);
    NSString *symbol = playing ? @"pause.fill" : @"play.fill";
    [self.playButton setImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:20.0 weight:UIImageSymbolWeightSemibold]] forState:UIControlStateNormal];

    if (state == BLPlayerPlaybackStateLoading || state == BLPlayerPlaybackStateBuffering) {
        self.stateLabel.text = @"加载中";
        self.stateLabel.hidden = NO;
    } else if (state == BLPlayerPlaybackStateFailed) {
        self.stateLabel.text = @"播放失败";
        self.stateLabel.hidden = NO;
    } else if (state == BLPlayerPlaybackStateEnded) {
        self.stateLabel.text = @"已结束";
        self.stateLabel.hidden = NO;
    } else {
        self.stateLabel.hidden = YES;
    }
}

- (void)updateCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration bufferProgress:(CGFloat)bufferProgress {
    if (!self.draggingProgress && duration > 0.0) {
        self.progressSlider.value = currentTime / duration;
    }
    self.bufferProgressView.progress = bufferProgress;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self formatTime:currentTime], [self formatTime:duration]];
}

- (NSString *)formatTime:(NSTimeInterval)time {
    if (!isfinite(time) || time < 0.0) {
        time = 0.0;
    }
    NSInteger seconds = (NSInteger)llround(time);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)(seconds / 60), (long)(seconds % 60)];
}

- (UIButton *)iconButton:(NSString *)symbol pointSize:(CGFloat)pointSize {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightSemibold];
    [button setImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:config] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    return button;
}

- (UIButton *)textButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    button.layer.cornerRadius = 14.0;
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.26];
    return button;
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
