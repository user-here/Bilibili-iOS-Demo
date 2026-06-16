#import "BLMallPageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLMallPink(void) { return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0]; }
static UIColor *BLMallPurple(void) { return [UIColor colorWithRed:0.72 green:0.35 blue:0.95 alpha:1.0]; }

@interface BLMallGradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLMallGradientView
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

@interface BLMallPageView () <UIScrollViewDelegate>
@property (nonatomic, strong) BLMallGradientView *fixedHeader;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) UIView *floatingCoupon;
@property (nonatomic, strong) UILabel *mainCouponTimeLabel;
@property (nonatomic, strong) UILabel *floatingCouponTimeLabel;
@property (nonatomic, strong) NSTimer *couponTimer;
@property (nonatomic, assign) NSInteger couponRemainingSeconds;
@property (nonatomic, assign) BOOL floatingCouponClosed;
@property (nonatomic, assign) BOOL couponExpired;
@end

@implementation BLMallPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.94 blue:0.98 alpha:1.0];
        self.couponRemainingSeconds = 6049;
        [self buildView];
        [self startCouponTimer];
    }
    return self;
}

- (void)dealloc {
    [self.couponTimer invalidate];
}

- (void)buildView {
    self.fixedHeader = [[BLMallGradientView alloc] init];
    self.fixedHeader.translatesAutoresizingMaskIntoConstraints = NO;
    self.fixedHeader.colors = @[
        [UIColor colorWithRed:0.69 green:0.37 blue:0.96 alpha:1.0],
        [UIColor colorWithRed:0.86 green:0.48 blue:0.94 alpha:1.0]
    ];
    [self addSubview:self.fixedHeader];

    UIView *fixedSearch = [self searchBar];
    [self.fixedHeader addSubview:fixedSearch];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 8.0;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self topHeroSection]];
    [self.contentStack addArrangedSubview:[self quickCategoryPanel]];
    [self.contentStack addArrangedSubview:[self couponBannerCompact:NO]];
    [self.contentStack addArrangedSubview:[self productGrid]];
    [self.contentStack addArrangedSubview:[self bottomSpacer]];

    self.floatingCoupon = [self couponBannerCompact:YES];
    self.floatingCoupon.translatesAutoresizingMaskIntoConstraints = NO;
    self.floatingCoupon.hidden = YES;
    [self addSubview:self.floatingCoupon];

    [NSLayoutConstraint activateConstraints:@[
        [self.fixedHeader.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.fixedHeader.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.fixedHeader.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.fixedHeader.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:62.0],
        [fixedSearch.leadingAnchor constraintEqualToAnchor:self.fixedHeader.leadingAnchor constant:14.0],
        [fixedSearch.trailingAnchor constraintEqualToAnchor:self.fixedHeader.trailingAnchor constant:-14.0],
        [fixedSearch.bottomAnchor constraintEqualToAnchor:self.fixedHeader.bottomAnchor constant:-7.0],
        [fixedSearch.heightAnchor constraintEqualToConstant:44.0],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.fixedHeader.bottomAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],
        [self.floatingCoupon.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.floatingCoupon.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.floatingCoupon.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.floatingCoupon.heightAnchor constraintEqualToConstant:64.0]
    ]];
}

