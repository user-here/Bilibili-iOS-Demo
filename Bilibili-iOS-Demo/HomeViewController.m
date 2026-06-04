#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLText(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

@interface BLVideoItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *danmaku;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, strong) NSArray<UIColor *> *colors;
+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views danmaku:(NSString *)danmaku duration:(NSString *)duration badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors;
@end

@implementation BLVideoItem

+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views danmaku:(NSString *)danmaku duration:(NSString *)duration badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors {
    BLVideoItem *item = [[BLVideoItem alloc] init];
    item.title = title;
    item.author = author;
    item.views = views;
    item.danmaku = danmaku;
    item.duration = duration;
    item.badge = badge;
    item.colors = colors;
    return item;
}

@end

@interface BLGradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.colors = cgColors;
    layer.startPoint = CGPointMake(0.0, 0.0);
    layer.endPoint = CGPointMake(1.0, 1.0);
}

@end

@interface HomeViewController ()
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIScrollView *feedScrollView;
@property (nonatomic, strong) UIStackView *feedStackView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) NSArray<BLVideoItem *> *items;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildData];
    [self buildTopBar];
    [self buildFeed];
    [self buildBottomBar];
}

- (void)buildData {
    UIColor *blue = [UIColor colorWithRed:0.11 green:0.28 blue:0.78 alpha:1.0];
    UIColor *cyan = [UIColor colorWithRed:0.18 green:0.76 blue:0.95 alpha:1.0];
    UIColor *rose = [UIColor colorWithRed:0.96 green:0.45 blue:0.64 alpha:1.0];
    UIColor *purple = [UIColor colorWithRed:0.46 green:0.34 blue:0.86 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0.18 green:0.64 blue:0.46 alpha:1.0];
    UIColor *gold = [UIColor colorWithRed:0.98 green:0.73 blue:0.24 alpha:1.0];
    UIColor *ink = [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1.0];

    self.items = @[
        [BLVideoItem itemWithTitle:@"如果绯雪在茶里添加热熔糖果，然后再拿去给洛瑟拉喝，那么一切又会怎样发展..." author:@"B站动画放映室" views:@"81.5万" danmaku:@"2083" duration:@"4:18" badge:@"动画混剪" colors:@[rose, purple]],
        [BLVideoItem itemWithTitle:@"3分钟codex桌面版接入DeepSeek，无需账号配置" author:@"唐师兄Terence" views:@"1479" danmaku:@"-" duration:@"2:36" badge:@"DeepSeek" colors:@[blue, cyan]],
        [BLVideoItem itemWithTitle:@"爱弥斯：“来亲亲我，亲一口学习一个小时！”" author:@"宪云王大可" views:@"4.3万" danmaku:@"119" duration:@"1:09" badge:@"新番" colors:@[ink, rose]],
        [BLVideoItem itemWithTitle:@"这段动作戏的镜头调度太爽了，反复看三遍" author:@"番剧剪辑社" views:@"12.7万" danmaku:@"402" duration:@"3:44" badge:@"高燃" colors:@[ink, green]],
        [BLVideoItem itemWithTitle:@"今天的蛋糕被谁偷吃了？现场只留下一个表情包" author:@"游戏观察员" views:@"26.8万" danmaku:@"285" duration:@"1:29" badge:@"日常" colors:@[gold, rose]],
        [BLVideoItem itemWithTitle:@"毕业歌会现场回顾：那些熟悉旋律再次响起" author:@"音乐现场" views:@"58.1万" danmaku:@"912" duration:@"5:20" badge:@"毕业歌会" colors:@[cyan, purple]]
    ];
}

