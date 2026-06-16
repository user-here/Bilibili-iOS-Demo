#import "BLPlaybackSettingsPanelView.h"

static UIColor *BLPlaybackPanelPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLPlaybackPanelText(void) {
    return [UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1.0];
}

@interface BLPlaybackSettingsPanelView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIButton *> *rateButtons;
@property (nonatomic, assign) float selectedRate;
@end

@implementation BLPlaybackSettingsPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.rateButtons = [NSMutableDictionary dictionary];
        _selectedRate = 1.0;
        [self buildView];
        [self updateRateButtons];
    }
    return self;
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    self.panelView = [[UIView alloc] init];
    self.panelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.panelView.layer.cornerRadius = 16.0;
    self.panelView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.panelView.layer.masksToBounds = YES;
    [self addSubview:self.panelView];

    UIView *handle = [[UIView alloc] init];
    handle.translatesAutoresizingMaskIntoConstraints = NO;
    handle.backgroundColor = [UIColor colorWithWhite:0.78 alpha:1.0];
    handle.layer.cornerRadius = 2.0;
    [self.panelView addSubview:handle];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 18.0, 0.0);
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
    [self.panelView addSubview:scrollView];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 16.0;
    [scrollView addSubview:contentStack];

    [contentStack addArrangedSubview:[self shareSection]];
    [contentStack addArrangedSubview:[self toolSection]];
    [contentStack addArrangedSubview:[self cardWithRows:@[
        [self speedRow],
        [self switchRowWithIcon:@"forward.end" title:@"自动连播" on:YES],
        [self segmentedRowWithIcon:@"repeat" title:@"循环播放" options:@[@"单集循环", @"列表循环", @"不循环"] selectedIndex:2],
        [self disclosureRowWithIcon:@"timer" title:@"定时关闭" detail:nil],
        [self switchRowWithIcon:@"headphones" title:@"后台听视频" on:YES],
        [self valueRowWithIcon:@"captions.bubble" title:@"字幕" value:@"无字幕资源"],
        [self disclosureRowWithIcon:@"text.bubble" title:@"弹幕设置" detail:nil],
        [self switchRowWithIcon:@"rectangle.lefthalf.inset.filled.arrow.left" title:@"镜像翻转" on:NO],
        [self disclosureRowWithIcon:@"play.rectangle.on.rectangle" title:@"更多播放设置" detail:nil],
        [self disclosureRowWithIcon:@"note.text" title:@"笔记" detail:nil],
        [self disclosureRowWithIcon:@"flame" title:@"助TA必火" detail:nil]
    ]]];
    [contentStack addArrangedSubview:[self cardWithRows:@[
        [self disclosureRowWithIcon:@"exclamationmark.triangle" title:@"举报" detail:nil],
        [self disclosureRowWithIcon:@"questionmark.bubble" title:@"播放反馈" detail:nil]
    ]]];

    [NSLayoutConstraint activateConstraints:@[
        [self.panelView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.panelView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.panelView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.panelView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.62],

        [handle.topAnchor constraintEqualToAnchor:self.panelView.topAnchor constant:12.0],
        [handle.centerXAnchor constraintEqualToAnchor:self.panelView.centerXAnchor],
        [handle.widthAnchor constraintEqualToConstant:44.0],
        [handle.heightAnchor constraintEqualToConstant:4.0],

        [scrollView.topAnchor constraintEqualToAnchor:handle.bottomAnchor constant:18.0],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.panelView.bottomAnchor],

        [contentStack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [contentStack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:18.0],
        [contentStack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-18.0],
        [contentStack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [contentStack.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor constant:-36.0]
    ]];
}

- (void)setSelectedRate:(float)rate {
    _selectedRate = rate;
    [self updateRateButtons];
}

- (void)setPanelVerticalOffset:(CGFloat)offset {
    self.panelView.transform = CGAffineTransformMakeTranslation(0.0, offset);
}

- (UIView *)shareSection {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 24.0;
    [scrollView addSubview:stack];

    NSArray *items = @[
        @[@"微信", @"bubble.left.and.bubble.right.fill", [UIColor colorWithRed:0.28 green:0.74 blue:0.24 alpha:1.0]],
        @[@"朋友圈", @"camera.aperture", [UIColor colorWithRed:0.32 green:0.72 blue:0.63 alpha:1.0]],
        @[@"动态", @"fanblades.fill", BLPlaybackPanelPink()],
        @[@"消息", @"envelope.fill", [UIColor colorWithRed:0.16 green:0.66 blue:0.86 alpha:1.0]],
        @[@"图片分享", @"photo.fill", [UIColor colorWithRed:0.96 green:0.55 blue:0.20 alpha:1.0]],
        @[@"下载", @"arrow.down.to.line", [UIColor colorWithRed:0.45 green:0.42 blue:0.86 alpha:1.0]]
    ];
    for (NSArray *item in items) {
        [stack addArrangedSubview:[self shareItemWithTitle:item[0] icon:item[1] color:item[2]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.heightAnchor constraintEqualToConstant:104.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor],
        [stack.centerYAnchor constraintEqualToAnchor:scrollView.centerYAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.heightAnchor]
    ]];
    return scrollView;
}

