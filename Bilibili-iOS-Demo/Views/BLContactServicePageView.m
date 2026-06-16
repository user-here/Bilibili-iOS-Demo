#import "BLContactServicePageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLContactPink(void) { return [UIColor colorWithRed:0.92 green:0.38 blue:0.59 alpha:1.0]; }
static UIColor *BLContactText(void) { return [UIColor colorWithRed:0.13 green:0.13 blue:0.15 alpha:1.0]; }
static UIColor *BLContactSubText(void) { return [UIColor colorWithWhite:0.58 alpha:1.0]; }
static UIColor *BLContactLine(void) { return [UIColor colorWithWhite:0.93 alpha:1.0]; }

@interface BLContactServicePageView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@end

@implementation BLContactServicePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
    }
    return self;
}

- (void)buildView {
    [self buildHeader];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 0.0;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self selfServiceSection]];
    [self.contentStack addArrangedSubview:[self questionSection]];
    [self.contentStack addArrangedSubview:[self customerServiceSection]];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
}

- (void)buildHeader {
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerView];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    back.tintColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [back setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:back];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.translatesAutoresizingMaskIntoConstraints = NO;
    close.tintColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [close setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:close];

    UILabel *title = [self labelWithText:@"客服中心" size:18.0 weight:UIFontWeightRegular color:BLContactText()];
    [self.headerView addSubview:title];

    UIImageView *more = [self systemIcon:@"ellipsis" size:22.0 color:[UIColor colorWithWhite:0.35 alpha:1.0]];
    more.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.headerView addSubview:more];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = BLContactLine();
    [self.headerView addSubview:line];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:55.0],
        [back.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:13.0],
        [back.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [back.widthAnchor constraintEqualToConstant:34.0],
        [back.heightAnchor constraintEqualToConstant:38.0],
        [close.leadingAnchor constraintEqualToAnchor:back.trailingAnchor constant:14.0],
        [close.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [close.widthAnchor constraintEqualToConstant:34.0],
        [close.heightAnchor constraintEqualToConstant:38.0],
        [title.leadingAnchor constraintEqualToAnchor:close.trailingAnchor constant:12.0],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [more.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-20.0],
        [more.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:24.0],
        [more.heightAnchor constraintEqualToConstant:24.0],
        [line.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5]
    ]];
}

- (UIView *)selfServiceSection {
    UIStackView *section = [self whiteSectionWithTopInset:17.0 bottomInset:15.0];
    [section addArrangedSubview:[self sectionTitle:@"自助服务" compact:NO]];

    NSArray<NSDictionary *> *items = @[
        @{@"asset": @"bl_contact_history_message", @"title": @"历史留言", @"color": [UIColor colorWithRed:0.95 green:0.57 blue:0.06 alpha:1.0]},
        @{@"asset": @"bl_contact_account_recover", @"title": @"账号找回申诉", @"color": BLContactPink()},
        @{@"asset": @"bl_contact_community_appeal", @"title": @"社区违规申诉", @"color": BLContactPink()},
        @{@"asset": @"bl_contact_submission_appeal", @"title": @"稿件申诉", @"color": [UIColor colorWithRed:0.95 green:0.57 blue:0.06 alpha:1.0]},
        @{@"asset": @"bl_contact_phone_rebind", @"title": @"手机换绑", @"color": BLContactPink()},
        @{@"asset": @"bl_contact_game_faq", @"title": @"游戏常见问题", @"color": [UIColor colorWithRed:0.11 green:0.62 blue:0.84 alpha:1.0]},
        @{@"asset": @"", @"title": @"大会员续费", @"color": BLContactPink()},
        @{@"asset": @"bl_contact_account_cancel", @"title": @"账号注销", @"color": [UIColor colorWithRed:0.95 green:0.57 blue:0.06 alpha:1.0]}
    ];
    [section addArrangedSubview:[self serviceGridWithItems:items]];

    UIView *pager = [[UIView alloc] init];
    pager.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *dot1 = [self dotSelected:YES];
    UIView *dot2 = [self dotSelected:NO];
    [pager addSubview:dot1];
    [pager addSubview:dot2];
    [NSLayoutConstraint activateConstraints:@[
        [pager.heightAnchor constraintEqualToConstant:15.0],
        [dot1.centerXAnchor constraintEqualToAnchor:pager.centerXAnchor constant:-4.0],
        [dot1.centerYAnchor constraintEqualToAnchor:pager.centerYAnchor],
        [dot1.widthAnchor constraintEqualToConstant:5.0],
        [dot1.heightAnchor constraintEqualToConstant:5.0],
        [dot2.leadingAnchor constraintEqualToAnchor:dot1.trailingAnchor constant:5.0],
        [dot2.centerYAnchor constraintEqualToAnchor:dot1.centerYAnchor],
        [dot2.widthAnchor constraintEqualToConstant:5.0],
        [dot2.heightAnchor constraintEqualToConstant:5.0]
    ]];
    [section addArrangedSubview:pager];
    return section;
}