- (void)buildTopBar {
    self.topBar = [[UIView alloc] init];
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBar];

    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.backgroundColor = [UIColor colorWithRed:0.87 green:0.92 blue:0.95 alpha:1.0];
    avatar.layer.cornerRadius = 22.0;
    avatar.layer.masksToBounds = YES;
    [self.topBar addSubview:avatar];

    UILabel *avatarText = [self labelWithText:@"UP" font:[UIFont boldSystemFontOfSize:13.0] color:BLText()];
    avatarText.textAlignment = NSTextAlignmentCenter;
    [avatar addSubview:avatarText];
    avatarText.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *searchBox = [[UIView alloc] init];
    searchBox.translatesAutoresizingMaskIntoConstraints = NO;
    searchBox.backgroundColor = [UIColor whiteColor];
    searchBox.layer.cornerRadius = 22.0;
    searchBox.layer.borderWidth = 1.5;
    searchBox.layer.borderColor = [UIColor colorWithWhite:0.62 alpha:1.0].CGColor;
    [self.topBar addSubview:searchBox];

    UIImageView *searchIcon = [self imageViewWithSystemName:@"magnifyingglass" pointSize:22.0 color:[UIColor colorWithWhite:0.25 alpha:1.0]];
    [searchBox addSubview:searchIcon];

    UILabel *searchText = [self labelWithText:@"deepseek限制次数" font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.42 alpha:1.0]];
    [searchBox addSubview:searchText];

    UIButton *gameButton = [self topIconButton:@"gamecontroller"];
    UIButton *messageButton = [self topIconButton:@"envelope"];
    [self.topBar addSubview:gameButton];
    [self.topBar addSubview:messageButton];

    UIScrollView *categoryScroll = [[UIScrollView alloc] init];
    categoryScroll.translatesAutoresizingMaskIntoConstraints = NO;
    categoryScroll.showsHorizontalScrollIndicator = NO;
    [self.topBar addSubview:categoryScroll];

    UIStackView *categoryStack = [[UIStackView alloc] init];
    categoryStack.translatesAutoresizingMaskIntoConstraints = NO;
    categoryStack.axis = UILayoutConstraintAxisHorizontal;
    categoryStack.spacing = 28.0;
    categoryStack.alignment = UIStackViewAlignmentCenter;
    [categoryScroll addSubview:categoryStack];

    NSArray<NSString *> *tabs = @[@"直播", @"推荐", @"热门", @"动画", @"影视", @"毕业歌会", @"新征程"];
    for (NSString *tab in tabs) {
        [categoryStack addArrangedSubview:[self categoryViewWithTitle:tab selected:[tab isEqualToString:@"推荐"]]];
    }

    UIButton *menuButton = [self topIconButton:@"line.3.horizontal"];
    [self.topBar addSubview:menuButton];

    UIView *separator = [[UIView alloc] init];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.topBar addSubview:separator];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.topBar.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [self.topBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.topBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.topBar.heightAnchor constraintEqualToConstant:122.0],

        [avatar.leadingAnchor constraintEqualToAnchor:self.topBar.leadingAnchor constant:16.0],
        [avatar.topAnchor constraintEqualToAnchor:self.topBar.topAnchor constant:14.0],
        [avatar.widthAnchor constraintEqualToConstant:44.0],
        [avatar.heightAnchor constraintEqualToConstant:44.0],
        [avatarText.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [avatarText.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],

        [searchBox.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:14.0],
        [searchBox.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [searchBox.heightAnchor constraintEqualToConstant:44.0],
        [searchBox.trailingAnchor constraintEqualToAnchor:gameButton.leadingAnchor constant:-14.0],

        [searchIcon.leadingAnchor constraintEqualToAnchor:searchBox.leadingAnchor constant:18.0],
        [searchIcon.centerYAnchor constraintEqualToAnchor:searchBox.centerYAnchor],
        [searchIcon.widthAnchor constraintEqualToConstant:22.0],
        [searchIcon.heightAnchor constraintEqualToConstant:22.0],
        [searchText.leadingAnchor constraintEqualToAnchor:searchIcon.trailingAnchor constant:12.0],
        [searchText.centerYAnchor constraintEqualToAnchor:searchBox.centerYAnchor],
        [searchText.trailingAnchor constraintLessThanOrEqualToAnchor:searchBox.trailingAnchor constant:-16.0],

        [messageButton.trailingAnchor constraintEqualToAnchor:self.topBar.trailingAnchor constant:-16.0],
        [messageButton.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [messageButton.widthAnchor constraintEqualToConstant:36.0],
        [messageButton.heightAnchor constraintEqualToConstant:36.0],
        [gameButton.trailingAnchor constraintEqualToAnchor:messageButton.leadingAnchor constant:-18.0],
        [gameButton.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [gameButton.widthAnchor constraintEqualToConstant:36.0],
        [gameButton.heightAnchor constraintEqualToConstant:36.0],

        [categoryScroll.leadingAnchor constraintEqualToAnchor:self.topBar.leadingAnchor constant:14.0],
        [categoryScroll.trailingAnchor constraintEqualToAnchor:menuButton.leadingAnchor constant:-12.0],
        [categoryScroll.topAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:15.0],
        [categoryScroll.heightAnchor constraintEqualToConstant:44.0],
        [categoryStack.leadingAnchor constraintEqualToAnchor:categoryScroll.contentLayoutGuide.leadingAnchor],
        [categoryStack.trailingAnchor constraintEqualToAnchor:categoryScroll.contentLayoutGuide.trailingAnchor],
        [categoryStack.topAnchor constraintEqualToAnchor:categoryScroll.contentLayoutGuide.topAnchor],
        [categoryStack.bottomAnchor constraintEqualToAnchor:categoryScroll.contentLayoutGuide.bottomAnchor],
        [categoryStack.heightAnchor constraintEqualToAnchor:categoryScroll.frameLayoutGuide.heightAnchor],

        [menuButton.trailingAnchor constraintEqualToAnchor:self.topBar.trailingAnchor constant:-16.0],
        [menuButton.centerYAnchor constraintEqualToAnchor:categoryScroll.centerYAnchor],
        [menuButton.widthAnchor constraintEqualToConstant:34.0],
        [menuButton.heightAnchor constraintEqualToConstant:34.0],

        [separator.leadingAnchor constraintEqualToAnchor:self.topBar.leadingAnchor],
        [separator.trailingAnchor constraintEqualToAnchor:self.topBar.trailingAnchor],
        [separator.bottomAnchor constraintEqualToAnchor:self.topBar.bottomAnchor],
        [separator.heightAnchor constraintEqualToConstant:1.0]
    ]];
}

- (void)buildFeed {
    self.feedScrollView = [[UIScrollView alloc] init];
    self.feedScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.feedScrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.feedScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.feedScrollView];

    self.feedStackView = [[UIStackView alloc] init];
    self.feedStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.feedStackView.axis = UILayoutConstraintAxisVertical;
    self.feedStackView.spacing = 8.0;
    [self.feedScrollView addSubview:self.feedStackView];

    [self.feedStackView addArrangedSubview:[self featuredCardWithItem:self.items.firstObject]];

    for (NSUInteger index = 1; index < self.items.count; index += 2) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 6.0;
        row.distribution = UIStackViewDistributionFillEqually;
        [self.feedStackView addArrangedSubview:row];

        [row addArrangedSubview:[self compactCardWithItem:self.items[index]]];
        if (index + 1 < self.items.count) {
            [row addArrangedSubview:[self compactCardWithItem:self.items[index + 1]]];
        } else {
            UIView *spacer = [[UIView alloc] init];
            [row addArrangedSubview:spacer];
        }
    }
}

