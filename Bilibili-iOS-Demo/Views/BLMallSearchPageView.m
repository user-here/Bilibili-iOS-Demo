#import "BLMallSearchPageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLMallSearchPurple(void) { return [UIColor colorWithRed:0.74 green:0.38 blue:0.95 alpha:1.0]; }

@interface BLMallSearchGradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLMallSearchGradientView
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

@interface BLMallSearchPageView () <UIScrollViewDelegate>
@property (nonatomic, strong) BLMallSearchGradientView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@end

@implementation BLMallSearchPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.headerView = [[BLMallSearchGradientView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.colors = @[
        [UIColor colorWithRed:0.68 green:0.36 blue:0.94 alpha:1.0],
        [UIColor colorWithRed:0.87 green:0.53 blue:0.94 alpha:1.0]
    ];
    [self addSubview:self.headerView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    backButton.tintColor = [UIColor whiteColor];
    UIImageSymbolConfiguration *backConfig = [UIImageSymbolConfiguration configurationWithPointSize:30.0 weight:UIImageSymbolWeightRegular];
    [backButton setImage:[[UIImage systemImageNamed:@"chevron.left"] imageWithConfiguration:backConfig] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:backButton];

    UIView *searchBox = [[UIView alloc] init];
    searchBox.translatesAutoresizingMaskIntoConstraints = NO;
    searchBox.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
    searchBox.layer.cornerRadius = 24.0;
    [self.headerView addSubview:searchBox];

    UITextField *field = [[UITextField alloc] init];
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"\u9b54\u529b\u8d4f" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.76]}];
    field.textColor = [UIColor whiteColor];
    field.tintColor = [UIColor colorWithRed:0.35 green:0.92 blue:1.0 alpha:1.0];
    field.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightRegular];
    [searchBox addSubview:field];

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [searchButton setTitle:@"\u641c\u7d22" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightMedium];
    [self.headerView addSubview:searchButton];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 22.0;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self discoverySection]];
    [self.contentStack addArrangedSubview:[self recommendationCarousel]];
    [self.contentStack addArrangedSubview:[self bottomSpacer]];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:74.0],
        [backButton.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:18.0],
        [backButton.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:-12.0],
        [backButton.widthAnchor constraintEqualToConstant:42.0],
        [backButton.heightAnchor constraintEqualToConstant:48.0],
        [searchBox.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:12.0],
        [searchBox.trailingAnchor constraintEqualToAnchor:searchButton.leadingAnchor constant:-14.0],
        [searchBox.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [searchBox.heightAnchor constraintEqualToConstant:48.0],
        [field.leadingAnchor constraintEqualToAnchor:searchBox.leadingAnchor constant:18.0],
        [field.trailingAnchor constraintEqualToAnchor:searchBox.trailingAnchor constant:-12.0],
        [field.topAnchor constraintEqualToAnchor:searchBox.topAnchor],
        [field.bottomAnchor constraintEqualToAnchor:searchBox.bottomAnchor],
        [searchButton.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-20.0],
        [searchButton.centerYAnchor constraintEqualToAnchor:searchBox.centerYAnchor],
        [searchButton.widthAnchor constraintEqualToConstant:72.0],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
}

