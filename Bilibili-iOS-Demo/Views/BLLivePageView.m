#import "BLLivePageView.h"
#import "BLLiveBeautyPageView.h"
#import "BLLiveCarouselView.h"
#import "BLLiveLeaguePageView.h"
#import "BLLivePopularityView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLLivePageText(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

@interface BLLiveMiniCoverView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *statsLabel;
@end

@implementation BLLiveMiniCoverView

- (instancetype)initWithQuestion:(NSString *)question colors:(NSArray<UIColor *> *)colors stats:(NSString *)stats {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.42 green:0.30 blue:0.70 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.78 green:0.34 blue:0.76 alpha:1.0];
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[
            (__bridge id)startColor.CGColor,
            (__bridge id)endColor.CGColor
        ];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];

        self.questionLabel = [self labelWithText:question font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
        self.questionLabel.numberOfLines = 2;
        [self addSubview:self.questionLabel];

        self.statsLabel = [self labelWithText:stats font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[[UIColor whiteColor] colorWithAlphaComponent:0.92]];
        [self addSubview:self.statsLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.questionLabel.frame = CGRectMake(12.0, 14.0, width - 24.0, 48.0);
    self.statsLabel.frame = CGRectMake(12.0, height - 30.0, width - 24.0, 18.0);
}

- (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end

@interface BLLivePageView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSMutableArray<UILabel *> *liveTabLabels;
@property (nonatomic, strong) UIView *liveContentContainer;
@property (nonatomic, strong) UIView *recommendContentView;
@property (nonatomic, strong) BLLiveBeautyPageView *beautyPageView;
@property (nonatomic, strong) BLLiveLeaguePageView *leaguePageView;
@property (nonatomic, strong) BLLivePopularityView *popularityView;
@property (nonatomic, strong) NSLayoutConstraint *liveContentHeightConstraint;
@property (nonatomic, copy) NSString *selectedLiveTab;
@property (nonatomic, assign) NSUInteger selectedLiveTabIndex;
@end

@implementation BLLivePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 12.0;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self carouselSection]];
    [self.contentStack addArrangedSubview:[self followingSection]];
    [self.contentStack addArrangedSubview:[self liveCategoryTabs]];
    [self.contentStack addArrangedSubview:[self liveContentSection]];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor constant:8.0],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-16.0],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
}

- (UIView *)carouselSection {
    NSArray *items = @[
        [BLLiveCarouselItem itemWithTitle:@"CSGO官方赛事" subtitle:@"IEM科隆Major" badge:@"直播中" colors:@[[UIColor colorWithRed:0.20 green:0.18 blue:0.14 alpha:1.0], [UIColor colorWithRed:0.44 green:0.34 blue:0.20 alpha:1.0]]],
        [BLLiveCarouselItem itemWithTitle:@"明日方舟庆典" subtitle:@"限定干员实况" badge:@"直播中" colors:@[[UIColor colorWithRed:0.86 green:0.78 blue:0.50 alpha:1.0], [UIColor colorWithRed:0.55 green:0.78 blue:0.95 alpha:1.0]]],
        [BLLiveCarouselItem itemWithTitle:@"虚拟主播电台" subtitle:@"今晚一起聊天" badge:@"直播中" colors:@[[UIColor colorWithRed:0.38 green:0.54 blue:0.95 alpha:1.0], [UIColor colorWithRed:0.78 green:0.47 blue:0.90 alpha:1.0]]],
        [BLLiveCarouselItem itemWithTitle:@"高能游戏时刻" subtitle:@"头号玩家集结" badge:@"直播中" colors:@[[UIColor colorWithRed:0.18 green:0.64 blue:0.54 alpha:1.0], [UIColor colorWithRed:0.22 green:0.32 blue:0.74 alpha:1.0]]]
    ];
    BLLiveCarouselView *carousel = [[BLLiveCarouselView alloc] initWithItems:items];
    [carousel.heightAnchor constraintEqualToConstant:260.0].active = YES;
    return carousel;
}

