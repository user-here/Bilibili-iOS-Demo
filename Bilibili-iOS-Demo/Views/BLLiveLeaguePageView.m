#import "BLLiveLeaguePageView.h"
#import "BLLiveLeagueLiveCardView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLLiveLeaguePink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLLiveLeagueMuted(void) {
    return [UIColor colorWithWhite:0.60 alpha:1.0];
}

@interface BLLiveLeagueBannerCell : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation BLLiveLeagueBannerCell

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.22 green:0.56 blue:0.26 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.66 green:0.86 blue:0.36 alpha:1.0];
        self.backgroundColor = startColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];

        UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:42.0 weight:UIFontWeightBold] color:[UIColor whiteColor]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];

        UILabel *subtitleLabel = [self labelWithText:subtitle font:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.95]];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:subtitleLabel];

        UILabel *dateLabel = [self labelWithText:@"06.03-06.08" font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightBold] color:[UIColor colorWithRed:0.96 green:0.86 blue:0.48 alpha:1.0]];
        [self addSubview:dateLabel];

        [NSLayoutConstraint activateConstraints:@[
            [titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-6.0],
            [titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:18.0],
            [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-18.0],
            [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
            [subtitleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:18.0],
            [dateLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18.0],
            [dateLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16.0]
        ]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
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

@interface BLLiveLeagueItem : NSObject
@property (nonatomic, copy) NSString *anchor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *viewers;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, strong) NSArray<UIColor *> *colors;
+ (instancetype)itemWithAnchor:(NSString *)anchor title:(NSString *)title viewers:(NSString *)viewers badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors;
@end

@implementation BLLiveLeagueItem

+ (instancetype)itemWithAnchor:(NSString *)anchor title:(NSString *)title viewers:(NSString *)viewers badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors {
    BLLiveLeagueItem *item = [[BLLiveLeagueItem alloc] init];
    item.anchor = anchor;
    item.title = title;
    item.viewers = viewers;
    item.badge = badge;
    item.colors = colors;
    return item;
}

@end

@interface BLLiveLeaguePageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bannerScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *bannerTimer;
@property (nonatomic, strong) NSArray<BLLiveLeagueBannerCell *> *bannerCells;
@property (nonatomic, strong) UIStackView *tabStack;
@property (nonatomic, strong) UIStackView *gridStack;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<BLLiveLeagueItem *> *> *itemsByTab;
@property (nonatomic, copy) NSString *selectedTab;
@end

@implementation BLLiveLeaguePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildData];
        [self buildView];
        [self selectTab:@"综合"];
        [self startBannerTimer];
    }
    return self;
}

- (void)dealloc {
    [self.bannerTimer invalidate];
}