- (void)buildBottomBar {
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomBar];

    UIStackView *tabs = [[UIStackView alloc] init];
    tabs.translatesAutoresizingMaskIntoConstraints = NO;
    tabs.axis = UILayoutConstraintAxisHorizontal;
    tabs.distribution = UIStackViewDistributionFillEqually;
    tabs.alignment = UIStackViewAlignmentCenter;
    [self.bottomBar addSubview:tabs];

    [tabs addArrangedSubview:[self bottomTabWithTitle:@"首页" symbol:@"house" selected:YES badge:nil]];
    [tabs addArrangedSubview:[self bottomTabWithTitle:@"关注" symbol:@"person.2" selected:NO badge:@"42"]];
    [tabs addArrangedSubview:[self uploadTab]];
    [tabs addArrangedSubview:[self bottomTabWithTitle:@"会员购" symbol:@"bag" selected:NO badge:nil]];
    [tabs addArrangedSubview:[self bottomTabWithTitle:@"我的" symbol:@"tv" selected:NO badge:nil]];

    UIView *homeIndicator = [[UIView alloc] init];
    homeIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    homeIndicator.backgroundColor = [UIColor colorWithWhite:0.52 alpha:1.0];
    homeIndicator.layer.cornerRadius = 2.0;
    [self.bottomBar addSubview:homeIndicator];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.bottomBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.bottomBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.bottomBar.topAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-76.0],

        [self.feedScrollView.topAnchor constraintEqualToAnchor:self.topBar.bottomAnchor],
        [self.feedScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.feedScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.feedScrollView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor],

        [self.feedStackView.topAnchor constraintEqualToAnchor:self.feedScrollView.contentLayoutGuide.topAnchor constant:8.0],
        [self.feedStackView.leadingAnchor constraintEqualToAnchor:self.feedScrollView.contentLayoutGuide.leadingAnchor constant:6.0],
        [self.feedStackView.trailingAnchor constraintEqualToAnchor:self.feedScrollView.contentLayoutGuide.trailingAnchor constant:-6.0],
        [self.feedStackView.bottomAnchor constraintEqualToAnchor:self.feedScrollView.contentLayoutGuide.bottomAnchor constant:-12.0],
        [self.feedStackView.widthAnchor constraintEqualToAnchor:self.feedScrollView.frameLayoutGuide.widthAnchor constant:-12.0],

        [tabs.leadingAnchor constraintEqualToAnchor:self.bottomBar.leadingAnchor],
        [tabs.trailingAnchor constraintEqualToAnchor:self.bottomBar.trailingAnchor],
        [tabs.topAnchor constraintEqualToAnchor:self.bottomBar.topAnchor constant:6.0],
        [tabs.heightAnchor constraintEqualToConstant:62.0],

        [homeIndicator.centerXAnchor constraintEqualToAnchor:self.bottomBar.centerXAnchor],
        [homeIndicator.bottomAnchor constraintEqualToAnchor:self.bottomBar.bottomAnchor constant:-7.0],
        [homeIndicator.widthAnchor constraintEqualToConstant:138.0],
        [homeIndicator.heightAnchor constraintEqualToConstant:4.0]
    ]];
}