- (UIView *)followingSection {
    UIView *card = [self whiteCard];
    UILabel *title = [self labelWithText:@"我的关注 7人正在直播" font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold] color:BLLivePageText()];
    [card addSubview:title];

    UILabel *all = [self labelWithText:@"全部 〉" font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.55 alpha:1.0]];
    [card addSubview:all];

    UIScrollView *avatars = [[UIScrollView alloc] init];
    avatars.translatesAutoresizingMaskIntoConstraints = NO;
    avatars.showsHorizontalScrollIndicator = NO;
    [card addSubview:avatars];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 20.0;
    [avatars addSubview:stack];

    NSArray *names = @[@"一叮当猫", @"Jason-老湿", @"汤臣一雪", @"尚硅谷", @"友利奈绪", @"马士兵官号", @"TED"];
    for (NSString *name in names) {
        [stack addArrangedSubview:[self avatarItemWithName:name]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [card.heightAnchor constraintEqualToConstant:168.0],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:18.0],
        [all.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [all.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [avatars.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [avatars.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [avatars.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:20.0],
        [avatars.heightAnchor constraintEqualToConstant:92.0],
        [stack.leadingAnchor constraintEqualToAnchor:avatars.contentLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:avatars.contentLayoutGuide.trailingAnchor],
        [stack.topAnchor constraintEqualToAnchor:avatars.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:avatars.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:avatars.frameLayoutGuide.heightAnchor]
    ]];
    return card;
}

- (UIView *)avatarItemWithName:(NSString *)name {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 6.0;

    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.backgroundColor = [UIColor colorWithRed:0.92 green:0.78 blue:0.86 alpha:1.0];
    avatar.layer.cornerRadius = 28.0;
    avatar.layer.borderWidth = 1.5;
    avatar.layer.borderColor = [UIColor colorWithRed:0.90 green:0.36 blue:0.57 alpha:1.0].CGColor;
    [stack addArrangedSubview:avatar];

    UILabel *label = [self labelWithText:name font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.36 alpha:1.0]];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [avatar.widthAnchor constraintEqualToConstant:56.0],
        [avatar.heightAnchor constraintEqualToConstant:56.0],
        [stack.widthAnchor constraintEqualToConstant:70.0]
    ]];
    return stack;
}

- (UIView *)liveCategoryTabs {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.liveTabLabels = [NSMutableArray array];

    UIStackView *tabs = [[UIStackView alloc] init];
    tabs.translatesAutoresizingMaskIntoConstraints = NO;
    tabs.axis = UILayoutConstraintAxisHorizontal;
    tabs.distribution = UIStackViewDistributionEqualSpacing;
    tabs.alignment = UIStackViewAlignmentCenter;
    [container addSubview:tabs];

    NSArray *titles = @[@"推荐", @"人气", @"颜值", @"英雄联盟", @"虚拟主播"];
    for (NSUInteger index = 0; index < titles.count; index++) {
        UIColor *color = index == 0 ? BLLivePageText() : [UIColor colorWithWhite:0.62 alpha:1.0];
        UIFont *font = [UIFont systemFontOfSize:18.0 weight:index == 0 ? UIFontWeightSemibold : UIFontWeightRegular];
        UILabel *label = [self labelWithText:titles[index] font:font color:color];
        label.userInteractionEnabled = YES;
        [self.liveTabLabels addObject:label];
        [tabs addArrangedSubview:label];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = index;
        [button addTarget:self action:@selector(liveTabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [label addSubview:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:label.topAnchor constant:-12.0],
            [button.leadingAnchor constraintEqualToAnchor:label.leadingAnchor constant:-14.0],
            [button.trailingAnchor constraintEqualToAnchor:label.trailingAnchor constant:14.0],
            [button.bottomAnchor constraintEqualToAnchor:label.bottomAnchor constant:12.0]
        ]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:48.0],
        [tabs.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:16.0],
        [tabs.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16.0],
        [tabs.centerYAnchor constraintEqualToAnchor:container.centerYAnchor]
    ]];
    return container;
}

