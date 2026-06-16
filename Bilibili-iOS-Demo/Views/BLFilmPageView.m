#import "BLFilmPageView.h"
#import "BLAnimeCarouselView.h"
#import "BLAnimePosterCardView.h"
#import "BLFilmProgressCardView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLFilmLargeCardView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation BLFilmLargeCardView

- (instancetype)initWithColors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        UIColor *startColor = colors.firstObject ?: [UIColor blackColor];
        UIColor *endColor = colors.lastObject ?: [UIColor darkGrayColor];
        self.backgroundColor = startColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

@end

@interface BLFilmPageView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSArray<UIButton *> *rankTabButtons;
@property (nonatomic, copy) NSString *selectedRankTab;
@end

@implementation BLFilmPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        [self buildView];
        [self selectRankTab:@"电影榜"];
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
    [carousel.heightAnchor constraintEqualToConstant:220.0].active = YES;

    [self.contentStack addArrangedSubview:[self actionChipSection]];
    [self.contentStack addArrangedSubview:[self watchingSection]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"正在热播" action:nil items:[self hotItems] largeCards:YES]];
    [self.contentStack addArrangedSubview:[self rankingSection]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"越看越懂 B站“下饭”好剧" action:@"查看更多" items:[self dramaItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"一起涨知识！动画同样很计划" action:nil items:[self knowledgeItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"爱奇艺美剧网聚乐园" action:nil items:[self varietyItems]]];
    [self.contentStack addArrangedSubview:[self posterSectionWithTitle:@"我不允许你错过这12部口碑炸裂的电视剧！" action:nil items:[self classicItems]]];
    [self.contentStack addArrangedSubview:[self likeSection]];

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

    for (NSString *title in @[@"找片看", @"片单", @"电影", @"电视剧", @"纪录片", @"综艺", @"短剧", @"我的追剧"]) {
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

- (UIView *)watchingSection {
    UIStackView *section = [self verticalSection];
    [section addArrangedSubview:[self sectionHeaderWithTitle:@"正在追" action:@"我的追剧"]];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [section addArrangedSubview:scrollView];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 10.0;
    [scrollView addSubview:stack];

    for (NSDictionary<NSString *, id> *item in [self watchingItems]) {
        BLFilmProgressCardView *card = [[BLFilmProgressCardView alloc] initWithTitle:item[@"title"] ?: @"" subtitle:item[@"subtitle"] ?: @"" progress:[item[@"progress"] doubleValue] colors:item[@"colors"] ?: @[]];
        [stack addArrangedSubview:card];
    }

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.heightAnchor constraintEqualToConstant:182.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:14.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-14.0],
        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.heightAnchor]
    ]];
    return section;
}

- (UIView *)rankingSection {
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
    for (NSString *title in @[@"电影榜", @"纪录片榜", @"电视剧榜", @"综艺榜", @"会员榜", @"短剧榜"]) {
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
    return [self posterSectionWithTitle:title action:action items:items largeCards:NO];
}

- (UIView *)posterSectionWithTitle:(NSString *)title action:(NSString *)action items:(NSArray<NSDictionary<NSString *, id> *> *)items largeCards:(BOOL)largeCards {
    UIStackView *section = [self verticalSection];
    [section addArrangedSubview:[self sectionHeaderWithTitle:title action:action]];
    [section addArrangedSubview:[self horizontalPosterListWithItems:items largeCards:largeCards]];
    return section;
}

- (UIScrollView *)horizontalPosterListWithItems:(NSArray<NSDictionary<NSString *, id> *> *)items {
    return [self horizontalPosterListWithItems:items largeCards:NO];
}

- (UIScrollView *)horizontalPosterListWithItems:(NSArray<NSDictionary<NSString *, id> *> *)items largeCards:(BOOL)largeCards {
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
        CGFloat cardWidth = largeCards ? 122.0 : 104.0;
        CGFloat coverHeight = largeCards ? 162.0 : 138.0;
        BLAnimePosterCardView *card = [[BLAnimePosterCardView alloc] initWithRank:[NSString stringWithFormat:@"%lu", (unsigned long)index] title:item[@"title"] ?: @"" subtitle:item[@"subtitle"] ?: @"" badge:item[@"badge"] ?: @"" colors:item[@"colors"] ?: @[] cardWidth:cardWidth coverHeight:coverHeight];
        [stack addArrangedSubview:card];
        index++;
    }

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.heightAnchor constraintEqualToConstant:(largeCards ? 208.0 : 182.0)],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:14.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-14.0],
        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.heightAnchor]
    ]];
    return scrollView;
}