- (UIView *)toolSection {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 14.0;
    [stack addArrangedSubview:[self toolItemWithTitle:@"不感兴趣" icon:@"face.dashed"]];
    [stack addArrangedSubview:[self toolItemWithTitle:@"稍后再看" icon:@"play.circle"]];
    [stack addArrangedSubview:[self toolItemWithTitle:@"缓存" icon:@"square.and.arrow.down"]];
    [stack addArrangedSubview:[self toolItemWithTitle:@"小窗播放" icon:@"pip"]];
    [stack addArrangedSubview:[self toolItemWithTitle:@"投屏" icon:@"tv"]];
    [stack.heightAnchor constraintEqualToConstant:86.0].active = YES;
    return stack;
}

- (UIView *)cardWithRows:(NSArray<UIView *> *)rows {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    [card addSubview:stack];

    for (NSUInteger index = 0; index < rows.count; index++) {
        [stack addArrangedSubview:rows[index]];
        if (index + 1 < rows.count) {
            [stack addArrangedSubview:[self divider]];
        }
    }

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:card.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor]
    ]];
    return card;
}

- (UIView *)speedRow {
    UIView *row = [self baseRowWithIcon:@"forward" title:@"倍速"];
    UIStackView *rateStack = [[UIStackView alloc] init];
    rateStack.translatesAutoresizingMaskIntoConstraints = NO;
    rateStack.axis = UILayoutConstraintAxisHorizontal;
    rateStack.distribution = UIStackViewDistributionFillEqually;
    rateStack.spacing = 0.0;
    [row addSubview:rateStack];

    NSArray<NSNumber *> *rates = @[@0.75, @1.0, @1.25, @1.5, @2.0];
    for (NSNumber *rate in rates) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = lround(rate.floatValue * 100.0);
        [button setTitle:[self displayTitleForRate:rate.floatValue] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
        [button addTarget:self action:@selector(rateTapped:) forControlEvents:UIControlEventTouchUpInside];
        [rateStack addArrangedSubview:button];
        self.rateButtons[rate] = button;
    }

    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:64.0],
        [rateStack.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:150.0],
        [rateStack.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-18.0],
        [rateStack.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [rateStack.heightAnchor constraintEqualToConstant:44.0]
    ]];
    return row;
}

- (UIView *)switchRowWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)on {
    UIView *row = [self baseRowWithIcon:icon title:title];
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.translatesAutoresizingMaskIntoConstraints = NO;
    switchView.onTintColor = BLPlaybackPanelPink();
    switchView.on = on;
    [row addSubview:switchView];
    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:64.0],
        [switchView.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-22.0],
        [switchView.centerYAnchor constraintEqualToAnchor:row.centerYAnchor]
    ]];
    return row;
}

- (UIView *)segmentedRowWithIcon:(NSString *)icon title:(NSString *)title options:(NSArray<NSString *> *)options selectedIndex:(NSUInteger)selectedIndex {
    UIView *row = [self baseRowWithIcon:icon title:title];
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 18.0;
    [row addSubview:stack];
    for (NSUInteger index = 0; index < options.count; index++) {
        UILabel *label = [self labelWithText:options[index] font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:index == selectedIndex ? BLPlaybackPanelPink() : [UIColor colorWithWhite:0.48 alpha:1.0]];
        [stack addArrangedSubview:label];
    }
    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:64.0],
        [stack.leadingAnchor constraintGreaterThanOrEqualToAnchor:row.leadingAnchor constant:194.0],
        [stack.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-22.0],
        [stack.centerYAnchor constraintEqualToAnchor:row.centerYAnchor]
    ]];
    return row;
}

- (UIView *)valueRowWithIcon:(NSString *)icon title:(NSString *)title value:(NSString *)value {
    UIView *row = [self baseRowWithIcon:icon title:title];
    UILabel *valueLabel = [self labelWithText:value font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.62 alpha:1.0]];
    [row addSubview:valueLabel];
    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:64.0],
        [valueLabel.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-22.0],
        [valueLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor]
    ]];
    return row;
}

