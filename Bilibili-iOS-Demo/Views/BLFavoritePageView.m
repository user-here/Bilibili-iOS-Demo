#import "BLFavoritePageView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static UIColor *BLFavoritePink(void) { return [UIColor colorWithRed:0.94 green:0.39 blue:0.57 alpha:1.0]; }
static UIColor *BLFavoriteText(void) { return [UIColor colorWithRed:0.15 green:0.14 blue:0.16 alpha:1.0]; }
static UIColor *BLFavoriteSubText(void) { return [UIColor colorWithWhite:0.57 alpha:1.0]; }
static NSString * const BLFavoriteTestVideoURLString = @"https://flyable-overlay-alone.ngrok-free.dev/files/08058f33c8ab0aa4b78ce19063e7510f.mp4";
static char BLFavoriteItemAssociationKey;
static char BLFavoriteFolderAssociationKey;

@interface BLFavoritePageView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *listHeaderContent;
@property (nonatomic, strong) UIView *detailHeaderContent;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSArray<UIButton *> *topTabs;
@property (nonatomic, strong) NSArray<UIView *> *topIndicators;
@property (nonatomic, strong) NSArray<UIButton *> *categoryTabs;
@property (nonatomic, assign) NSInteger selectedTopTab;
@property (nonatomic, assign) NSInteger selectedCategory;
@property (nonatomic, assign) BOOL showingFolderDetail;
@property (nonatomic, strong, nullable) NSDictionary *selectedFolder;
@end