- (void)buildData {
    UIColor *navy = [UIColor colorWithRed:0.10 green:0.17 blue:0.28 alpha:1.0];
    UIColor *steel = [UIColor colorWithRed:0.26 green:0.38 blue:0.52 alpha:1.0];
    UIColor *gold = [UIColor colorWithRed:0.78 green:0.58 blue:0.20 alpha:1.0];
    UIColor *purple = [UIColor colorWithRed:0.42 green:0.20 blue:0.66 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:0.56 green:0.14 blue:0.10 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0.20 green:0.55 blue:0.24 alpha:1.0];

    NSArray *base = @[
        [BLLiveLeagueItem itemWithAnchor:@"老实憨厚的笑笑" title:@"德云色LPL季后赛 AL LGD" viewers:@"22.1万" badge:@"TopStar" colors:@[purple, gold]],
        [BLLiveLeagueItem itemWithAnchor:@"哔哩哔哩英雄联盟" title:@"【预告】6号17点BLG vs JDG" viewers:@"35.2万" badge:@"" colors:@[navy, steel]],
        [BLLiveLeagueItem itemWithAnchor:@"赵俊日" title:@"二路" viewers:@"2.7万" badge:@"SSS主播" colors:@[steel, navy]],
        [BLLiveLeagueItem itemWithAnchor:@"不死斩剑圣" title:@"斩归！今日只有一字！杀！" viewers:@"3.3万" badge:@"SSS主播" colors:@[red, gold]],
        [BLLiveLeagueItem itemWithAnchor:@"挖机牧魂人" title:@"对线？只有高手才对线！" viewers:@"2.6万" badge:@"SS主播" colors:@[navy, purple]],
        [BLLiveLeagueItem itemWithAnchor:@"LGDPYL116" title:@"LGD AL@!" viewers:@"2.6万" badge:@"SSS主播" colors:@[steel, navy]]
    ];
    self.itemsByTab = @{
        @"综合": base,
        @"云顶之弈": @[
            [BLLiveLeagueItem itemWithAnchor:@"弈手小王" title:@"新版本阵容先手开测" viewers:@"8.8万" badge:@"百胜" colors:@[navy, gold]],
            [BLLiveLeagueItem itemWithAnchor:@"棋盘观察员" title:@"经济运营教学局" viewers:@"6.1万" badge:@"SSS主播" colors:@[purple, steel]],
            [BLLiveLeagueItem itemWithAnchor:@"九五至尊" title:@"这把只玩高费卡" viewers:@"3.4万" badge:@"SS主播" colors:@[red, gold]],
            [BLLiveLeagueItem itemWithAnchor:@"天选打工人" title:@"上分阵容稳定复盘" viewers:@"1.7万" badge:@"" colors:@[green, steel]]
        ],
        @"巅峰王者": @[
            [BLLiveLeagueItem itemWithAnchor:@"峡谷第一视角" title:@"王者局打野思路" viewers:@"12.6万" badge:@"SSS主播" colors:@[navy, steel]],
            [BLLiveLeagueItem itemWithAnchor:@"高分路人王" title:@"只打质量局" viewers:@"9.4万" badge:@"百胜" colors:@[purple, gold]],
            [BLLiveLeagueItem itemWithAnchor:@"上单不服输" title:@"今天练新英雄" viewers:@"5.2万" badge:@"SS主播" colors:@[red, navy]],
            [BLLiveLeagueItem itemWithAnchor:@"下路双排中" title:@"冲分到凌晨" viewers:@"4.7万" badge:@"" colors:@[green, steel]]
        ],
        @"颜值声优": @[
            [BLLiveLeagueItem itemWithAnchor:@"软糖解说" title:@"峡谷聊天电台" viewers:@"3.8万" badge:@"SS主播" colors:@[purple, red]],
            [BLLiveLeagueItem itemWithAnchor:@"晚风配音社" title:@"声优陪看LPL" viewers:@"2.9万" badge:@"SSS主播" colors:@[steel, purple]],
            [BLLiveLeagueItem itemWithAnchor:@"可乐妹妹" title:@"边玩辅助边点歌" viewers:@"1.8万" badge:@"" colors:@[red, gold]],
            [BLLiveLeagueItem itemWithAnchor:@"阿九不熬夜" title:@"今晚只玩软辅" viewers:@"1.2万" badge:@"SS主播" colors:@[green, navy]]
        ]
    };
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

    self.bannerScrollView = [[UIScrollView alloc] init];
    self.bannerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerScrollView.pagingEnabled = YES;
    self.bannerScrollView.showsHorizontalScrollIndicator = NO;
    self.bannerScrollView.delegate = self;
    [self addSubview:self.bannerScrollView];

    NSArray *banners = @[
        [[BLLiveLeagueBannerCell alloc] initWithTitle:@"大狗放粽" subtitle:@"舰长福利" colors:@[[UIColor colorWithRed:0.20 green:0.58 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.66 green:0.84 blue:0.34 alpha:1.0]]],
        [[BLLiveLeagueBannerCell alloc] initWithTitle:@"峡谷开黑" subtitle:@"端午组队挑战" colors:@[[UIColor colorWithRed:0.13 green:0.27 blue:0.56 alpha:1.0], [UIColor colorWithRed:0.38 green:0.62 blue:0.95 alpha:1.0]]],
        [[BLLiveLeagueBannerCell alloc] initWithTitle:@"LPL观赛" subtitle:@"赛事直播间" colors:@[[UIColor colorWithRed:0.44 green:0.14 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.82 green:0.58 blue:0.25 alpha:1.0]]]
    ];
    self.bannerCells = banners;
    for (UIView *banner in banners) {
        banner.translatesAutoresizingMaskIntoConstraints = YES;
        [self.bannerScrollView addSubview:banner];
    }

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.numberOfPages = banners.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.62];
    self.pageControl.currentPageIndicatorTintColor = BLLiveLeaguePink();
    [self addSubview:self.pageControl];

    self.tabStack = [[UIStackView alloc] init];
    self.tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabStack.axis = UILayoutConstraintAxisHorizontal;
    self.tabStack.spacing = 16.0;
    self.tabStack.alignment = UIStackViewAlignmentCenter;
    [self addSubview:self.tabStack];

    NSMutableArray *buttons = [NSMutableArray array];
    for (NSString *title in @[@"综合", @"云顶之弈", @"巅峰王者", @"颜值声优"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        button.layer.cornerRadius = 17.0;
        button.layer.borderWidth = 1.2;
        button.accessibilityIdentifier = title;
        [button addTarget:self action:@selector(tabButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabStack addArrangedSubview:button];
        [buttons addObject:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.widthAnchor constraintEqualToConstant:[title isEqualToString:@"综合"] ? 70.0 : 92.0],
            [button.heightAnchor constraintEqualToConstant:34.0]
        ]];
    }
    self.tabButtons = buttons.copy;

    self.gridStack = [[UIStackView alloc] init];
    self.gridStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.gridStack.axis = UILayoutConstraintAxisVertical;
    self.gridStack.spacing = 12.0;
    [self addSubview:self.gridStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.bannerScrollView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0],
        [self.bannerScrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10.0],
        [self.bannerScrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10.0],
        [self.bannerScrollView.heightAnchor constraintEqualToConstant:150.0],

        [self.pageControl.trailingAnchor constraintEqualToAnchor:self.bannerScrollView.trailingAnchor constant:-8.0],
        [self.pageControl.bottomAnchor constraintEqualToAnchor:self.bannerScrollView.bottomAnchor constant:-8.0],
        [self.pageControl.heightAnchor constraintEqualToConstant:18.0],

        [self.tabStack.topAnchor constraintEqualToAnchor:self.bannerScrollView.bottomAnchor constant:18.0],
        [self.tabStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [self.tabStack.heightAnchor constraintEqualToConstant:42.0],

        [self.gridStack.topAnchor constraintEqualToAnchor:self.tabStack.bottomAnchor constant:10.0],
        [self.gridStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12.0],
        [self.gridStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12.0],
        [self.gridStack.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bannerScrollView.bounds);
    CGFloat height = CGRectGetHeight(self.bannerScrollView.bounds);
    if (width <= 0.0) {
        return;
    }
    for (NSUInteger index = 0; index < self.bannerCells.count; index++) {
        self.bannerCells[index].frame = CGRectMake(width * index, 0.0, width, height);
    }
    self.bannerScrollView.contentSize = CGSizeMake(width * self.bannerCells.count, height);
}

