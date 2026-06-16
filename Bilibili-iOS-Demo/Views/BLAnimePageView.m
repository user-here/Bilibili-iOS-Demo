#import "BLAnimePageView.h"
#import "BLAnimeCarouselView.h"
#import "BLAnimePosterCardView.h"

@interface BLAnimePageView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSArray<UIButton *> *rankTabButtons;
@property (nonatomic, copy) NSString *selectedRankTab;
@end

@implementation BLAnimePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        [self buildView];
        [self selectRankTab:@"番剧榜"];
    }
    return self;
}

- (void)buildView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 0.0;
    [self.scrollView addSubview:self.contentStack];

    BLAnimeCarouselView *carousel = [[BLAnimeCarouselView alloc] initWithItems:[self carouselItems]];
    [self.contentStack addArrangedSubview:carousel];
    [carousel.heightAnchor constraintEqualToConstant:300.0].active = YES;

    [self.contentStack addArrangedSubview:[self actionChipSection]];
    [self.contentStack addArrangedSubview:[self hotRankingSection]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"继续看" action:@"我的追番" items:[self continueItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"萌系榜" action:@"查看更多" items:[self moeItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"搞笑榜" action:@"查看更多" items:[self comedyItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"期待榜" action:@"查看更多" items:[self expectedItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"战斗榜" action:@"查看更多" items:[self battleItems]]];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-16.0],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
}

- (UIView *)actionChipSection {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 10.0;
    [scrollView addSubview:stack];

    for (NSString *title in @[@"找番看", @"时间表", @"番剧", @"国创", @"UP动画", @"少儿", @"动画种草"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.24 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        button.layer.cornerRadius = 8.0;
        [stack addArrangedSubview:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.widthAnchor constraintEqualToConstant:74.0],
            [button.heightAnchor constraintEqualToConstant:42.0]
        ]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.heightAnchor constraintEqualToConstant:58.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:12.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-12.0],
        [stack.centerYAnchor constraintEqualToAnchor:scrollView.centerYAnchor],
        [stack.heightAnchor constraintEqualToConstant:42.0]
    ]];
    return scrollView;
}

- (UIView *)hotRankingSection {
    UIStackView *section = [self verticalSection];
    [section addArrangedSubview:[self sectionHeaderWithTitle:@"热门排行榜" action:@"更多榜单"]];

    UIScrollView *tabScrollView = [[UIScrollView alloc] init];
    tabScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    tabScrollView.showsHorizontalScrollIndicator = NO;
    [section addArrangedSubview:tabScrollView];

    UIStackView *tabStack = [[UIStackView alloc] init];
    tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    tabStack.axis = UILayoutConstraintAxisHorizontal;
    tabStack.spacing = 20.0;
    [tabScrollView addSubview:tabStack];

    NSMutableArray *buttons = [NSMutableArray array];
    for (NSString *title in @[@"番剧榜", @"国创榜", @"资讯榜", @"热搜榜", @"会员榜", @"新番榜", @"口碑榜"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        button.accessibilityIdentifier = title;
        [button addTarget:self action:@selector(rankTabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tabStack addArrangedSubview:button];
        [buttons addObject:button];
    }
    self.rankTabButtons = buttons.copy;

    [NSLayoutConstraint activateConstraints:@[
        [tabScrollView.heightAnchor constraintEqualToConstant:34.0],
        [tabStack.leadingAnchor constraintEqualToAnchor:tabScrollView.contentLayoutGuide.leadingAnchor constant:14.0],
        [tabStack.trailingAnchor constraintEqualToAnchor:tabScrollView.contentLayoutGuide.trailingAnchor constant:-14.0],
        [tabStack.topAnchor constraintEqualToAnchor:tabScrollView.contentLayoutGuide.topAnchor],
        [tabStack.bottomAnchor constraintEqualToAnchor:tabScrollView.contentLayoutGuide.bottomAnchor],
        [tabStack.heightAnchor constraintEqualToAnchor:tabScrollView.frameLayoutGuide.heightAnchor]
    ]];

    [section addArrangedSubview:[self horizontalPosterListWithItems:[self rankingItems]]];
    return section;
}

- (UIView *)posterSectionWithTitle:(NSString *)title action:(NSString *)action items:(NSArray<NSDictionary<NSString *, id> *> *)items {
    UIStackView *section = [self verticalSection];
    [section addArrangedSubview:[self sectionHeaderWithTitle:title action:action]];
    [section addArrangedSubview:[self horizontalPosterListWithItems:items]];
    return section;
}

- (UIScrollView *)horizontalPosterListWithItems:(NSArray<NSDictionary<NSString *, id> *> *)items {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 10.0;
    [scrollView addSubview:stack];

    NSUInteger index = 1;
    for (NSDictionary<NSString *, id> *item in items) {
        BLAnimePosterCardView *card = [[BLAnimePosterCardView alloc] initWithRank:[NSString stringWithFormat:@"%lu", (unsigned long)index] title:item[@"title"] ?: @"" subtitle:item[@"subtitle"] ?: @"" badge:item[@"badge"] ?: @"" colors:item[@"colors"] ?: @[]];
        [stack addArrangedSubview:card];
        index++;
    }

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.heightAnchor constraintEqualToConstant:182.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:14.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-14.0],
        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.heightAnchor]
    ]];
    return scrollView;
}

