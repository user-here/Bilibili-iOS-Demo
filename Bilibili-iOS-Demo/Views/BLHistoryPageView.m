#import "BLHistoryPageView.h"
#import "BLVideoURLProvider.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static UIColor *BLHistoryPink(void) { return [UIColor colorWithRed:0.94 green:0.39 blue:0.56 alpha:1.0]; }
static UIColor *BLHistoryText(void) { return [UIColor colorWithRed:0.15 green:0.14 blue:0.16 alpha:1.0]; }
static UIColor *BLHistorySubText(void) { return [UIColor colorWithWhite:0.56 alpha:1.0]; }
static char BLHistoryItemAssociationKey;

@interface BLHistoryPageView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, assign) NSInteger selectedTab;
@end

@implementation BLHistoryPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.selectedTab = 0;
        [self buildView];
    }
    return self;
}

- (void)buildView {
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

    UILabel *title = [self labelWithText:@"\u5386\u53f2\u8bb0\u5f55" size:18.0 weight:UIFontWeightSemibold color:BLHistoryText()];
    title.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:title];

    UIImageView *search = [self systemIcon:@"magnifyingglass" size:22.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.headerView addSubview:search];
    UIImageView *more = [self systemIcon:@"ellipsis" size:22.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    more.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.headerView addSubview:more];

    UIScrollView *tabScroll = [[UIScrollView alloc] init];
    tabScroll.translatesAutoresizingMaskIntoConstraints = NO;
    tabScroll.showsHorizontalScrollIndicator = NO;
    [self.headerView addSubview:tabScroll];
    UIStackView *tabs = [[UIStackView alloc] init];
    tabs.translatesAutoresizingMaskIntoConstraints = NO;
    tabs.axis = UILayoutConstraintAxisHorizontal;
    tabs.spacing = 15.0;
    tabs.alignment = UIStackViewAlignmentCenter;
    [tabScroll addSubview:tabs];
    NSArray *tabTitles = @[
        @"\u5168\u90e8",
        @"\u89c6\u9891",
        @"\u76f4\u64ad",
        @"\u4e13\u680f",
        @"\u6e38\u620f",
        @"\u5546\u54c1",
        @"\u5c55\u6f14"
    ];
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger index = 0; index < tabTitles.count; index++) {
        UIButton *button = [self tabButtonWithTitle:tabTitles[index] index:index];
        [tabs addArrangedSubview:button];
        [buttons addObject:button];
    }
    self.tabButtons = buttons;
    [self updateTabs];

    UIButton *filter = [UIButton buttonWithType:UIButtonTypeSystem];
    filter.translatesAutoresizingMaskIntoConstraints = NO;
    filter.tintColor = [UIColor colorWithWhite:0.34 alpha:1.0];
    [filter setImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease"] forState:UIControlStateNormal];
    [self.headerView addSubview:filter];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.headerView addSubview:line];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 0.0;
    [self.scrollView addSubview:self.contentStack];
    [self buildHistoryContent];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:92.0],
        [back.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:12.0],
        [back.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [back.widthAnchor constraintEqualToConstant:38.0],
        [back.heightAnchor constraintEqualToConstant:38.0],
        [title.centerXAnchor constraintEqualToAnchor:self.headerView.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [search.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-22.0],
        [search.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [search.widthAnchor constraintEqualToConstant:24.0],
        [search.heightAnchor constraintEqualToConstant:24.0],
        [more.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-15.0],
        [more.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:24.0],
        [more.heightAnchor constraintEqualToConstant:24.0],
        [filter.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-13.0],
        [filter.bottomAnchor constraintEqualToAnchor:line.topAnchor constant:-7.0],
        [filter.widthAnchor constraintEqualToConstant:30.0],
        [filter.heightAnchor constraintEqualToConstant:30.0],
        [tabScroll.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:13.0],
        [tabScroll.trailingAnchor constraintEqualToAnchor:filter.leadingAnchor constant:-10.0],
        [tabScroll.centerYAnchor constraintEqualToAnchor:filter.centerYAnchor],
        [tabScroll.heightAnchor constraintEqualToConstant:38.0],
        [tabs.leadingAnchor constraintEqualToAnchor:tabScroll.contentLayoutGuide.leadingAnchor],
        [tabs.trailingAnchor constraintEqualToAnchor:tabScroll.contentLayoutGuide.trailingAnchor],
        [tabs.topAnchor constraintEqualToAnchor:tabScroll.contentLayoutGuide.topAnchor],
        [tabs.bottomAnchor constraintEqualToAnchor:tabScroll.contentLayoutGuide.bottomAnchor],
        [tabs.heightAnchor constraintEqualToAnchor:tabScroll.frameLayoutGuide.heightAnchor],
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
}

- (void)buildHistoryContent {
    [self.contentStack addArrangedSubview:[self groupHeader:@"\u4eca\u5929"]];
    NSArray *today = @[
        @{@"title": @"\u58f0\u4e50\u8001\u5e08\u9510\u8bc4\u6797\u4fca\u6770\u795e\u7ea7Live\u300a\u8d77\u98ce\u4e86\u300b\uff01\u6700\u96be\u5531...", @"author": @"Jason-\u8001\u6e7f", @"date": @"2026\u5e746\u670811\u65e5 00:12", @"time": @"13:54 / 14:07", @"seed": @0},
        @{@"title": @"\u7237\u7237\u7684\u70c2\u83dc\u677f #\u67d3\u5b50 #\u8bb0\u5f55\u8001\u4eba #\u83dc\u677f #\u5236\u4f5c\u8fc7\u7a0b", @"author": @"\u5c0f\u4e8c\u54e5\u5f53\u5bb6", @"date": @"2026\u5e746\u670811\u65e5 00:09", @"time": @"02:36 / 02:45", @"seed": @1},
        @{@"title": @"\u3010\u4e2d\u5b57\u3011\u6d77\u5916\u535a\u4e3b\u7206\uff1aAnt\u4e09\u8fdb\u3001GPT5.6\u5c06\u81f3", @"author": @"\u67ab\u53f6\u8fb9\u57ce", @"date": @"2026\u5e746\u670811\u65e5 00:06", @"time": @"00:17 / 08:31", @"seed": @2},
        @{@"title": @"Codex \u6700\u72e0\u5347\u7ea7", @"author": @"\u65b0\u667a\u5143AIera", @"date": @"2026\u5e746\u670811\u65e5 00:06", @"time": @"00:20 / 01:12", @"seed": @3}
    ];
    for (NSDictionary *item in today) {
        [self.contentStack addArrangedSubview:[self historyRow:item]];
    }

    [self.contentStack addArrangedSubview:[self groupHeader:@"\u6628\u5929"]];
    NSArray *yesterday = @[
        @{@"title": @"\u7ef4\u96eaCV\u674e\u5355\u5982\u76f4\u64ad\u201c\u5077\u5403\u201d\u98df\u7269\uff0c\u6211\u624d\u6ca1\u6709\u5427\u54ea\u54ea...", @"author": @"\u7ef4\u91cc\u5948\u9ebb\u9ebb", @"date": @"2026\u5e746\u670810\u65e5 23:58", @"time": @"00:55 / 03:28", @"seed": @4},
        @{@"title": @"\u53d8\u6001\uff01\u592a\u53ef\u6076\u4e86\uff01\u574e\u7279\u83b1\u62c9CV\u88ab\u6f6e\u53cb\u6b3a\u9a97\uff0c\u53d1\u51fa\u8d85...", @"author": @"\u7ef4\u91cc\u5948\u9ebb\u9ebb", @"date": @"2026\u5e746\u670810\u65e5 23:57", @"time": @"00:59 / 03:58", @"seed": @5},
        @{@"title": @"\u7b11\u4e0d\u6d3b\u4e86\uff01\u9e23\u6f6e\u4e8c\u521b\u4e00\u59d0\u201c\u6c50\u7761\u8857\u201d\u7528\u4e1c\u6728\u53e3\u97f3\u5531\u54c8\u57fa...", @"author": @"\u7ef4\u91cc\u5948\u9ebb\u9ebb", @"date": @"2026\u5e746\u670810\u65e5 23:56", @"time": @"00:01 / 02:19", @"seed": @6},
        @{@"title": @"AI\u5708\u6cb8\u817e\uff01\u72d9\u51fbMythos\uff0c\u667a\u8c31 GLM-5.2 \u6216\u5c06\u53d1\u5e03\u5f15...", @"author": @"\u9ed1\u9e2dHeya", @"date": @"2026\u5e746\u670810\u65e5 23:55", @"time": @"00:09 / 01:42", @"seed": @7},
        @{@"title": @"\u5730\u72f1\u9ed1\u6770\u514b\uff08PC+\u5b89\u5353+\u6574\u5408\u5305\uff09\u8d85\u597d\u73a9\u768421\u70b9\u8089\u9e3d\u5427...", @"author": @"\u714c\u7130\u706b\u5c71", @"date": @"2026\u5e746\u670810\u65e5 23:54", @"time": @"00:08 / 01:03", @"seed": @8},
        @{@"title": @"\u8d85\u4e0a\u5934\u7684\u8089\u9e3d\u5361\u724c\u3010\u5730\u72f1\u9ed1\u6770\u514b\u3011\uff08\u9644\u5730\u5740\uff09PC+\u5b89\u5353...", @"author": @"\u7231\u6e38\u732b\u624bAiu", @"date": @"2026\u5e746\u670810\u65e5 23:53", @"time": @"\u5df2\u770b\u5b8c", @"seed": @9},
        @{@"title": @"\u5168\u7f51\u9996\u53d1\uff013\u4eba\u56e2\u961f\u663c\u591c\u4e0d\u505c\u6210\u529f\u79fb\u690d\u51fa\u300a\u5730\u72f1\u9ed1\u6770\u514b\u300b...", @"author": @"\u5e73\u5e73\u65e0\u5947\u7684\u8def\u4eba\u82af", @"date": @"2026\u5e746\u670810\u65e5 23:52", @"time": @"\u5df2\u770b\u5b8c", @"seed": @10},
        @{@"title": @"\u8fd9\u662f\u4e00\u6b3e\u53ef\u4ee5\u8d4c\u4e0a\u7075\u9b42\u7684\u6e38\u620f\u2026\u2026\u3010\u5730\u72f1\u9ed1\u6770\u514b\u3011", @"author": @"\u72ec\u7acb\u6e38\u620f\u7f16\u8f91\u8005", @"date": @"2026\u5e746\u670810\u65e5 23:49", @"time": @"\u5df2\u770b\u5b8c", @"seed": @11},
        @{@"title": @"\u54c6\u5566A\u68a6\uff1a\u4f34\u6211\u540c\u884c", @"author": @"", @"date": @"2026\u5e746\u670810\u65e5 23:14", @"time": @"07:09 / 01:34:24", @"seed": @12}
    ];
    for (NSDictionary *item in yesterday) {
        [self.contentStack addArrangedSubview:[self historyRow:item]];
    }
}

- (UIView *)groupHeader:(NSString *)title {
    UILabel *label = [self labelWithText:title size:15.0 weight:UIFontWeightSemibold color:BLHistoryText()];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.layoutMargins = UIEdgeInsetsMake(0, 12, 0, 0);
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:label];
    [container.heightAnchor constraintEqualToConstant:42.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:12.0],
        [label.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [label.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-7.0]
    ]];
    return container;
}

