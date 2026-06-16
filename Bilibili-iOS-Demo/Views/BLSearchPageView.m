#import "BLSearchPageView.h"

static UIColor *BLSearchPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLSearchTextColor(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

@interface BLSearchPaddedLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets textInsets;
@end

@implementation BLSearchPaddedLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += self.textInsets.left + self.textInsets.right;
    size.height += self.textInsets.top + self.textInsets.bottom;
    return size;
}

@end

@interface BLSearchPageView () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray<NSString *> *historyItems;
@property (nonatomic, strong) UIStackView *historyGridStack;
@property (nonatomic, strong) UIButton *historyExpandButton;
@property (nonatomic, assign) BOOL historyExpanded;
@property (nonatomic, strong) UIStackView *discoveryGridStack;
@property (nonatomic, strong) UIStackView *discoveryActionStack;
@property (nonatomic, strong) UIButton *discoveryRefreshButton;
@property (nonatomic, strong) UIButton *discoveryEyeButton;
@property (nonatomic, strong) UILabel *discoveryHiddenLabel;
@property (nonatomic, strong) UIView *discoveryDivider;
@property (nonatomic, assign) BOOL discoveryHidden;
@property (nonatomic, strong) UIView *deleteHistoryOverlay;
@property (nonatomic, assign) CGFloat lastHistoryLayoutWidth;
@end

@implementation BLSearchPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildData];
        [self buildView];
    }
    return self;
}

- (void)buildData {
    self.historyItems = [@[
        @"莫妮卡",
        @"狗头豚",
        @"终于看到正常的...",
        @"爱弥斯",
        @"小米17promax",
        @"达妮娅",
        @"鸣潮抽卡",
        @"终末地风评反转",
        @"钢琴纯音乐",
        @"富士山下",
        @"瑞克和莫蒂",
        @"达妮娅成为鸣潮首个..."
    ] mutableCopy];
}

- (void)focusSearchField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutIfNeeded];
        [self.searchTextField becomeFirstResponder];
    });
}

- (void)resignSearchField {
    [self.searchTextField resignFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.historyGridStack.bounds);
    if (width > 0.0 && fabs(width - self.lastHistoryLayoutWidth) > 0.5) {
        self.lastHistoryLayoutWidth = width;
        [self reloadHistoryGridAnimated:NO];
    }
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideVisibleHistoryCloseButtons)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];

    UIButton *backButton = [self backButton];
    UIView *inputBox = [self searchInputBox];
    UIButton *searchButton = [self searchButton];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;

    [self addSubview:backButton];
    [self addSubview:inputBox];
    [self addSubview:searchButton];
    [self addSubview:scrollView];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 28.0;
    [scrollView addSubview:contentStack];

    [contentStack addArrangedSubview:[self hotSearchSection]];
    [contentStack addArrangedSubview:[self searchHistorySection]];
    [contentStack addArrangedSubview:[self searchDiscoverySection]];
    [contentStack addArrangedSubview:[self feedbackPill]];

    UILayoutGuide *safe = self.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [backButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [backButton.centerYAnchor constraintEqualToAnchor:inputBox.centerYAnchor],
        [backButton.widthAnchor constraintEqualToConstant:36.0],
        [backButton.heightAnchor constraintEqualToConstant:44.0],

        [inputBox.topAnchor constraintEqualToAnchor:safe.topAnchor constant:16.0],
        [inputBox.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:12.0],
        [inputBox.trailingAnchor constraintEqualToAnchor:searchButton.leadingAnchor constant:-16.0],
        [inputBox.heightAnchor constraintEqualToConstant:44.0],

        [searchButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18.0],
        [searchButton.centerYAnchor constraintEqualToAnchor:inputBox.centerYAnchor],
        [searchButton.widthAnchor constraintEqualToConstant:54.0],

        [scrollView.topAnchor constraintEqualToAnchor:inputBox.bottomAnchor constant:34.0],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [contentStack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [contentStack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:16.0],
        [contentStack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-16.0],
        [contentStack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor constant:-40.0],
        [contentStack.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor constant:-32.0]
    ]];
}