- (UIView *)likeSection {
    UIStackView *section = [self verticalSection];
    [section addArrangedSubview:[self sectionHeaderWithTitle:@"猜你喜欢" action:nil]];
    [section addArrangedSubview:[self largeFilmCardWithTitle:@"飞驰人生3" subtitle:@"电影热映 · 赛车喜剧回归" colors:@[[UIColor colorWithRed:0.10 green:0.16 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.62 green:0.28 blue:0.18 alpha:1.0]]]];
    [section addArrangedSubview:[self largeFilmCardWithTitle:@"机智的医生生活 第二季" subtitle:@"情感群像 · 4K 重温医疗人生" colors:@[[UIColor colorWithRed:0.10 green:0.26 blue:0.34 alpha:1.0], [UIColor colorWithRed:0.28 green:0.56 blue:0.70 alpha:1.0]]]];
    [section addArrangedSubview:[self largeFilmCardWithTitle:@"坚如磐石" subtitle:@"犯罪悬疑 · 高能反转" colors:@[[UIColor colorWithRed:0.06 green:0.10 blue:0.14 alpha:1.0], [UIColor colorWithRed:0.28 green:0.32 blue:0.44 alpha:1.0]]]];
    [section addArrangedSubview:[self largeFilmCardWithTitle:@"流浪地球3" subtitle:@"科幻大片 · 末日危机再启" colors:@[[UIColor colorWithRed:0.08 green:0.14 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.34 green:0.50 blue:0.72 alpha:1.0]]]];
    return section;
}

- (UIView *)largeFilmCardWithTitle:(NSString *)title subtitle:(NSString *)subtitle colors:(NSArray<UIColor *> *)colors {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;

    BLFilmLargeCardView *card = [[BLFilmLargeCardView alloc] initWithColors:colors];
    [container addSubview:card];

    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:156.0],
        [card.topAnchor constraintEqualToAnchor:container.topAnchor],
        [card.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:14.0],
        [card.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-14.0],
        [card.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];

    card.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
    [card addSubview:titleLabel];

    UILabel *subtitleLabel = [self labelWithText:subtitle font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[[UIColor whiteColor] colorWithAlphaComponent:0.82]];
    [card addSubview:subtitleLabel];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"追剧" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    button.layer.cornerRadius = 14.0;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.65].CGColor;
    [card addSubview:button];

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [titleLabel.bottomAnchor constraintEqualToAnchor:subtitleLabel.topAnchor constant:-7.0],
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [subtitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:button.leadingAnchor constant:-12.0],
        [subtitleLabel.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18.0],
        [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [button.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-16.0],
        [button.widthAnchor constraintEqualToConstant:64.0],
        [button.heightAnchor constraintEqualToConstant:28.0]
    ]];

    return container;
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

