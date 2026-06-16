#import "BLMallCouponPageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLMallCouponPink(void) { return [UIColor colorWithRed:0.94 green:0.23 blue:0.50 alpha:1.0]; }
static UIColor *BLMallCouponLightPink(void) { return [UIColor colorWithRed:1.0 green:0.88 blue:0.93 alpha:1.0]; }
static UIColor *BLMallCouponText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }

@interface BLMallCouponGradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLMallCouponGradientView
+ (Class)layerClass { return [CAGradientLayer class]; }
- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;
    NSMutableArray *values = [NSMutableArray array];
    for (UIColor *color in colors) {
        [values addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.colors = values;
    layer.startPoint = CGPointMake(0.0, 0.0);
    layer.endPoint = CGPointMake(1.0, 1.0);
}
@end

@interface BLMallCouponPageView ()
@property (nonatomic, strong) BLMallCouponGradientView *headerView;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) NSArray<UIView *> *tabIndicators;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger remainingTicks;
@property (nonatomic, assign) NSInteger selectedTabIndex;
@end

@implementation BLMallCouponPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.remainingTicks = 30280;
        self.selectedTabIndex = 0;
        [self buildView];
        [self rebuildProducts];
        [self startTimer];
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)buildView {
    self.headerView = [[BLMallCouponGradientView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.colors = @[
        [UIColor colorWithRed:1.0 green:0.42 blue:0.65 alpha:1.0],
        [UIColor colorWithRed:1.0 green:0.67 blue:0.28 alpha:1.0],
        [UIColor colorWithRed:0.98 green:0.25 blue:0.55 alpha:1.0]
    ];
    [self addSubview:self.headerView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    backButton.tintColor = [UIColor whiteColor];
    UIImageSymbolConfiguration *backConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightRegular];
    [backButton setImage:[[UIImage systemImageNamed:@"chevron.left"] imageWithConfiguration:backConfig] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:backButton];

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    searchButton.tintColor = [UIColor whiteColor];
    UIImageSymbolConfiguration *searchConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightRegular];
    [searchButton setImage:[[UIImage systemImageNamed:@"magnifyingglass"] imageWithConfiguration:searchConfig] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:searchButton];

    UILabel *title = [self labelWithText:@"\u5165\u5751\u63a8\u8350 \u53cc\u500d\u8865\u81f3 1\u5143\u8d77" size:27.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.shadowColor = BLMallCouponPink().CGColor;
    title.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    title.layer.shadowOpacity = 0.7;
    title.layer.shadowRadius = 0.0;
    [self.headerView addSubview:title];

    UIView *couponStrip = [self couponStrip];
    [self.headerView addSubview:couponStrip];

    self.tabBar = [[UIView alloc] init];
    self.tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.layer.cornerRadius = 16.0;
    self.tabBar.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.tabBar.layer.masksToBounds = YES;
    [self addSubview:self.tabBar];

    UIStackView *tabs = [[UIStackView alloc] init];
    tabs.translatesAutoresizingMaskIntoConstraints = NO;
    tabs.axis = UILayoutConstraintAxisHorizontal;
    tabs.distribution = UIStackViewDistributionFillEqually;
    tabs.alignment = UIStackViewAlignmentFill;
    [self.tabBar addSubview:tabs];

    NSArray<NSString *> *titles = @[
        @"\u5165\u5751\u5fc5\u901b",
        @"\u53cc\u500d\u8865\u8d34",
        @"\u70ed\u9500\u76f2\u76d2",
        @"\u7206\u6b3e\u5355\u54c1"
    ];
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *indicators = [NSMutableArray array];
    for (NSInteger index = 0; index < titles.count; index++) {
        UIView *container = [self tabItemWithTitle:titles[index] index:index indicatorOut:indicators];
        [tabs addArrangedSubview:container];
        [buttons addObject:[container viewWithTag:100 + index]];
    }
    self.tabButtons = buttons;
    self.tabIndicators = indicators;

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 12.0;
    self.contentStack.layoutMargins = UIEdgeInsetsMake(8.0, 12.0, 24.0, 12.0);
    self.contentStack.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:145.0],
        [backButton.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:10.0],
        [backButton.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:-80.0],
        [backButton.widthAnchor constraintEqualToConstant:42.0],
        [backButton.heightAnchor constraintEqualToConstant:42.0],
        [searchButton.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-12.0],
        [searchButton.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [searchButton.widthAnchor constraintEqualToConstant:42.0],
        [searchButton.heightAnchor constraintEqualToConstant:42.0],
        [title.centerXAnchor constraintEqualToAnchor:self.headerView.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [title.leadingAnchor constraintGreaterThanOrEqualToAnchor:backButton.trailingAnchor constant:8.0],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:searchButton.leadingAnchor constant:-8.0],
        [couponStrip.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:16.0],
        [couponStrip.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-16.0],
        [couponStrip.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:-18.0],
        [couponStrip.heightAnchor constraintEqualToConstant:48.0],
        [self.tabBar.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.tabBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tabBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tabBar.heightAnchor constraintEqualToConstant:48.0],
        [tabs.leadingAnchor constraintEqualToAnchor:self.tabBar.leadingAnchor],
        [tabs.trailingAnchor constraintEqualToAnchor:self.tabBar.trailingAnchor],
        [tabs.topAnchor constraintEqualToAnchor:self.tabBar.topAnchor],
        [tabs.bottomAnchor constraintEqualToAnchor:self.tabBar.bottomAnchor],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.tabBar.bottomAnchor],
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
}

- (UIView *)couponStrip {
    UIView *strip = [[UIView alloc] init];
    strip.translatesAutoresizingMaskIntoConstraints = NO;
    strip.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.62];
    strip.layer.cornerRadius = 10.0;
    strip.layer.masksToBounds = YES;

    UILabel *price = [self labelWithText:@"\u00a520" size:23.0 weight:UIFontWeightHeavy color:[UIColor colorWithWhite:0.05 alpha:1.0]];
    UILabel *name = [self labelWithText:@"\u65b0\u4eba\u5238\u5305" size:20.0 weight:UIFontWeightHeavy color:BLMallCouponPink()];
    self.countdownLabel = [self labelWithText:@"" size:17.0 weight:UIFontWeightHeavy color:[UIColor colorWithWhite:0.05 alpha:1.0]];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    self.countdownLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.94 blue:0.28 alpha:1.0];
    self.countdownLabel.layer.cornerRadius = 4.0;
    self.countdownLabel.layer.masksToBounds = YES;
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.down"]];
    arrow.translatesAutoresizingMaskIntoConstraints = NO;
    arrow.tintColor = BLMallCouponPink();

    [strip addSubview:price];
    [strip addSubview:name];
    [strip addSubview:self.countdownLabel];
    [strip addSubview:arrow];
    [NSLayoutConstraint activateConstraints:@[
        [price.leadingAnchor constraintEqualToAnchor:strip.leadingAnchor constant:18.0],
        [price.centerYAnchor constraintEqualToAnchor:strip.centerYAnchor],
        [name.leadingAnchor constraintEqualToAnchor:price.trailingAnchor constant:12.0],
        [name.centerYAnchor constraintEqualToAnchor:strip.centerYAnchor],
        [self.countdownLabel.trailingAnchor constraintEqualToAnchor:arrow.leadingAnchor constant:-10.0],
        [self.countdownLabel.centerYAnchor constraintEqualToAnchor:strip.centerYAnchor],
        [self.countdownLabel.widthAnchor constraintEqualToConstant:112.0],
        [self.countdownLabel.heightAnchor constraintEqualToConstant:26.0],
        [arrow.trailingAnchor constraintEqualToAnchor:strip.trailingAnchor constant:-16.0],
        [arrow.centerYAnchor constraintEqualToAnchor:strip.centerYAnchor],
        [arrow.widthAnchor constraintEqualToConstant:18.0],
        [arrow.heightAnchor constraintEqualToConstant:18.0],
        [name.trailingAnchor constraintLessThanOrEqualToAnchor:self.countdownLabel.leadingAnchor constant:-8.0]
    ]];
    [self updateCountdown];
    return strip;
}