- (UIView *)questionSection {
    UIStackView *section = [self whiteSectionWithTopInset:17.0 bottomInset:18.0];
    [section addArrangedSubview:[self sectionTitle:@"猜你想问" compact:NO]];

    UIStackView *tabs = [[UIStackView alloc] init];
    tabs.translatesAutoresizingMaskIntoConstraints = NO;
    tabs.axis = UILayoutConstraintAxisHorizontal;
    tabs.spacing = 12.0;
    tabs.distribution = UIStackViewDistributionFillEqually;
    [tabs addArrangedSubview:[self questionTab:@"猜你想问" selected:YES]];
    [tabs addArrangedSubview:[self questionTab:@"账号相关" selected:NO]];
    [tabs addArrangedSubview:[self questionTab:@"付费增值" selected:NO]];
    [tabs addArrangedSubview:[self questionTab:@"平板相关" selected:NO]];
    [section addArrangedSubview:tabs];
    [tabs.heightAnchor constraintEqualToConstant:42.0].active = YES;

    NSArray<NSString *> *questions = @[
        @"我要如何投稿?",
        @"如何换绑手机号?",
        @"哔哩哔哩游戏账号如何找回?",
        @"预售商品什么时候出荷？什么时候补款呢？",
        @"游戏中心在哪里呢?"
    ];
    for (NSString *question in questions) {
        [section addArrangedSubview:[self questionRow:question]];
    }

    UILabel *more = [self labelWithText:@"更多问题请前往 帮助中心 查看哦" size:13.0 weight:UIFontWeightRegular color:BLContactSubText()];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:more.text];
    NSRange range = [more.text rangeOfString:@"帮助中心"];
    if (range.location != NSNotFound) {
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.18 green:0.62 blue:0.72 alpha:1.0] range:range];
    }
    more.attributedText = attr;
    [section addArrangedSubview:more];
    [more.heightAnchor constraintEqualToConstant:30.0].active = YES;
    return section;
}

- (UIView *)customerServiceSection {
    UIStackView *section = [self whiteSectionWithTopInset:17.0 bottomInset:20.0];
    [section addArrangedSubview:[self sectionTitle:@"联系客服" compact:NO]];
    UILabel *hint = [self labelWithText:@"点击分类可以查看更多具体问题哦" size:14.0 weight:UIFontWeightRegular color:BLContactSubText()];
    [section addArrangedSubview:hint];
    [hint.heightAnchor constraintEqualToConstant:26.0].active = YES;

    NSArray<NSDictionary *> *rows = @[
        @{@"icon": @"up.square", @"title": @"UP主服务", @"sub": @"UP主视频创作/审核/推广等问题"},
        @{@"icon": @"yensign.circle", @"title": @"付费增值", @"sub": @"大会员/漫画/装扮/收藏集等个人消费"},
        @{@"icon": @"bag", @"title": @"会员购电商", @"sub": @"商品/订单/魔力赏/票务展演等问题"},
        @{@"icon": @"link.circle", @"title": @"社区互动", @"sub": @"视频、私信、评论等功能的举报或申诉"},
        @{@"icon": @"person.crop.circle", @"title": @"账号", @"sub": @"账号登录/认证/封禁/手机号等问题"},
        @{@"icon": @"play.rectangle", @"title": @"播放相关", @"sub": @"视频观看/搜索/推荐等问题"},
        @{@"icon": @"tv", @"title": @"直播", @"sub": @"直播间开播/审核/观看/互动等问题"},
        @{@"icon": @"gearshape", @"title": @"公益/能量加油站", @"sub": @"哔哩哔哩公益/能量加油站"}
    ];
    for (NSDictionary *row in rows) {
        [section addArrangedSubview:[self contactCardWithIcon:row[@"icon"] title:row[@"title"] subtitle:row[@"sub"]]];
    }

    NSArray<NSString *> *phones = @[
        @"会员购问题客服热线: 4006262233转2",
        @"大会员问题客服热线: 4006262233转1",
        @"热线受理时间   10:00-18:00"
    ];
    for (NSString *phone in phones) {
        UILabel *label = [self labelWithText:phone size:13.5 weight:UIFontWeightRegular color:BLContactSubText()];
        label.textAlignment = NSTextAlignmentCenter;
        [section addArrangedSubview:label];
        [label.heightAnchor constraintEqualToConstant:26.0].active = YES;
    }
    return section;
}