- (UIView *)sectionHeaderWithTitle:(NSString *)title action:(nullable NSString *)action {
    UIView *header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *titleLabel = [self labelWithText:title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold] color:[UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1.0]];
    [header addSubview:titleLabel];

    UILabel *actionLabel = [self labelWithText:(action.length > 0 ? [NSString stringWithFormat:@"%@ >", action] : @"") font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
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
    UIColor *pink = [UIColor colorWithRed:0.96 green:0.44 blue:0.60 alpha:1.0];
    UIColor *cream = [UIColor colorWithRed:0.98 green:0.72 blue:0.58 alpha:1.0];
    UIColor *blue = [UIColor colorWithRed:0.16 green:0.36 blue:0.62 alpha:1.0];
    UIColor *gold = [UIColor colorWithRed:0.82 green:0.56 blue:0.18 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0.18 green:0.46 blue:0.36 alpha:1.0];
    return @[
        @{@"title": @"奔跑吧周年", @"subtitle": @"假期放松就看综艺大片", @"episode": @"会员专享", @"colors": @[pink, cream]},
        @{@"title": @"太行山上", @"subtitle": @"热血战争大片限时热播", @"episode": @"更新至10集", @"colors": @[blue, gold]},
        @{@"title": @"末日逃生2", @"subtitle": @"巨幕灾难电影高能上线", @"episode": @"电影热映", @"colors": @[[UIColor colorWithRed:0.20 green:0.22 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.66 green:0.22 blue:0.18 alpha:1.0]]},
        @{@"title": @"寻味中国", @"subtitle": @"纪录片带你看见烟火人间", @"episode": @"纪录片精选", @"colors": @[green, gold]},
        @{@"title": @"法医笔记", @"subtitle": @"悬疑短剧一口气看完", @"episode": @"短剧上新", @"colors": @[blue, green]}
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)watchingItems {
    return @[
        @{@"title": @"蝙蝠侠：黑暗骑士", @"subtitle": @"看到第2分钟", @"progress": @0.16, @"colors": @[[UIColor colorWithRed:0.08 green:0.12 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.22 green:0.30 blue:0.42 alpha:1.0]]},
        @{@"title": @"正义联盟：扎导版", @"subtitle": @"看到第15分钟", @"progress": @0.34, @"colors": @[[UIColor colorWithRed:0.12 green:0.14 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.54 green:0.54 blue:0.56 alpha:1.0]]},
        @{@"title": @"月光骑士", @"subtitle": @"看到第6集", @"progress": @0.78, @"colors": @[[UIColor colorWithRed:0.10 green:0.12 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.54 green:0.48 blue:0.38 alpha:1.0]]},
        @{@"title": @"柯南剧场版", @"subtitle": @"看到第42分钟", @"progress": @0.52, @"colors": @[[UIColor colorWithRed:0.18 green:0.34 blue:0.60 alpha:1.0], [UIColor colorWithRed:0.72 green:0.32 blue:0.26 alpha:1.0]]},
        @{@"title": @"机智的医生生活", @"subtitle": @"看到第4集", @"progress": @0.44, @"colors": @[[UIColor colorWithRed:0.10 green:0.26 blue:0.34 alpha:1.0], [UIColor colorWithRed:0.28 green:0.56 blue:0.70 alpha:1.0]]}
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)hotItems {
    return @[
        [self item:@"末日逃生2：狂怒" subtitle:@"末日题材爽片" badge:@"会员" colors:@[[UIColor colorWithRed:0.24 green:0.28 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.72 green:0.28 blue:0.20 alpha:1.0]]],
        [self item:@"太行山上" subtitle:@"大战役真实改编" badge:@"会员" colors:@[[UIColor colorWithRed:0.32 green:0.24 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.78 green:0.60 blue:0.32 alpha:1.0]]],
        [self item:@"百年情书" subtitle:@"经典影片回顾" badge:@"" colors:@[[UIColor colorWithRed:0.18 green:0.16 blue:0.20 alpha:1.0], [UIColor colorWithRed:0.58 green:0.24 blue:0.38 alpha:1.0]]],
        [self item:@"飞驰人生3" subtitle:@"赛车喜剧回归" badge:@"" colors:@[[UIColor colorWithRed:0.10 green:0.20 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.86 green:0.38 blue:0.20 alpha:1.0]]],
        [self item:@"深海行动" subtitle:@"高能动作大片" badge:@"会员" colors:@[[UIColor colorWithRed:0.08 green:0.16 blue:0.28 alpha:1.0], [UIColor colorWithRed:0.20 green:0.56 blue:0.74 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)rankingItems {
    return @[
        [self item:@"熊出没·年货" subtitle:@"欢乐春节合家欢" badge:@"" colors:@[[UIColor colorWithRed:0.96 green:0.62 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.88 green:0.22 blue:0.18 alpha:1.0]]],
        [self item:@"飞驰人生3" subtitle:@"赛车喜剧回归" badge:@"" colors:@[[UIColor colorWithRed:0.10 green:0.20 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.86 green:0.38 blue:0.20 alpha:1.0]]],
        [self item:@"神奇动物：邓布利多" subtitle:@"魔法世界冒险" badge:@"" colors:@[[UIColor colorWithRed:0.18 green:0.20 blue:0.28 alpha:1.0], [UIColor colorWithRed:0.82 green:0.44 blue:0.12 alpha:1.0]]],
        [self item:@"热辣滚烫" subtitle:@"口碑喜剧片" badge:@"会员" colors:@[[UIColor colorWithRed:0.90 green:0.38 blue:0.42 alpha:1.0], [UIColor colorWithRed:0.98 green:0.72 blue:0.40 alpha:1.0]]],
        [self item:@"孤注一掷" subtitle:@"现实题材热播" badge:@"" colors:@[[UIColor colorWithRed:0.16 green:0.20 blue:0.26 alpha:1.0], [UIColor colorWithRed:0.72 green:0.42 blue:0.18 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)dramaItems {
    return @[
        [self item:@"孤独的美食家" subtitle:@"温暖下饭日剧" badge:@"" colors:@[[UIColor colorWithRed:0.62 green:0.42 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.18 green:0.12 blue:0.10 alpha:1.0]]],
        [self item:@"深夜食堂" subtitle:@"城市里的暖心故事" badge:@"" colors:@[[UIColor colorWithRed:0.18 green:0.18 blue:0.20 alpha:1.0], [UIColor colorWithRed:0.52 green:0.34 blue:0.20 alpha:1.0]]],
        [self item:@"一起露营吧" subtitle:@"综艺轻松看" badge:@"" colors:@[[UIColor colorWithRed:0.16 green:0.46 blue:0.38 alpha:1.0], [UIColor colorWithRed:0.86 green:0.62 blue:0.28 alpha:1.0]]],
        [self item:@"昨日的美食" subtitle:@"治愈系下饭剧" badge:@"" colors:@[[UIColor colorWithRed:0.50 green:0.30 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.84 green:0.62 blue:0.38 alpha:1.0]]],
        [self item:@"请回答1988" subtitle:@"温情家庭群像" badge:@"" colors:@[[UIColor colorWithRed:0.36 green:0.28 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.78 green:0.44 blue:0.30 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)knowledgeItems {
    return @[
        [self item:@"再建的青春" subtitle:@"热血校园成长" badge:@"" colors:@[[UIColor colorWithRed:0.22 green:0.40 blue:0.72 alpha:1.0], [UIColor colorWithRed:0.88 green:0.32 blue:0.32 alpha:1.0]]],
        [self item:@"奔跑吧兄弟" subtitle:@"国民综艺合集" badge:@"" colors:@[[UIColor colorWithRed:0.24 green:0.56 blue:0.86 alpha:1.0], [UIColor colorWithRed:0.96 green:0.68 blue:0.22 alpha:1.0]]],
        [self item:@"WWE 世界摔角" subtitle:@"热血竞技现场" badge:@"" colors:@[[UIColor colorWithRed:0.16 green:0.18 blue:0.26 alpha:1.0], [UIColor colorWithRed:0.62 green:0.18 blue:0.22 alpha:1.0]]],
        [self item:@"宇宙探索编辑部" subtitle:@"科幻伪纪录片" badge:@"" colors:@[[UIColor colorWithRed:0.18 green:0.24 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.56 green:0.48 blue:0.30 alpha:1.0]]],
        [self item:@"河西走廊" subtitle:@"历史纪录片精选" badge:@"" colors:@[[UIColor colorWithRed:0.44 green:0.28 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.84 green:0.62 blue:0.30 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)varietyItems {
    return @[
        [self item:@"奔跑吧 第2季" subtitle:@"奔跑团名场面" badge:@"会员" colors:@[[UIColor colorWithRed:0.72 green:0.18 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.20 green:0.42 blue:0.76 alpha:1.0]]],
        [self item:@"王派对王派" subtitle:@"王牌综艺合集" badge:@"" colors:@[[UIColor colorWithRed:0.22 green:0.34 blue:0.64 alpha:1.0], [UIColor colorWithRed:0.88 green:0.52 blue:0.26 alpha:1.0]]],
        [self item:@"奔跑吧兄弟 第六季" subtitle:@"会员完整版" badge:@"会员" colors:@[[UIColor colorWithRed:0.95 green:0.48 blue:0.20 alpha:1.0], [UIColor colorWithRed:0.28 green:0.56 blue:0.86 alpha:1.0]]],
        [self item:@"极限挑战" subtitle:@"爆笑户外挑战" badge:@"" colors:@[[UIColor colorWithRed:0.88 green:0.34 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.26 green:0.36 blue:0.68 alpha:1.0]]],
        [self item:@"明星大侦探" subtitle:@"推理综艺高能局" badge:@"会员" colors:@[[UIColor colorWithRed:0.22 green:0.16 blue:0.30 alpha:1.0], [UIColor colorWithRed:0.64 green:0.28 blue:0.62 alpha:1.0]]]
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)classicItems {
    return @[
        [self item:@"三国演义" subtitle:@"经典四大名著" badge:@"" colors:@[[UIColor colorWithRed:0.34 green:0.22 blue:0.16 alpha:1.0], [UIColor colorWithRed:0.72 green:0.36 blue:0.18 alpha:1.0]]],
        [self item:@"西游记" subtitle:@"童年经典回顾" badge:@"" colors:@[[UIColor colorWithRed:0.20 green:0.44 blue:0.34 alpha:1.0], [UIColor colorWithRed:0.88 green:0.66 blue:0.28 alpha:1.0]]],
        [self item:@"雍正王朝" subtitle:@"历史正剧典藏" badge:@"" colors:@[[UIColor colorWithRed:0.26 green:0.14 blue:0.10 alpha:1.0], [UIColor colorWithRed:0.82 green:0.54 blue:0.22 alpha:1.0]]],
        [self item:@"红楼梦" subtitle:@"古典名著剧集" badge:@"" colors:@[[UIColor colorWithRed:0.50 green:0.18 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.86 green:0.56 blue:0.54 alpha:1.0]]],
        [self item:@"大明王朝1566" subtitle:@"高分历史剧" badge:@"" colors:@[[UIColor colorWithRed:0.24 green:0.18 blue:0.12 alpha:1.0], [UIColor colorWithRed:0.66 green:0.46 blue:0.24 alpha:1.0]]]
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
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end