- (UIView *)topHeroSection {
    BLMallGradientView *hero = [[BLMallGradientView alloc] init];
    hero.translatesAutoresizingMaskIntoConstraints = NO;
    hero.colors = @[
        [UIColor colorWithRed:0.86 green:0.48 blue:0.94 alpha:1.0],
        [UIColor colorWithRed:0.78 green:0.43 blue:0.95 alpha:1.0]
    ];
    [hero.heightAnchor constraintEqualToConstant:92.0].active = YES;

    UIStackView *orders = [[UIStackView alloc] init];
    orders.translatesAutoresizingMaskIntoConstraints = NO;
    orders.axis = UILayoutConstraintAxisHorizontal;
    orders.distribution = UIStackViewDistributionFillEqually;
    orders.alignment = UIStackViewAlignmentCenter;
    [hero addSubview:orders];

    NSArray *items = @[
        @[@"6", @"\u6211\u7684\u8ba2\u5355"],
        @[@"1", @"\u8d2d\u7269\u8f66"],
        @[@"8", @"\u4f18\u60e0\u5238"],
        @[@"\u72c2", @"\u5546\u54c1\u6536\u85cf"],
        @[@"\u6b22", @"\u5546\u54c1\u8db3\u8ff9"]
    ];
    for (NSArray *item in items) {
        [orders addArrangedSubview:[self heroShortcutWithNumber:item[0] title:item[1]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [orders.leadingAnchor constraintEqualToAnchor:hero.leadingAnchor],
        [orders.trailingAnchor constraintEqualToAnchor:hero.trailingAnchor],
        [orders.topAnchor constraintEqualToAnchor:hero.topAnchor constant:2.0],
        [orders.heightAnchor constraintEqualToConstant:78.0]
    ]];
    return hero;
}

- (UIView *)searchBar {
    UIView *search = [[UIView alloc] init];
    search.translatesAutoresizingMaskIntoConstraints = NO;
    search.backgroundColor = [UIColor whiteColor];
    search.layer.cornerRadius = 24.0;

    UIImageView *icon = [self iconWithSymbol:@"magnifyingglass" size:24.0 color:BLMallPurple()];
    [search addSubview:icon];
    UILabel *label = [self labelWithText:@"\u62ef\u6551\u8005" size:18.0 weight:UIFontWeightMedium color:[UIColor colorWithWhite:0.16 alpha:1.0]];
    [search addSubview:label];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor colorWithRed:0.78 green:0.38 blue:0.92 alpha:1.0];
    button.layer.cornerRadius = 20.0;
    [button setTitle:@"\u641c\u7d22" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    [search addSubview:button];

    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [tapButton addTarget:self action:@selector(searchTappedAction) forControlEvents:UIControlEventTouchUpInside];
    [search addSubview:tapButton];

    [NSLayoutConstraint activateConstraints:@[
        [icon.leadingAnchor constraintEqualToAnchor:search.leadingAnchor constant:14.0],
        [icon.centerYAnchor constraintEqualToAnchor:search.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:28.0],
        [icon.heightAnchor constraintEqualToConstant:28.0],
        [label.leadingAnchor constraintEqualToAnchor:icon.trailingAnchor constant:9.0],
        [label.centerYAnchor constraintEqualToAnchor:search.centerYAnchor],
        [button.trailingAnchor constraintEqualToAnchor:search.trailingAnchor constant:-5.0],
        [button.centerYAnchor constraintEqualToAnchor:search.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:76.0],
        [button.heightAnchor constraintEqualToConstant:40.0],
        [tapButton.topAnchor constraintEqualToAnchor:search.topAnchor],
        [tapButton.leadingAnchor constraintEqualToAnchor:search.leadingAnchor],
        [tapButton.trailingAnchor constraintEqualToAnchor:search.trailingAnchor],
        [tapButton.bottomAnchor constraintEqualToAnchor:search.bottomAnchor]
    ]];
    return search;
}

- (void)searchTappedAction {
    if (self.searchTapped) {
        self.searchTapped();
    }
}

- (UIView *)heroShortcutWithNumber:(NSString *)number title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 2.0;
    UILabel *num = [self labelWithText:number size:46.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    num.layer.shadowColor = [UIColor colorWithRed:0.15 green:0.10 blue:0.35 alpha:1.0].CGColor;
    num.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    num.layer.shadowOpacity = 0.55;
    num.layer.shadowRadius = 0.0;
    UILabel *name = [self labelWithText:title size:14.0 weight:UIFontWeightRegular color:[UIColor whiteColor]];
    [stack addArrangedSubview:num];
    [stack addArrangedSubview:name];
    return stack;
}

- (UIView *)quickCategoryPanel {
    UIView *panel = [[UIView alloc] init];
    panel.translatesAutoresizingMaskIntoConstraints = NO;
    panel.backgroundColor = [UIColor whiteColor];
    panel.layer.cornerRadius = 17.0;
    panel.layer.masksToBounds = YES;
    [panel.heightAnchor constraintEqualToConstant:194.0].active = YES;

    UIScrollView *topScroll = [[UIScrollView alloc] init];
    topScroll.translatesAutoresizingMaskIntoConstraints = NO;
    topScroll.showsHorizontalScrollIndicator = NO;
    topScroll.alwaysBounceHorizontal = YES;
    [panel addSubview:topScroll];

    UIStackView *topRow = [[UIStackView alloc] init];
    topRow.translatesAutoresizingMaskIntoConstraints = NO;
    topRow.axis = UILayoutConstraintAxisHorizontal;
    topRow.alignment = UIStackViewAlignmentCenter;
    topRow.spacing = 20.0;
    [topScroll addSubview:topRow];
    UIView *fixedCategory = [self iconEntryWithSymbol:@"square.grid.2x2" title:@"\u5206\u7c7b"];
    fixedCategory.translatesAutoresizingMaskIntoConstraints = NO;
    fixedCategory.backgroundColor = [UIColor whiteColor];
    [panel addSubview:fixedCategory];
    NSArray *top = @[
        @[@"figure.stand", @"\u624b\u529e\u96d5\u50cf"],
        @[@"cube.box", @"\u76f2\u76d2"],
        @[@"ticket", @"\u6f2b\u5c55\u6f14\u51fa"],
        @[@"shippingbox", @"\u5468\u8fb9\u670d\u9970"],
        @[@"gamecontroller", @"3C\u6570\u7801"]
    ];
    for (NSArray *entry in top) {
        [topRow addArrangedSubview:[self iconEntryWithSymbol:entry[0] title:entry[1]]];
    }

    UIStackView *cardRow = [[UIStackView alloc] init];
    cardRow.translatesAutoresizingMaskIntoConstraints = NO;
    cardRow.axis = UILayoutConstraintAxisHorizontal;
    cardRow.distribution = UIStackViewDistributionFillEqually;
    cardRow.spacing = 8.0;
    [panel addSubview:cardRow];
    NSArray *cards = @[
        @[@"\u5965\u7279\u66fc\u7cfb\u5217", @"\u8fd1\u671f\u7231\u770b"],
        @[@"\u9e23\u6f6e", @"\u8fd1\u671f\u641c\u8fc7"],
        @[@"\u6f2b\u5a01", @"8\u4ef6\u65b0\u54c1"],
        @[@"\u53d8\u5f62\u91d1\u521a\u7cfb", @"5\u4ef6\u65b0\u54c1"]
    ];
    for (NSArray *card in cards) {
        [cardRow addArrangedSubview:[self interestCardWithTitle:card[0] subtitle:card[1]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [topScroll.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor],
        [topScroll.trailingAnchor constraintEqualToAnchor:fixedCategory.leadingAnchor constant:-10.0],
        [topScroll.topAnchor constraintEqualToAnchor:panel.topAnchor constant:15.0],
        [topScroll.heightAnchor constraintEqualToConstant:48.0],
        [fixedCategory.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-14.0],
        [fixedCategory.centerYAnchor constraintEqualToAnchor:topScroll.centerYAnchor],
        [fixedCategory.heightAnchor constraintEqualToAnchor:topScroll.heightAnchor],
        [fixedCategory.widthAnchor constraintGreaterThanOrEqualToConstant:72.0],
        [topRow.leadingAnchor constraintEqualToAnchor:topScroll.contentLayoutGuide.leadingAnchor constant:14.0],
        [topRow.trailingAnchor constraintEqualToAnchor:topScroll.contentLayoutGuide.trailingAnchor constant:-14.0],
        [topRow.topAnchor constraintEqualToAnchor:topScroll.contentLayoutGuide.topAnchor],
        [topRow.bottomAnchor constraintEqualToAnchor:topScroll.contentLayoutGuide.bottomAnchor],
        [topRow.heightAnchor constraintEqualToAnchor:topScroll.frameLayoutGuide.heightAnchor],
        [cardRow.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:12.0],
        [cardRow.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-12.0],
        [cardRow.topAnchor constraintEqualToAnchor:topScroll.bottomAnchor constant:13.0],
        [cardRow.bottomAnchor constraintEqualToAnchor:panel.bottomAnchor constant:-12.0]
    ]];
    return panel;
}

- (UIView *)iconEntryWithSymbol:(NSString *)symbol title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 6.0;
    stack.layoutMargins = UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0);
    stack.layoutMarginsRelativeArrangement = YES;
    [stack addArrangedSubview:[self iconWithSymbol:symbol size:23.0 color:[UIColor colorWithWhite:0.18 alpha:1.0]]];
    UILabel *label = [self labelWithText:title size:16.0 weight:UIFontWeightMedium color:[UIColor colorWithWhite:0.16 alpha:1.0]];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [stack addArrangedSubview:label];
    return stack;
}