- (UIButton *)backButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    button.tintColor = [UIColor colorWithWhite:0.34 alpha:1.0];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)searchInputBox {
    UIView *inputBox = [[UIView alloc] init];
    inputBox.translatesAutoresizingMaskIntoConstraints = NO;
    inputBox.backgroundColor = [UIColor whiteColor];
    inputBox.layer.cornerRadius = 22.0;
    inputBox.layer.borderWidth = 1.4;
    inputBox.layer.borderColor = [UIColor colorWithWhite:0.62 alpha:1.0].CGColor;

    UIImageView *searchIcon = [self iconViewWithName:@"magnifyingglass" pointSize:22.0 color:[UIColor colorWithWhite:0.25 alpha:1.0]];
    [inputBox addSubview:searchIcon];

    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTextField.borderStyle = UITextBorderStyleNone;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.delegate = self;
    self.searchTextField.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular];
    self.searchTextField.textColor = BLSearchTextColor();
    self.searchTextField.placeholder = @"听到弗糯糯哭能绷住的也是神...";
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [inputBox addSubview:self.searchTextField];

    [NSLayoutConstraint activateConstraints:@[
        [searchIcon.leadingAnchor constraintEqualToAnchor:inputBox.leadingAnchor constant:18.0],
        [searchIcon.centerYAnchor constraintEqualToAnchor:inputBox.centerYAnchor],
        [searchIcon.widthAnchor constraintEqualToConstant:22.0],
        [searchIcon.heightAnchor constraintEqualToConstant:22.0],
        [self.searchTextField.leadingAnchor constraintEqualToAnchor:searchIcon.trailingAnchor constant:10.0],
        [self.searchTextField.trailingAnchor constraintEqualToAnchor:inputBox.trailingAnchor constant:-12.0],
        [self.searchTextField.centerYAnchor constraintEqualToAnchor:inputBox.centerYAnchor],
        [self.searchTextField.heightAnchor constraintEqualToConstant:34.0]
    ]];

    return inputBox;
}

- (UIButton *)searchButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:21.0 weight:UIFontWeightRegular];
    [button setTitleColor:BLSearchPink() forState:UIControlStateNormal];
    return button;
}

- (UIView *)hotSearchSection {
    UIView *section = [[UIView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *title = [self labelWithText:@"bilibili热搜" font:[UIFont boldSystemFontOfSize:22.0] color:[UIColor blackColor]];
    [section addSubview:title];

    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rankButton.translatesAutoresizingMaskIntoConstraints = NO;
    [rankButton setTitle:@"完整榜单 〉" forState:UIControlStateNormal];
    rankButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    [rankButton setTitleColor:[UIColor colorWithWhite:0.58 alpha:1.0] forState:UIControlStateNormal];
    [section addSubview:rankButton];

    UIStackView *grid = [[UIStackView alloc] init];
    grid.translatesAutoresizingMaskIntoConstraints = NO;
    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 16.0;
    [section addSubview:grid];

    NSArray<NSArray<NSString *> *> *rows = @[
        @[@"尼克斯为何能在G1...", @"NBA总决赛G1五佳球"],
        @[@"李昊炎加盟巴萨U1...", @"国内成品油价格调整"],
        @[@"青年大学习之高考注...", @"高考安检新变化"],
        @[@"火星海洋迎来最新证据", @"荷兰是否有机会闯..."],
        @[@"影之刃零延期有何内幕", @"TYLOO vs Sharks..."]
    ];
    NSArray<NSString *> *badges = @[@"新", @"热", @"新", @"", @"", @"", @"", @"新", @"", @"▮▮"];
    NSUInteger badgeIndex = 0;
    for (NSArray<NSString *> *rowItems in rows) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 22.0;
        row.distribution = UIStackViewDistributionFillEqually;
        [grid addArrangedSubview:row];

        for (NSString *item in rowItems) {
            [row addArrangedSubview:[self hotSearchItemWithText:item badge:badges[badgeIndex]]];
            badgeIndex += 1;
        }
    }

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:section.topAnchor],
        [title.leadingAnchor constraintEqualToAnchor:section.leadingAnchor],
        [rankButton.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [rankButton.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [grid.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:26.0],
        [grid.leadingAnchor constraintEqualToAnchor:section.leadingAnchor],
        [grid.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [grid.bottomAnchor constraintEqualToAnchor:section.bottomAnchor]
    ]];
    return section;
}

- (UIView *)hotSearchItemWithText:(NSString *)text badge:(NSString *)badge {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 6.0;
    stack.alignment = UIStackViewAlignmentCenter;

    UILabel *label = [self labelWithText:text font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular] color:BLSearchTextColor()];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [stack addArrangedSubview:label];

    if (badge.length > 0) {
        UILabel *badgeLabel = [self labelWithText:badge font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightBold] color:[UIColor whiteColor]];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [badge isEqualToString:@"热"] ? [UIColor colorWithRed:0.91 green:0.24 blue:0.25 alpha:1.0] : BLSearchPink();
        if ([badge isEqualToString:@"新"]) {
            badgeLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.69 blue:0.24 alpha:1.0];
        }
        badgeLabel.layer.cornerRadius = 3.0;
        badgeLabel.layer.masksToBounds = YES;
        [badgeLabel.widthAnchor constraintEqualToConstant:20.0].active = YES;
        [badgeLabel.heightAnchor constraintEqualToConstant:20.0].active = YES;
        [stack addArrangedSubview:badgeLabel];
    }

    return stack;
}