- (UIStackView *)whiteSectionWithTopInset:(CGFloat)top bottomInset:(CGFloat)bottom {
    UIStackView *section = [[UIStackView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 0.0;
    section.backgroundColor = [UIColor whiteColor];
    section.layoutMargins = UIEdgeInsetsMake(top, 16.0, bottom, 16.0);
    section.layoutMarginsRelativeArrangement = YES;
    return section;
}

- (UIView *)serviceGridWithItems:(NSArray<NSDictionary *> *)items {
    UIStackView *grid = [[UIStackView alloc] init];
    grid.translatesAutoresizingMaskIntoConstraints = NO;
    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 18.0;
    grid.distribution = UIStackViewDistributionFillEqually;
    for (NSInteger row = 0; row < 2; row++) {
        UIStackView *line = [[UIStackView alloc] init];
        line.axis = UILayoutConstraintAxisHorizontal;
        line.distribution = UIStackViewDistributionFillEqually;
        line.alignment = UIStackViewAlignmentFill;
        for (NSInteger col = 0; col < 4; col++) {
            [line addArrangedSubview:[self serviceItem:items[row * 4 + col]]];
        }
        [grid addArrangedSubview:line];
    }
    [grid.heightAnchor constraintEqualToConstant:182.0].active = YES;
    return grid;
}

- (UIView *)serviceItem:(NSDictionary *)item {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 7.0;
    stack.distribution = UIStackViewDistributionFill;
    NSString *asset = item[@"asset"];
    UIColor *color = item[@"color"] ?: BLContactPink();
    UIView *icon = asset.length > 0 ? [self serviceIconWithAsset:asset color:color] : [self vipRenewIconWithColor:color];
    UILabel *title = [self labelWithText:item[@"title"] size:13.0 weight:UIFontWeightRegular color:BLContactText()];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 1;
    [stack addArrangedSubview:icon];
    [stack addArrangedSubview:title];
    [title.heightAnchor constraintEqualToConstant:18.0].active = YES;
    return stack;
}

- (UIView *)serviceIconWithAsset:(NSString *)asset color:(UIColor *)color {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [color colorWithAlphaComponent:0.13];
    container.layer.cornerRadius = 27.0;
    container.layer.masksToBounds = YES;

    UIImageView *icon = [self imageIcon:asset size:31.0];
    [container addSubview:icon];
    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:54.0],
        [container.heightAnchor constraintEqualToConstant:54.0],
        [icon.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:container.centerYAnchor]
    ]];
    return container;
}

- (UIView *)vipRenewIconWithColor:(UIColor *)color {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [color colorWithAlphaComponent:0.13];
    container.layer.cornerRadius = 27.0;
    container.layer.masksToBounds = YES;
    UILabel *label = [self labelWithText:@"大" size:23.0 weight:UIFontWeightSemibold color:color];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = color.CGColor;
    label.layer.borderWidth = 2.0;
    label.layer.cornerRadius = 17.0;
    label.layer.masksToBounds = YES;
    [container addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:54.0],
        [container.heightAnchor constraintEqualToConstant:54.0],
        [label.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [label.widthAnchor constraintEqualToConstant:34.0],
        [label.heightAnchor constraintEqualToConstant:34.0]
    ]];
    return container;
}