- (UIView *)discoverySection {
    UIStackView *section = [[UIStackView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 18.0;
    section.layoutMargins = UIEdgeInsetsMake(24.0, 18.0, 0.0, 18.0);
    section.layoutMarginsRelativeArrangement = YES;

    UILabel *title = [self labelWithText:@"\u641c\u7d22\u53d1\u73b0" size:23.0 weight:UIFontWeightSemibold color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    [section addArrangedSubview:title];

    UIStackView *row1 = [self chipRow];
    [row1 addArrangedSubview:[self hotChipWithText:@"\u6bcf\u65e5\u6d88\u8d39TOP1\u9886\u795e\u5238" hot:YES]];
    [row1 addArrangedSubview:[self hotChipWithText:@"\u4f4e\u81f312\u5143\u62bd\u624b\u529e" hot:YES]];
    [section addArrangedSubview:row1];

    UIStackView *row2 = [self chipRow];
    [row2 addArrangedSubview:[self hotChipWithText:@"\u5851\u6599\u5c0f\u4eba\u624b\u529e\u4e0a\u65b0" hot:YES]];
    [row2 addArrangedSubview:[self hotChipWithText:@"\u70ed\u95e8IP\u62bd\u60ca\u559c\u8d4f" hot:NO]];
    [section addArrangedSubview:row2];
    return section;
}

- (UIStackView *)chipRow {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 14.0;
    row.distribution = UIStackViewDistributionFillEqually;
    return row;
}

- (UIView *)hotChipWithText:(NSString *)text hot:(BOOL)hot {
    UIView *chip = [[UIView alloc] init];
    chip.translatesAutoresizingMaskIntoConstraints = NO;
    chip.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    chip.layer.cornerRadius = 22.0;
    [chip.heightAnchor constraintEqualToConstant:44.0].active = YES;
    UILabel *label = [self labelWithText:text size:17.0 weight:UIFontWeightMedium color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    [chip addSubview:label];
    UILabel *hotLabel = [self labelWithText:@"\u70ed" size:13.0 weight:UIFontWeightBold color:[UIColor whiteColor]];
    hotLabel.textAlignment = NSTextAlignmentCenter;
    hotLabel.backgroundColor = [UIColor colorWithRed:0.86 green:0.22 blue:0.24 alpha:1.0];
    hotLabel.layer.cornerRadius = 5.0;
    hotLabel.layer.masksToBounds = YES;
    hotLabel.hidden = !hot;
    [chip addSubview:hotLabel];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerYAnchor constraintEqualToAnchor:chip.centerYAnchor],
        [label.leadingAnchor constraintEqualToAnchor:chip.leadingAnchor constant:18.0],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:hotLabel.leadingAnchor constant:-8.0],
        [hotLabel.trailingAnchor constraintEqualToAnchor:chip.trailingAnchor constant:-16.0],
        [hotLabel.centerYAnchor constraintEqualToAnchor:chip.centerYAnchor],
        [hotLabel.widthAnchor constraintEqualToConstant:24.0],
        [hotLabel.heightAnchor constraintEqualToConstant:24.0]
    ]];
    return chip;
}

- (UIView *)recommendationCarousel {
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.alwaysBounceHorizontal = YES;
    [scroll.heightAnchor constraintEqualToConstant:470.0].active = YES;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 14.0;
    stack.layoutMargins = UIEdgeInsetsMake(0.0, 14.0, 0.0, 14.0);
    stack.layoutMarginsRelativeArrangement = YES;
    [scroll addSubview:stack];

    [stack addArrangedSubview:[self goodsRankCard]];
    [stack addArrangedSubview:[self ipRecommendCard]];
    [stack addArrangedSubview:[self roleRecommendCard]];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.heightAnchor]
    ]];
    return scroll;
}

- (UIView *)baseRecommendCardWithTitle:(NSString *)title {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 10.0;
    card.layer.masksToBounds = YES;
    [card.widthAnchor constraintEqualToConstant:292.0].active = YES;

    UIImageSymbolConfiguration *fireConfig = [UIImageSymbolConfiguration configurationWithPointSize:21.0 weight:UIImageSymbolWeightSemibold];
    UIImageView *fire = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:@"flame.fill"] imageWithConfiguration:fireConfig]];
    fire.translatesAutoresizingMaskIntoConstraints = NO;
    fire.tintColor = [UIColor colorWithRed:0.92 green:0.24 blue:0.20 alpha:1.0];
    fire.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *titleLabel = [self labelWithText:title size:22.0 weight:UIFontWeightSemibold color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    [card addSubview:fire];
    [card addSubview:titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [fire.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [fire.topAnchor constraintEqualToAnchor:card.topAnchor constant:22.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:fire.trailingAnchor constant:8.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:fire.centerYAnchor]
    ]];
    return card;
}

