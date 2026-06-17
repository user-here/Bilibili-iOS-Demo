#import "HomeViewController.h"
#import "Views/BLFeedbackPanelView.h"
#import "Views/BLAnimePageView.h"
#import "Views/BLFilmPageView.h"
#import "Views/BLHotPageView.h"
#import "Views/BLLivePageView.h"
#import "Views/BLVideoDetailViewController.h"
#import "Views/BLFollowingPageView.h"
#import "Views/BLMallPageView.h"
#import "Views/BLMinePageView.h"
#import "Views/BLVideoURLProvider.h"
#import "Models/BLVideoItem.h"
#import "DataSource/BLMockDataSource.h"
#import "Coordinators/BLAppCoordinator.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLText(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

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
@property (nonatomic, strong) BLLivePageView *livePageView;
@property (nonatomic, strong) BLHotPageView *hotPageView;
@property (nonatomic, strong) BLAnimePageView *animePageView;
@property (nonatomic, strong) BLFilmPageView *filmPageView;
@property (nonatomic, strong) BLFollowingPageView *followingPageView;
@property (nonatomic, strong) BLMallPageView *mallPageView;
@property (nonatomic, strong) BLMinePageView *minePageView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UILabel *followingBadgeLabel;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIImageView *> *bottomTabIcons;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UILabel *> *bottomTabLabels;
@property (nonatomic, copy) NSString *selectedBottomTab;
@property (nonatomic, strong) NSArray<BLVideoItem *> *items;
@property (nonatomic, strong) NSMutableArray<UILabel *> *categoryLabels;
@property (nonatomic, strong) NSMutableArray<UIView *> *categoryIndicators;
@property (nonatomic, copy) NSString *selectedCategory;
@property (nonatomic, assign) BOOL featuredLiked;
@property (nonatomic, assign) NSInteger featuredLikeCount;
@property (nonatomic, strong) UIButton *featuredLikeButton;
@property (nonatomic, strong) UILabel *featuredLikeCountLabel;
@property (nonatomic, strong) BLFeedbackPanelView *feedbackPanelView;
@property (nonatomic, strong) BLAppCoordinator *coordinator;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.featuredLikeCount = 359;
    self.selectedCategory = @"推荐";
    self.selectedBottomTab = @"house";
    [self buildData];
    [self buildTopBar];
    [self buildFeed];
    [self buildBottomBar];
    self.coordinator = [[BLAppCoordinator alloc] initWithRootView:self.view
                                                        bottomBar:self.bottomBar
                                           presentingViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.followingPageView != nil && !self.followingPageView.hidden) {
        [self.followingPageView activate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.followingPageView deactivate];
    [self.coordinator deactivateAllPages];
}

