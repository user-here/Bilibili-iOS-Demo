#import "BLAnimeCarouselView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLAnimeCarouselCell : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation BLAnimeCarouselCell

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle episode:(NSString *)episode colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.layer.masksToBounds = YES;

        UIColor *startColor = colors.firstObject ?: [UIColor colorWithRed:0.14 green:0.36 blue:0.27 alpha:1.0];
        UIColor *endColor = colors.lastObject ?: [UIColor colorWithRed:0.42 green:0.62 blue:0.46 alpha:1.0];
        self.backgroundColor = startColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];

        UIView *shade = [[UIView alloc] init];
        shade.translatesAutoresizingMaskIntoConstraints = NO;
        shade.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.24];
        [self addSubview:shade];

        UILabel *hero = [self labelWithText:title font:[UIFont systemFontOfSize:38.0 weight:UIFontWeightSemibold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.92]];
        hero.textAlignment = NSTextAlignmentCenter;
        hero.numberOfLines = 2;
        [self addSubview:hero];

        UILabel *subtitleLabel = [self labelWithText:subtitle font:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium] color:[[UIColor whiteColor] colorWithAlphaComponent:0.95]];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:subtitleLabel];

        UILabel *episodeLabel = [self labelWithText:episode font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[[UIColor whiteColor] colorWithAlphaComponent:0.90]];
        episodeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:episodeLabel];

        [NSLayoutConstraint activateConstraints:@[
            [shade.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [shade.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [shade.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [shade.heightAnchor constraintEqualToConstant:92.0],
            [hero.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [hero.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-4.0],
            [hero.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:24.0],
            [hero.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-24.0],
            [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18.0],
            [subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18.0],
            [subtitleLabel.bottomAnchor constraintEqualToAnchor:episodeLabel.topAnchor constant:-6.0],
            [episodeLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18.0],
            [episodeLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18.0],
            [episodeLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-30.0]
        ]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
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

@interface BLAnimeCarouselView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray<BLAnimeCarouselCell *> *cells;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BLAnimeCarouselView

- (instancetype)initWithItems:(NSArray<NSDictionary<NSString *, id> *> *)items {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];

        NSMutableArray *cells = [NSMutableArray array];
        for (NSDictionary<NSString *, id> *item in items) {
            BLAnimeCarouselCell *cell = [[BLAnimeCarouselCell alloc] initWithTitle:item[@"title"] ?: @"" subtitle:item[@"subtitle"] ?: @"" episode:item[@"episode"] ?: @"" colors:item[@"colors"] ?: @[]];
            [self.scrollView addSubview:cell];
            [cells addObject:cell];
        }
        self.cells = cells.copy;

        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        self.pageControl.numberOfPages = self.cells.count;
        self.pageControl.currentPage = 0;
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.55];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.pageControl];

        [NSLayoutConstraint activateConstraints:@[
            [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [self.pageControl.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.pageControl.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0],
            [self.pageControl.heightAnchor constraintEqualToConstant:18.0]
        ]];

        [self startTimer];
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    for (NSUInteger index = 0; index < self.cells.count; index++) {
        self.cells[index].frame = CGRectMake(width * index, 0.0, width, height);
    }
    self.scrollView.contentSize = CGSizeMake(width * self.cells.count, height);
}

- (void)startTimer {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.8 repeats:YES block:^(NSTimer *timer) {
        [weakSelf advance];
    }];
}

- (void)advance {
    if (self.cells.count == 0 || CGRectGetWidth(self.scrollView.bounds) <= 0.0) {
        return;
    }
    NSInteger nextPage = (self.pageControl.currentPage + 1) % self.cells.count;
    CGPoint offset = CGPointMake(CGRectGetWidth(self.scrollView.bounds) * nextPage, 0.0);
    [self.scrollView setContentOffset:offset animated:YES];
    self.pageControl.currentPage = nextPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    if (width <= 0.0) {
        return;
    }
    self.pageControl.currentPage = (NSInteger)lrint(scrollView.contentOffset.x / width);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