- (UIView *)searchHistorySection {
    UIStackView *section = [[UIStackView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 18.0;
    [section addArrangedSubview:[self historyHeader]];

    self.historyGridStack = [[UIStackView alloc] init];
    self.historyGridStack.axis = UILayoutConstraintAxisVertical;
    self.historyGridStack.spacing = 12.0;
    [section addArrangedSubview:self.historyGridStack];
    [self reloadHistoryGridAnimated:NO];
    return section;
}

- (UIView *)searchDiscoverySection {
    NSArray<NSString *> *items = @[@"overload", @"钢琴曲纯音乐", @"莫蒂和瑞克", @"音乐", @"电影解说", @"oppofindx9pro", @"意难平の小曲", @"十年 陈奕迅", @"瑞克和莫蒂", @"百听不厌的神仙歌曲", @"小片片说大片·昨天更新", @"富士山下"];
    UIStackView *section = [[UIStackView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 18.0;
    [section addArrangedSubview:[self discoveryHeader]];

    self.discoveryGridStack = [[UIStackView alloc] init];
    self.discoveryGridStack.axis = UILayoutConstraintAxisVertical;
    self.discoveryGridStack.spacing = 10.0;
    [section addArrangedSubview:self.discoveryGridStack];
    [self populateChipRows:[self rowsFromItems:items columns:2 maxRows:NSIntegerMax] intoGrid:self.discoveryGridStack historyStyle:NO];
    return section;
}

- (UIView *)historyHeader {
    UIView *header = [self baseHeaderWithTitle:@"搜索历史"];
    UIStackView *actions = [[UIStackView alloc] init];
    actions.translatesAutoresizingMaskIntoConstraints = NO;
    actions.axis = UILayoutConstraintAxisHorizontal;
    actions.spacing = 16.0;
    actions.alignment = UIStackViewAlignmentCenter;
    [header addSubview:actions];

    UIButton *deleteButton = [self iconButtonWithName:@"trash" action:@selector(showDeleteAllHistoryDialog)];
    self.historyExpandButton = [self iconButtonWithName:@"chevron.down" action:@selector(toggleHistoryExpanded)];
    [actions addArrangedSubview:deleteButton];
    [actions addArrangedSubview:[self verticalDivider]];
    [actions addArrangedSubview:self.historyExpandButton];

    [NSLayoutConstraint activateConstraints:@[
        [actions.trailingAnchor constraintEqualToAnchor:header.trailingAnchor],
        [actions.centerYAnchor constraintEqualToAnchor:header.centerYAnchor]
    ]];
    return header;
}

- (UIView *)discoveryHeader {
    UIView *header = [self baseHeaderWithTitle:@"搜索发现"];
    self.discoveryActionStack = [[UIStackView alloc] init];
    self.discoveryActionStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.discoveryActionStack.axis = UILayoutConstraintAxisHorizontal;
    self.discoveryActionStack.spacing = 16.0;
    self.discoveryActionStack.alignment = UIStackViewAlignmentCenter;
    [header addSubview:self.discoveryActionStack];
    [self updateDiscoveryActionStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.discoveryActionStack.trailingAnchor constraintEqualToAnchor:header.trailingAnchor],
        [self.discoveryActionStack.centerYAnchor constraintEqualToAnchor:header.centerYAnchor]
    ]];
    return header;
}

- (UIView *)baseHeaderWithTitle:(NSString *)title {
    UIView *header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    [header.heightAnchor constraintEqualToConstant:28.0].active = YES;

    UILabel *titleLabel = [self labelWithText:title font:[UIFont boldSystemFontOfSize:21.0] color:BLSearchTextColor()];
    [header addSubview:titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:header.leadingAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:header.centerYAnchor]
    ]];
    return header;
}