- (UILabel *)sectionTitle:(NSString *)title compact:(BOOL)compact {
    UILabel *label = [self labelWithText:title size:18.0 weight:UIFontWeightSemibold color:BLContactText()];
    [label.heightAnchor constraintEqualToConstant:compact ? 28.0 : 36.0].active = YES;
    return label;
}

- (UIView *)questionTab:(NSString *)title selected:(BOOL)selected {
    UILabel *label = [self labelWithText:title size:14.0 weight:UIFontWeightRegular color:selected ? BLContactPink() : [UIColor colorWithWhite:0.42 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 4.0;
    label.layer.borderWidth = 0.8;
    label.layer.borderColor = (selected ? BLContactPink() : BLContactLine()).CGColor;
    label.layer.masksToBounds = YES;
    return label;
}

- (UIView *)questionRow:(NSString *)title {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *label = [self labelWithText:title size:15.0 weight:UIFontWeightRegular color:BLContactText()];
    UIImageView *arrow = [self systemIcon:@"chevron.down" size:13.0 color:BLContactSubText()];
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = BLContactLine();
    [row addSubview:label];
    [row addSubview:arrow];
    [row addSubview:line];
    [NSLayoutConstraint activateConstraints:@[
        [row.heightAnchor constraintEqualToConstant:56.0],
        [label.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [label.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [arrow.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [arrow.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [arrow.widthAnchor constraintEqualToConstant:14.0],
        [arrow.heightAnchor constraintEqualToConstant:14.0],
        [line.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:row.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5]
    ]];
    return row;
}

- (UIView *)contactCardWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    card.layer.cornerRadius = 7.0;
    card.layer.masksToBounds = YES;
    UIImageView *iconView = [self systemIcon:icon size:25.0 color:BLContactPink()];
    UILabel *titleLabel = [self labelWithText:title size:16.5 weight:UIFontWeightSemibold color:BLContactText()];
    UILabel *subtitleLabel = [self labelWithText:subtitle size:13.0 weight:UIFontWeightRegular color:BLContactSubText()];
    UIImageView *arrow = [self systemIcon:@"chevron.down" size:13.0 color:BLContactSubText()];
    [card addSubview:iconView];
    [card addSubview:titleLabel];
    [card addSubview:subtitleLabel];
    [card addSubview:arrow];
    [NSLayoutConstraint activateConstraints:@[
        [card.heightAnchor constraintEqualToConstant:74.0],
        [iconView.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [iconView.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:28.0],
        [iconView.heightAnchor constraintEqualToConstant:28.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:16.0],
        [titleLabel.topAnchor constraintEqualToAnchor:card.topAnchor constant:16.0],
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:7.0],
        [subtitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:arrow.leadingAnchor constant:-12.0],
        [arrow.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18.0],
        [arrow.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [arrow.widthAnchor constraintEqualToConstant:14.0],
        [arrow.heightAnchor constraintEqualToConstant:14.0]
    ]];
    return card;
}

- (UIView *)dotSelected:(BOOL)selected {
    UIView *dot = [[UIView alloc] init];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    dot.backgroundColor = selected ? BLContactPink() : [UIColor colorWithRed:1.0 green:0.78 blue:0.86 alpha:1.0];
    dot.layer.cornerRadius = 2.5;
    return dot;
}

- (UIImageView *)imageIcon:(NSString *)asset size:(CGFloat)size {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:asset]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView.widthAnchor constraintEqualToConstant:size].active = YES;
    [imageView.heightAnchor constraintEqualToConstant:size].active = YES;
    return imageView;
}

- (UIImageView *)systemIcon:(NSString *)name size:(CGFloat)size color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:size weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = color;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UILabel *)labelWithText:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.75;
    return label;
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

@end