- (UIStackView *)verticalSection {
    UIStackView *section = [[UIStackView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 8.0;
    section.backgroundColor = [UIColor whiteColor];
    section.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0);
    section.layoutMarginsRelativeArrangement = YES;
    return section;
}

- (UIView *)sectionHeaderWithTitle:(NSString *)title action:(NSString *)action {
    UIView *header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold] color:[UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1.0]];
    [header addSubview:titleLabel];

    UILabel *actionLabel = [self labelWithText:[NSString stringWithFormat:@"%@ >", action] font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    actionLabel.textAlignment = NSTextAlignmentRight;
    [header addSubview:actionLabel];

    [NSLayoutConstraint activateConstraints:@[
        [header.heightAnchor constraintEqualToConstant:34.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:14.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [actionLabel.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant:-14.0],
        [actionLabel.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [actionLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:titleLabel.trailingAnchor constant:12.0]
    ]];
    return header;
}

- (void)rankTabTapped:(UIButton *)sender {
    [self selectRankTab:sender.accessibilityIdentifier ?: @""];
}

- (void)selectRankTab:(NSString *)title {
    self.selectedRankTab = title;
    for (UIButton *button in self.rankTabButtons) {
        BOOL selected = [button.accessibilityIdentifier isEqualToString:title];
        [button setTitleColor:(selected ? [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0] : [UIColor colorWithWhite:0.55 alpha:1.0]) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:(selected ? UIFontWeightSemibold : UIFontWeightRegular)];
    }
}

- (NSArray<NSDictionary<NSString *, id> *> *)carouselItems {
    UIColor *forest = [UIColor colorWithRed:0.12 green:0.35 blue:0.24 alpha:1.0];
    UIColor *mist = [UIColor colorWithRed:0.56 green:0.72 blue:0.62 alpha:1.0];
    UIColor *blue = [UIColor colorWithRed:0.16 green:0.38 blue:0.76 alpha:1.0];
    UIColor *violet = [UIColor colorWithRed:0.50 green:0.32 blue:0.78 alpha:1.0];
    UIColor *orange = [UIColor colorWithRed:0.90 green:0.48 blue:0.20 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:0.72 green:0.18 blue:0.24 alpha:1.0];
    return @[
        @{@"title": @"鸣潮", @"subtitle": @"第33集 重逢异星族人", @"episode": @"国创热播", @"colors": @[forest, mist]},
        @{@"title": @"凡人修仙传", @"subtitle": @"新章开启，热血归来", @"episode": @"会员抢先看", @"colors": @[blue, forest]},
        @{@"title": @"时光代理人", @"subtitle": @"记忆与真相交织", @"episode": @"独家放送", @"colors": @[violet, blue]},
        @{@"title": @"小魔头暴露啦", @"subtitle": @"今天也要认真冒险", @"episode": @"轻喜剧新番", @"colors": @[orange, red]},
        @{@"title": @"银魂", @"subtitle": @"经典篇章继续回顾", @"episode": @"全200话", @"colors": @[red, violet]},
        @{@"title": @"灵笼", @"subtitle": @"废土世界再度集结", @"episode": @"高能国创", @"colors": @[forest, blue]},
        @{@"title": @"雾山五行", @"subtitle": @"东方幻想战斗美学", @"episode": @"燃系推荐", @"colors": @[orange, forest]},
        @{@"title": @"罗小黑战记", @"subtitle": @"温柔世界里的相遇", @"episode": @"治愈榜单", @"colors": @[blue, mist]},
        @{@"title": @"一人之下", @"subtitle": @"异人江湖风云再起", @"episode": @"战斗榜热播", @"colors": @[violet, red]},
        @{@"title": @"元气食堂", @"subtitle": @"打开美食世界的一天", @"episode": @"萌系精选", @"colors": @[orange, mist]}
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)rankingItems {
    return @[
        [self item:@"假面骑士ZZZ" subtitle:@"令和假面骑士第七作" badge:@"会员" colors:@[[UIColor colorWithRed:0.92 green:0.20 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.12 green:0.16 blue:0.18 alpha:1.0]]],
        [self item:@"名侦探柯南" subtitle:@"真相永远只有一个" badge:@"会员" colors:@[[UIColor colorWithRed:0.25 green:0.52 blue:0.88 alpha:1.0], [UIColor colorWithRed:0.96 green:0.70 blue:0.18 alpha:1.0]]],
        [self item:@"小马国女孩" subtitle:@"彩虹小组合集" badge:@"会员" colors:@[[UIColor colorWithRed:0.74 green:0.30 blue:0.86 alpha:1.0], [UIColor colorWithRed:0.22 green:0.68 blue:0.92 alpha:1.0]]],
        [self item:@"小魔头暴露啦" subtitle:@"轻松下饭新番" badge:@"" colors:@[[UIColor colorWithRed:0.95 green:0.46 blue:0.26 alpha:1.0], [UIColor colorWithRed:0.98 green:0.78 blue:0.28 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)continueItems {
    return @[
        [self item:@"EVA 新世纪福音战士" subtitle:@"看到第2话 99%" badge:@"" colors:@[[UIColor blackColor], [UIColor colorWithWhite:0.22 alpha:1.0]]],
        [self item:@"游戏王 怪兽之决斗" subtitle:@"看到第21话 12%" badge:@"" colors:@[[UIColor colorWithRed:0.78 green:0.10 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.12 green:0.22 blue:0.58 alpha:1.0]]],
        [self item:@"OVERLORD" subtitle:@"看到第1话" badge:@"" colors:@[[UIColor colorWithRed:0.22 green:0.25 blue:0.45 alpha:1.0], [UIColor colorWithRed:0.64 green:0.72 blue:0.82 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)moeItems {
    return @[
        [self item:@"小魔国漫大百科" subtitle:@"你的粮食科普大师" badge:@"" colors:@[[UIColor colorWithRed:0.97 green:0.76 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.95 green:0.47 blue:0.30 alpha:1.0]]],
        [self item:@"王者？别闹！" subtitle:@"王者峡谷爆笑对战" badge:@"" colors:@[[UIColor colorWithRed:0.20 green:0.40 blue:0.72 alpha:1.0], [UIColor colorWithRed:0.72 green:0.28 blue:0.42 alpha:1.0]]],
        [self item:@"元气食堂" subtitle:@"打开美食世界的一天" badge:@"" colors:@[[UIColor colorWithRed:0.98 green:0.66 blue:0.38 alpha:1.0], [UIColor colorWithRed:0.96 green:0.82 blue:0.50 alpha:1.0]]],
        [self item:@"罗小黑战记" subtitle:@"有温度的奇幻旅程" badge:@"" colors:@[[UIColor colorWithRed:0.18 green:0.56 blue:0.44 alpha:1.0], [UIColor colorWithRed:0.28 green:0.74 blue:0.72 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)comedyItems {
    return @[
        [self item:@"非人哉 第三季" subtitle:@"神仙妖怪的现代生活" badge:@"出品" colors:@[[UIColor colorWithRed:0.34 green:0.68 blue:0.88 alpha:1.0], [UIColor colorWithRed:0.72 green:0.82 blue:0.96 alpha:1.0]]],
        [self item:@"蜡笔小新 第二季" subtitle:@"不想来一口吗？" badge:@"会员" colors:@[[UIColor colorWithRed:0.20 green:0.56 blue:0.92 alpha:1.0], [UIColor colorWithRed:0.86 green:0.56 blue:0.28 alpha:1.0]]],
        [self item:@"蜡笔小新 第一季" subtitle:@"童年的快乐记忆" badge:@"会员" colors:@[[UIColor colorWithRed:0.95 green:0.54 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.62 green:0.82 blue:0.92 alpha:1.0]]],
        [self item:@"银魂" subtitle:@"最会吐槽的江户日常" badge:@"" colors:@[[UIColor colorWithRed:0.20 green:0.24 blue:0.34 alpha:1.0], [UIColor colorWithRed:0.72 green:0.22 blue:0.38 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)expectedItems {
    return @[
        [self item:@"偷星九月天" subtitle:@"童年经典漫画动画化" badge:@"出品" colors:@[[UIColor colorWithRed:0.25 green:0.50 blue:0.90 alpha:1.0], [UIColor colorWithRed:0.92 green:0.42 blue:0.60 alpha:1.0]]],
        [self item:@"天宝伏妖录 第三季" subtitle:@"驱魔司集结" badge:@"出品" colors:@[[UIColor colorWithRed:0.22 green:0.44 blue:0.38 alpha:1.0], [UIColor colorWithRed:0.82 green:0.72 blue:0.52 alpha:1.0]]],
        [self item:@"璃心战纪" subtitle:@"自我机会仅剩一次" badge:@"出品" colors:@[[UIColor colorWithWhite:0.86 alpha:1.0], [UIColor colorWithRed:0.30 green:0.42 blue:0.54 alpha:1.0]]],
        [self item:@"夜行档案" subtitle:@"时间线重新启动" badge:@"" colors:@[[UIColor colorWithRed:0.18 green:0.20 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.52 green:0.34 blue:0.68 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)battleItems {
    return @[
        [self item:@"假面骑士ZZZ" subtitle:@"更新至37话" badge:@"会员" colors:@[[UIColor colorWithRed:0.92 green:0.20 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.10 green:0.12 blue:0.15 alpha:1.0]]],
        [self item:@"放开那个女巫" subtitle:@"全8话" badge:@"会员" colors:@[[UIColor colorWithRed:0.22 green:0.16 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.84 green:0.36 blue:0.18 alpha:1.0]]],
        [self item:@"银魂" subtitle:@"全200话" badge:@"" colors:@[[UIColor colorWithRed:0.24 green:0.28 blue:0.48 alpha:1.0], [UIColor colorWithRed:0.86 green:0.22 blue:0.30 alpha:1.0]]],
        [self item:@"盗墓笔记" subtitle:@"高能冒险继续" badge:@"" colors:@[[UIColor colorWithRed:0.16 green:0.28 blue:0.20 alpha:1.0], [UIColor colorWithRed:0.54 green:0.44 blue:0.24 alpha:1.0]]]
    ];
}

- (NSDictionary<NSString *, id> *)item:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors {
    return @{@"title": title, @"subtitle": subtitle, @"badge": badge, @"colors": colors};
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