- (UIView *)liveContentSection {
    self.liveContentContainer = [[UIView alloc] init];
    self.liveContentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.recommendContentView = [self liveGridSection];
    self.beautyPageView = [[BLLiveBeautyPageView alloc] initWithFrame:CGRectZero];
    self.beautyPageView.hidden = YES;
    self.leaguePageView = [[BLLiveLeaguePageView alloc] initWithFrame:CGRectZero];
    self.leaguePageView.hidden = YES;
    self.popularityView = [[BLLivePopularityView alloc] initWithFrame:CGRectZero];
    self.popularityView.hidden = YES;

    [self.liveContentContainer addSubview:self.recommendContentView];
    [self.liveContentContainer addSubview:self.beautyPageView];
    [self.liveContentContainer addSubview:self.leaguePageView];
    [self.liveContentContainer addSubview:self.popularityView];
    self.liveContentHeightConstraint = [self.liveContentContainer.heightAnchor constraintEqualToConstant:444.0];

    [NSLayoutConstraint activateConstraints:@[
        self.liveContentHeightConstraint,
        [self.recommendContentView.topAnchor constraintEqualToAnchor:self.liveContentContainer.topAnchor],
        [self.recommendContentView.leadingAnchor constraintEqualToAnchor:self.liveContentContainer.leadingAnchor],
        [self.recommendContentView.trailingAnchor constraintEqualToAnchor:self.liveContentContainer.trailingAnchor],
        [self.recommendContentView.bottomAnchor constraintEqualToAnchor:self.liveContentContainer.bottomAnchor],
        [self.beautyPageView.topAnchor constraintEqualToAnchor:self.liveContentContainer.topAnchor],
        [self.beautyPageView.leadingAnchor constraintEqualToAnchor:self.liveContentContainer.leadingAnchor],
        [self.beautyPageView.trailingAnchor constraintEqualToAnchor:self.liveContentContainer.trailingAnchor],
        [self.beautyPageView.bottomAnchor constraintEqualToAnchor:self.liveContentContainer.bottomAnchor],
        [self.leaguePageView.topAnchor constraintEqualToAnchor:self.liveContentContainer.topAnchor],
        [self.leaguePageView.leadingAnchor constraintEqualToAnchor:self.liveContentContainer.leadingAnchor],
        [self.leaguePageView.trailingAnchor constraintEqualToAnchor:self.liveContentContainer.trailingAnchor],
        [self.leaguePageView.bottomAnchor constraintEqualToAnchor:self.liveContentContainer.bottomAnchor],
        [self.popularityView.topAnchor constraintEqualToAnchor:self.liveContentContainer.topAnchor],
        [self.popularityView.leadingAnchor constraintEqualToAnchor:self.liveContentContainer.leadingAnchor],
        [self.popularityView.trailingAnchor constraintEqualToAnchor:self.liveContentContainer.trailingAnchor],
        [self.popularityView.bottomAnchor constraintEqualToAnchor:self.liveContentContainer.bottomAnchor]
    ]];
    self.selectedLiveTab = @"推荐";
    self.selectedLiveTabIndex = 0;
    return self.liveContentContainer;
}

- (void)liveTabTapped:(UIButton *)sender {
    NSArray *titles = @[@"推荐", @"人气", @"颜值", @"英雄联盟", @"虚拟主播"];
    if (sender.tag >= titles.count) {
        return;
    }
    self.selectedLiveTab = titles[sender.tag];
    self.selectedLiveTabIndex = sender.tag;
    [self updateLiveTabSelection];
}