- (UIView *)featuredCardWithItem:(BLVideoItem *)item {
    UIView *card = [self cardContainer];
    BLGradientView *cover = [self coverViewWithItem:item compact:NO];
    [card addSubview:cover];

    UILabel *title = [self labelWithText:item.title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:BLText()];
    title.numberOfLines = 2;
    [card addSubview:title];

    UIImageView *likeIcon = [self imageViewWithSystemName:@"hand.thumbsup.fill" pointSize:28.0 color:[UIColor colorWithWhite:0.50 alpha:1.0]];
    [card addSubview:likeIcon];

    UILabel *likeCount = [self labelWithText:@"359" font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.50 alpha:1.0]];
    [card addSubview:likeCount];

    UIButton *more = [self moreButton];
    [card addSubview:more];

    [NSLayoutConstraint activateConstraints:@[
        [cover.topAnchor constraintEqualToAnchor:card.topAnchor],
        [cover.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [cover.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [cover.heightAnchor constraintEqualToAnchor:cover.widthAnchor multiplier:0.56],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14.0],
        [title.topAnchor constraintEqualToAnchor:cover.bottomAnchor constant:12.0],
        [title.trailingAnchor constraintEqualToAnchor:likeIcon.leadingAnchor constant:-16.0],
        [title.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18.0],
        [likeIcon.trailingAnchor constraintEqualToAnchor:likeCount.leadingAnchor constant:-4.0],
        [likeIcon.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [likeIcon.widthAnchor constraintEqualToConstant:30.0],
        [likeIcon.heightAnchor constraintEqualToConstant:30.0],
        [likeCount.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-18.0],
        [likeCount.centerYAnchor constraintEqualToAnchor:likeIcon.centerYAnchor],
        [more.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-8.0],
        [more.centerYAnchor constraintEqualToAnchor:likeIcon.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:28.0],
        [more.heightAnchor constraintEqualToConstant:38.0]
    ]];

    return card;
}

- (UIView *)compactCardWithItem:(BLVideoItem *)item {
    UIView *card = [self cardContainer];
    BLGradientView *cover = [self coverViewWithItem:item compact:YES];
    [card addSubview:cover];

    UILabel *title = [self labelWithText:item.title font:[UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular] color:BLText()];
    title.numberOfLines = 2;
    [card addSubview:title];

    UIImageView *upIcon = [self imageViewWithSystemName:@"person.crop.square" pointSize:16.0 color:[UIColor colorWithWhite:0.63 alpha:1.0]];
    [card addSubview:upIcon];

    UILabel *author = [self labelWithText:item.author font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    [card addSubview:author];

    UIButton *more = [self moreButton];
    [card addSubview:more];

    [NSLayoutConstraint activateConstraints:@[
        [cover.topAnchor constraintEqualToAnchor:card.topAnchor],
        [cover.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [cover.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [cover.heightAnchor constraintEqualToAnchor:cover.widthAnchor multiplier:0.68],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:10.0],
        [title.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-10.0],
        [title.topAnchor constraintEqualToAnchor:cover.bottomAnchor constant:10.0],
        [upIcon.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [upIcon.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:14.0],
        [upIcon.widthAnchor constraintEqualToConstant:18.0],
        [upIcon.heightAnchor constraintEqualToConstant:18.0],
        [author.leadingAnchor constraintEqualToAnchor:upIcon.trailingAnchor constant:6.0],
        [author.centerYAnchor constraintEqualToAnchor:upIcon.centerYAnchor],
        [author.trailingAnchor constraintLessThanOrEqualToAnchor:more.leadingAnchor constant:-6.0],
        [more.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-6.0],
        [more.centerYAnchor constraintEqualToAnchor:upIcon.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:24.0],
        [more.heightAnchor constraintEqualToConstant:32.0],
        [upIcon.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-12.0]
    ]];

    return card;
}

- (BLGradientView *)coverViewWithItem:(BLVideoItem *)item compact:(BOOL)compact {
    BLGradientView *cover = [[BLGradientView alloc] init];
    cover.translatesAutoresizingMaskIntoConstraints = NO;
    cover.colors = item.colors;
    cover.layer.cornerRadius = 4.0;
    cover.layer.masksToBounds = YES;

    UILabel *badge = [self labelWithText:item.badge font:[UIFont boldSystemFontOfSize:(compact ? 28.0 : 36.0)] color:[UIColor whiteColor]];
    badge.numberOfLines = 2;
    badge.textAlignment = NSTextAlignmentCenter;
    [cover addSubview:badge];

    UIStackView *metrics = [[UIStackView alloc] init];
    metrics.translatesAutoresizingMaskIntoConstraints = NO;
    metrics.axis = UILayoutConstraintAxisHorizontal;
    metrics.spacing = 10.0;
    metrics.alignment = UIStackViewAlignmentCenter;
    [metrics addArrangedSubview:[self metricViewWithIcon:@"play.rectangle" text:item.views]];
    [metrics addArrangedSubview:[self metricViewWithIcon:@"text.bubble" text:item.danmaku]];
    [cover addSubview:metrics];

    UILabel *duration = [self labelWithText:item.duration font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
    duration.textAlignment = NSTextAlignmentRight;
    [cover addSubview:duration];

    [NSLayoutConstraint activateConstraints:@[
        [badge.centerXAnchor constraintEqualToAnchor:cover.centerXAnchor],
        [badge.centerYAnchor constraintEqualToAnchor:cover.centerYAnchor],
        [badge.leadingAnchor constraintGreaterThanOrEqualToAnchor:cover.leadingAnchor constant:14.0],
        [badge.trailingAnchor constraintLessThanOrEqualToAnchor:cover.trailingAnchor constant:-14.0],
        [metrics.leadingAnchor constraintEqualToAnchor:cover.leadingAnchor constant:10.0],
        [metrics.bottomAnchor constraintEqualToAnchor:cover.bottomAnchor constant:-9.0],
        [duration.trailingAnchor constraintEqualToAnchor:cover.trailingAnchor constant:-10.0],
        [duration.centerYAnchor constraintEqualToAnchor:metrics.centerYAnchor],
        [metrics.trailingAnchor constraintLessThanOrEqualToAnchor:duration.leadingAnchor constant:-8.0]
    ]];

    return cover;
}

- (UIView *)metricViewWithIcon:(NSString *)icon text:(NSString *)text {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 4.0;
    stack.alignment = UIStackViewAlignmentCenter;

    UIImageView *image = [self imageViewWithSystemName:icon pointSize:14.0 color:[UIColor whiteColor]];
    [image.widthAnchor constraintEqualToConstant:16.0].active = YES;
    [image.heightAnchor constraintEqualToConstant:16.0].active = YES;
    [stack addArrangedSubview:image];

    UILabel *label = [self labelWithText:text font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
    [stack addArrangedSubview:label];

    return stack;
}

- (UIView *)cardContainer {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 4.0;
    card.layer.masksToBounds = YES;
    return card;
}

- (UIView *)categoryViewWithTitle:(NSString *)title selected:(BOOL)selected {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 5.0;

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:19.0 weight:(selected ? UIFontWeightSemibold : UIFontWeightRegular)] color:(selected ? BLPink() : [UIColor colorWithWhite:0.36 alpha:1.0])];
    [stack addArrangedSubview:label];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = selected ? BLPink() : [UIColor clearColor];
    line.layer.cornerRadius = 2.0;
    [stack addArrangedSubview:line];
    [NSLayoutConstraint activateConstraints:@[
        [line.widthAnchor constraintEqualToConstant:27.0],
        [line.heightAnchor constraintEqualToConstant:4.0]
    ]];

    return stack;
}

- (UIView *)bottomTabWithTitle:(NSString *)title symbol:(NSString *)symbol selected:(BOOL)selected badge:(NSString *)badge {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 3.0;
    [container addSubview:stack];

    UIColor *color = selected ? BLPink() : [UIColor colorWithWhite:0.35 alpha:1.0];
    UIImageView *icon = [self imageViewWithSystemName:symbol pointSize:28.0 color:color];
    [icon.widthAnchor constraintEqualToConstant:30.0].active = YES;
    [icon.heightAnchor constraintEqualToConstant:30.0].active = YES;
    [stack addArrangedSubview:icon];

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:color];
    [stack addArrangedSubview:label];

    if (badge.length > 0) {
        UILabel *badgeLabel = [self labelWithText:badge font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
        badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor colorWithRed:0.92 green:0.20 blue:0.23 alpha:1.0];
        badgeLabel.layer.cornerRadius = 10.0;
        badgeLabel.layer.masksToBounds = YES;
        [container addSubview:badgeLabel];
        [NSLayoutConstraint activateConstraints:@[
            [badgeLabel.centerXAnchor constraintEqualToAnchor:icon.trailingAnchor constant:3.0],
            [badgeLabel.centerYAnchor constraintEqualToAnchor:icon.topAnchor constant:3.0],
            [badgeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:22.0],
            [badgeLabel.heightAnchor constraintEqualToConstant:20.0]
        ]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [stack.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [stack.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [container.heightAnchor constraintEqualToConstant:62.0]
    ]];
    return container;
}

- (UIView *)uploadTab {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *button = [[UIView alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = BLPink();
    button.layer.cornerRadius = 24.0;
    [container addSubview:button];

    UIImageView *plus = [self imageViewWithSystemName:@"plus" pointSize:30.0 color:[UIColor whiteColor]];
    [button addSubview:plus];

    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:62.0],
        [button.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:64.0],
        [button.heightAnchor constraintEqualToConstant:56.0],
        [plus.centerXAnchor constraintEqualToAnchor:button.centerXAnchor],
        [plus.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [plus.widthAnchor constraintEqualToConstant:30.0],
        [plus.heightAnchor constraintEqualToConstant:30.0]
    ]];

    return container;
}

- (UIButton *)topIconButton:(NSString *)systemName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *image = [UIImage systemImageNamed:systemName];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = [UIColor colorWithWhite:0.30 alpha:1.0];
    return button;
}

- (UIButton *)moreButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"⋮" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:26.0 weight:UIFontWeightRegular];
    [button setTitleColor:[UIColor colorWithWhite:0.62 alpha:1.0] forState:UIControlStateNormal];
    return button;
}

- (UIImageView *)imageViewWithSystemName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImage *image = [[UIImage systemImageNamed:name] imageWithConfiguration:configuration];
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

@end