- (void)reloadHistoryGridAnimated:(BOOL)animated {
    NSArray<NSArray<NSString *> *> *rows = [self historyRowsForCurrentWidth];
    [self populateChipRows:rows intoGrid:self.historyGridStack historyStyle:YES];
    [self applyHistoryExpansionStateAnimated:NO];
}

- (void)applyHistoryExpansionStateAnimated:(BOOL)animated {
    UIImage *image = [UIImage systemImageNamed:self.historyExpanded ? @"chevron.up" : @"chevron.down"];
    [self.historyExpandButton setImage:image forState:UIControlStateNormal];

    void (^changes)(void) = ^{
        NSUInteger index = 0;
        for (UIView *row in self.historyGridStack.arrangedSubviews) {
            BOOL shouldHide = !self.historyExpanded && index >= 2;
            row.hidden = shouldHide;
            row.alpha = shouldHide ? 0.0 : 1.0;
            index += 1;
        }
        [self layoutIfNeeded];
    };

    if (animated) {
        [UIView animateWithDuration:0.18 animations:changes];
    } else {
        changes();
    }
}

- (void)populateChipRows:(NSArray<NSArray<NSString *> *> *)rows intoGrid:(UIStackView *)grid historyStyle:(BOOL)historyStyle {
    for (UIView *view in grid.arrangedSubviews.copy) {
        [grid removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    for (NSArray<NSString *> *rowItems in rows) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = historyStyle ? 14.0 : 10.0;
        row.alignment = UIStackViewAlignmentFill;
        row.distribution = historyStyle ? UIStackViewDistributionFill : UIStackViewDistributionFillEqually;
        [grid addArrangedSubview:row];

        for (NSString *item in rowItems) {
            [row addArrangedSubview:[self chipWithText:item historyStyle:historyStyle]];
        }

        if (historyStyle) {
            UIView *spacer = [[UIView alloc] init];
            [spacer setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
            [row addArrangedSubview:spacer];
        }
    }
}

- (void)toggleHistoryExpanded {
    self.historyExpanded = !self.historyExpanded;
    [self applyHistoryExpansionStateAnimated:YES];
}

- (void)deleteOneHistoryItem:(UIButton *)sender {
    NSString *text = sender.accessibilityIdentifier;
    if (text.length == 0) {
        return;
    }
    [self.historyItems removeObject:text];
    [self reloadHistoryGridAnimated:NO];
}

- (void)showCloseButtonForHistoryChip:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UIView *chip = gesture.view;
    UIButton *closeButton = (UIButton *)[chip viewWithTag:9101];
    closeButton.hidden = NO;
    closeButton.alpha = 0.0;
    closeButton.transform = CGAffineTransformMakeScale(0.65, 0.65);
    [UIView animateWithDuration:0.16 animations:^{
        closeButton.alpha = 1.0;
        closeButton.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideVisibleHistoryCloseButtons {
    for (UIStackView *row in self.historyGridStack.arrangedSubviews) {
        for (UIView *chip in row.arrangedSubviews) {
            UIButton *closeButton = (UIButton *)[chip viewWithTag:9101];
            if (!closeButton || closeButton.hidden) {
                continue;
            }
            [UIView animateWithDuration:0.12 animations:^{
                closeButton.alpha = 0.0;
            } completion:^(BOOL finished) {
                closeButton.hidden = YES;
                closeButton.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (void)showDeleteAllHistoryDialog {
    [self buildDeleteHistoryOverlayIfNeeded];
    self.deleteHistoryOverlay.hidden = NO;
    self.deleteHistoryOverlay.alpha = 0.0;
    [UIView animateWithDuration:0.18 animations:^{
        self.deleteHistoryOverlay.alpha = 1.0;
    }];
}

- (void)dismissDeleteHistoryDialog {
    [UIView animateWithDuration:0.18 animations:^{
        self.deleteHistoryOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.deleteHistoryOverlay.hidden = YES;
    }];
}

- (void)confirmDeleteAllHistory {
    [self.historyItems removeAllObjects];
    [self reloadHistoryGridAnimated:YES];
    [self dismissDeleteHistoryDialog];
}

- (void)buildDeleteHistoryOverlayIfNeeded {
    if (self.deleteHistoryOverlay != nil) {
        return;
    }

    self.deleteHistoryOverlay = [[UIView alloc] init];
    self.deleteHistoryOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    self.deleteHistoryOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.48];
    self.deleteHistoryOverlay.hidden = YES;
    [self addSubview:self.deleteHistoryOverlay];

    UIView *dialog = [[UIView alloc] init];
    dialog.translatesAutoresizingMaskIntoConstraints = NO;
    dialog.backgroundColor = [UIColor whiteColor];
    dialog.layer.cornerRadius = 10.0;
    dialog.layer.masksToBounds = YES;
    [self.deleteHistoryOverlay addSubview:dialog];

    UILabel *title = [self labelWithText:@"删除全部搜索历史？" font:[UIFont systemFontOfSize:21.0 weight:UIFontWeightRegular] color:BLSearchTextColor()];
    title.textAlignment = NSTextAlignmentCenter;
    [dialog addSubview:title];

    UIView *divider = [[UIView alloc] init];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    divider.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [dialog addSubview:divider];

    UIButton *cancelButton = [self dialogButtonWithTitle:@"取消" color:BLSearchTextColor() action:@selector(dismissDeleteHistoryDialog)];
    UIButton *confirmButton = [self dialogButtonWithTitle:@"全部删除" color:BLSearchPink() action:@selector(confirmDeleteAllHistory)];
    [dialog addSubview:cancelButton];
    [dialog addSubview:confirmButton];

    UIView *verticalDivider = [[UIView alloc] init];
    verticalDivider.translatesAutoresizingMaskIntoConstraints = NO;
    verticalDivider.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [dialog addSubview:verticalDivider];

    [NSLayoutConstraint activateConstraints:@[
        [self.deleteHistoryOverlay.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.deleteHistoryOverlay.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.deleteHistoryOverlay.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.deleteHistoryOverlay.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [dialog.centerXAnchor constraintEqualToAnchor:self.deleteHistoryOverlay.centerXAnchor],
        [dialog.centerYAnchor constraintEqualToAnchor:self.deleteHistoryOverlay.centerYAnchor constant:-10.0],
        [dialog.widthAnchor constraintEqualToAnchor:self.deleteHistoryOverlay.widthAnchor multiplier:0.78],
        [dialog.heightAnchor constraintEqualToConstant:160.0],

        [title.topAnchor constraintEqualToAnchor:dialog.topAnchor],
        [title.leadingAnchor constraintEqualToAnchor:dialog.leadingAnchor],
        [title.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor],
        [title.heightAnchor constraintEqualToConstant:98.0],

        [divider.leadingAnchor constraintEqualToAnchor:dialog.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor],
        [divider.topAnchor constraintEqualToAnchor:title.bottomAnchor],
        [divider.heightAnchor constraintEqualToConstant:1.0],

        [cancelButton.leadingAnchor constraintEqualToAnchor:dialog.leadingAnchor],
        [cancelButton.topAnchor constraintEqualToAnchor:divider.bottomAnchor],
        [cancelButton.bottomAnchor constraintEqualToAnchor:dialog.bottomAnchor],
        [cancelButton.trailingAnchor constraintEqualToAnchor:verticalDivider.leadingAnchor],

        [verticalDivider.widthAnchor constraintEqualToConstant:1.0],
        [verticalDivider.topAnchor constraintEqualToAnchor:divider.bottomAnchor],
        [verticalDivider.bottomAnchor constraintEqualToAnchor:dialog.bottomAnchor],
        [verticalDivider.centerXAnchor constraintEqualToAnchor:dialog.centerXAnchor],

        [confirmButton.leadingAnchor constraintEqualToAnchor:verticalDivider.trailingAnchor],
        [confirmButton.topAnchor constraintEqualToAnchor:divider.bottomAnchor],
        [confirmButton.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor],
        [confirmButton.bottomAnchor constraintEqualToAnchor:dialog.bottomAnchor]
    ]];
}

- (UIButton *)dialogButtonWithTitle:(NSString *)title color:(UIColor *)color action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)toggleDiscoveryHidden {
    self.discoveryHidden = !self.discoveryHidden;
    self.discoveryGridStack.hidden = self.discoveryHidden;
    [self updateDiscoveryActionStack];
    [UIView animateWithDuration:0.18 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)updateDiscoveryActionStack {
    if (self.discoveryRefreshButton == nil) {
        self.discoveryRefreshButton = [self iconButtonWithName:@"arrow.2.circlepath" action:nil];
        self.discoveryDivider = [self verticalDivider];
        self.discoveryEyeButton = [self iconButtonWithName:@"eye" action:@selector(toggleDiscoveryHidden)];
        self.discoveryHiddenLabel = [self labelWithText:@"已隐藏" font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];

        [self.discoveryActionStack addArrangedSubview:self.discoveryRefreshButton];
        [self.discoveryActionStack addArrangedSubview:self.discoveryDivider];
        [self.discoveryActionStack addArrangedSubview:self.discoveryHiddenLabel];
        [self.discoveryActionStack addArrangedSubview:self.discoveryEyeButton];
    }

    self.discoveryRefreshButton.hidden = self.discoveryHidden;
    self.discoveryDivider.hidden = self.discoveryHidden;
    self.discoveryHiddenLabel.hidden = !self.discoveryHidden;
    UIImage *eyeImage = [UIImage systemImageNamed:self.discoveryHidden ? @"eye.slash" : @"eye"];
    [self.discoveryEyeButton setImage:eyeImage forState:UIControlStateNormal];
}

- (NSArray<NSArray<NSString *> *> *)historyRowsForCurrentWidth {
    CGFloat availableWidth = CGRectGetWidth(self.historyGridStack.bounds);
    if (availableWidth <= 0.0) {
        availableWidth = CGRectGetWidth(UIScreen.mainScreen.bounds) - 32.0;
    }

    NSMutableArray<NSArray<NSString *> *> *rows = [NSMutableArray array];
    NSMutableArray<NSString *> *currentRow = [NSMutableArray array];
    CGFloat currentWidth = 0.0;
    CGFloat spacing = 14.0;

    for (NSString *item in self.historyItems) {
        CGFloat chipWidth = [self historyChipWidthForText:item];
        CGFloat nextWidth = currentRow.count == 0 ? chipWidth : currentWidth + spacing + chipWidth;
        if (currentRow.count > 0 && nextWidth > availableWidth) {
            [rows addObject:currentRow.copy];
            currentRow = [NSMutableArray array];
            currentWidth = 0.0;
        }

        [currentRow addObject:item];
        currentWidth = currentRow.count == 1 ? chipWidth : currentWidth + spacing + chipWidth;
    }

    if (currentRow.count > 0) {
        [rows addObject:currentRow.copy];
    }
    return rows;
}

- (CGFloat)historyChipWidthForText:(NSString *)text {
    NSDictionary<NSAttributedStringKey, id> *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:19.0 weight:UIFontWeightRegular]};
    CGFloat textWidth = ceil([text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 38.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width);
    return MIN(158.0, MAX(90.0, textWidth + 42.0));
}

- (NSArray<NSArray<NSString *> *> *)rowsFromItems:(NSArray<NSString *> *)items columns:(NSUInteger)columns maxRows:(NSInteger)maxRows {
    NSMutableArray<NSArray<NSString *> *> *rows = [NSMutableArray array];
    for (NSUInteger index = 0; index < items.count && rows.count < (NSUInteger)maxRows; index += columns) {
        NSRange range = NSMakeRange(index, MIN(columns, items.count - index));
        [rows addObject:[items subarrayWithRange:range]];
    }
    return rows;
}

- (UIView *)chipWithText:(NSString *)text historyStyle:(BOOL)historyStyle {
    BLSearchPaddedLabel *label = [[BLSearchPaddedLabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:19.0 weight:UIFontWeightRegular];
    label.textColor = BLSearchTextColor();
    label.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    label.layer.cornerRadius = historyStyle ? 4.0 : 2.0;
    label.layer.masksToBounds = YES;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 1;
    label.textInsets = historyStyle ? UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0) : UIEdgeInsetsMake(0.0, 18.0, 0.0, 12.0);
    label.textAlignment = historyStyle ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    if (!historyStyle) {
        [NSLayoutConstraint activateConstraints:@[
            [label.heightAnchor constraintEqualToConstant:46.0],
            [label.widthAnchor constraintLessThanOrEqualToConstant:220.0]
        ]];
        return label;
    }

    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:label];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    closeButton.hidden = YES;
    closeButton.tag = 9101;
    closeButton.accessibilityIdentifier = text;
    closeButton.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1.0];
    closeButton.layer.cornerRadius = 9.0;
    [closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    closeButton.tintColor = [UIColor whiteColor];
    closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeButton addTarget:self action:@selector(deleteOneHistoryItem:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:closeButton];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCloseButtonForHistoryChip:)];
    longPress.minimumPressDuration = 0.35;
    [container addGestureRecognizer:longPress];

    CGFloat width = [self historyChipWidthForText:text] - 8.0;
    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:width + 8.0],
        [container.heightAnchor constraintEqualToConstant:44.0],
        [label.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [label.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [label.widthAnchor constraintEqualToConstant:width],
        [label.heightAnchor constraintEqualToConstant:38.0],
        [closeButton.topAnchor constraintEqualToAnchor:container.topAnchor],
        [closeButton.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:18.0],
        [closeButton.heightAnchor constraintEqualToConstant:18.0]
    ]];
    return container;
}

- (UIButton *)iconButtonWithName:(NSString *)name action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setImage:[UIImage systemImageNamed:name] forState:UIControlStateNormal];
    button.tintColor = [UIColor colorWithWhite:0.58 alpha:1.0];
    if (action != NULL) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [NSLayoutConstraint activateConstraints:@[
        [button.widthAnchor constraintEqualToConstant:24.0],
        [button.heightAnchor constraintEqualToConstant:22.0]
    ]];
    return button;
}

- (UIView *)verticalDivider {
    UIView *divider = [[UIView alloc] init];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    divider.backgroundColor = [UIColor colorWithWhite:0.86 alpha:1.0];
    [NSLayoutConstraint activateConstraints:@[
        [divider.widthAnchor constraintEqualToConstant:1.0],
        [divider.heightAnchor constraintEqualToConstant:18.0]
    ]];
    return divider;
}

- (UIView *)feedbackPill {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"反馈 ？" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    [button setTitleColor:[UIColor colorWithWhite:0.45 alpha:1.0] forState:UIControlStateNormal];
    button.layer.cornerRadius = 18.0;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor colorWithWhite:0.82 alpha:1.0].CGColor;

    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:54.0],
        [button.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:92.0],
        [button.heightAnchor constraintEqualToConstant:36.0]
    ]];
    return container;
}

- (UIImageView *)iconViewWithName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:configuration]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = color;
    [imageView.widthAnchor constraintEqualToConstant:22.0].active = YES;
    [imageView.heightAnchor constraintEqualToConstant:22.0].active = YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)backButtonTapped {
    if (self.backTapped) {
        self.backTapped();
    }
}

@end