- (UIView *)disclosureRowWithIcon:(NSString *)icon title:(NSString *)title detail:(NSString *)detail {
    UIView *row = [self baseRowWithIcon:icon title:title];
    UIImageView *arrow = [self imageViewWithName:@"chevron.right" pointSize:18.0 color:[UIColor colorWithWhite:0.62 alpha:1.0]];
    [row addSubview:arrow];
    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:64.0],
        [arrow.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-22.0],
        [arrow.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [arrow.widthAnchor constraintEqualToConstant:18.0],
        [arrow.heightAnchor constraintEqualToConstant:18.0]
    ]];
    return row;
}

- (UIView *)baseRowWithIcon:(NSString *)icon title:(NSString *)title {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.backgroundColor = [UIColor whiteColor];

    UIImageView *iconView = [self imageViewWithName:icon pointSize:25.0 color:[UIColor colorWithWhite:0.10 alpha:1.0]];
    [row addSubview:iconView];

    UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular] color:BLPlaybackPanelText()];
    [row addSubview:titleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [iconView.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:22.0],
        [iconView.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:28.0],
        [iconView.heightAnchor constraintEqualToConstant:28.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:18.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor]
    ]];
    return row;
}

- (UIView *)shareItemWithTitle:(NSString *)title icon:(NSString *)icon color:(UIColor *)color {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 8.0;

    UIView *circle = [[UIView alloc] init];
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    circle.backgroundColor = color;
    circle.layer.cornerRadius = 30.0;
    [stack addArrangedSubview:circle];

    UIImageView *image = [self imageViewWithName:icon pointSize:27.0 color:[UIColor whiteColor]];
    [circle addSubview:image];

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.48 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [stack.widthAnchor constraintEqualToConstant:76.0],
        [circle.widthAnchor constraintEqualToConstant:60.0],
        [circle.heightAnchor constraintEqualToConstant:60.0],
        [image.centerXAnchor constraintEqualToAnchor:circle.centerXAnchor],
        [image.centerYAnchor constraintEqualToAnchor:circle.centerYAnchor],
        [image.widthAnchor constraintEqualToConstant:31.0],
        [image.heightAnchor constraintEqualToConstant:31.0]
    ]];
    return stack;
}

- (UIView *)toolItemWithTitle:(NSString *)title icon:(NSString *)icon {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 9.0;

    UIView *box = [[UIView alloc] init];
    box.translatesAutoresizingMaskIntoConstraints = NO;
    box.backgroundColor = [UIColor whiteColor];
    box.layer.cornerRadius = 8.0;
    [stack addArrangedSubview:box];

    UIImageView *image = [self imageViewWithName:icon pointSize:25.0 color:[UIColor blackColor]];
    [box addSubview:image];

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.42 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [box.widthAnchor constraintEqualToConstant:54.0],
        [box.heightAnchor constraintEqualToConstant:54.0],
        [image.centerXAnchor constraintEqualToAnchor:box.centerXAnchor],
        [image.centerYAnchor constraintEqualToAnchor:box.centerYAnchor],
        [image.widthAnchor constraintEqualToConstant:30.0],
        [image.heightAnchor constraintEqualToConstant:30.0]
    ]];
    return stack;
}

- (UIView *)divider {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [container addSubview:line];
    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:1.0],
        [line.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:76.0],
        [line.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [line.topAnchor constraintEqualToAnchor:container.topAnchor],
        [line.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
    return container;
}

- (void)rateTapped:(UIButton *)sender {
    float rate = sender.tag / 100.0;
    [self setSelectedRate:rate];
    if (self.rateSelected) {
        self.rateSelected(rate);
    }
}

- (void)updateRateButtons {
    [self.rateButtons enumerateKeysAndObjectsUsingBlock:^(NSNumber *rate, UIButton *button, BOOL *stop) {
        BOOL selected = fabs(rate.floatValue - _selectedRate) < 0.01;
        [button setTitleColor:selected ? BLPlaybackPanelPink() : [UIColor colorWithWhite:0.52 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
    }];
}

- (NSString *)displayTitleForRate:(float)rate {
    if (fabs(rate - 0.75) < 0.01) {
        return @"0.75";
    }
    if (fabs(rate - 1.0) < 0.01) {
        return @"1.0";
    }
    if (fabs(rate - 1.25) < 0.01) {
        return @"1.25";
    }
    if (fabs(rate - 1.5) < 0.01) {
        return @"1.5";
    }
    if (fabs(rate - 2.0) < 0.01) {
        return @"2.0";
    }
    return [NSString stringWithFormat:@"%.2g", rate];
}

- (UIImageView *)imageViewWithName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:configuration]];
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
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

- (void)backgroundTapped {
    if (self.dismissRequested) {
        self.dismissRequested();
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.panelView];
}

@end