- (void)startBannerTimer {
    __weak typeof(self) weakSelf = self;
    self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:2.8 repeats:YES block:^(NSTimer *timer) {
        [weakSelf advanceBanner];
    }];
}

- (void)advanceBanner {
    if (self.bannerCells.count == 0 || CGRectGetWidth(self.bannerScrollView.bounds) <= 0.0) {
        return;
    }
    NSInteger nextPage = (self.pageControl.currentPage + 1) % self.bannerCells.count;
    CGPoint offset = CGPointMake(CGRectGetWidth(self.bannerScrollView.bounds) * nextPage, 0.0);
    [self.bannerScrollView setContentOffset:offset animated:YES];
    self.pageControl.currentPage = nextPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    if (width <= 0.0) {
        return;
    }
    self.pageControl.currentPage = (NSInteger)round(scrollView.contentOffset.x / width);
}

- (void)tabButtonTapped:(UIButton *)sender {
    [self selectTab:sender.accessibilityIdentifier ?: @"综合"];
}

- (void)selectTab:(NSString *)tab {
    self.selectedTab = tab;
    for (UIButton *button in self.tabButtons) {
        BOOL selected = [button.accessibilityIdentifier isEqualToString:tab];
        UIColor *color = selected ? BLLiveLeaguePink() : BLLiveLeagueMuted();
        [button setTitleColor:color forState:UIControlStateNormal];
        button.layer.borderColor = color.CGColor;
        button.backgroundColor = selected ? [[UIColor whiteColor] colorWithAlphaComponent:0.96] : [UIColor clearColor];
    }
    [self reloadGrid];
}

- (void)reloadGrid {
    for (UIView *view in self.gridStack.arrangedSubviews.copy) {
        [self.gridStack removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    NSArray<BLLiveLeagueItem *> *items = self.itemsByTab[self.selectedTab] ?: @[];
    for (NSUInteger index = 0; index < items.count; index += 2) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 10.0;
        row.distribution = UIStackViewDistributionFillEqually;
        [self.gridStack addArrangedSubview:row];

        BLLiveLeagueItem *left = items[index];
        [row addArrangedSubview:[[BLLiveLeagueLiveCardView alloc] initWithAnchor:left.anchor title:left.title viewers:left.viewers badge:left.badge colors:left.colors]];
        if (index + 1 < items.count) {
            BLLiveLeagueItem *right = items[index + 1];
            [row addArrangedSubview:[[BLLiveLeagueLiveCardView alloc] initWithAnchor:right.anchor title:right.title viewers:right.viewers badge:right.badge colors:right.colors]];
        } else {
            [row addArrangedSubview:[[UIView alloc] init]];
        }
    }
}

@end