- (UIView *)goodsRankCard {
    UIView *card = [self baseRecommendCardWithTitle:@"\u70ed\u641c\u5546\u54c1\u699c"];
    NSArray *items = @[
        @[@"1", @"\u5439\u5317\u5973\u89d2\u592a\u591a\u4e86 \u56fe\u4e66\u6f2b\u753b", @"\u70ed\u5ea6\u503c1632", @YES],
        @[@"2", @"\u9b54\u9053\u7956\u5e08 \u56fe\u4e66\u6f2b\u753b", @"\u65e9\u4e70\u65e9\u5212\u7b97\uff0c\u9650\u65f6\u51cf\u5c3e\u6b3e", @YES],
        @[@"3", @"VOCALOID \u5468\u8fb9", @"N\u4ef6N\u6298", @YES],
        @[@"4", @"\u539f\u521b \u6a21\u578b\u5175\u4eba", @"\u70ed\u5ea6\u503c807", @NO],
        @[@"5", @"\u98de\u5929\u5c0f\u5973\u8b66 \u5468\u8fb9", @"\u70ed\u5ea6\u503c716", @NO],
        @[@"6", @"\u9e23\u6f6e \u5468\u8fb9", @"\u6b27\u6c14\u5b9d\u7bb1\uff0c\u9650\u65f6\u51cf\u5c3e\u6b3e", @NO]
    ];
    UIStackView *list = [self verticalListInCard:card];
    for (NSArray *item in items) {
        [list addArrangedSubview:[self rankRowWithNumber:item[0] title:item[1] subtitle:item[2] showThumb:[item[3] boolValue]]];
    }
    return card;
}

- (UIView *)ipRecommendCard {
    UIView *card = [self baseRecommendCardWithTitle:@"\u4e3a\u4f60\u63a8\u8350\u7684IP"];
    NSArray *items = @[
        @[@"\u9e23\u6f6e", @"92\u4ef6\u65b0\u54c1"],
        @[@"\u53d8\u5f62\u91d1\u521a\u7cfb\u5217", @"54\u4ef6\u65b0\u54c1"],
        @[@"\u5965\u7279\u66fc\u7cfb\u5217", @"178\u4ef6\u65b0\u54c1"],
        @[@"\u6f2b\u5a01", @"58\u4ef6\u65b0\u54c1"],
        @[@"OVERLORD", @"6\u4ef6\u65b0\u54c1"],
        @[@"\u4e00\u4eba\u4e4b\u4e0b", @"14\u4ef6\u65b0\u54c1"],
        @[@"Fate\u7cfb\u5217", @"191\u4ef6\u65b0\u54c1"],
        @[@"VOCALOID", @"207\u4ef6\u65b0\u54c1"]
    ];
    UIStackView *list = [self verticalListInCard:card];
    for (NSArray *item in items) {
        [list addArrangedSubview:[self tagRowWithTitle:item[0] tag:item[1]]];
    }
    return card;
}

- (UIView *)roleRecommendCard {
    UIView *card = [self baseRecommendCardWithTitle:@"\u4e3a\u4f60\u63a8\u8350\u7684\u89d2\u8272"];
    NSArray *roles = @[
        @"\u83f2\u6bd4", @"\u4e1d\u67ef\u514b", @"\u96f7\u7535\u5c06\u519b", @"\u53f6\u52a0\u6fc0\u51ac\u96ea", @"\u6d1b\u5929\u4f9d",
        @"\u5e7b\u9e9f\u795e", @"\u57c3\u683c\u59ae\u4e1d", @"\u7433\u5948", @"\u521d\u97f3\u672a\u6765", @"\u963f\u5c14\u6258\u8389\u96c5[Alter]"
    ];
    UIStackView *list = [self verticalListInCard:card];
    for (NSString *role in roles) {
        UILabel *label = [self labelWithText:role size:18.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.18 alpha:1.0]];
        [label.heightAnchor constraintEqualToConstant:35.0].active = YES;
        [list addArrangedSubview:label];
    }
    return card;
}