- (UIView *)tabItemWithTitle:(NSString *)title index:(NSInteger)index indicatorOut:(NSMutableArray<UIView *> *)indicators {
    UIView *container = [[UIView alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = 100 + index;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:button];
    UIView *indicator = [[UIView alloc] init];
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    indicator.backgroundColor = BLMallCouponPink();
    indicator.layer.cornerRadius = 1.5;
    [container addSubview:indicator];
    [indicators addObject:indicator];
    [NSLayoutConstraint activateConstraints:@[
        [button.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [button.topAnchor constraintEqualToAnchor:container.topAnchor],
        [button.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [indicator.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [indicator.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-4.0],
        [indicator.widthAnchor constraintEqualToConstant:26.0],
        [indicator.heightAnchor constraintEqualToConstant:3.0]
    ]];
    return container;
}

- (void)tabTapped:(UIButton *)sender {
    self.selectedTabIndex = sender.tag - 100;
    [self updateTabs];
    [self rebuildProducts];
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}

- (void)updateTabs {
    for (NSInteger index = 0; index < self.tabButtons.count; index++) {
        BOOL selected = index == self.selectedTabIndex;
        [self.tabButtons[index] setTitleColor:selected ? BLMallCouponPink() : BLMallCouponText() forState:UIControlStateNormal];
        self.tabButtons[index].titleLabel.font = [UIFont systemFontOfSize:16.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
        self.tabIndicators[index].hidden = !selected;
    }
}

- (void)rebuildProducts {
    for (UIView *view in self.contentStack.arrangedSubviews) {
        [self.contentStack removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    NSArray<NSDictionary *> *products = [self productsForTab:self.selectedTabIndex];
    for (NSDictionary *product in products) {
        [self.contentStack addArrangedSubview:[self productRow:product]];
    }
}

- (NSArray<NSDictionary *> *)productsForTab:(NSInteger)tab {
    NSArray *base = @[
        @{@"title": @"BEMOE \u65f6\u5149\u4ee3\u7406\u4eba \u6309\u52a8\u4e2d", @"meta": @"\u6b63\u54c1\u4fdd\u969c | 7\u5929\u65e0\u7406\u7531", @"hot": @"\u65f6\u5149\u4ee3\u7406\u4eba\u70ed\u9500TOP1", @"price": @"\u00a51", @"old": @"\u00a55.00", @"tag": @"\u65b0\u4eba\u76f4\u964d4  \u8fd0\u8d39\u51cf10", @"seed": @0},
        @{@"title": @"8.9\u5143\u62bdlabubu\u524d\u65b9\u9ad8\u80fd", @"meta": @"\u62bd\u4ef7\u503c2334\u5143\u5546\u54c1", @"hot": @"4\u4e07+\u4eba\u611f\u5174\u8da3", @"price": @"\u00a58.9/\u62bd", @"old": @"", @"tag": @"", @"seed": @1},
        @{@"title": @"\u604b\u4e0e\u5236\u4f5c\u4eba \u8054\u540d\u5468\u8fb9\u793c\u76d2", @"meta": @"\u6b63\u54c1\u4fdd\u969c", @"hot": @"7\u5929\u70ed\u9500TOP10", @"price": @"\u00a529", @"old": @"\u00a539.00", @"tag": @"\u6ee120\u51cf10", @"seed": @2},
        @{@"title": @"SONGX \u00d7 VSINGER\u6d1b\u5929\u4f9d1", @"meta": @"\u6b63\u54c1\u4fdd\u969c | 7\u5929\u65e0\u7406\u7531", @"hot": @"2.6\u4e07+\u4eba\u52a0\u8d2d", @"price": @"\u00a516.89", @"old": @"\u00a528.90", @"tag": @"\u65b0\u4eba\u76f4\u964d12.01", @"seed": @3},
        @{@"title": @"\u9e23\u6f6e \u7cfb\u5217\u6b27\u6c14\u5b9d\u7bb1", @"meta": @"\u6b27\u6c14\u76f2\u76d2 | \u9650\u65f6\u5c3e\u6b3e", @"hot": @"13.1\u4e07+\u4eba\u611f\u5174\u8da3", @"price": @"\u00a512/\u62bd", @"old": @"", @"tag": @"", @"seed": @4},
        @{@"title": @"\u4e91\u6e38\u620f\u7545\u73a9\u5361", @"meta": @"\u4ec5\u9650B\u670d", @"hot": @"\u56de\u5934\u5ba217\u4e07+\u4eba", @"price": @"\u00a50.5", @"old": @"\u00a51.50", @"tag": @"\u5df2\u51cf1", @"seed": @5},
        @{@"title": @"\u660e\u65e5\u65b9\u821f \u89d2\u8272\u5408\u96c6vol.3", @"meta": @"\u62bd\u70ed\u95e8\u89d2\u8272\u6d77\u91cf\u624b\u529e", @"hot": @"8.7\u4e07+\u4eba\u611f\u5174\u8da3", @"price": @"\u00a515/\u62bd", @"old": @"", @"tag": @"", @"seed": @6},
        @{@"title": @"\u5c11\u5e74\u6b4c\u884c \u9650\u5b9a\u5fbd\u7ae0", @"meta": @"\u6b63\u54c1\u4fdd\u969c", @"hot": @"14\u5929\u70ed\u9500TOP8", @"price": @"\u00a579", @"old": @"\u00a589.00", @"tag": @"\u6ee120\u51cf10", @"seed": @7}
    ];
    if (tab == 0) {
        return @[base[5], base[2], base[0], base[2], base[7], base[1], base[2], base[3], base[6]];
    }
    if (tab == 1) {
        return @[base[3], base[3], base[0], base[7], base[4], base[6], base[1], base[2], base[3]];
    }
    if (tab == 2) {
        return @[base[1], base[4], base[4], base[6], base[4], base[6], base[3], base[6], base[4]];
    }
    return @[base[0], base[1], base[2], base[3], base[5], base[6], base[4], base[7], base[3], base[4]];
}

- (UIView *)productRow:(NSDictionary *)product {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.backgroundColor = [UIColor whiteColor];
    [row.heightAnchor constraintEqualToConstant:142.0].active = YES;

    UIView *thumb = [self productThumbWithSeed:[product[@"seed"] integerValue]];
    UILabel *title = [self labelWithText:product[@"title"] size:15.0 weight:UIFontWeightMedium color:BLMallCouponText()];
    title.numberOfLines = 2;
    UILabel *meta = [self labelWithText:product[@"meta"] size:13.0 weight:UIFontWeightRegular color:BLMallCouponPink()];
    UILabel *hot = [self pillLabelWithText:product[@"hot"] color:[UIColor colorWithRed:1.0 green:0.86 blue:0.42 alpha:1.0] textColor:[UIColor colorWithRed:0.67 green:0.42 blue:0.08 alpha:1.0]];
    UIView *price = [self pricePanelWithPrice:product[@"price"] oldPrice:product[@"old"] tag:product[@"tag"]];

    [row addSubview:thumb];
    [row addSubview:title];
    [row addSubview:meta];
    [row addSubview:hot];
    [row addSubview:price];
    [NSLayoutConstraint activateConstraints:@[
        [thumb.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [thumb.topAnchor constraintEqualToAnchor:row.topAnchor],
        [thumb.widthAnchor constraintEqualToConstant:142.0],
        [thumb.heightAnchor constraintEqualToConstant:132.0],
        [title.leadingAnchor constraintEqualToAnchor:thumb.trailingAnchor constant:10.0],
        [title.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-2.0],
        [title.topAnchor constraintEqualToAnchor:row.topAnchor constant:2.0],
        [meta.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [meta.trailingAnchor constraintEqualToAnchor:title.trailingAnchor],
        [meta.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:6.0],
        [hot.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [hot.topAnchor constraintEqualToAnchor:meta.bottomAnchor constant:6.0],
        [price.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [price.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [price.bottomAnchor constraintEqualToAnchor:thumb.bottomAnchor],
        [price.heightAnchor constraintEqualToConstant:48.0]
    ]];
    return row;
}

- (UIView *)productThumbWithSeed:(NSInteger)seed {
    BLMallCouponGradientView *thumb = [[BLMallCouponGradientView alloc] init];
    thumb.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *palettes = @[
        @[[UIColor colorWithRed:0.77 green:0.92 blue:1.0 alpha:1.0], [UIColor colorWithRed:1.0 green:0.89 blue:0.92 alpha:1.0]],
        @[[UIColor colorWithRed:0.39 green:0.22 blue:0.62 alpha:1.0], [UIColor colorWithRed:0.98 green:0.62 blue:0.88 alpha:1.0]],
        @[[UIColor colorWithRed:1.0 green:0.86 blue:0.73 alpha:1.0], [UIColor colorWithRed:0.76 green:0.94 blue:1.0 alpha:1.0]],
        @[[UIColor colorWithRed:0.04 green:0.06 blue:0.09 alpha:1.0], [UIColor colorWithRed:0.10 green:0.35 blue:0.62 alpha:1.0]]
    ];
    thumb.colors = palettes[seed % palettes.count];
    thumb.layer.cornerRadius = 5.0;
    thumb.layer.masksToBounds = YES;

    UILabel *mark = [self labelWithText:[NSString stringWithFormat:@"NO.%ld", (long)(seed + 1)] size:13.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    mark.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.28];
    mark.textAlignment = NSTextAlignmentCenter;
    mark.layer.cornerRadius = 12.0;
    mark.layer.masksToBounds = YES;
    UILabel *title = [self labelWithText:@"BILIBILI" size:19.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    UILabel *badge = [self labelWithText:@"\u53cc\u500d\u7701" size:12.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    badge.textAlignment = NSTextAlignmentCenter;
    badge.backgroundColor = BLMallCouponPink();
    badge.layer.cornerRadius = 10.0;
    badge.layer.masksToBounds = YES;
    [thumb addSubview:mark];
    [thumb addSubview:title];
    [thumb addSubview:badge];
    [NSLayoutConstraint activateConstraints:@[
        [mark.trailingAnchor constraintEqualToAnchor:thumb.trailingAnchor constant:-8.0],
        [mark.topAnchor constraintEqualToAnchor:thumb.topAnchor constant:8.0],
        [mark.widthAnchor constraintEqualToConstant:48.0],
        [mark.heightAnchor constraintEqualToConstant:24.0],
        [title.centerXAnchor constraintEqualToAnchor:thumb.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:thumb.centerYAnchor],
        [badge.leadingAnchor constraintEqualToAnchor:thumb.leadingAnchor constant:8.0],
        [badge.bottomAnchor constraintEqualToAnchor:thumb.bottomAnchor constant:-8.0],
        [badge.widthAnchor constraintEqualToConstant:58.0],
        [badge.heightAnchor constraintEqualToConstant:22.0]
    ]];
    return thumb;
}

- (UIView *)pricePanelWithPrice:(NSString *)price oldPrice:(NSString *)oldPrice tag:(NSString *)tag {
    UIView *panel = [[UIView alloc] init];
    panel.translatesAutoresizingMaskIntoConstraints = NO;
    panel.backgroundColor = BLMallCouponLightPink();
    panel.layer.cornerRadius = 24.0;
    panel.layer.masksToBounds = YES;

    UILabel *priceLabel = [self labelWithText:price size:22.0 weight:UIFontWeightHeavy color:BLMallCouponPink()];
    UILabel *old = [self labelWithText:oldPrice size:12.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.48 alpha:1.0]];
    UILabel *tagLabel = [self labelWithText:tag size:10.0 weight:UIFontWeightMedium color:[UIColor whiteColor]];
    tagLabel.backgroundColor = BLMallCouponPink();
    tagLabel.layer.cornerRadius = 3.0;
    tagLabel.layer.masksToBounds = YES;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *grab = [self labelWithText:@"\u26a1\u62a2" size:26.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    grab.textAlignment = NSTextAlignmentCenter;
    grab.backgroundColor = BLMallCouponPink();
    grab.layer.cornerRadius = 24.0;
    grab.layer.masksToBounds = YES;
    [panel addSubview:priceLabel];
    [panel addSubview:old];
    [panel addSubview:tagLabel];
    [panel addSubview:grab];
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray arrayWithArray:@[
        [priceLabel.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:14.0],
        [old.leadingAnchor constraintEqualToAnchor:priceLabel.trailingAnchor constant:3.0],
        [old.lastBaselineAnchor constraintEqualToAnchor:priceLabel.lastBaselineAnchor constant:-2.0],
        [tagLabel.leadingAnchor constraintEqualToAnchor:priceLabel.leadingAnchor],
        [tagLabel.heightAnchor constraintEqualToConstant:16.0],
        [tagLabel.widthAnchor constraintGreaterThanOrEqualToConstant:46.0],
        [grab.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor],
        [grab.topAnchor constraintEqualToAnchor:panel.topAnchor],
        [grab.bottomAnchor constraintEqualToAnchor:panel.bottomAnchor],
        [grab.widthAnchor constraintEqualToConstant:70.0],
        [old.trailingAnchor constraintLessThanOrEqualToAnchor:grab.leadingAnchor constant:-6.0]
    ]];
    if (tag.length > 0) {
        [constraints addObjectsFromArray:@[
            [priceLabel.topAnchor constraintEqualToAnchor:panel.topAnchor constant:4.0],
            [tagLabel.topAnchor constraintEqualToAnchor:priceLabel.bottomAnchor constant:-1.0]
        ]];
    } else {
        [constraints addObjectsFromArray:@[
            [priceLabel.centerYAnchor constraintEqualToAnchor:panel.centerYAnchor],
            [tagLabel.topAnchor constraintEqualToAnchor:priceLabel.bottomAnchor]
        ]];
    }
    [NSLayoutConstraint activateConstraints:constraints];
    tagLabel.hidden = tag.length == 0;
    old.hidden = oldPrice.length == 0;
    return panel;
}

- (UILabel *)pillLabelWithText:(NSString *)text color:(UIColor *)color textColor:(UIColor *)textColor {
    UILabel *label = [self labelWithText:text size:12.0 weight:UIFontWeightMedium color:textColor];
    label.backgroundColor = color;
    label.layer.cornerRadius = 9.0;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label.widthAnchor constraintGreaterThanOrEqualToConstant:92.0].active = YES;
    [label.heightAnchor constraintEqualToConstant:20.0].active = YES;
    return label;
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

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

- (void)timerTick {
    if (self.remainingTicks <= 0) {
        [self.timer invalidate];
        self.headerView.hidden = YES;
        self.tabBar.layer.cornerRadius = 0.0;
        return;
    }
    self.remainingTicks -= 1;
    [self updateCountdown];
}

- (void)updateCountdown {
    NSInteger totalSeconds = MAX(0, self.remainingTicks / 10);
    NSInteger hours = totalSeconds / 3600;
    NSInteger minutes = (totalSeconds % 3600) / 60;
    NSInteger seconds = totalSeconds % 60;
    NSInteger tenth = MAX(0, self.remainingTicks % 10);
    self.countdownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%ld", (long)hours, (long)minutes, (long)seconds, (long)tenth];
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (void)searchButtonTapped {
    if (self.searchTapped) {
        self.searchTapped();
    }
}

@end