- (UIView *)historyRow:(NSDictionary *)item {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.backgroundColor = [UIColor whiteColor];
    [row.heightAnchor constraintEqualToConstant:96.0].active = YES;

    UIView *thumb = [self thumbnailWithSeed:[item[@"seed"] integerValue] time:item[@"time"]];
    UILabel *title = [self labelWithText:item[@"title"] size:15.0 weight:UIFontWeightRegular color:BLHistoryText()];
    title.numberOfLines = 2;
    UILabel *author = [self metaLabelWithText:item[@"author"] prefix:@"UP"];
    UILabel *date = [self metaLabelWithText:item[@"date"] prefix:@"\u25a1"];
    UIImageView *more = [self systemIcon:@"ellipsis" size:17.0 color:[UIColor colorWithWhite:0.72 alpha:1.0]];
    more.transform = CGAffineTransformMakeRotation(M_PI_2);
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.translatesAutoresizingMaskIntoConstraints = NO;
    objc_setAssociatedObject(tapButton, &BLHistoryItemAssociationKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [tapButton addTarget:self action:@selector(historyRowTapped:) forControlEvents:UIControlEventTouchUpInside];
    [row addSubview:thumb];
    [row addSubview:title];
    [row addSubview:author];
    [row addSubview:date];
    [row addSubview:more];
    [row addSubview:line];
    [row addSubview:tapButton];
    [NSLayoutConstraint activateConstraints:@[
        [thumb.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:12.0],
        [thumb.topAnchor constraintEqualToAnchor:row.topAnchor constant:7.0],
        [thumb.widthAnchor constraintEqualToConstant:148.0],
        [thumb.heightAnchor constraintEqualToConstant:82.0],
        [title.leadingAnchor constraintEqualToAnchor:thumb.trailingAnchor constant:10.0],
        [title.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-6.0],
        [title.topAnchor constraintEqualToAnchor:thumb.topAnchor constant:1.0],
        [author.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [author.trailingAnchor constraintEqualToAnchor:title.trailingAnchor],
        [author.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:6.0],
        [date.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [date.trailingAnchor constraintEqualToAnchor:title.trailingAnchor],
        [date.topAnchor constraintEqualToAnchor:author.bottomAnchor constant:4.0],
        [more.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-10.0],
        [more.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:18.0],
        [more.heightAnchor constraintEqualToConstant:18.0],
        [line.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:row.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5],
        [tapButton.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [tapButton.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-2.0],
        [tapButton.topAnchor constraintEqualToAnchor:row.topAnchor],
        [tapButton.bottomAnchor constraintEqualToAnchor:row.bottomAnchor]
    ]];
    return row;
}

- (void)historyRowTapped:(UIButton *)sender {
    NSDictionary *item = objc_getAssociatedObject(sender, &BLHistoryItemAssociationKey);
    NSString *URLString = item[@"videoURL"];
    if (URLString.length == 0) {
        URLString = BLDefaultLocalVideoRelativePath;
    }
    NSURL *URL = [BLVideoURLProvider videoURLForRelativePath:URLString];
    if (URL != nil && self.videoSelected) {
        NSString *title = item[@"title"] ?: @"";
        NSString *author = item[@"author"] ?: @"";
        self.videoSelected(URL, title, author);
    }
}

- (UIView *)thumbnailWithSeed:(NSInteger)seed time:(NSString *)time {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.layer.cornerRadius = 4.0;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [self colorForSeed:seed];
    UILabel *text = [self labelWithText:[self thumbTextForSeed:seed] size:18.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    text.textAlignment = NSTextAlignmentCenter;
    text.numberOfLines = 2;
    text.layer.shadowColor = [UIColor blackColor].CGColor;
    text.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    text.layer.shadowOpacity = 0.55;
    text.layer.shadowRadius = 1.0;
    UIView *shade = [[UIView alloc] init];
    shade.translatesAutoresizingMaskIntoConstraints = NO;
    shade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.18];
    UILabel *timeLabel = [self labelWithText:time size:11.0 weight:UIFontWeightMedium color:[UIColor whiteColor]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
    [view addSubview:shade];
    [view addSubview:text];
    [view addSubview:timeLabel];
    [NSLayoutConstraint activateConstraints:@[
        [shade.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        [shade.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
        [shade.topAnchor constraintEqualToAnchor:view.topAnchor],
        [shade.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
        [text.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:6.0],
        [text.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-6.0],
        [text.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [timeLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
        [timeLabel.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
        [timeLabel.heightAnchor constraintEqualToConstant:18.0],
        [timeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:78.0]
    ]];
    return view;
}

- (UIColor *)colorForSeed:(NSInteger)seed {
    NSArray *colors = @[
        [UIColor colorWithRed:0.95 green:0.18 blue:0.17 alpha:1.0],
        [UIColor colorWithRed:0.73 green:0.54 blue:0.30 alpha:1.0],
        [UIColor colorWithRed:0.07 green:0.13 blue:0.25 alpha:1.0],
        [UIColor colorWithRed:0.38 green:0.64 blue:0.88 alpha:1.0],
        [UIColor colorWithRed:0.29 green:0.33 blue:0.45 alpha:1.0],
        [UIColor colorWithRed:0.70 green:0.25 blue:0.58 alpha:1.0],
        [UIColor colorWithRed:0.21 green:0.62 blue:0.32 alpha:1.0],
        [UIColor colorWithRed:0.95 green:0.82 blue:0.48 alpha:1.0],
        [UIColor colorWithRed:0.20 green:0.20 blue:0.21 alpha:1.0],
        [UIColor colorWithRed:0.48 green:0.13 blue:0.10 alpha:1.0],
        [UIColor colorWithRed:0.58 green:0.76 blue:0.56 alpha:1.0],
        [UIColor colorWithRed:0.41 green:0.23 blue:0.18 alpha:1.0],
        [UIColor colorWithRed:0.57 green:0.79 blue:0.96 alpha:1.0]
    ];
    return colors[seed % colors.count];
}

- (NSString *)thumbTextForSeed:(NSInteger)seed {
    NSArray *texts = @[@"\u8d77\u98ce\u4e86", @"\u7237\u7237\u7684", @"GPT 5.6", @"Codex", @"CV\u76f4\u64ad", @"\u53d8\u6001!", @"\u9e23\u6f6e\u4e8c\u521b", @"GLM-5.2", @"\u5730\u72f1\u9ed1\u6770\u514b", @"\u8d85\u4e0a\u5934", @"\u5168\u7f51\u9996\u53d1", @"\u7075\u9b42\u6e38\u620f", @"\u4f34\u6211\u540c\u884c"];
    return texts[seed % texts.count];
}

- (UILabel *)metaLabelWithText:(NSString *)text prefix:(NSString *)prefix {
    NSString *value = text.length > 0 ? [NSString stringWithFormat:@"%@  %@", prefix, text] : @"";
    UILabel *label = [self labelWithText:value size:12.0 weight:UIFontWeightRegular color:BLHistorySubText()];
    return label;
}

- (UIButton *)tabButtonWithTitle:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = 100 + index;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 7.0, 5.0, 7.0);
    button.layer.cornerRadius = 4.0;
    [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tabTapped:(UIButton *)sender {
    self.selectedTab = sender.tag - 100;
    [self updateTabs];
}

- (void)updateTabs {
    for (NSInteger index = 0; index < self.tabButtons.count; index++) {
        UIButton *button = self.tabButtons[index];
        BOOL selected = index == self.selectedTab;
        button.backgroundColor = selected ? [UIColor colorWithRed:1.0 green:0.90 blue:0.94 alpha:1.0] : [UIColor clearColor];
        [button setTitleColor:selected ? BLHistoryPink() : BLHistoryText() forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
    }
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
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