- (UIStackView *)verticalListInCard:(UIView *)card {
    UIStackView *list = [[UIStackView alloc] init];
    list.translatesAutoresizingMaskIntoConstraints = NO;
    list.axis = UILayoutConstraintAxisVertical;
    list.spacing = 10.0;
    [card addSubview:list];
    [NSLayoutConstraint activateConstraints:@[
        [list.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [list.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18.0],
        [list.topAnchor constraintEqualToAnchor:card.topAnchor constant:70.0],
        [list.bottomAnchor constraintLessThanOrEqualToAnchor:card.bottomAnchor constant:-18.0]
    ]];
    return list;
}

- (UIView *)rankRowWithNumber:(NSString *)number title:(NSString *)title subtitle:(NSString *)subtitle showThumb:(BOOL)showThumb {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    [row.heightAnchor constraintEqualToConstant:54.0].active = YES;

    UILabel *num = [self labelWithText:number size:16.0 weight:UIFontWeightBold color:[UIColor whiteColor]];
    num.textAlignment = NSTextAlignmentCenter;
    num.backgroundColor = number.integerValue <= 3 ? [UIColor colorWithRed:0.95 green:0.42 blue:0.18 alpha:1.0] : [UIColor colorWithWhite:0.78 alpha:1.0];
    num.layer.cornerRadius = 4.0;
    num.layer.masksToBounds = YES;
    [row addSubview:num];

    UIView *thumb = [[UIView alloc] init];
    thumb.translatesAutoresizingMaskIntoConstraints = NO;
    thumb.backgroundColor = showThumb ? [UIColor colorWithRed:0.88 green:0.84 blue:0.94 alpha:1.0] : [UIColor clearColor];
    thumb.layer.cornerRadius = 4.0;
    [row addSubview:thumb];

    UILabel *titleLabel = [self labelWithText:title size:17.0 weight:UIFontWeightMedium color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    UILabel *subLabel = [self labelWithText:subtitle size:14.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.45 alpha:1.0]];
    [row addSubview:titleLabel];
    [row addSubview:subLabel];

    [NSLayoutConstraint activateConstraints:@[
        [num.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [num.topAnchor constraintEqualToAnchor:row.topAnchor constant:4.0],
        [num.widthAnchor constraintEqualToConstant:26.0],
        [num.heightAnchor constraintEqualToConstant:26.0],
        [thumb.leadingAnchor constraintEqualToAnchor:num.trailingAnchor constant:8.0],
        [thumb.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [thumb.widthAnchor constraintEqualToConstant:48.0],
        [thumb.heightAnchor constraintEqualToConstant:48.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:thumb.trailingAnchor constant:10.0],
        [titleLabel.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:row.topAnchor constant:4.0],
        [subLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [subLabel.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
        [subLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4.0]
    ]];
    return row;
}

- (UIView *)tagRowWithTitle:(NSString *)title tag:(NSString *)tag {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    [row.heightAnchor constraintEqualToConstant:39.0].active = YES;
    UILabel *titleLabel = [self labelWithText:title size:18.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.14 alpha:1.0]];
    UILabel *tagLabel = [self labelWithText:tag size:14.0 weight:UIFontWeightMedium color:[UIColor colorWithRed:0.78 green:0.56 blue:0.26 alpha:1.0]];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.layer.borderWidth = 1.0;
    tagLabel.layer.borderColor = [UIColor colorWithRed:0.82 green:0.63 blue:0.34 alpha:1.0].CGColor;
    tagLabel.layer.cornerRadius = 7.0;
    tagLabel.layer.masksToBounds = YES;
    [row addSubview:titleLabel];
    [row addSubview:tagLabel];
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [tagLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:titleLabel.trailingAnchor constant:8.0],
        [tagLabel.trailingAnchor constraintLessThanOrEqualToAnchor:row.trailingAnchor],
        [tagLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [tagLabel.heightAnchor constraintEqualToConstant:26.0],
        [tagLabel.widthAnchor constraintGreaterThanOrEqualToConstant:78.0]
    ]];
    return row;
}

- (UIView *)bottomSpacer {
    UIView *spacer = [[UIView alloc] init];
    spacer.translatesAutoresizingMaskIntoConstraints = NO;
    [spacer.heightAnchor constraintEqualToConstant:260.0].active = YES;
    return spacer;
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

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

@end
