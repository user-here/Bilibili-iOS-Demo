#import "BLMinePageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLMinePink(void) { return [UIColor colorWithRed:0.91 green:0.36 blue:0.56 alpha:1.0]; }
static UIColor *BLMineText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }
static UIColor *BLMineSubText(void) { return [UIColor colorWithWhite:0.55 alpha:1.0]; }

@interface BLMinePageView ()
@property (nonatomic, strong) UIView *fixedHeader;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@end

@implementation BLMinePageView

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
    self.fixedHeader = [[UIView alloc] init];
    self.fixedHeader.translatesAutoresizingMaskIntoConstraints = NO;
    self.fixedHeader.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.fixedHeader];

    [self buildHeaderContent];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 22.0;
    self.contentStack.layoutMargins = UIEdgeInsetsMake(18.0, 20.0, 30.0, 20.0);
    self.contentStack.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self quickGridWithItems:[self topScrollItems] columns:4]];
    [self.contentStack addArrangedSubview:[self publishCard]];
    [self.contentStack addArrangedSubview:[self gameSection]];
    [self.contentStack addArrangedSubview:[self sectionTitle:@"\u6211\u7684\u670d\u52a1"]];
    [self.contentStack addArrangedSubview:[self quickGridWithItems:[self serviceItems] columns:4]];
    [self.contentStack addArrangedSubview:[self sectionTitle:@"\u66f4\u591a\u670d\u52a1"]];
    [self.contentStack addArrangedSubview:[self serviceList]];

    [NSLayoutConstraint activateConstraints:@[
        [self.fixedHeader.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.fixedHeader.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.fixedHeader.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.fixedHeader.heightAnchor constraintEqualToConstant:398.0],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.fixedHeader.bottomAnchor],
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

- (void)buildHeaderContent {
    UIStackView *topTools = [[UIStackView alloc] init];
    topTools.translatesAutoresizingMaskIntoConstraints = NO;
    topTools.axis = UILayoutConstraintAxisHorizontal;
    topTools.spacing = 28.0;
    topTools.alignment = UIStackViewAlignmentCenter;
    [self.fixedHeader addSubview:topTools];
    NSArray *tools = @[
        @"bl_mine_light_mode",
        @"bl_mine_scan",
        @"bl_mine_dress",
        @"bl_mine_dark_mode"
    ];
    for (NSString *asset in tools) {
        [topTools addArrangedSubview:[self imageIcon:asset size:27.0 tint:nil]];
    }

    UIView *avatar = [self avatarView];
    [self.fixedHeader addSubview:avatar];
    [avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileButtonTapped)]];

    UILabel *name = [self labelWithText:@"\u963f\u72f8\u7231\u5403\u72d0\u72f8" size:21.0 weight:UIFontWeightRegular color:BLMinePink()];
    name.userInteractionEnabled = YES;
    [name addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileButtonTapped)]];
    [self.fixedHeader addSubview:name];

    UIImageView *edit = [self systemIcon:@"pencil" size:20.0 color:[UIColor colorWithWhite:0.45 alpha:1.0]];
    [self.fixedHeader addSubview:edit];

    UILabel *level = [self labelWithText:@"LV5" size:14.0 weight:UIFontWeightHeavy color:[UIColor colorWithRed:0.86 green:0.35 blue:0.14 alpha:1.0]];
    level.textAlignment = NSTextAlignmentCenter;
    level.layer.borderColor = level.textColor.CGColor;
    level.layer.borderWidth = 1.5;
    level.layer.cornerRadius = 3.0;
    level.layer.masksToBounds = YES;
    [self.fixedHeader addSubview:level];

    UILabel *vip = [self labelWithText:@"\u5e74\u5ea6\u5927\u4f1a\u5458" size:14.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    vip.textAlignment = NSTextAlignmentCenter;
    vip.backgroundColor = BLMinePink();
    vip.layer.cornerRadius = 13.0;
    vip.layer.masksToBounds = YES;
    [self.fixedHeader addSubview:vip];

    UILabel *coins = [self labelWithText:@"B\u5e01\uff1a0.0   \u786c\u5e01\uff1a1714" size:15.0 weight:UIFontWeightRegular color:BLMineSubText()];
    [self.fixedHeader addSubview:coins];

    UIStackView *space = [[UIStackView alloc] init];
    space.translatesAutoresizingMaskIntoConstraints = NO;
    space.axis = UILayoutConstraintAxisHorizontal;
    space.spacing = 4.0;
    space.alignment = UIStackViewAlignmentCenter;
    UILabel *spaceLabel = [self labelWithText:@"\u7a7a\u95f4" size:15.0 weight:UIFontWeightRegular color:BLMineSubText()];
    [space addArrangedSubview:spaceLabel];
    [space addArrangedSubview:[self systemIcon:@"chevron.right" size:18.0 color:BLMineSubText()]];
    [self.fixedHeader addSubview:space];
    UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spaceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [spaceButton addTarget:self action:@selector(profileButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [space addSubview:spaceButton];

    UIStackView *stats = [[UIStackView alloc] init];
    stats.translatesAutoresizingMaskIntoConstraints = NO;
    stats.axis = UILayoutConstraintAxisHorizontal;
    stats.distribution = UIStackViewDistributionFillEqually;
    stats.alignment = UIStackViewAlignmentCenter;
    [self.fixedHeader addSubview:stats];
    [stats addArrangedSubview:[self statViewWithNumber:@"1" title:@"\u52a8\u6001"]];
    [stats addArrangedSubview:[self statViewWithNumber:@"241" title:@"\u5173\u6ce8"]];
    [stats addArrangedSubview:[self statViewWithNumber:@"1" title:@"\u7c89\u4e1d"]];

    UIView *vipCard = [self vipCard];
    [self.fixedHeader addSubview:vipCard];

    [NSLayoutConstraint activateConstraints:@[
        [topTools.trailingAnchor constraintEqualToAnchor:self.fixedHeader.trailingAnchor constant:-24.0],
        [topTools.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:18.0],
        [avatar.leadingAnchor constraintEqualToAnchor:self.fixedHeader.leadingAnchor constant:26.0],
        [avatar.topAnchor constraintEqualToAnchor:topTools.bottomAnchor constant:28.0],
        [avatar.widthAnchor constraintEqualToConstant:90.0],
        [avatar.heightAnchor constraintEqualToConstant:90.0],
        [name.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:16.0],
        [name.topAnchor constraintEqualToAnchor:avatar.topAnchor constant:19.0],
        [edit.leadingAnchor constraintEqualToAnchor:name.trailingAnchor constant:10.0],
        [edit.centerYAnchor constraintEqualToAnchor:name.centerYAnchor],
        [edit.widthAnchor constraintEqualToConstant:20.0],
        [edit.heightAnchor constraintEqualToConstant:20.0],
        [level.leadingAnchor constraintEqualToAnchor:edit.trailingAnchor constant:12.0],
        [level.centerYAnchor constraintEqualToAnchor:edit.centerYAnchor],
        [level.widthAnchor constraintEqualToConstant:42.0],
        [level.heightAnchor constraintEqualToConstant:21.0],
        [vip.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [vip.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:9.0],
        [vip.widthAnchor constraintEqualToConstant:106.0],
        [vip.heightAnchor constraintEqualToConstant:24.0],
        [coins.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [coins.topAnchor constraintEqualToAnchor:vip.bottomAnchor constant:11.0],
        [space.trailingAnchor constraintEqualToAnchor:self.fixedHeader.trailingAnchor constant:-28.0],
        [space.centerYAnchor constraintEqualToAnchor:name.centerYAnchor constant:48.0],
        [spaceButton.topAnchor constraintEqualToAnchor:space.topAnchor constant:-10.0],
        [spaceButton.leadingAnchor constraintEqualToAnchor:space.leadingAnchor constant:-12.0],
        [spaceButton.trailingAnchor constraintEqualToAnchor:space.trailingAnchor constant:12.0],
        [spaceButton.bottomAnchor constraintEqualToAnchor:space.bottomAnchor constant:10.0],
        [stats.leadingAnchor constraintEqualToAnchor:self.fixedHeader.leadingAnchor constant:40.0],
        [stats.trailingAnchor constraintEqualToAnchor:self.fixedHeader.trailingAnchor constant:-40.0],
        [stats.topAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:24.0],
        [stats.heightAnchor constraintEqualToConstant:50.0],
        [vipCard.leadingAnchor constraintEqualToAnchor:self.fixedHeader.leadingAnchor constant:20.0],
        [vipCard.trailingAnchor constraintEqualToAnchor:self.fixedHeader.trailingAnchor constant:-20.0],
        [vipCard.topAnchor constraintEqualToAnchor:stats.bottomAnchor constant:16.0],
        [vipCard.heightAnchor constraintEqualToConstant:64.0]
    ]];
}

- (UIView *)avatarView {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor clearColor];

    UIView *ring = [[UIView alloc] init];
    ring.translatesAutoresizingMaskIntoConstraints = NO;
    ring.backgroundColor = [UIColor colorWithRed:0.86 green:0.96 blue:1.0 alpha:1.0];
    ring.layer.cornerRadius = 45.0;
    ring.layer.borderWidth = 4.0;
    ring.layer.borderColor = [UIColor colorWithRed:0.14 green:0.43 blue:0.64 alpha:1.0].CGColor;
    [container addSubview:ring];

    UILabel *face = [self labelWithText:@"\u72f8" size:32.0 weight:UIFontWeightHeavy color:[UIColor colorWithWhite:0.22 alpha:1.0]];
    face.textAlignment = NSTextAlignmentCenter;
    face.backgroundColor = [UIColor colorWithRed:0.93 green:0.86 blue:0.77 alpha:1.0];
    face.layer.cornerRadius = 32.0;
    face.layer.masksToBounds = YES;
    [container addSubview:face];

    UILabel *badge = [self labelWithText:@"\u5927" size:20.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    badge.textAlignment = NSTextAlignmentCenter;
    badge.backgroundColor = BLMinePink();
    badge.layer.cornerRadius = 18.0;
    badge.layer.masksToBounds = YES;
    [container addSubview:badge];

    [NSLayoutConstraint activateConstraints:@[
        [ring.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [ring.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [ring.topAnchor constraintEqualToAnchor:container.topAnchor],
        [ring.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [face.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [face.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [face.widthAnchor constraintEqualToConstant:64.0],
        [face.heightAnchor constraintEqualToConstant:64.0],
        [badge.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:4.0],
        [badge.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:4.0],
        [badge.widthAnchor constraintEqualToConstant:36.0],
        [badge.heightAnchor constraintEqualToConstant:36.0]
    ]];
    return container;
}

- (UIView *)vipCard {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor colorWithRed:1.0 green:0.91 blue:0.95 alpha:1.0];
    card.layer.cornerRadius = 10.0;
    card.layer.masksToBounds = YES;

    UILabel *title = [self labelWithText:@"\u5927\u4f1a\u5458\u6bcf\u6708\u9886\u732b\u8033\u94bb\u77f3" size:18.0 weight:UIFontWeightSemibold color:BLMinePink()];
    UILabel *subtitle = [self labelWithText:@"\u4f17\u591a\u70ed\u95e8\u5e7f\u64ad\u5267\u7b49\u4f60\u6765\u542c \u203a" size:14.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.46 alpha:1.0]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = BLMinePink();
    button.layer.cornerRadius = 19.0;
    [button setTitle:@"\u5927\u4f1a\u5458\u4e2d\u5fc3" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
    [button addTarget:self action:@selector(memberCenterButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    [card addSubview:title];
    [card addSubview:subtitle];
    [card addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:10.0],
        [subtitle.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [subtitle.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:5.0],
        [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18.0],
        [button.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:126.0],
        [button.heightAnchor constraintEqualToConstant:38.0],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:button.leadingAnchor constant:-12.0]
    ]];
    return card;
}

- (UIView *)statViewWithNumber:(NSString *)number title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 3.0;
    [stack addArrangedSubview:[self labelWithText:number size:20.0 weight:UIFontWeightRegular color:BLMineText()]];
    [stack addArrangedSubview:[self labelWithText:title size:15.0 weight:UIFontWeightRegular color:BLMineSubText()]];
    return stack;
}

- (NSArray<NSDictionary *> *)topScrollItems {
    return @[
        @{@"asset": @"bl_mine_offline", @"title": @"\u79bb\u7ebf\u7f13\u5b58"},
        @{@"asset": @"bl_mine_history", @"title": @"\u5386\u53f2\u8bb0\u5f55"},
        @{@"asset": @"bl_mine_favorite", @"title": @"\u6211\u7684\u6536\u85cf"},
        @{@"asset": @"bl_mine_watch_later", @"title": @"\u7a0d\u540e\u518d\u770b"}
    ];
}

- (NSArray<NSDictionary *> *)serviceItems {
    return @[
        @{@"asset": @"bl_mine_course", @"title": @"\u6211\u7684\u8bfe\u7a0b"},
        @{@"asset": @"bl_mine_free_data", @"title": @"\u514d\u6d41\u91cf\u670d\u52a1"},
        @{@"asset": @"bl_mine_dress", @"title": @"\u4e2a\u6027\u88c5\u626e"},
        @{@"asset": @"bl_mine_wallet", @"title": @"\u6211\u7684\u94b1\u5305"},
        @{@"asset": @"bl_mine_mall", @"title": @"\u4f1a\u5458\u8d2d\u8ba2\u5355"},
        @{@"asset": @"bl_mine_live", @"title": @"\u6211\u7684\u76f4\u64ad"},
        @{@"asset": @"bl_mine_comic", @"title": @"\u6f2b\u753b"},
        @{@"asset": @"bl_mine_promote", @"title": @"\u5fc5\u706b\u63a8\u5e7f"},
        @{@"asset": @"bl_mine_creator", @"title": @"\u521b\u4f5c\u4e2d\u5fc3"},
        @{@"asset": @"bl_mine_community", @"title": @"\u793e\u533a\u4e2d\u5fc3"},
        @{@"asset": @"bl_mine_charity", @"title": @"\u54d4\u54e9\u54d4\u54e9\u516c\u76ca"},
        @{@"asset": @"bl_mine_workshop", @"title": @"\u5de5\u623f"},
        @{@"asset": @"bl_mine_energy", @"title": @"\u80fd\u91cf\u52a0\u6cb9\u7ad9"}
    ];
}

- (UIView *)quickGridWithItems:(NSArray<NSDictionary *> *)items columns:(NSInteger)columns {
    UIStackView *grid = [[UIStackView alloc] init];
    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 20.0;
    NSInteger index = 0;
    while (index < items.count) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.distribution = UIStackViewDistributionFillEqually;
        row.alignment = UIStackViewAlignmentTop;
        for (NSInteger column = 0; column < columns; column++) {
            if (index < items.count) {
                [row addArrangedSubview:[self iconEntryWithAsset:items[index][@"asset"] title:items[index][@"title"]]];
            } else {
                UIView *empty = [[UIView alloc] init];
                [row addArrangedSubview:empty];
            }
            index++;
        }
        [grid addArrangedSubview:row];
    }
    return grid;
}

- (UIView *)iconEntryWithAsset:(NSString *)asset title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 7.0;
    [stack addArrangedSubview:[self imageIcon:asset size:30.0 tint:nil]];
    UILabel *label = [self labelWithText:title size:14.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.25 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    [stack addArrangedSubview:label];
    [stack.heightAnchor constraintEqualToConstant:62.0].active = YES;
    if ([asset isEqualToString:@"bl_mine_offline"] || [asset isEqualToString:@"bl_mine_history"] || [asset isEqualToString:@"bl_mine_favorite"] || [asset isEqualToString:@"bl_mine_watch_later"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        SEL action = @selector(offlineCacheButtonTapped);
        if ([asset isEqualToString:@"bl_mine_history"]) {
            action = @selector(historyButtonTapped);
        } else if ([asset isEqualToString:@"bl_mine_favorite"]) {
            action = @selector(favoriteButtonTapped);
        } else if ([asset isEqualToString:@"bl_mine_watch_later"]) {
            action = @selector(watchLaterButtonTapped);
        }
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [stack addSubview:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:stack.topAnchor],
            [button.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
            [button.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
            [button.bottomAnchor constraintEqualToAnchor:stack.bottomAnchor]
        ]];
    }
    return stack;
}

- (void)offlineCacheButtonTapped {
    if (self.offlineCacheTapped) {
        self.offlineCacheTapped();
    }
}

- (void)historyButtonTapped {
    if (self.historyTapped) {
        self.historyTapped();
    }
}

- (void)favoriteButtonTapped {
    if (self.favoriteTapped) {
        self.favoriteTapped();
    }
}

- (void)watchLaterButtonTapped {
    if (self.watchLaterTapped) {
        self.watchLaterTapped();
    }
}

- (void)profileButtonTapped {
    if (self.profileTapped) {
        self.profileTapped();
    }
}

- (void)memberCenterButtonTapped {
    if (self.memberCenterTapped) {
        self.memberCenterTapped();
    }
}

- (UIView *)publishCard {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.98 alpha:1.0];
    card.layer.cornerRadius = 8.0;
    card.layer.borderColor = [UIColor colorWithRed:0.98 green:0.85 blue:0.90 alpha:1.0].CGColor;
    card.layer.borderWidth = 1.0;
    [card.heightAnchor constraintEqualToConstant:78.0].active = YES;

    UILabel *up = [self labelWithText:@"UP" size:14.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    up.textAlignment = NSTextAlignmentCenter;
    up.backgroundColor = BLMinePink();
    up.layer.cornerRadius = 4.0;
    up.layer.masksToBounds = YES;
    UILabel *title = [self labelWithText:@"\u53d1\u5e03\u4f60\u7684\u7b2c\u4e00\u4e2a\u89c6\u9891" size:18.0 weight:UIFontWeightSemibold color:BLMineText()];
    UILabel *sub = [self labelWithText:@"\u9886\u9650\u5b9a\u5934\u50cf\u6302\u4ef6\uff0c\u8d62\u6d3b\u52a8\u5956\u91d1" size:14.0 weight:UIFontWeightRegular color:BLMineSubText()];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = BLMinePink();
    button.layer.cornerRadius = 18.0;
    [button setTitle:@"\u21e7 \u6709\u5956\u53d1\u5e03" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];

    [card addSubview:up];
    [card addSubview:title];
    [card addSubview:sub];
    [card addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [up.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [up.topAnchor constraintEqualToAnchor:card.topAnchor constant:18.0],
        [up.widthAnchor constraintEqualToConstant:28.0],
        [up.heightAnchor constraintEqualToConstant:22.0],
        [title.leadingAnchor constraintEqualToAnchor:up.trailingAnchor constant:10.0],
        [title.centerYAnchor constraintEqualToAnchor:up.centerYAnchor],
        [sub.leadingAnchor constraintEqualToAnchor:up.leadingAnchor],
        [sub.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:8.0],
        [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [button.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:118.0],
        [button.heightAnchor constraintEqualToConstant:36.0],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:button.leadingAnchor constant:-12.0]
    ]];
    return card;
}

- (UIView *)gameSection {
    UIStackView *section = [[UIStackView alloc] init];
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 18.0;
    UIView *headline = [[UIView alloc] init];
    headline.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *title = [self labelWithText:@"\u6e38\u620f\u4e2d\u5fc3" size:17.0 weight:UIFontWeightSemibold color:BLMineText()];
    UILabel *promo = [self labelWithText:@"\u516d\u661f\u5957\u88c5\u3010\u85af\u795e\u6625\u9192\u3011\u9650\u65f6\u767b\u9646" size:14.0 weight:UIFontWeightRegular color:BLMineSubText()];
    UIImageView *arrow = [self systemIcon:@"chevron.right" size:18.0 color:BLMineSubText()];
    [headline addSubview:title];
    [headline addSubview:promo];
    [headline addSubview:arrow];
    [headline.heightAnchor constraintEqualToConstant:28.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:headline.leadingAnchor],
        [title.centerYAnchor constraintEqualToAnchor:headline.centerYAnchor],
        [arrow.trailingAnchor constraintEqualToAnchor:headline.trailingAnchor],
        [arrow.centerYAnchor constraintEqualToAnchor:headline.centerYAnchor],
        [promo.trailingAnchor constraintEqualToAnchor:arrow.leadingAnchor constant:-8.0],
        [promo.centerYAnchor constraintEqualToAnchor:headline.centerYAnchor],
        [promo.leadingAnchor constraintGreaterThanOrEqualToAnchor:title.trailingAnchor constant:16.0]
    ]];
    [section addArrangedSubview:headline];
    [section addArrangedSubview:[self quickGridWithItems:@[
        @{@"asset": @"bl_mine_game", @"title": @"\u6211\u7684\u6e38\u620f"},
        @{@"asset": @"bl_mine_reservation", @"title": @"\u6211\u7684\u9884\u7ea6"},
        @{@"asset": @"bl_mine_find_game", @"title": @"\u627e\u6e38\u620f"},
        @{@"asset": @"bl_mine_game_rank", @"title": @"\u6e38\u620f\u6392\u884c\u699c"}
    ] columns:4]];
    return section;
}

- (UIView *)serviceList {
    UIStackView *list = [[UIStackView alloc] init];
    list.axis = UILayoutConstraintAxisVertical;
    list.spacing = 0.0;
    NSArray *rows = @[
        @{@"asset": @"bl_mine_service", @"title": @"\u8054\u7cfb\u5ba2\u670d"},
        @{@"asset": @"bl_mine_listen", @"title": @"\u542c\u89c6\u9891"},
        @{@"asset": @"bl_mine_guardian", @"title": @"\u672a\u6210\u5e74\u4eba\u5b88\u62a4"},
        @{@"asset": @"bl_mine_settings", @"title": @"\u8bbe\u7f6e"}
    ];
    for (NSDictionary *row in rows) {
        [list addArrangedSubview:[self listRowWithAsset:row[@"asset"] title:row[@"title"]]];
    }
    return list;
}

- (UIView *)listRowWithAsset:(NSString *)asset title:(NSString *)title {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.userInteractionEnabled = YES;
    [row.heightAnchor constraintEqualToConstant:64.0].active = YES;
    UIImageView *icon = [self imageIcon:asset size:29.0 tint:nil];
    UILabel *label = [self labelWithText:title size:17.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.23 alpha:1.0]];
    UIImageView *arrow = [self systemIcon:@"chevron.right" size:19.0 color:BLMineSubText()];
    [row addSubview:icon];
    [row addSubview:label];
    [row addSubview:arrow];
    if ([asset isEqualToString:@"bl_mine_service"]) {
        [row addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactServiceButtonTapped)]];
    }
    [NSLayoutConstraint activateConstraints:@[
        [icon.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:29.0],
        [icon.heightAnchor constraintEqualToConstant:29.0],
        [label.leadingAnchor constraintEqualToAnchor:icon.trailingAnchor constant:22.0],
        [label.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [arrow.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [arrow.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [arrow.widthAnchor constraintEqualToConstant:19.0],
        [arrow.heightAnchor constraintEqualToConstant:19.0]
    ]];
    return row;
}

- (void)contactServiceButtonTapped {
    if (self.contactServiceTapped) {
        self.contactServiceTapped();
    }
}

- (UILabel *)sectionTitle:(NSString *)title {
    UILabel *label = [self labelWithText:title size:19.0 weight:UIFontWeightSemibold color:BLMineText()];
    [label.heightAnchor constraintEqualToConstant:26.0].active = YES;
    return label;
}

- (UIImageView *)imageIcon:(NSString *)asset size:(CGFloat)size tint:(UIColor *)tint {
    UIImage *image = [UIImage imageNamed:asset];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:tint ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (tint) {
        imageView.tintColor = tint;
    }
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

@end
