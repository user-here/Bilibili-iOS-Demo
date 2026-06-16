#import "BLSharePanelView.h"

static UIColor *BLShareText(void) {
    return [UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:1.0];
}

@interface BLSharePanelView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *panelView;
@end

@implementation BLSharePanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.56];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    self.panelView = [[UIView alloc] init];
    self.panelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    [self addSubview:self.panelView];

    UILabel *title = [self labelWithText:@"分享" font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:BLShareText()];
    [self.panelView addSubview:title];

    UIScrollView *shareScroll = [[UIScrollView alloc] init];
    shareScroll.translatesAutoresizingMaskIntoConstraints = NO;
    shareScroll.showsHorizontalScrollIndicator = NO;
    [self.panelView addSubview:shareScroll];

    UIStackView *shareStack = [[UIStackView alloc] init];
    shareStack.translatesAutoresizingMaskIntoConstraints = NO;
    shareStack.axis = UILayoutConstraintAxisHorizontal;
    shareStack.spacing = 24.0;
    [shareScroll addSubview:shareStack];

    NSArray *shareItems = @[
        @[@"微信", @"bubble.left.and.bubble.right.fill", [UIColor colorWithRed:0.34 green:0.75 blue:0.25 alpha:1.0]],
        @[@"朋友圈", @"camera.aperture", [UIColor colorWithRed:0.38 green:0.74 blue:0.65 alpha:1.0]],
        @[@"下载分享", @"bl_download_share", [UIColor colorWithRed:0.40 green:0.38 blue:0.86 alpha:1.0]],
        @[@"动态", @"fanblades.fill", [UIColor colorWithRed:0.91 green:0.35 blue:0.58 alpha:1.0]],
        @[@"消息", @"envelope.fill", [UIColor colorWithRed:0.28 green:0.66 blue:0.86 alpha:1.0]],
        @[@"复制链接", @"link", [UIColor colorWithRed:0.95 green:0.55 blue:0.20 alpha:1.0]]
    ];
    for (NSArray *item in shareItems) {
        [shareStack addArrangedSubview:[self actionItemWithTitle:item[0] icon:item[1] color:item[2]]];
    }

    UIView *divider = [[UIView alloc] init];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    divider.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.panelView addSubview:divider];

    UIView *laterItem = [self toolItemWithTitle:@"稍后再看" icon:@"bl_watch_later"];
    [self.panelView addSubview:laterItem];

    UIView *bottomDivider = [[UIView alloc] init];
    bottomDivider.translatesAutoresizingMaskIntoConstraints = NO;
    bottomDivider.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.panelView addSubview:bottomDivider];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightRegular];
    [cancelButton setTitleColor:BLShareText() forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:cancelButton];

    UILayoutGuide *safe = self.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.panelView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.panelView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.panelView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.panelView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.42],

        [title.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:24.0],
        [title.topAnchor constraintEqualToAnchor:self.panelView.topAnchor constant:22.0],

        [shareScroll.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor],
        [shareScroll.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor],
        [shareScroll.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:18.0],
        [shareScroll.heightAnchor constraintEqualToConstant:98.0],
        [shareStack.leadingAnchor constraintEqualToAnchor:shareScroll.contentLayoutGuide.leadingAnchor constant:24.0],
        [shareStack.trailingAnchor constraintEqualToAnchor:shareScroll.contentLayoutGuide.trailingAnchor constant:-24.0],
        [shareStack.centerYAnchor constraintEqualToAnchor:shareScroll.centerYAnchor],
        [shareStack.heightAnchor constraintEqualToAnchor:shareScroll.frameLayoutGuide.heightAnchor],

        [divider.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor],
        [divider.topAnchor constraintEqualToAnchor:shareScroll.bottomAnchor constant:6.0],
        [divider.heightAnchor constraintEqualToConstant:1.0],

        [laterItem.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:24.0],
        [laterItem.topAnchor constraintEqualToAnchor:divider.bottomAnchor constant:24.0],
        [laterItem.widthAnchor constraintEqualToConstant:88.0],
        [laterItem.heightAnchor constraintEqualToConstant:86.0],

        [bottomDivider.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor],
        [bottomDivider.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor],
        [bottomDivider.bottomAnchor constraintEqualToAnchor:cancelButton.topAnchor],
        [bottomDivider.heightAnchor constraintEqualToConstant:1.0],

        [cancelButton.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor],
        [cancelButton.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor],
        [cancelButton.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor],
        [cancelButton.heightAnchor constraintEqualToConstant:62.0]
    ]];
}

- (void)setPanelVerticalOffset:(CGFloat)offset {
    self.panelView.transform = CGAffineTransformMakeTranslation(0.0, offset);
}

- (UIView *)actionItemWithTitle:(NSString *)title icon:(NSString *)icon color:(UIColor *)color {
    UIControl *container = [[UIControl alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.accessibilityLabel = title;
    [container addTarget:self action:@selector(optionTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 8.0;
    stack.userInteractionEnabled = NO;
    [container addSubview:stack];

    UIView *circle = [[UIView alloc] init];
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    circle.backgroundColor = color;
    circle.layer.cornerRadius = 31.0;
    [stack addArrangedSubview:circle];

    UIImageView *image = [self imageViewWithName:icon pointSize:28.0 color:[UIColor whiteColor]];
    [circle addSubview:image];

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.48 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:72.0],
        [stack.topAnchor constraintEqualToAnchor:container.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [circle.widthAnchor constraintEqualToConstant:62.0],
        [circle.heightAnchor constraintEqualToConstant:62.0],
        [image.centerXAnchor constraintEqualToAnchor:circle.centerXAnchor],
        [image.centerYAnchor constraintEqualToAnchor:circle.centerYAnchor],
        [image.widthAnchor constraintEqualToConstant:32.0],
        [image.heightAnchor constraintEqualToConstant:32.0]
    ]];
    return container;
}

- (UIView *)toolItemWithTitle:(NSString *)title icon:(NSString *)icon {
    UIControl *container = [[UIControl alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.accessibilityLabel = title;
    [container addTarget:self action:@selector(optionTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 12.0;
    stack.userInteractionEnabled = NO;
    [container addSubview:stack];

    UIImageView *image = [self imageViewWithName:icon pointSize:36.0 color:[UIColor colorWithWhite:0.34 alpha:1.0]];
    [stack addArrangedSubview:image];

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.55 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:container.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [image.widthAnchor constraintEqualToConstant:44.0],
        [image.heightAnchor constraintEqualToConstant:44.0]
    ]];
    return container;
}

- (UIImageView *)imageViewWithName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImage *assetImage = [UIImage imageNamed:name];
    UIImage *image = assetImage ? [assetImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : [[UIImage systemImageNamed:name] imageWithConfiguration:config];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = color;
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

- (void)backgroundTapped {
    [self cancelTapped];
}

- (void)cancelTapped {
    if (self.dismissRequested) {
        self.dismissRequested();
    }
}

- (void)optionTapped:(UIControl *)sender {
    if (self.optionSelected) {
        self.optionSelected(sender.accessibilityLabel ?: @"");
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.panelView];
}

@end