- (UIView *)interestCardWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    BLMallGradientView *card = [[BLMallGradientView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.colors = @[[UIColor whiteColor], [UIColor colorWithRed:1.0 green:0.82 blue:0.90 alpha:1.0]];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;

    UILabel *titleLabel = [self labelWithText:title size:15.0 weight:UIFontWeightSemibold color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *image = [self labelWithText:[title substringToIndex:1] size:25.0 weight:UIFontWeightHeavy color:BLMallPurple()];
    image.textAlignment = NSTextAlignmentCenter;
    image.backgroundColor = [UIColor colorWithRed:0.92 green:0.90 blue:1.0 alpha:1.0];
    image.layer.cornerRadius = 24.0;
    image.layer.masksToBounds = YES;
    UILabel *sub = [self labelWithText:subtitle size:14.0 weight:UIFontWeightSemibold color:BLMallPink()];
    sub.textAlignment = NSTextAlignmentCenter;
    [card addSubview:titleLabel];
    [card addSubview:image];
    [card addSubview:sub];
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:card.topAnchor constant:7.0],
        [titleLabel.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [image.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [image.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:7.0],
        [image.widthAnchor constraintEqualToConstant:48.0],
        [image.heightAnchor constraintEqualToConstant:48.0],
        [sub.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [sub.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-7.0]
    ]];
    return card;
}

- (UIView *)couponBannerCompact:(BOOL)compact {
    UIView *banner = [[UIView alloc] init];
    banner.translatesAutoresizingMaskIntoConstraints = NO;
    banner.backgroundColor = BLMallPink();
    if (!compact) {
        banner.layer.cornerRadius = 8.0;
        banner.layer.masksToBounds = YES;
        [banner.heightAnchor constraintEqualToConstant:52.0].active = YES;
    }

    UILabel *price = [self labelWithText:@"\u00a520" size:compact ? 23.0 : 28.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    UILabel *title = [self labelWithText:@"\u65b0\u4eba\u5238\u5305" size:compact ? 19.0 : 21.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    UILabel *time = [self labelWithText:[self couponTimeText] size:compact ? 13.0 : 15.0 weight:UIFontWeightMedium color:[UIColor whiteColor]];
    UIButton *claim = [UIButton buttonWithType:UIButtonTypeCustom];
    claim.translatesAutoresizingMaskIntoConstraints = NO;
    claim.backgroundColor = [UIColor colorWithRed:1.0 green:0.91 blue:0.24 alpha:1.0];
    claim.layer.cornerRadius = compact ? 17.0 : 18.0;
    claim.layer.borderWidth = 2.0;
    claim.layer.borderColor = [UIColor colorWithWhite:0.15 alpha:1.0].CGColor;
    [claim setTitle:@"\u7acb\u5373\u9886\u53d6" forState:UIControlStateNormal];
    [claim setTitleColor:[UIColor colorWithWhite:0.13 alpha:1.0] forState:UIControlStateNormal];
    claim.titleLabel.font = [UIFont systemFontOfSize:compact ? 15.0 : 16.0 weight:UIFontWeightHeavy];
    [claim addTarget:self action:@selector(couponTappedAction) forControlEvents:UIControlEventTouchUpInside];
    [banner addSubview:price];
    [banner addSubview:title];
    [banner addSubview:time];
    [banner addSubview:claim];
    if (compact) {
        self.floatingCouponTimeLabel = time;
        UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
        close.translatesAutoresizingMaskIntoConstraints = NO;
        close.tintColor = [UIColor whiteColor];
        close.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.28];
        close.layer.cornerRadius = 14.0;
        [close setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(closeFloatingCoupon) forControlEvents:UIControlEventTouchUpInside];
        [banner addSubview:close];
        [NSLayoutConstraint activateConstraints:@[
            [close.trailingAnchor constraintEqualToAnchor:banner.trailingAnchor constant:-7.0],
            [close.topAnchor constraintEqualToAnchor:banner.topAnchor constant:-14.0],
            [close.widthAnchor constraintEqualToConstant:28.0],
            [close.heightAnchor constraintEqualToConstant:28.0]
        ]];
    } else {
        self.mainCouponTimeLabel = time;
    }
    [NSLayoutConstraint activateConstraints:@[
        [price.leadingAnchor constraintEqualToAnchor:banner.leadingAnchor constant:compact ? 12.0 : 18.0],
        [price.centerYAnchor constraintEqualToAnchor:banner.centerYAnchor],
        [title.leadingAnchor constraintEqualToAnchor:price.trailingAnchor constant:10.0],
        [title.centerYAnchor constraintEqualToAnchor:banner.centerYAnchor],
        [time.leadingAnchor constraintEqualToAnchor:title.trailingAnchor constant:8.0],
        [time.centerYAnchor constraintEqualToAnchor:banner.centerYAnchor],
        [claim.trailingAnchor constraintEqualToAnchor:banner.trailingAnchor constant:compact ? -18.0 : -16.0],
        [claim.centerYAnchor constraintEqualToAnchor:banner.centerYAnchor],
        [claim.widthAnchor constraintEqualToConstant:compact ? 94.0 : 102.0],
        [claim.heightAnchor constraintEqualToConstant:compact ? 34.0 : 36.0],
        [time.trailingAnchor constraintLessThanOrEqualToAnchor:claim.leadingAnchor constant:-8.0]
    ]];
    return banner;
}

- (void)couponTappedAction {
    if (self.couponTapped) {
        self.couponTapped();
    }
}

- (UIView *)productGrid {
    UIStackView *grid = [[UIStackView alloc] init];
    grid.translatesAutoresizingMaskIntoConstraints = NO;
    grid.axis = UILayoutConstraintAxisHorizontal;
    grid.spacing = 10.0;
    grid.alignment = UIStackViewAlignmentTop;
    grid.layoutMargins = UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0);
    grid.layoutMarginsRelativeArrangement = YES;

    UIStackView *left = [self productColumn];
    UIStackView *right = [self productColumn];
    [grid addArrangedSubview:left];
    [grid addArrangedSubview:right];
    [left.widthAnchor constraintEqualToAnchor:right.widthAnchor].active = YES;

    [left addArrangedSubview:[self productCardWithTitle:@"SONGX \u51e1\u4eba\u89e6\u5c4f\u964d\u566a\u8033\u673a" price:@"\u5b9a\u91d1 \u00a559.85" meta:@"\u72ec\u5bb6 \u4e0a\u65b05\u5929 \u6ee1399\u51cf40" tag:@"618 \u81ea\u8425" tall:NO]];
    [right addArrangedSubview:[self carnivalPromoCard]];
    [left addArrangedSubview:[self productCardWithTitle:@"\u9884\u552e\u00b7ADK Emoti" price:@"\u5b9a\u91d1 \u00a5222" meta:@"\u72ec\u5bb6\u7279\u5178 \u6ee11099\u51cf110" tag:@"\u81ea\u8425" tall:YES]];
    [right addArrangedSubview:[self productCardWithTitle:@"Hobby Rangers \u9e23\u6f6e" price:@"\u5b9a\u91d1 \u00a535.85" meta:@"\u6b27\u6c14\u5b9d\u7bb1 100%\u968f\u673a\u7acb\u51cf" tag:@"618 \u81ea\u8425" tall:NO]];
    [left addArrangedSubview:[self productCardWithTitle:@"10\u5143\u62bd switch2" price:@"\u00a510/\u62bd" meta:@"\u56de\u5934\u5ba234\u4eba" tag:@"\u60ca\u559c\u8d4f" tall:NO]];
    [right addArrangedSubview:[self productCardWithTitle:@"10\u5143\u6b27\uff01\u6d1b\u514b\u738b\u56fd" price:@"\u00a510" meta:@"\u6bdb\u7ed2\u6302\u4ef6" tag:@"\u60ca\u559c\u8d4f" tall:YES]];
    return grid;
}

- (UIStackView *)productColumn {
    UIStackView *column = [[UIStackView alloc] init];
    column.translatesAutoresizingMaskIntoConstraints = NO;
    column.axis = UILayoutConstraintAxisVertical;
    column.spacing = 10.0;
    return column;
}

- (UIView *)carnivalPromoCard {
    BLMallGradientView *card = [[BLMallGradientView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.colors = @[
        [UIColor colorWithRed:0.78 green:0.36 blue:0.96 alpha:1.0],
        [UIColor colorWithRed:1.0 green:0.62 blue:0.90 alpha:1.0]
    ];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;
    [card.heightAnchor constraintEqualToConstant:318.0].active = YES;

    UILabel *title = [self labelWithText:@"618\u72c2\u6b22" size:28.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [card addSubview:title];

    UIView *visit = [[UIView alloc] init];
    visit.translatesAutoresizingMaskIntoConstraints = NO;
    visit.backgroundColor = [UIColor whiteColor];
    visit.layer.cornerRadius = 6.0;
    [card addSubview:visit];
    UILabel *visitText = [self labelWithText:@"\u6bcf\u65e5\u62a2\u5927\u989d\u5238" size:14.0 weight:UIFontWeightSemibold color:BLMallPurple()];
    UILabel *go = [self labelWithText:@"\u53bb\u6d4f\u89c8 >" size:15.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    go.textAlignment = NSTextAlignmentCenter;
    go.backgroundColor = BLMallPurple();
    go.layer.cornerRadius = 5.0;
    go.layer.masksToBounds = YES;
    [visit addSubview:visitText];
    [visit addSubview:go];

    UIView *subsidy = [self promoTileWithTitle:@"\u00a5285" subtitle:@"\u5b98\u65b9\u8865\u8d34" large:YES];
    UIView *redPacket = [self promoTileWithTitle:@"\u62bd\u7ea2\u5305\u597d\u793c" subtitle:@"" large:NO];
    UIView *box = [self promoTileWithTitle:@"\u6b27\u6c14\u5b9d\u7bb1" subtitle:@"" large:NO];
    UIView *discount = [self promoTileWithTitle:@"\u60ca\u559c\u6298\u6263" subtitle:@"" large:NO];
    [card addSubview:subsidy];
    [card addSubview:redPacket];
    [card addSubview:box];
    [card addSubview:discount];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:10.0],
        [title.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [visit.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:10.0],
        [visit.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-10.0],
        [visit.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:9.0],
        [visit.heightAnchor constraintEqualToConstant:36.0],
        [visitText.leadingAnchor constraintEqualToAnchor:visit.leadingAnchor constant:12.0],
        [visitText.centerYAnchor constraintEqualToAnchor:visit.centerYAnchor],
        [go.trailingAnchor constraintEqualToAnchor:visit.trailingAnchor constant:-4.0],
        [go.centerYAnchor constraintEqualToAnchor:visit.centerYAnchor],
        [go.widthAnchor constraintEqualToConstant:78.0],
        [go.heightAnchor constraintEqualToConstant:28.0],
        [subsidy.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:10.0],
        [subsidy.topAnchor constraintEqualToAnchor:visit.bottomAnchor constant:10.0],
        [subsidy.widthAnchor constraintEqualToAnchor:card.widthAnchor multiplier:0.48 constant:-13.0],
        [subsidy.heightAnchor constraintEqualToConstant:86.0],
        [redPacket.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-10.0],
        [redPacket.topAnchor constraintEqualToAnchor:subsidy.topAnchor],
        [redPacket.widthAnchor constraintEqualToAnchor:subsidy.widthAnchor],
        [redPacket.heightAnchor constraintEqualToAnchor:subsidy.heightAnchor],
        [box.leadingAnchor constraintEqualToAnchor:subsidy.leadingAnchor],
        [box.topAnchor constraintEqualToAnchor:subsidy.bottomAnchor constant:10.0],
        [box.widthAnchor constraintEqualToAnchor:subsidy.widthAnchor],
        [box.heightAnchor constraintEqualToConstant:78.0],
        [discount.trailingAnchor constraintEqualToAnchor:redPacket.trailingAnchor],
        [discount.topAnchor constraintEqualToAnchor:box.topAnchor],
        [discount.widthAnchor constraintEqualToAnchor:subsidy.widthAnchor],
        [discount.heightAnchor constraintEqualToAnchor:box.heightAnchor]
    ]];
    return card;
}

- (UIView *)promoTileWithTitle:(NSString *)title subtitle:(NSString *)subtitle large:(BOOL)large {
    BLMallGradientView *tile = [[BLMallGradientView alloc] init];
    tile.translatesAutoresizingMaskIntoConstraints = NO;
    tile.colors = large ? @[[UIColor whiteColor], [UIColor colorWithRed:1.0 green:0.78 blue:0.94 alpha:1.0]] : @[[UIColor colorWithRed:0.97 green:0.90 blue:1.0 alpha:1.0], [UIColor colorWithRed:0.75 green:0.47 blue:0.92 alpha:1.0]];
    tile.layer.cornerRadius = 7.0;
    tile.layer.masksToBounds = YES;
    UILabel *main = [self labelWithText:title size:large ? 29.0 : 17.0 weight:UIFontWeightHeavy color:large ? BLMallPink() : [UIColor whiteColor]];
    main.textAlignment = NSTextAlignmentCenter;
    UILabel *sub = [self labelWithText:subtitle size:large ? 17.0 : 13.0 weight:UIFontWeightHeavy color:large ? BLMallPink() : [UIColor whiteColor]];
    sub.textAlignment = NSTextAlignmentCenter;
    [tile addSubview:main];
    [tile addSubview:sub];
    [NSLayoutConstraint activateConstraints:@[
        [main.centerXAnchor constraintEqualToAnchor:tile.centerXAnchor],
        [main.centerYAnchor constraintEqualToAnchor:tile.centerYAnchor constant:large ? -11.0 : 0.0],
        [main.leadingAnchor constraintGreaterThanOrEqualToAnchor:tile.leadingAnchor constant:5.0],
        [main.trailingAnchor constraintLessThanOrEqualToAnchor:tile.trailingAnchor constant:-5.0],
        [sub.centerXAnchor constraintEqualToAnchor:tile.centerXAnchor],
        [sub.topAnchor constraintEqualToAnchor:main.bottomAnchor constant:2.0]
    ]];
    return tile;
}

- (UIView *)productCardWithTitle:(NSString *)title price:(NSString *)price meta:(NSString *)meta tag:(NSString *)tag tall:(BOOL)tall {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;

    BLMallGradientView *image = [[BLMallGradientView alloc] init];
    image.translatesAutoresizingMaskIntoConstraints = NO;
    image.colors = tall ? @[[UIColor colorWithRed:0.94 green:0.82 blue:1.0 alpha:1.0], [UIColor colorWithRed:0.58 green:0.48 blue:0.88 alpha:1.0]] : @[[UIColor colorWithRed:0.24 green:0.28 blue:0.24 alpha:1.0], [UIColor colorWithRed:0.85 green:0.68 blue:0.55 alpha:1.0]];
    [card addSubview:image];

    UILabel *art = [self labelWithText:tag size:23.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    art.textAlignment = NSTextAlignmentCenter;
    [image addSubview:art];

    UILabel *titleLabel = [self labelWithText:title size:15.5 weight:UIFontWeightSemibold color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    titleLabel.numberOfLines = 2;
    UILabel *metaLabel = [self labelWithText:meta size:13.0 weight:UIFontWeightMedium color:[UIColor colorWithRed:0.72 green:0.52 blue:0.18 alpha:1.0]];
    UILabel *priceLabel = [self labelWithText:price size:19.0 weight:UIFontWeightSemibold color:BLMallPink()];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.minimumScaleFactor = 0.72;
    [card addSubview:titleLabel];
    [card addSubview:metaLabel];
    [card addSubview:priceLabel];

    CGFloat imageHeight = tall ? 218.0 : 174.0;
    [NSLayoutConstraint activateConstraints:@[
        [image.topAnchor constraintEqualToAnchor:card.topAnchor],
        [image.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [image.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [image.heightAnchor constraintEqualToConstant:imageHeight],
        [art.centerXAnchor constraintEqualToAnchor:image.centerXAnchor],
        [art.centerYAnchor constraintEqualToAnchor:image.centerYAnchor],
        [titleLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:10.0],
        [titleLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-10.0],
        [titleLabel.topAnchor constraintEqualToAnchor:image.bottomAnchor constant:10.0],
        [metaLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [metaLabel.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
        [metaLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:6.0],
        [priceLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [priceLabel.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
        [priceLabel.topAnchor constraintEqualToAnchor:metaLabel.bottomAnchor constant:7.0],
        [priceLabel.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-12.0]
    ]];
    return card;
}

- (void)startCouponTimer {
    [self updateCouponLabels];
    self.couponTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(couponTimerTick) userInfo:nil repeats:YES];
}

- (void)couponTimerTick {
    if (self.couponRemainingSeconds <= 0) {
        [self.couponTimer invalidate];
        self.couponExpired = YES;
        [self hideCouponViews];
        return;
    }
    self.couponRemainingSeconds -= 1;
    [self updateCouponLabels];
}

- (void)updateCouponLabels {
    NSString *text = [self couponTimeText];
    self.mainCouponTimeLabel.text = text;
    self.floatingCouponTimeLabel.text = text;
}

- (NSString *)couponTimeText {
    NSInteger seconds = MAX(0, self.couponRemainingSeconds);
    NSInteger hours = seconds / 3600;
    NSInteger minutes = (seconds % 3600) / 60;
    NSInteger secs = seconds % 60;
    return [NSString stringWithFormat:@"\u4ec5\u5269%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)secs];
}

- (void)hideCouponViews {
    self.floatingCoupon.hidden = YES;
    self.mainCouponTimeLabel.superview.hidden = YES;
}

- (UIView *)bottomSpacer {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.heightAnchor constraintEqualToConstant:18.0].active = YES;
    return view;
}

- (UIImageView *)iconWithSymbol:(NSString *)symbol size:(CGFloat)size color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:size weight:UIImageSymbolWeightRegular];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:config]];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    icon.tintColor = color;
    icon.contentMode = UIViewContentModeScaleAspectFit;
    return icon;
}

- (UILabel *)labelWithText:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.floatingCouponClosed || self.couponExpired) {
        return;
    }
    self.floatingCoupon.hidden = scrollView.contentOffset.y < 330.0;
}

- (void)closeFloatingCoupon {
    self.floatingCouponClosed = YES;
    self.floatingCoupon.hidden = YES;
}

@end