- (void)buildData {
    self.items = [[BLMockDataSource shared] recommendFeedItems];
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

    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [avatarButton addTarget:self action:@selector(showProfileSpacePage) forControlEvents:UIControlEventTouchUpInside];
    [avatar addSubview:avatarButton];

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

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [searchButton addTarget:self action:@selector(showSearchPage) forControlEvents:UIControlEventTouchUpInside];
    [searchBox addSubview:searchButton];

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

    self.categoryLabels = [NSMutableArray array];
    self.categoryIndicators = [NSMutableArray array];
    NSArray<NSString *> *tabs = @[@"直播", @"推荐", @"热门", @"动画", @"影视", @"毕业歌会", @"新征程"];
    for (NSString *tab in tabs) {
        [categoryStack addArrangedSubview:[self categoryViewWithTitle:tab selected:[tab isEqualToString:self.selectedCategory]]];
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
        [avatarButton.topAnchor constraintEqualToAnchor:avatar.topAnchor],
        [avatarButton.leadingAnchor constraintEqualToAnchor:avatar.leadingAnchor],
        [avatarButton.trailingAnchor constraintEqualToAnchor:avatar.trailingAnchor],
        [avatarButton.bottomAnchor constraintEqualToAnchor:avatar.bottomAnchor],

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
        [searchButton.topAnchor constraintEqualToAnchor:searchBox.topAnchor],
        [searchButton.leadingAnchor constraintEqualToAnchor:searchBox.leadingAnchor],
        [searchButton.trailingAnchor constraintEqualToAnchor:searchBox.trailingAnchor],
        [searchButton.bottomAnchor constraintEqualToAnchor:searchBox.bottomAnchor],

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

- (void)buildLivePageIfNeeded {
    if (self.livePageView != nil) {
        return;
    }
    self.livePageView = [[BLLivePageView alloc] init];
    self.livePageView.hidden = YES;
    [self.view addSubview:self.livePageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.livePageView.topAnchor constraintEqualToAnchor:self.topBar.bottomAnchor],
        [self.livePageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.livePageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.livePageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildHotPageIfNeeded {
    if (self.hotPageView != nil) {
        return;
    }
    self.hotPageView = [[BLHotPageView alloc] init];
    self.hotPageView.hidden = YES;
    [self.view addSubview:self.hotPageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.hotPageView.topAnchor constraintEqualToAnchor:self.topBar.bottomAnchor],
        [self.hotPageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.hotPageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.hotPageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildAnimePageIfNeeded {
    if (self.animePageView != nil) {
        return;
    }
    self.animePageView = [[BLAnimePageView alloc] init];
    self.animePageView.hidden = YES;
    [self.view addSubview:self.animePageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.animePageView.topAnchor constraintEqualToAnchor:self.topBar.bottomAnchor],
        [self.animePageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.animePageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.animePageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildFilmPageIfNeeded {
    if (self.filmPageView != nil) {
        return;
    }
    self.filmPageView = [[BLFilmPageView alloc] init];
    self.filmPageView.hidden = YES;
    [self.view addSubview:self.filmPageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.filmPageView.topAnchor constraintEqualToAnchor:self.topBar.bottomAnchor],
        [self.filmPageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.filmPageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.filmPageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildFollowingPageIfNeeded {
    if (self.followingPageView != nil) {
        return;
    }
    self.followingPageView = [[BLFollowingPageView alloc] init];
    self.followingPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.followingPageView.videoSelected = ^(NSURL *URL, NSString *title, NSString *author) {
        [weakSelf.followingPageView deactivate];
        [weakSelf.coordinator openPlayerWithURL:URL title:title author:author];
    };
    [self.view addSubview:self.followingPageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.followingPageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.followingPageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.followingPageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.followingPageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildMallPageIfNeeded {
    if (self.mallPageView != nil) {
        return;
    }
    self.mallPageView = [[BLMallPageView alloc] init];
    self.mallPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.mallPageView.searchTapped = ^{
        [weakSelf.coordinator showMallSearchPage];
    };
    self.mallPageView.couponTapped = ^{
        [weakSelf.coordinator showMallCouponPage];
    };
    [self.view addSubview:self.mallPageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.mallPageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.mallPageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.mallPageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.mallPageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildMinePageIfNeeded {
    if (self.minePageView != nil) {
        return;
    }
    self.minePageView = [[BLMinePageView alloc] init];
    self.minePageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.minePageView.offlineCacheTapped = ^{
        [weakSelf.coordinator showOfflineCachePage];
    };
    self.minePageView.historyTapped = ^{
        [weakSelf.coordinator showHistoryPage];
    };
    self.minePageView.favoriteTapped = ^{
        [weakSelf.coordinator showFavoritePage];
    };
    self.minePageView.watchLaterTapped = ^{
        [weakSelf.coordinator showWatchLaterPage];
    };
    self.minePageView.profileTapped = ^{
        [weakSelf.coordinator showProfileSpacePage];
    };
    self.minePageView.memberCenterTapped = ^{
        [weakSelf.coordinator showMemberCenterPage];
    };
    self.minePageView.contactServiceTapped = ^{
        [weakSelf.coordinator showContactServicePage];
    };
    [self.view addSubview:self.minePageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.minePageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.minePageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.minePageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.minePageView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor]
    ]];
}

- (void)buildBottomBar {
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomBar];
    self.bottomTabIcons = [NSMutableDictionary dictionary];
    self.bottomTabLabels = [NSMutableDictionary dictionary];

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
    [self updateBottomTabSelection:self.selectedBottomTab];

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
    [self addOpenPlayerButtonToCard:card item:item];
    BLGradientView *cover = [self coverViewWithItem:item compact:NO];
    [card addSubview:cover];

    UILabel *title = [self labelWithText:item.title font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:BLText()];
    title.numberOfLines = 2;
    [card addSubview:title];

    UIStackView *likeStack = [[UIStackView alloc] init];
    likeStack.translatesAutoresizingMaskIntoConstraints = NO;
    likeStack.axis = UILayoutConstraintAxisHorizontal;
    likeStack.alignment = UIStackViewAlignmentCenter;
    likeStack.spacing = 4.0;
    [card addSubview:likeStack];

    self.featuredLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.featuredLikeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.featuredLikeButton.adjustsImageWhenHighlighted = NO;
    self.featuredLikeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.featuredLikeButton addTarget:self action:@selector(featuredLikeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [likeStack addArrangedSubview:self.featuredLikeButton];

    self.featuredLikeCountLabel = [self labelWithText:[self formattedLikeCount] font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.50 alpha:1.0]];
    self.featuredLikeCountLabel.textAlignment = NSTextAlignmentLeft;
    [likeStack addArrangedSubview:self.featuredLikeCountLabel];
    [self updateFeaturedLikeAppearanceAnimated:NO];

    UIButton *more = [self moreButton];
    [card addSubview:more];

    [NSLayoutConstraint activateConstraints:@[
        [cover.topAnchor constraintEqualToAnchor:card.topAnchor],
        [cover.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [cover.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [cover.heightAnchor constraintEqualToAnchor:cover.widthAnchor multiplier:0.56],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14.0],
        [title.topAnchor constraintEqualToAnchor:cover.bottomAnchor constant:12.0],
        [title.trailingAnchor constraintEqualToAnchor:likeStack.leadingAnchor constant:-12.0],
        [title.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18.0],
        [likeStack.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-10.0],
        [likeStack.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [likeStack.widthAnchor constraintEqualToConstant:70.0],
        [self.featuredLikeButton.widthAnchor constraintEqualToConstant:30.0],
        [self.featuredLikeButton.heightAnchor constraintEqualToConstant:30.0],
        [self.featuredLikeCountLabel.widthAnchor constraintGreaterThanOrEqualToConstant:30.0],
        [more.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-8.0],
        [more.centerYAnchor constraintEqualToAnchor:likeStack.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:28.0],
        [more.heightAnchor constraintEqualToConstant:38.0]
    ]];

    return card;
}

- (void)featuredLikeTapped:(UIButton *)sender {
    self.featuredLiked = !self.featuredLiked;
    self.featuredLikeCount += self.featuredLiked ? 1 : -1;
    [self updateFeaturedLikeAppearanceAnimated:YES];
}

- (void)updateFeaturedLikeAppearanceAnimated:(BOOL)animated {
    UIColor *color = self.featuredLiked ? BLPink() : [UIColor colorWithWhite:0.44 alpha:1.0];
    UIImage *image = [self thumbsUpImageWithColor:color size:CGSizeMake(24.0, 24.0)];
    [self.featuredLikeButton setImage:image forState:UIControlStateNormal];
    self.featuredLikeCountLabel.text = [self formattedLikeCount];
    self.featuredLikeCountLabel.textColor = color;

    if (!animated) {
        return;
    }

    self.featuredLikeButton.transform = CGAffineTransformMakeScale(0.78, 0.78);
    self.featuredLikeCountLabel.transform = CGAffineTransformMakeTranslation(0.0, 4.0);
    self.featuredLikeCountLabel.alpha = 0.65;

    [UIView animateWithDuration:0.18 delay:0.0 usingSpringWithDamping:0.48 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.featuredLikeButton.transform = CGAffineTransformMakeScale(1.22, 1.22);
        self.featuredLikeCountLabel.transform = CGAffineTransformIdentity;
        self.featuredLikeCountLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^{
            self.featuredLikeButton.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (NSString *)formattedLikeCount {
    return [NSString stringWithFormat:@"%ld", (long)self.featuredLikeCount];
}

- (void)showFeedbackPanel {
    [self buildFeedbackPanelIfNeeded];
    self.feedbackPanelView.hidden = NO;
    self.feedbackPanelView.alpha = 0.0;
    [self.feedbackPanelView setPanelVerticalOffset:CGRectGetHeight(self.view.bounds) * 0.40];

    [UIView animateWithDuration:0.28 delay:0.0 usingSpringWithDamping:0.88 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.feedbackPanelView.alpha = 1.0;
        [self.feedbackPanelView setPanelVerticalOffset:0.0];
    } completion:nil];
}

- (void)dismissFeedbackPanel {
    if (self.feedbackPanelView.hidden) {
        return;
    }

    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.feedbackPanelView.alpha = 0.0;
        [self.feedbackPanelView setPanelVerticalOffset:CGRectGetHeight(self.view.bounds) * 0.40];
    } completion:^(BOOL finished) {
        self.feedbackPanelView.hidden = YES;
        [self.feedbackPanelView setPanelVerticalOffset:0.0];
    }];
}

- (void)buildFeedbackPanelIfNeeded {
    if (self.feedbackPanelView != nil) {
        return;
    }

    self.feedbackPanelView = [[BLFeedbackPanelView alloc] init];
    self.feedbackPanelView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.feedbackPanelView.dismissRequested = ^{
        [weakSelf dismissFeedbackPanel];
    };
    self.feedbackPanelView.optionSelected = ^(NSString *title) {
        [weakSelf dismissFeedbackPanel];
    };
    [self.view addSubview:self.feedbackPanelView];

    [NSLayoutConstraint activateConstraints:@[
        [self.feedbackPanelView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.feedbackPanelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.feedbackPanelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.feedbackPanelView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)showSearchPage {
    [self.coordinator showSearchPage];
}

- (void)showProfileSpacePage {
    [self.coordinator showProfileSpacePage];
}
- (UIView *)compactCardWithItem:(BLVideoItem *)item {
    UIView *card = [self cardContainer];
    [self addOpenPlayerButtonToCard:card item:item];
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
    cover.userInteractionEnabled = NO;
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

- (void)addOpenPlayerButtonToCard:(UIView *)card item:(BLVideoItem *)item {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.accessibilityLabel = item.title;
    button.accessibilityHint = item.author;
    [button addTarget:self action:@selector(openPlayerFromCard:) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.topAnchor constraintEqualToAnchor:card.topAnchor],
        [button.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [button.bottomAnchor constraintEqualToAnchor:card.bottomAnchor]
    ]];
}

- (void)openPlayerFromCard:(UIButton *)sender {
    NSURL *URL = [BLVideoURLProvider defaultVideoURL];
    if (URL == nil) {
        return;
    }
    NSString *title = sender.accessibilityLabel.length > 0 ? sender.accessibilityLabel : @"没什么比一位妈妈的力量更强大";
    NSString *author = sender.accessibilityHint.length > 0 ? sender.accessibilityHint : @"Youtube抢先看";
    [self openPlayerWithURL:URL title:title author:author];
}

- (void)openPlayerWithURL:(NSURL *)URL title:(NSString *)title author:(NSString *)author {
    BLVideoDetailViewController *detail = [[BLVideoDetailViewController alloc] initWithVideoURL:URL title:title author:author];
    [self presentViewController:detail animated:YES completion:nil];
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
    [self.categoryLabels addObject:label];
    [self.categoryIndicators addObject:line];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.accessibilityIdentifier = title;
    [button addTarget:self action:@selector(categoryTapped:) forControlEvents:UIControlEventTouchUpInside];
    [stack addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [line.widthAnchor constraintEqualToConstant:27.0],
        [line.heightAnchor constraintEqualToConstant:4.0],
        [button.topAnchor constraintEqualToAnchor:stack.topAnchor],
        [button.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [button.bottomAnchor constraintEqualToAnchor:stack.bottomAnchor]
    ]];

    return stack;
}

- (void)categoryTapped:(UIButton *)sender {
    NSString *category = sender.accessibilityIdentifier;
    if (category.length == 0 || [category isEqualToString:self.selectedCategory]) {
        return;
    }
    if (![category isEqualToString:@"直播"] && ![category isEqualToString:@"推荐"] && ![category isEqualToString:@"热门"] && ![category isEqualToString:@"动画"] && ![category isEqualToString:@"影视"]) {
        self.selectedCategory = category;
        [self updateCategorySelection];
        self.feedScrollView.hidden = NO;
        self.livePageView.hidden = YES;
        self.hotPageView.hidden = YES;
        self.animePageView.hidden = YES;
        self.filmPageView.hidden = YES;
        return;
    }
    self.selectedCategory = category;
    [self updateCategorySelection];
    [self showSelectedContent];
}

- (void)updateCategorySelection {
    for (NSUInteger index = 0; index < self.categoryLabels.count; index++) {
        UILabel *label = self.categoryLabels[index];
        UIView *indicator = self.categoryIndicators[index];
        BOOL selected = [label.text isEqualToString:self.selectedCategory];
        label.textColor = selected ? BLPink() : [UIColor colorWithWhite:0.36 alpha:1.0];
        label.font = [UIFont systemFontOfSize:19.0 weight:(selected ? UIFontWeightSemibold : UIFontWeightRegular)];
        indicator.backgroundColor = selected ? BLPink() : [UIColor clearColor];
    }
}

- (void)showSelectedContent {
    if ([self.selectedCategory isEqualToString:@"直播"]) {
        [self buildLivePageIfNeeded];
        self.feedScrollView.hidden = YES;
        self.livePageView.hidden = NO;
        self.hotPageView.hidden = YES;
        self.animePageView.hidden = YES;
        self.filmPageView.hidden = YES;
    } else if ([self.selectedCategory isEqualToString:@"热门"]) {
        [self buildHotPageIfNeeded];
        self.feedScrollView.hidden = YES;
        self.livePageView.hidden = YES;
        self.hotPageView.hidden = NO;
        self.animePageView.hidden = YES;
        self.filmPageView.hidden = YES;
    } else if ([self.selectedCategory isEqualToString:@"动画"]) {
        [self buildAnimePageIfNeeded];
        self.feedScrollView.hidden = YES;
        self.livePageView.hidden = YES;
        self.hotPageView.hidden = YES;
        self.animePageView.hidden = NO;
        self.filmPageView.hidden = YES;
    } else if ([self.selectedCategory isEqualToString:@"影视"]) {
        [self buildFilmPageIfNeeded];
        self.feedScrollView.hidden = YES;
        self.livePageView.hidden = YES;
        self.hotPageView.hidden = YES;
        self.animePageView.hidden = YES;
        self.filmPageView.hidden = NO;
    } else {
        self.feedScrollView.hidden = NO;
        self.livePageView.hidden = YES;
        self.hotPageView.hidden = YES;
        self.animePageView.hidden = YES;
        self.filmPageView.hidden = YES;
    }
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
    self.bottomTabIcons[symbol] = icon;

    UILabel *label = [self labelWithText:title font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:color];
    [stack addArrangedSubview:label];
    self.bottomTabLabels[symbol] = label;

    if (badge.length > 0) {
        UILabel *badgeLabel = [self labelWithText:badge font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
        badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor colorWithRed:0.92 green:0.20 blue:0.23 alpha:1.0];
        badgeLabel.layer.cornerRadius = 10.0;
        badgeLabel.layer.masksToBounds = YES;
        [container addSubview:badgeLabel];
        if ([symbol isEqualToString:@"person.2"]) {
            self.followingBadgeLabel = badgeLabel;
        }
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

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.accessibilityIdentifier = symbol;
    [button addTarget:self action:@selector(bottomTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.topAnchor constraintEqualToAnchor:container.topAnchor],
        [button.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [button.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
    return container;
}

- (void)bottomTabTapped:(UIButton *)sender {
    if ([sender.accessibilityIdentifier isEqualToString:@"person.2"]) {
        [self showFollowingPage];
    } else if ([sender.accessibilityIdentifier isEqualToString:@"house"]) {
        [self showHomePage];
    } else if ([sender.accessibilityIdentifier isEqualToString:@"bag"]) {
        [self showMallPage];
    } else if ([sender.accessibilityIdentifier isEqualToString:@"tv"]) {
        [self showMinePage];
    }
}

- (void)updateBottomTabSelection:(NSString *)selectedSymbol {
    self.selectedBottomTab = selectedSymbol;
    UIColor *selectedColor = BLPink();
    UIColor *normalColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [self.bottomTabIcons enumerateKeysAndObjectsUsingBlock:^(NSString *symbol, UIImageView *icon, BOOL *stop) {
        BOOL selected = [symbol isEqualToString:selectedSymbol];
        icon.tintColor = selected ? selectedColor : normalColor;
        self.bottomTabLabels[symbol].textColor = selected ? selectedColor : normalColor;
    }];
}

- (void)showFollowingPage {
    [self buildFollowingPageIfNeeded];
    [self updateBottomTabSelection:@"person.2"];
    self.followingBadgeLabel.hidden = YES;
    self.topBar.hidden = YES;
    self.feedScrollView.hidden = YES;
    self.livePageView.hidden = YES;
    self.hotPageView.hidden = YES;
    self.animePageView.hidden = YES;
    self.filmPageView.hidden = YES;
    self.mallPageView.hidden = YES;
    self.minePageView.hidden = YES;
    self.followingPageView.hidden = NO;
    [self.view bringSubviewToFront:self.followingPageView];
    [self.view bringSubviewToFront:self.bottomBar];
    [self.followingPageView activate];
}

- (void)showHomePage {
    [self updateBottomTabSelection:@"house"];
    [self.followingPageView deactivate];
    self.followingPageView.hidden = YES;
    self.mallPageView.hidden = YES;
    self.minePageView.hidden = YES;
    self.topBar.hidden = NO;
    [self showSelectedContent];
    [self.view bringSubviewToFront:self.bottomBar];
}

- (void)showMallPage {
    [self buildMallPageIfNeeded];
    [self updateBottomTabSelection:@"bag"];
    [self.followingPageView deactivate];
    self.topBar.hidden = YES;
    self.feedScrollView.hidden = YES;
    self.livePageView.hidden = YES;
    self.hotPageView.hidden = YES;
    self.animePageView.hidden = YES;
    self.filmPageView.hidden = YES;
    self.followingPageView.hidden = YES;
    self.minePageView.hidden = YES;
    self.mallPageView.hidden = NO;
    [self.view bringSubviewToFront:self.mallPageView];
    [self.view bringSubviewToFront:self.bottomBar];
}

- (void)showMinePage {
    [self buildMinePageIfNeeded];
    [self updateBottomTabSelection:@"tv"];
    [self.followingPageView deactivate];
    self.topBar.hidden = YES;
    self.feedScrollView.hidden = YES;
    self.livePageView.hidden = YES;
    self.hotPageView.hidden = YES;
    self.animePageView.hidden = YES;
    self.filmPageView.hidden = YES;
    self.followingPageView.hidden = YES;
    self.mallPageView.hidden = YES;
    self.minePageView.hidden = NO;
    [self.view bringSubviewToFront:self.minePageView];
    [self.view bringSubviewToFront:self.bottomBar];
}

- (void)showMallSearchPage {
    [self.coordinator showMallSearchPage];
}

- (void)showHistoryPage {
    [self.coordinator showHistoryPage];
}

- (void)showMallCouponPage {
    [self.coordinator showMallCouponPage];
}

- (void)showPublishPage {
    [self.coordinator showPublishPageWithFollowingPageView:self.followingPageView];
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

    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [tapButton addTarget:self action:@selector(showPublishPage) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:tapButton];

    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:62.0],
        [button.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:64.0],
        [button.heightAnchor constraintEqualToConstant:56.0],
        [plus.centerXAnchor constraintEqualToAnchor:button.centerXAnchor],
        [plus.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [plus.widthAnchor constraintEqualToConstant:30.0],
        [plus.heightAnchor constraintEqualToConstant:30.0],
        [tapButton.topAnchor constraintEqualToAnchor:container.topAnchor],
        [tapButton.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [tapButton.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [tapButton.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
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
    [button addTarget:self action:@selector(showFeedbackPanel) forControlEvents:UIControlEventTouchUpInside];
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

- (UIImage *)thumbsUpImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
    format.opaque = NO;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
        CGContextRef context = rendererContext.CGContext;
        CGContextScaleCTM(context, size.width / 1024.0, size.height / 1024.0);

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(64.0, 483.04)];
        [path addLineToPoint:CGPointMake(64.0, 872.0)];
        [path addCurveToPoint:CGPointMake(131.36, 939.36) controlPoint1:CGPointMake(64.0, 909.216) controlPoint2:CGPointMake(94.144, 939.36)];
        [path addLineToPoint:CGPointMake(192.0, 939.36)];
        [path addLineToPoint:CGPointMake(192.0, 416.32)];
        [path addLineToPoint:CGPointMake(131.36, 415.68)];
        [path addCurveToPoint:CGPointMake(64.0, 483.04) controlPoint1:CGPointMake(94.144, 415.68) controlPoint2:CGPointMake(64.0, 445.824)];
        [path closePath];

        [path moveToPoint:CGPointMake(857.28, 344.992)];
        [path addLineToPoint:CGPointMake(589.472, 346.688)];
        [path addCurveToPoint:CGPointMake(608.416, 228.48) controlPoint1:CGPointMake(602.048, 302.432) controlPoint2:CGPointMake(608.416, 263.104)];
        [path addCurveToPoint:CGPointMake(470.848, 82.976) controlPoint1:CGPointMake(608.416, 149.92) controlPoint2:CGPointMake(539.584, 72.992)];
        [path addCurveToPoint:CGPointMake(403.584, 209.792) controlPoint1:CGPointMake(410.24, 91.776) controlPoint2:CGPointMake(403.584, 144.16)];
        [path addLineToPoint:CGPointMake(403.584, 269.056)];
        [path addCurveToPoint:CGPointMake(265.728, 417.056) controlPoint1:CGPointMake(403.584, 345.12) controlPoint2:CGPointMake(339.744, 409.92)];
        [path addLineToPoint:CGPointMake(256.0, 416.96)];
        [path addLineToPoint:CGPointMake(256.0, 939.36)];
        [path addLineToPoint:CGPointMake(783.552, 939.36)];
        [path addCurveToPoint:CGPointMake(884.48, 855.776) controlPoint1:CGPointMake(833.024, 939.36) controlPoint2:CGPointMake(875.232, 904.384)];
        [path addLineToPoint:CGPointMake(958.208, 466.816)];
        [path addCurveToPoint:CGPointMake(857.28, 344.992) controlPoint1:CGPointMake(970.56, 401.536) controlPoint2:CGPointMake(923.968, 344.576)];
        [path closePath];

        [color setFill];
        [path fill];
    }];
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