- (void)updateLiveTabSelection {
    for (NSUInteger index = 0; index < self.liveTabLabels.count; index++) {
        UILabel *label = self.liveTabLabels[index];
        BOOL selected = index == self.selectedLiveTabIndex;
        label.textColor = selected ? BLLivePageText() : [UIColor colorWithWhite:0.62 alpha:1.0];
        label.font = [UIFont systemFontOfSize:18.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
    }

    BOOL showPopularity = self.selectedLiveTabIndex == 1;
    BOOL showBeauty = self.selectedLiveTabIndex == 2;
    BOOL showLeague = self.selectedLiveTabIndex == 3;
    self.recommendContentView.hidden = showPopularity || showBeauty || showLeague;
    self.beautyPageView.hidden = !showBeauty;
    self.leaguePageView.hidden = !showLeague;
    self.popularityView.hidden = !showPopularity;
    self.liveContentHeightConstraint.constant = showPopularity ? 756.0 : (showBeauty ? 600.0 : (showLeague ? 740.0 : 444.0));
}

- (UIView *)liveGridSection {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView *grid = [[UIStackView alloc] init];
    grid.translatesAutoresizingMaskIntoConstraints = NO;
    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 8.0;
    [container addSubview:grid];

    NSArray *rows = @[
        @[
            @{@"title": @"能力越小责任越小", @"question": @"今晚打排位还是刷素材?", @"stats": @"357观看  ·  弹幕聊天中"},
            @{@"title": @"就是瞎玩~", @"question": @"这把能不能逆风翻盘?", @"stats": @"319观看  ·  主播在线"}
        ],
        @[
            @{@"title": @"今晚来点轻松的", @"question": @"要不要一起点歌?", @"stats": @"486观看  ·  轻松电台"},
            @{@"title": @"新角色试玩", @"question": @"新角色强度怎么样?", @"stats": @"692观看  ·  试玩中"}
        ]
    ];
    for (NSArray *rowItems in rows) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 8.0;
        row.distribution = UIStackViewDistributionFillEqually;
        [grid addArrangedSubview:row];
        for (NSDictionary *item in rowItems) {
            [row addArrangedSubview:[self liveCardWithTitle:item[@"title"] question:item[@"question"] stats:item[@"stats"]]];
        }
    }

    [NSLayoutConstraint activateConstraints:@[
        [grid.topAnchor constraintEqualToAnchor:container.topAnchor],
        [grid.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:6.0],
        [grid.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-6.0],
        [grid.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
    return container;
}

- (UIView *)liveCardWithTitle:(NSString *)title question:(NSString *)question stats:(NSString *)stats {
    UIView *card = [self whiteCard];
    NSArray *palettes = @[
        @[[UIColor colorWithRed:0.41 green:0.28 blue:0.75 alpha:1.0], [UIColor colorWithRed:0.86 green:0.38 blue:0.72 alpha:1.0]],
        @[[UIColor colorWithRed:0.12 green:0.50 blue:0.78 alpha:1.0], [UIColor colorWithRed:0.46 green:0.82 blue:0.76 alpha:1.0]],
        @[[UIColor colorWithRed:0.95 green:0.44 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.95 green:0.72 blue:0.31 alpha:1.0]],
        @[[UIColor colorWithRed:0.24 green:0.66 blue:0.43 alpha:1.0], [UIColor colorWithRed:0.28 green:0.43 blue:0.86 alpha:1.0]]
    ];
    NSUInteger paletteIndex = title.length % palettes.count;
    BLLiveMiniCoverView *cover = [[BLLiveMiniCoverView alloc] initWithQuestion:question colors:palettes[paletteIndex] stats:stats];
    [card addSubview:cover];

    UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular] color:BLLivePageText()];
    [card addSubview:titleLabel];
    UILabel *author = [self labelWithText:@"素颜朝天的脸好..." font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.55 alpha:1.0]];
    [card addSubview:author];

    [NSLayoutConstraint activateConstraints:@[
        [card.heightAnchor constraintEqualToConstant:218.0],
        [cover.topAnchor constraintEqualToAnchor:card.topAnchor],
        [cover.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [cover.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [cover.heightAnchor constraintEqualToAnchor:cover.widthAnchor multiplier:0.72],
        [titleLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:10.0],
        [titleLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-10.0],
        [titleLabel.topAnchor constraintEqualToAnchor:cover.bottomAnchor constant:10.0],
        [author.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [author.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
        [author.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4.0]
    ]];
    return card;
}

- (UIView *)whiteCard {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6.0;
    view.layer.masksToBounds = YES;
    return view;
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
