#import "BLLiveCarouselView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLLivePink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

@implementation BLLiveCarouselItem

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors {
    BLLiveCarouselItem *item = [[BLLiveCarouselItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    item.badge = badge;
    item.colors = colors;
    return item;
}

@end

@interface BLLiveCarouselCardView : UIView
@property (nonatomic, strong) BLLiveCarouselItem *item;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UIImageView *danmakuIcon;
@property (nonatomic, strong) UIImageView *speakerIcon;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation BLLiveCarouselCardView

- (instancetype)initWithItem:(BLLiveCarouselItem *)item {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.item = item;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = self.item.colors.firstObject ?: BLLivePink();
    [self addSubview:self.coverView];

    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[
        (__bridge id)self.item.colors.firstObject.CGColor,
        (__bridge id)self.item.colors.lastObject.CGColor
    ];
    self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    [self.coverView.layer insertSublayer:self.gradientLayer atIndex:0];

    self.titleLabel = [self labelWithText:self.item.title font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
    [self.coverView addSubview:self.titleLabel];

    self.badgeLabel = [self labelWithText:self.item.badge font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.backgroundColor = BLLivePink();
    self.badgeLabel.layer.cornerRadius = 4.0;
    self.badgeLabel.layer.masksToBounds = YES;
    [self.coverView addSubview:self.badgeLabel];

    self.symbolLabel = [self labelWithText:@"LIVE" font:[UIFont systemFontOfSize:38.0 weight:UIFontWeightBold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.86]];
    self.symbolLabel.textAlignment = NSTextAlignmentCenter;
    [self.coverView addSubview:self.symbolLabel];

    self.danmakuIcon = [self iconView:@"text.bubble" pointSize:25.0];
    self.speakerIcon = [self iconView:@"speaker.wave.2" pointSize:25.0];
    [self.coverView addSubview:self.danmakuIcon];
    [self.coverView addSubview:self.speakerIcon];

    self.subtitleLabel = [self labelWithText:self.item.subtitle font:[UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular] color:[UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1.0]];
    self.subtitleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.subtitleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat coverHeight = MAX(0.0, height - 58.0);
    self.coverView.frame = CGRectMake(0.0, 0.0, width, coverHeight);
    self.gradientLayer.frame = self.coverView.bounds;
    self.subtitleLabel.frame = CGRectMake(18.0, coverHeight, width - 36.0, 58.0);
    self.titleLabel.frame = CGRectMake(18.0, 20.0, MAX(0.0, width - 128.0), 30.0);
    self.badgeLabel.frame = CGRectMake(width - 106.0, 18.0, 88.0, 32.0);
    self.symbolLabel.frame = CGRectMake(20.0, (coverHeight - 48.0) / 2.0, width - 40.0, 48.0);
    self.speakerIcon.frame = CGRectMake(width - 48.0, coverHeight - 48.0, 30.0, 30.0);
    self.danmakuIcon.frame = CGRectMake(CGRectGetMinX(self.speakerIcon.frame) - 52.0, CGRectGetMinY(self.speakerIcon.frame), 30.0, 30.0);
}

- (UIImageView *)iconView:(NSString *)name pointSize:(CGFloat)pointSize {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.tintColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end

@interface BLLiveCarouselView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<BLLiveCarouselCardView *> *cards;
@property (nonatomic, strong) NSArray<BLLiveCarouselItem *> *items;
@property (nonatomic, assign) CGFloat cardWidth;
@property (nonatomic, assign) CGFloat cardSpacing;
@property (nonatomic, assign) BOOL didSetInitialOffset;
@end

@implementation BLLiveCarouselView

- (instancetype)initWithItems:(NSArray<BLLiveCarouselItem *> *)items {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.items = items;
        self.cardSpacing = 10.0;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];

    NSMutableArray *cards = [NSMutableArray array];
    NSMutableArray *displayItems = [NSMutableArray array];
    if (self.items.count > 1) {
        [displayItems addObject:self.items.lastObject];
        [displayItems addObjectsFromArray:self.items];
        [displayItems addObject:self.items.firstObject];
    } else {
        [displayItems addObjectsFromArray:self.items];
    }

    for (BLLiveCarouselItem *item in displayItems) {
        BLLiveCarouselCardView *card = [[BLLiveCarouselCardView alloc] initWithItem:item];
        [self.scrollView addSubview:card];
        [cards addObject:card];
    }
    self.cards = cards;

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    if (width <= 0.0) {
        return;
    }
    self.cardWidth = width * 0.78;
    CGFloat x = (width - self.cardWidth) / 2.0;
    CGFloat cardHeight = CGRectGetHeight(self.bounds) - 16.0;
    for (UIView *card in self.cards) {
        card.frame = CGRectMake(x, 8.0, self.cardWidth, cardHeight);
        x += self.cardWidth + self.cardSpacing;
    }
    self.scrollView.contentSize = CGSizeMake(x - self.cardSpacing + (width - self.cardWidth) / 2.0, CGRectGetHeight(self.bounds));
    if (!self.didSetInitialOffset && self.cards.count > self.items.count) {
        self.scrollView.contentOffset = CGPointMake(self.cardWidth + self.cardSpacing, 0.0);
        self.didSetInitialOffset = YES;
    }
    [self updateCardTransforms];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCardTransforms];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat page = self.cardWidth + self.cardSpacing;
    NSInteger index = (NSInteger)round(targetContentOffset->x / page);
    index = MAX(0, MIN(index, (NSInteger)self.cards.count - 1));
    targetContentOffset->x = index * page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self normalizeInfiniteOffsetIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self normalizeInfiniteOffsetIfNeeded];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self normalizeInfiniteOffsetIfNeeded];
}

- (void)normalizeInfiniteOffsetIfNeeded {
    if (self.items.count <= 1 || self.cards.count <= self.items.count || self.cardWidth <= 0.0) {
        return;
    }
    CGFloat page = self.cardWidth + self.cardSpacing;
    NSInteger index = (NSInteger)round(self.scrollView.contentOffset.x / page);
    if (index == 0) {
        self.scrollView.contentOffset = CGPointMake(page * (self.cards.count - 2), 0.0);
    } else if (index == (NSInteger)self.cards.count - 1) {
        self.scrollView.contentOffset = CGPointMake(page, 0.0);
    }
    [self updateCardTransforms];
}

- (void)updateCardTransforms {
    CGFloat centerX = self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds) / 2.0;
    for (UIView *card in self.cards) {
        CGFloat distance = fabs(CGRectGetMidX(card.frame) - centerX);
        CGFloat progress = MIN(1.0, distance / (self.cardWidth + self.cardSpacing));
        CGFloat scale = 1.0 - 0.10 * progress;
        card.transform = CGAffineTransformMakeScale(scale, scale);
        card.alpha = 1.0 - 0.06 * progress;
    }
}

@end