@implementation BLFavoritePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        self.selectedTopTab = 0;
        self.selectedCategory = 0;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerView];

    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.backButton.tintColor = [UIColor colorWithWhite:0.36 alpha:1.0];
    [self.backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.backButton];

    self.listHeaderContent = [[UIView alloc] init];
    self.listHeaderContent.translatesAutoresizingMaskIntoConstraints = NO;
    [self.headerView addSubview:self.listHeaderContent];
    self.detailHeaderContent = [[UIView alloc] init];
    self.detailHeaderContent.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailHeaderContent.hidden = YES;
    [self.headerView addSubview:self.detailHeaderContent];

    UIStackView *topTabs = [[UIStackView alloc] init];
    topTabs.translatesAutoresizingMaskIntoConstraints = NO;
    topTabs.axis = UILayoutConstraintAxisHorizontal;
    topTabs.spacing = 46.0;
    topTabs.alignment = UIStackViewAlignmentCenter;
    [self.listHeaderContent addSubview:topTabs];
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *indicators = [NSMutableArray array];
    NSArray *topTitles = @[@"\u6536\u85cf", @"\u8ffd\u66f4"];
    for (NSInteger index = 0; index < topTitles.count; index++) {
        UIView *item = [self topTabItemWithTitle:topTitles[index] index:index indicators:indicators];
        [topTabs addArrangedSubview:item];
        [buttons addObject:[item viewWithTag:100 + index]];
    }
    self.topTabs = buttons;
    self.topIndicators = indicators;

    UIStackView *categories = [[UIStackView alloc] init];
    categories.translatesAutoresizingMaskIntoConstraints = NO;
    categories.axis = UILayoutConstraintAxisHorizontal;
    categories.spacing = 20.0;
    categories.alignment = UIStackViewAlignmentCenter;
    [self.listHeaderContent addSubview:categories];
    NSArray *categoryTitles = @[@"\u6536\u85cf\u5939", @"\u5168\u90e8", @"\u89c6\u9891", @"\u56fe\u6587"];
    NSMutableArray *categoryButtons = [NSMutableArray array];
    for (NSInteger index = 0; index < categoryTitles.count; index++) {
        UIButton *button = [self categoryButtonWithTitle:categoryTitles[index] index:index];
        [categories addArrangedSubview:button];
        [categoryButtons addObject:button];
    }
    self.categoryTabs = categoryButtons;

    UIImageView *search = [self systemIcon:@"magnifyingglass" size:22.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.listHeaderContent addSubview:search];
    UIImageView *plus = [self systemIcon:@"plus" size:22.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.listHeaderContent addSubview:plus];
    UIImageView *layout = [self systemIcon:@"rectangle.grid.1x2" size:22.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.listHeaderContent addSubview:layout];

    self.detailTitleLabel = [self labelWithText:@"" size:18.0 weight:UIFontWeightSemibold color:BLFavoriteText()];
    self.detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.detailHeaderContent addSubview:self.detailTitleLabel];
    UIImageView *detailSearch = [self systemIcon:@"magnifyingglass" size:24.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.detailHeaderContent addSubview:detailSearch];
    UIImageView *detailSort = [self systemIcon:@"list.bullet.indent" size:24.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.detailHeaderContent addSubview:detailSort];
    UIImageView *detailMore = [self systemIcon:@"ellipsis" size:24.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    detailMore.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.detailHeaderContent addSubview:detailMore];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.headerView addSubview:line];
    [self.headerView bringSubviewToFront:self.backButton];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self addSubview:self.scrollView];
    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 12.0;
    self.contentStack.layoutMargins = UIEdgeInsetsMake(14.0, 14.0, 24.0, 14.0);
    self.contentStack.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:94.0],
        [self.backButton.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:12.0],
        [self.backButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [self.backButton.widthAnchor constraintEqualToConstant:38.0],
        [self.backButton.heightAnchor constraintEqualToConstant:38.0],
        [self.listHeaderContent.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.listHeaderContent.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.listHeaderContent.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.listHeaderContent.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.detailHeaderContent.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.detailHeaderContent.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.detailHeaderContent.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.detailHeaderContent.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [topTabs.centerXAnchor constraintEqualToAnchor:self.listHeaderContent.centerXAnchor],
        [topTabs.centerYAnchor constraintEqualToAnchor:self.backButton.centerYAnchor],
        [categories.leadingAnchor constraintEqualToAnchor:self.listHeaderContent.leadingAnchor constant:20.0],
        [categories.bottomAnchor constraintEqualToAnchor:line.topAnchor constant:-8.0],
        [categories.heightAnchor constraintEqualToConstant:34.0],
        [layout.trailingAnchor constraintEqualToAnchor:self.listHeaderContent.trailingAnchor constant:-16.0],
        [layout.centerYAnchor constraintEqualToAnchor:categories.centerYAnchor],
        [layout.widthAnchor constraintEqualToConstant:24.0],
        [layout.heightAnchor constraintEqualToConstant:24.0],
        [plus.trailingAnchor constraintEqualToAnchor:layout.leadingAnchor constant:-22.0],
        [plus.centerYAnchor constraintEqualToAnchor:layout.centerYAnchor],
        [plus.widthAnchor constraintEqualToConstant:24.0],
        [plus.heightAnchor constraintEqualToConstant:24.0],
        [search.trailingAnchor constraintEqualToAnchor:plus.leadingAnchor constant:-24.0],
        [search.centerYAnchor constraintEqualToAnchor:layout.centerYAnchor],
        [search.widthAnchor constraintEqualToConstant:24.0],
        [search.heightAnchor constraintEqualToConstant:24.0],
        [self.detailTitleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.backButton.trailingAnchor constant:12.0],
        [self.detailTitleLabel.centerXAnchor constraintEqualToAnchor:self.detailHeaderContent.centerXAnchor],
        [self.detailTitleLabel.centerYAnchor constraintEqualToAnchor:self.backButton.centerYAnchor],
        [detailMore.trailingAnchor constraintEqualToAnchor:self.detailHeaderContent.trailingAnchor constant:-16.0],
        [detailMore.centerYAnchor constraintEqualToAnchor:self.backButton.centerYAnchor],
        [detailMore.widthAnchor constraintEqualToConstant:24.0],
        [detailMore.heightAnchor constraintEqualToConstant:24.0],
        [detailSort.trailingAnchor constraintEqualToAnchor:detailMore.leadingAnchor constant:-28.0],
        [detailSort.centerYAnchor constraintEqualToAnchor:self.backButton.centerYAnchor],
        [detailSort.widthAnchor constraintEqualToConstant:24.0],
        [detailSort.heightAnchor constraintEqualToConstant:24.0],
        [detailSearch.trailingAnchor constraintEqualToAnchor:detailSort.leadingAnchor constant:-32.0],
        [detailSearch.centerYAnchor constraintEqualToAnchor:self.backButton.centerYAnchor],
        [detailSearch.widthAnchor constraintEqualToConstant:24.0],
        [detailSearch.heightAnchor constraintEqualToConstant:24.0],
        [self.detailTitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:detailSearch.leadingAnchor constant:-12.0],
        [line.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5],
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
    [self updateTabs];
    [self rebuildContent];
}

- (void)rebuildContent {
    for (UIView *view in self.contentStack.arrangedSubviews) {
        [self.contentStack removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    if (self.showingFolderDetail) {
        self.contentStack.spacing = 0.0;
        self.contentStack.layoutMargins = UIEdgeInsetsZero;
        [self.contentStack addArrangedSubview:[self folderDetailSummary:self.selectedFolder]];
        NSArray *videos = [self videosForFolder:self.selectedFolder];
        for (NSDictionary *item in videos) {
            [self.contentStack addArrangedSubview:[self videoRow:item]];
        }
        return;
    }
    if (self.selectedCategory == 0) {
        for (NSDictionary *folder in [self favoriteFolders]) {
            [self.contentStack addArrangedSubview:[self folderCard:folder]];
        }
    } else {
        self.contentStack.spacing = 0.0;
        self.contentStack.layoutMargins = UIEdgeInsetsZero;
        for (NSDictionary *item in [self favoriteVideos]) {
            [self.contentStack addArrangedSubview:[self videoRow:item]];
        }
        return;
    }
    self.contentStack.spacing = 12.0;
    self.contentStack.layoutMargins = UIEdgeInsetsMake(14.0, 14.0, 24.0, 14.0);
}

- (NSArray<NSDictionary *> *)favoriteFolders {
    return @[
        @{@"title": @"\u9ed8\u8ba4\u6536\u85cf\u5939", @"count": @"156\u4e2a\u5185\u5bb9", @"items": @[@"\u7f51\u53cb\uff1a\u5e78\u4e8f\u662f\u8001\u864e\uff0c\u8fd9\u8981\u662f\u732b\u2026", @"\u83f2\u6bd4\uff1a\u5c31\u4f60\u4eec\u5bdd\u5ba4\u6700\u5435\uff01\uff01", @"\u201c\u8fd9\u8f88\u5b50\u8c08\u4e0d\u5230\u8fd9\u6837\u7684\u6211\u5c31\u4e0d\u6b7b\uff01\u201d"], @"seed": @0},
        @{@"title": @"\u5c0f\u90ed", @"count": @"29\u4e2a\u5185\u5bb9", @"items": @[@"\u301066\u5c0f\u65f6\u3011\u4e00\u767e\u5e74\u4e86\uff0c\u6211\u7ec8\u4e8e\u56de\u2026", @"C\u8bed\u8a00\u8003\u524d\u5fc5\u5237\u7f16\u7a0b\u98986", @"\u300a\u6570\u636e\u7ed3\u6784C\u8bed\u8a00\u7248\u300b3\u5c0f\u65f6\u671f\u672b\u2026"], @"seed": @1},
        @{@"title": @"\u6df1\u5ea6\u5b66\u4e60", @"count": @"5\u4e2a\u5185\u5bb9", @"items": @[@"\u5f90\u4ea6\u8fbe\u673a\u5668\u5b66\u4e60\uff1aDirichlet Proc\u2026", @"ChatGPT\u539f\u7406\u63ed\u79d8\uff5c\u80cc\u540e\u7684\u9ed1\u2026", @"\u3010\u738b\u6811\u68ee\u3011\u673a\u5668\u5b66\u4e60ML\u8054\u90a6\u5b66\u4e60\u2026"], @"seed": @2},
        @{@"title": @"\u82f1\u8bed", @"count": @"20\u4e2a\u5185\u5bb9", @"items": @[@"\u516d\u7ea7\u542c\u529b\u6838\u5fc3\u8bcd\u6c47150\u4e2a", @"\u3010+1000\u96c6\u5168\u3011\u5730\u9053\u7f8e\u97f3English\u2026", @"\u3010\u5b66\u4e60\u8bfe\u7a0b\u8bf7\u53d1\u79c1\u4fe1\u3011\u5b66\u597d\u82f1\u2026"], @"seed": @3},
        @{@"title": @"\u81ea\u7136\u8bed\u8a00\u5904\u7406", @"count": @"12\u4e2a\u5185\u5bb9", @"items": @[@"LDA\u4e3b\u9898\u6a21\u578b", @"\u3010BERT\u6a21\u578b\u3011\u66b4\u529b\u7684\u7f8e\u5b66\uff0c\u534f\u4f5c\u2026", @"Building an entity extr\u2026"], @"seed": @4},
        @{@"title": @"\u6570\u5b66", @"count": @"7\u4e2a\u5185\u5bb9", @"items": @[@"\u4e2d\u79d1\u5927-\u51f8\u4f18\u5316", @"\u300a\u56fe\u8bba\u53ca\u5e94\u7528\u300b", @"\u5341\u5206\u949f\u641e\u5b9a\u6700\u5927\u4f3c\u7136\u4f30\u8ba1"], @"seed": @5},
        @{@"title": @"\u6570\u5b66", @"count": @"2\u4e2a\u5185\u5bb9", @"items": @[@"\u6700\u4f18\u5316\u7406\u8bba\u4e0e\u65b9\u6cd5-\u7b2c\u4e00\u8bb2\uff1a\u6700\u2026", @"\u3010\u5168\u56fd\u5927\u5b66\u751f\u6570\u5b66\u7ade\u8d5b\u8bfe\u7a0b\u3011\u5f3a\u2026"], @"seed": @6}
    ];
}

- (NSArray<NSDictionary *> *)favoriteVideos {
    return @[
        @{@"title": @"\u7f51\u53cb\uff1a\u5e78\u4e8f\u662f\u8001\u864e\uff0c\u8fd9\u8981\u662f\u732b\u5c31\u7834\u4f60\u4e86", @"author": @"Chinajoy", @"views": @"2.7\u4e07", @"comments": @"21", @"time": @"01:46", @"seed": @0},
        @{@"title": @"\u83f2\u6bd4\uff1a\u5c31\u4f60\u4eec\u5bdd\u5ba4\u6700\u5435\uff01\uff01", @"author": @"Lm\u6d77\u6d0b", @"views": @"168.2\u4e07", @"comments": @"903", @"time": @"04:22", @"seed": @1},
        @{@"title": @"\u201c\u8fd9\u8f88\u5b50\u8c08\u4e0d\u5230\u8fd9\u6837\u7684\u6211\u5c31\u4e0d\u6b7b\uff01\u201d", @"author": @"\u6c50\u6c50\u4e0d\u60f3\u901b\u5927\u8857", @"views": @"23.3\u4e07", @"comments": @"131", @"time": @"04:28", @"seed": @2},
        @{@"title": @"\u3010\u9e23\u6f6e\u96c4\u5fc3\u301116\u5206\u949f\u756a\u5267\u7248\uff0c\u5168\u7a0b\u7535\u5f71\u7ea7\u2014\u2014\u8d60\u4e88\u95e8\u540e\u7684\u4f60", @"author": @"\u514d\u4e91\u738b\u5927\u53ef", @"views": @"11.5\u4e07", @"comments": @"648", @"time": @"16:15", @"seed": @3},
        @{@"title": @"\u300a\u81f4\u6f02\u6cca\u8005\u7684\u4e00\u5c01\u4fe1\u300b\u7206\u809d\u4e00\u6708\uff01\u89c6\u542c\u76db\u5bb4\uff01\u3010\u9e23\u6f6e2\u5468\u5e74\u3011", @"author": @"\u5b59\u7188\u7136", @"views": @"25.6\u4e07", @"comments": @"407", @"time": @"04:01", @"seed": @4},
        @{@"title": @"\u3010\u9e23\u6f6e\u52a8\u753b\u3011\u7231\u5f25\u65af\u53d1\u73b0\u4e86\u7238\u5988\u7761\u89c9\u7684\u79d8\u5bc6\uff1f\uff01", @"author": @"\u8f89\u6708Atsuki", @"views": @"46.6\u4e07", @"comments": @"393", @"time": @"02:09", @"seed": @5},
        @{@"title": @"Solar5\u7433\u5948\u2018Round n Round\u2019 M/V\u3010\u9e23\u6f6e\u751f\u65e5\u4f1a\u3011", @"author": @"\u9e23\u54c7\u9891\u9053", @"views": @"114.3\u4e07", @"comments": @"1.6\u4e07", @"time": @"01:56", @"seed": @6},
        @{@"title": @"\u843d\u8dd1\u540e\u6211\u6210\u4e3a\u4e86\u5973\u56e2\u51fa\u9053\uff1f\uff01\u3010\u9e23\u6f6e\u751f\u65e5\u4f1a\u3011", @"author": @"\u7075\u611f\u6307\u5927\u738b", @"views": @"110.7\u4e07", @"comments": @"1\u4e07", @"time": @"03:21", @"seed": @7},
        @{@"title": @"\u6211\u4eec\u51fa\u9053\u4e86\uff01Solar5\u300aShine Together\u300bMV\u3010\u9e23\u6f6e\u751f\u65e5\u4f1a\u3011", @"author": @"\u9e23\u54c7\u9891\u9053", @"views": @"213.9\u4e07", @"comments": @"2.1\u4e07", @"time": @"02:02", @"seed": @8},
        @{@"title": @"\u4e3a\u4ec0\u4e48cos\u6bd4sin\u66f4\u81ea\u79c1", @"author": @"\u5c71\u7ae5\u6570\u5b66", @"views": @"537.1\u4e07", @"comments": @"1.4\u4e07", @"time": @"03:55", @"seed": @9},
        @{@"title": @"claude code\u6d88\u606f\u901a\u77e5", @"author": @"H\u6d69\u540c\u5b66", @"views": @"1036", @"comments": @"1", @"time": @"03:50", @"seed": @10},
        @{@"title": @"\u666e\u901a\u5bb6\u5ead\u7684\u7b2c\u4e00\u4e2a\u7814\u7a76\u751f\u4e00\u5b9a\u8981\u77e5\u9053\u8fd98\u4ef6\u4e8b", @"author": @"\u9001\u61d2\u6d0b\u6d0b\u4e0a\u5b66", @"views": @"3.3\u4e07", @"comments": @"43", @"time": @"14:01", @"seed": @11}
    ];
}

- (UIView *)folderCard:(NSDictionary *)folder {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 12.0;
    card.layer.masksToBounds = YES;
    [card.heightAnchor constraintEqualToConstant:178.0].active = YES;
    UILabel *title = [self labelWithText:folder[@"title"] size:17.0 weight:UIFontWeightSemibold color:BLFavoriteText()];
    UILabel *count = [self labelWithText:[NSString stringWithFormat:@"%@ \u203a", folder[@"count"]] size:13.0 weight:UIFontWeightRegular color:BLFavoriteSubText()];
    count.textAlignment = NSTextAlignmentRight;
    UIStackView *covers = [[UIStackView alloc] init];
    covers.translatesAutoresizingMaskIntoConstraints = NO;
    covers.axis = UILayoutConstraintAxisHorizontal;
    covers.spacing = 6.0;
    covers.distribution = UIStackViewDistributionFillEqually;
    NSArray *items = folder[@"items"];
    NSInteger seed = [folder[@"seed"] integerValue];
    for (NSInteger index = 0; index < 3; index++) {
        if (index < items.count) {
            [covers addArrangedSubview:[self folderCoverWithTitle:items[index] seed:seed + index]];
        } else {
            [covers addArrangedSubview:[self emptyFolderCover]];
        }
    }
    [card addSubview:title];
    [card addSubview:count];
    [card addSubview:covers];
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.translatesAutoresizingMaskIntoConstraints = NO;
    objc_setAssociatedObject(tapButton, &BLFavoriteFolderAssociationKey, folder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [tapButton addTarget:self action:@selector(folderTapped:) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:tapButton];
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:18.0],
        [count.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [count.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [count.leadingAnchor constraintGreaterThanOrEqualToAnchor:title.trailingAnchor constant:10.0],
        [covers.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [covers.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [covers.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:16.0],
        [covers.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14.0],
        [tapButton.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [tapButton.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [tapButton.topAnchor constraintEqualToAnchor:card.topAnchor],
        [tapButton.bottomAnchor constraintEqualToAnchor:card.bottomAnchor]
    ]];
    return card;
}

- (void)folderTapped:(UIButton *)sender {
    NSDictionary *folder = objc_getAssociatedObject(sender, &BLFavoriteFolderAssociationKey);
    self.selectedFolder = folder;
    self.showingFolderDetail = YES;
    self.detailTitleLabel.text = folder[@"title"] ?: @"";
    self.listHeaderContent.hidden = YES;
    self.detailHeaderContent.hidden = NO;
    [self rebuildContent];
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    self.detailHeaderContent.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0.0);
    self.scrollView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0.0);
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.detailHeaderContent.transform = CGAffineTransformIdentity;
        self.scrollView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (UIView *)folderDetailSummary:(NSDictionary *)folder {
    UIView *summary = [[UIView alloc] init];
    summary.translatesAutoresizingMaskIntoConstraints = NO;
    summary.backgroundColor = [UIColor whiteColor];
    [summary.heightAnchor constraintEqualToConstant:170.0].active = YES;
    UILabel *title = [self labelWithText:folder[@"title"] ?: @"" size:25.0 weight:UIFontWeightSemibold color:BLFavoriteText()];
    UILabel *creator = [self labelWithText:@"\u521b\u5efa\u8005\uff1a\u963f\u72f8\u7231\u5403\u72d0\u72f8" size:17.0 weight:UIFontWeightRegular color:BLFavoriteSubText()];
    UILabel *count = [self labelWithText:folder[@"count"] ?: @"" size:17.0 weight:UIFontWeightRegular color:BLFavoriteSubText()];
    UIStackView *actions = [[UIStackView alloc] init];
    actions.translatesAutoresizingMaskIntoConstraints = NO;
    actions.axis = UILayoutConstraintAxisHorizontal;
    actions.spacing = 22.0;
    actions.alignment = UIStackViewAlignmentCenter;
    [actions addArrangedSubview:[self detailActionWithAsset:@"bl_like_before" symbol:nil title:@"\u70b9\u8d5e"]];
    [actions addArrangedSubview:[self detailActionWithAsset:@"bl_favorite_before" symbol:nil title:@"\u6536\u85cf"]];
    [actions addArrangedSubview:[self detailActionWithAsset:nil symbol:@"arrowshape.turn.up.right.fill" title:@"\u5206\u4eab"]];
    [summary addSubview:title];
    [summary addSubview:creator];
    [summary addSubview:count];
    [summary addSubview:actions];
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:summary.leadingAnchor constant:24.0],
        [title.topAnchor constraintEqualToAnchor:summary.topAnchor constant:26.0],
        [creator.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [creator.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:22.0],
        [count.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [count.topAnchor constraintEqualToAnchor:creator.bottomAnchor constant:15.0],
        [actions.trailingAnchor constraintEqualToAnchor:summary.trailingAnchor constant:-28.0],
        [actions.centerYAnchor constraintEqualToAnchor:summary.centerYAnchor constant:15.0],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:actions.leadingAnchor constant:-18.0]
    ]];
    return summary;
}

- (UIView *)detailActionWithAsset:(NSString *)asset symbol:(NSString *)symbol title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 6.0;
    if (asset.length > 0) {
        [stack addArrangedSubview:[self assetIcon:asset size:22.0]];
    } else {
        [stack addArrangedSubview:[self systemIcon:symbol size:22.0 color:[UIColor colorWithWhite:0.58 alpha:1.0]]];
    }
    UILabel *label = [self labelWithText:title size:12.0 weight:UIFontWeightRegular color:BLFavoriteSubText()];
    label.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:label];
    [stack.widthAnchor constraintEqualToConstant:46.0].active = YES;
    return stack;
}

- (NSArray<NSDictionary *> *)videosForFolder:(NSDictionary *)folder {
    NSArray *videos = [self favoriteVideos];
    if (videos.count == 0) {
        return @[];
    }
    NSInteger seed = [folder[@"seed"] integerValue];
    NSMutableArray *rotated = [NSMutableArray arrayWithCapacity:videos.count];
    for (NSInteger index = 0; index < videos.count; index++) {
        [rotated addObject:videos[(index + seed) % videos.count]];
    }
    return rotated;
}

- (UIView *)emptyFolderCover {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)folderCoverWithTitle:(NSString *)title seed:(NSInteger)seed {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 7.0;
    UIView *thumb = [self thumbnailWithSeed:seed time:nil];
    [stack addArrangedSubview:thumb];
    UILabel *label = [self labelWithText:title size:13.0 weight:UIFontWeightRegular color:BLFavoriteText()];
    label.numberOfLines = 2;
    [stack addArrangedSubview:label];
    [thumb.heightAnchor constraintEqualToConstant:66.0].active = YES;
    return stack;
}

- (UIView *)videoRow:(NSDictionary *)item {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.backgroundColor = [UIColor whiteColor];
    [row.heightAnchor constraintEqualToConstant:106.0].active = YES;
    UIView *thumb = [self thumbnailWithSeed:[item[@"seed"] integerValue] time:item[@"time"]];
    UILabel *title = [self labelWithText:item[@"title"] size:15.0 weight:UIFontWeightRegular color:BLFavoriteText()];
    title.numberOfLines = 2;
    UILabel *author = [self metaLabelWithText:item[@"author"] prefix:@"UP"];
    UILabel *stats = [self metaLabelWithText:[NSString stringWithFormat:@"%@     %@", item[@"views"], item[@"comments"]] prefix:@"\u25b6"];
    UIImageView *more = [self systemIcon:@"ellipsis" size:17.0 color:[UIColor colorWithWhite:0.72 alpha:1.0]];
    more.transform = CGAffineTransformMakeRotation(M_PI_2);
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.translatesAutoresizingMaskIntoConstraints = NO;
    objc_setAssociatedObject(tapButton, &BLFavoriteItemAssociationKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [tapButton addTarget:self action:@selector(videoRowTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    [row addSubview:thumb];
    [row addSubview:title];
    [row addSubview:author];
    [row addSubview:stats];
    [row addSubview:more];
    [row addSubview:line];
    [row addSubview:tapButton];
    [NSLayoutConstraint activateConstraints:@[
        [thumb.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:12.0],
        [thumb.topAnchor constraintEqualToAnchor:row.topAnchor constant:10.0],
        [thumb.widthAnchor constraintEqualToConstant:155.0],
        [thumb.heightAnchor constraintEqualToConstant:86.0],
        [title.leadingAnchor constraintEqualToAnchor:thumb.trailingAnchor constant:10.0],
        [title.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-6.0],
        [title.topAnchor constraintEqualToAnchor:thumb.topAnchor],
        [author.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [author.trailingAnchor constraintEqualToAnchor:title.trailingAnchor],
        [author.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:10.0],
        [stats.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [stats.trailingAnchor constraintEqualToAnchor:title.trailingAnchor],
        [stats.topAnchor constraintEqualToAnchor:author.bottomAnchor constant:5.0],
        [more.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-10.0],
        [more.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:18.0],
        [more.heightAnchor constraintEqualToConstant:18.0],
        [line.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:row.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5],
        [tapButton.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [tapButton.trailingAnchor constraintEqualToAnchor:more.leadingAnchor],
        [tapButton.topAnchor constraintEqualToAnchor:row.topAnchor],
        [tapButton.bottomAnchor constraintEqualToAnchor:row.bottomAnchor]
    ]];
    return row;
}

- (void)videoRowTapped:(UIButton *)sender {
    NSDictionary *item = objc_getAssociatedObject(sender, &BLFavoriteItemAssociationKey);
    NSString *URLString = item[@"videoURL"];
    if (URLString.length == 0) {
        URLString = BLFavoriteTestVideoURLString;
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    if (URL != nil && self.videoSelected) {
        self.videoSelected(URL, item[@"title"] ?: @"", item[@"author"] ?: @"");
    }
}

- (UIView *)thumbnailWithSeed:(NSInteger)seed time:(NSString *)time {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [self colorForSeed:seed];
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    UILabel *text = [self labelWithText:[self thumbTextForSeed:seed] size:16.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    text.textAlignment = NSTextAlignmentCenter;
    text.numberOfLines = 2;
    text.layer.shadowColor = [UIColor blackColor].CGColor;
    text.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    text.layer.shadowOpacity = 0.55;
    text.layer.shadowRadius = 1.0;
    [view addSubview:text];
    [NSLayoutConstraint activateConstraints:@[
        [text.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:6.0],
        [text.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-6.0],
        [text.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    if (time.length > 0) {
        UILabel *timeLabel = [self labelWithText:time size:11.0 weight:UIFontWeightMedium color:[UIColor whiteColor]];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        [view addSubview:timeLabel];
        [NSLayoutConstraint activateConstraints:@[
            [timeLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
            [timeLabel.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
            [timeLabel.heightAnchor constraintEqualToConstant:18.0],
            [timeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:48.0]
        ]];
    }
    return view;
}

- (UIColor *)colorForSeed:(NSInteger)seed {
    NSArray *colors = @[
        [UIColor colorWithRed:0.63 green:0.38 blue:0.25 alpha:1.0],
        [UIColor colorWithRed:0.25 green:0.16 blue:0.12 alpha:1.0],
        [UIColor colorWithRed:0.37 green:0.68 blue:0.78 alpha:1.0],
        [UIColor colorWithRed:0.93 green:0.23 blue:0.47 alpha:1.0],
        [UIColor colorWithRed:0.57 green:0.42 blue:0.82 alpha:1.0],
        [UIColor colorWithRed:0.13 green:0.12 blue:0.18 alpha:1.0],
        [UIColor colorWithRed:0.22 green:0.34 blue:0.58 alpha:1.0],
        [UIColor colorWithRed:0.95 green:0.79 blue:0.86 alpha:1.0],
        [UIColor colorWithRed:0.48 green:0.27 blue:0.75 alpha:1.0],
        [UIColor colorWithRed:0.91 green:0.91 blue:0.89 alpha:1.0],
        [UIColor colorWithRed:0.87 green:0.91 blue:0.96 alpha:1.0],
        [UIColor colorWithRed:0.05 green:0.05 blue:0.06 alpha:1.0]
    ];
    return colors[seed % colors.count];
}

- (NSString *)thumbTextForSeed:(NSInteger)seed {
    NSArray *texts = @[@"\u5e78\u4e8f\u662f\u8001\u864e", @"\u83f2\u6bd4", @"\u8c08\u4e0d\u5230", @"\u9e23\u6f6e\u96c4\u5fc3", @"\u81f4\u6f02\u6cca\u8005", @"\u7231\u5f25\u65af", @"Solar5", @"\u751f\u65e5\u4f1a", @"Shine Together", @"cos\u6bd4sin", @"Claude Code", @"\u666e\u901a\u5bb6\u5ead"];
    return texts[seed % texts.count];
}

- (UIView *)topTabItemWithTitle:(NSString *)title index:(NSInteger)index indicators:(NSMutableArray<UIView *> *)indicators {
    UIView *container = [[UIView alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = 100 + index;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(topTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIView *indicator = [[UIView alloc] init];
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    indicator.backgroundColor = BLFavoritePink();
    indicator.layer.cornerRadius = 1.5;
    [container addSubview:button];
    [container addSubview:indicator];
    [indicators addObject:indicator];
    [NSLayoutConstraint activateConstraints:@[
        [button.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [button.topAnchor constraintEqualToAnchor:container.topAnchor],
        [button.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [container.widthAnchor constraintEqualToConstant:44.0],
        [container.heightAnchor constraintEqualToConstant:44.0],
        [indicator.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [indicator.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [indicator.widthAnchor constraintEqualToConstant:16.0],
        [indicator.heightAnchor constraintEqualToConstant:3.0]
    ]];
    return container;
}

- (UIButton *)categoryButtonWithTitle:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = 200 + index;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 8.0, 5.0, 8.0);
    button.layer.cornerRadius = 4.0;
    [button addTarget:self action:@selector(categoryTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)topTabTapped:(UIButton *)sender {
    self.selectedTopTab = sender.tag - 100;
    [self updateTabs];
}

- (void)categoryTapped:(UIButton *)sender {
    self.selectedCategory = sender.tag - 200;
    [self updateTabs];
    [self rebuildContent];
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}

- (void)updateTabs {
    for (NSInteger index = 0; index < self.topTabs.count; index++) {
        BOOL selected = index == self.selectedTopTab;
        UIButton *button = self.topTabs[index];
        [button setTitleColor:selected ? BLFavoritePink() : BLFavoriteText() forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
        self.topIndicators[index].hidden = !selected;
    }
    for (NSInteger index = 0; index < self.categoryTabs.count; index++) {
        BOOL selected = index == self.selectedCategory;
        UIButton *button = self.categoryTabs[index];
        button.backgroundColor = selected ? [UIColor colorWithRed:1.0 green:0.90 blue:0.94 alpha:1.0] : [UIColor clearColor];
        [button setTitleColor:selected ? BLFavoritePink() : BLFavoriteText() forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
    }
}

- (UILabel *)metaLabelWithText:(NSString *)text prefix:(NSString *)prefix {
    UILabel *label = [self labelWithText:[NSString stringWithFormat:@"%@  %@", prefix, text] size:12.0 weight:UIFontWeightRegular color:BLFavoriteSubText()];
    return label;
}

- (void)closeButtonTapped {
    if (self.showingFolderDetail) {
        [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.detailHeaderContent.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0.0);
            self.scrollView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0.0);
        } completion:^(BOOL finished) {
            self.showingFolderDetail = NO;
            self.selectedFolder = nil;
            self.detailHeaderContent.transform = CGAffineTransformIdentity;
            self.scrollView.transform = CGAffineTransformIdentity;
            self.listHeaderContent.hidden = NO;
            self.detailHeaderContent.hidden = YES;
            [self rebuildContent];
            [self.scrollView setContentOffset:CGPointZero animated:NO];
        }];
        return;
    }
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (UIImageView *)assetIcon:(NSString *)asset size:(CGFloat)size {
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
    label.minimumScaleFactor = 0.72;
    return label;
}

@end
