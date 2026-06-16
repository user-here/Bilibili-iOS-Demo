#import "BLFeedbackPanelView.h"

static UIColor *BLFeedbackTextColor(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

@interface BLFeedbackPanelView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *panelView;
@end

@implementation BLFeedbackPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
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
    self.panelView.layer.cornerRadius = 14.0;
    self.panelView.layer.masksToBounds = YES;
    [self addSubview:self.panelView];

    UIView *handle = [[UIView alloc] init];
    handle.translatesAutoresizingMaskIntoConstraints = NO;
    handle.backgroundColor = [UIColor colorWithWhite:0.77 alpha:1.0];
    handle.layer.cornerRadius = 2.0;
    [self.panelView addSubview:handle];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 18.0;
    [self.panelView addSubview:contentStack];

    [contentStack addArrangedSubview:[self cardWithRows:@[
        [self rowWithIcon:@"clock.arrow.circlepath" title:@"添加至稍后再看"]
    ]]];

    [contentStack addArrangedSubview:[self cardWithRows:@[
        [self rowWithIcon:@"play.rectangle" title:@"不感兴趣：当前视频"],
        [self rowWithIcon:@"person.crop.circle" title:@"不感兴趣：UP"],
        [self rowWithIcon:@"person.3" title:@"不感兴趣：鸣潮"]
    ]]];

    [NSLayoutConstraint activateConstraints:@[
        [self.panelView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.panelView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.panelView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.panelView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.40],

        [handle.topAnchor constraintEqualToAnchor:self.panelView.topAnchor constant:12.0],
        [handle.centerXAnchor constraintEqualToAnchor:self.panelView.centerXAnchor],
        [handle.widthAnchor constraintEqualToConstant:40.0],
        [handle.heightAnchor constraintEqualToConstant:4.0],

        [contentStack.topAnchor constraintEqualToAnchor:handle.bottomAnchor constant:20.0],
        [contentStack.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:20.0],
        [contentStack.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor constant:-20.0],
        [contentStack.bottomAnchor constraintLessThanOrEqualToAnchor:self.panelView.bottomAnchor constant:-24.0]
    ]];
}

- (void)setPanelVerticalOffset:(CGFloat)offset {
    self.panelView.transform = CGAffineTransformMakeTranslation(0.0, offset);
}

- (UIView *)cardWithRows:(NSArray<UIView *> *)rows {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 10.0;
    card.layer.masksToBounds = YES;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    [card addSubview:stack];

    for (NSUInteger index = 0; index < rows.count; index++) {
        [stack addArrangedSubview:rows[index]];
        if (index + 1 < rows.count) {
            UIView *dividerContainer = [[UIView alloc] init];
            dividerContainer.translatesAutoresizingMaskIntoConstraints = NO;
            UIView *divider = [[UIView alloc] init];
            divider.translatesAutoresizingMaskIntoConstraints = NO;
            divider.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
            [dividerContainer addSubview:divider];
            [NSLayoutConstraint activateConstraints:@[
                [dividerContainer.heightAnchor constraintEqualToConstant:1.0],
                [divider.leadingAnchor constraintEqualToAnchor:dividerContainer.leadingAnchor constant:58.0],
                [divider.trailingAnchor constraintEqualToAnchor:dividerContainer.trailingAnchor],
                [divider.topAnchor constraintEqualToAnchor:dividerContainer.topAnchor],
                [divider.bottomAnchor constraintEqualToAnchor:dividerContainer.bottomAnchor]
            ]];
            [stack addArrangedSubview:dividerContainer];
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

- (UIView *)rowWithIcon:(NSString *)icon title:(NSString *)title {
    UIButton *row = [UIButton buttonWithType:UIButtonTypeCustom];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.backgroundColor = [UIColor whiteColor];
    row.accessibilityLabel = title;
    [row addTarget:self action:@selector(optionTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:27.0 weight:UIImageSymbolWeightRegular];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:icon] imageWithConfiguration:configuration]];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.tintColor = [UIColor colorWithWhite:0.12 alpha:1.0];
    [row addSubview:iconView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:19.0 weight:UIFontWeightRegular];
    titleLabel.textColor = BLFeedbackTextColor();
    [row addSubview:titleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:64.0],
        [iconView.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:24.0],
        [iconView.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:28.0],
        [iconView.heightAnchor constraintEqualToConstant:28.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:18.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:row.trailingAnchor constant:-18.0]
    ]];

    return row;
}

- (void)backgroundTapped {
    if (self.dismissRequested) {
        self.dismissRequested();
    }
}

- (void)optionTapped:(UIButton *)sender {
    if (self.optionSelected) {
        self.optionSelected(sender.accessibilityLabel ?: @"");
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.panelView];
}

@end
