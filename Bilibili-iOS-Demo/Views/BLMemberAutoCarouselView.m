#import "BLMemberAutoCarouselView.h"

@interface BLMemberAutoCarouselView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, strong, nullable) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation BLMemberAutoCarouselView

- (instancetype)initWithItems:(NSArray<NSString *> *)items {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.items = items;
        [self buildView];
    }
    return self;
}

- (void)dealloc {
    [self stopAutoScroll];
}

- (void)buildView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];

    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.spacing = 12.0;
    [self.scrollView addSubview:self.stackView];

    for (NSInteger i = 0; i < self.items.count; i++) {
        UIView *card = [self bannerCard:self.items[i] index:i];
        [self.stackView addArrangedSubview:card];
        [card.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor constant:-58.0].active = YES;
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.stackView.heightAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.heightAnchor]
    ]];
}

- (UIView *)bannerCard:(NSString *)title index:(NSInteger)index {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.layer.cornerRadius = 10.0;
    card.layer.masksToBounds = YES;
    card.backgroundColor = [self colorForIndex:index];
    UILabel *badge = [self label:@"大会员" size:12.0 weight:UIFontWeightSemibold color:[UIColor whiteColor]];
    badge.textAlignment = NSTextAlignmentCenter;
    badge.backgroundColor = [UIColor colorWithRed:0.93 green:0.32 blue:0.57 alpha:1.0];
    badge.layer.cornerRadius = 9.0;
    badge.layer.masksToBounds = YES;
    UILabel *label = [self label:title size:16.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    label.numberOfLines = 2;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor colorWithRed:0.94 green:0.33 blue:0.58 alpha:1.0];
    button.layer.cornerRadius = 15.0;
    [button setTitle:@"立即参与" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [card addSubview:badge];
    [card addSubview:label];
    [card addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [badge.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14.0],
        [badge.topAnchor constraintEqualToAnchor:card.topAnchor constant:12.0],
        [badge.widthAnchor constraintEqualToConstant:58.0],
        [badge.heightAnchor constraintEqualToConstant:20.0],
        [label.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [label.topAnchor constraintEqualToAnchor:badge.bottomAnchor constant:10.0],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:button.leadingAnchor constant:-12.0],
        [label.bottomAnchor constraintLessThanOrEqualToAnchor:card.bottomAnchor constant:-12.0],
        [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [button.centerYAnchor constraintEqualToAnchor:label.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:92.0],
        [button.heightAnchor constraintEqualToConstant:30.0]
    ]];
    return card;
}

- (void)startAutoScroll {
    [self stopAutoScroll];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)stopAutoScroll {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)tick {
    if (self.items.count == 0 || CGRectGetWidth(self.scrollView.bounds) <= 0.0) {
        return;
    }
    self.currentIndex = (self.currentIndex + 1) % self.items.count;
    CGFloat cardWidth = CGRectGetWidth(self.scrollView.bounds) - 58.0;
    CGFloat pageWidth = cardWidth + self.stackView.spacing;
    CGFloat maxX = MAX(0.0, self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds));
    CGFloat x = MIN(maxX, self.currentIndex * pageWidth);
    [self.scrollView setContentOffset:CGPointMake(x, 0.0) animated:YES];
}

- (UIColor *)colorForIndex:(NSInteger)index {
    NSArray *colors = @[
        [UIColor colorWithRed:0.18 green:0.37 blue:0.83 alpha:1.0],
        [UIColor colorWithRed:0.93 green:0.53 blue:0.70 alpha:1.0],
        [UIColor colorWithRed:0.37 green:0.42 blue:0.75 alpha:1.0],
        [UIColor colorWithRed:0.22 green:0.62 blue:0.72 alpha:1.0]
    ];
    return colors[index % colors.count];
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
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
