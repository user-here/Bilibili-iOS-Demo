#import "BLPublishPageView.h"
#import "BLCapturePublishView.h"
#import "BLAlbumUploadView.h"

typedef NS_ENUM(NSInteger, BLPublishTab) {
    BLPublishTabCapture,
    BLPublishTabUpload,
    BLPublishTabLive,
    BLPublishTabArticle
};

static UIColor *BLPublishPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

@interface BLPublishPlaceholderView : UIView
- (instancetype)initWithTitle:(NSString *)title symbol:(NSString *)symbol;
@end

@implementation BLPublishPlaceholderView

- (instancetype)initWithTitle:(NSString *)title symbol:(NSString *)symbol {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor blackColor];
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:52.0 weight:UIImageSymbolWeightRegular];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:config]];
        icon.translatesAutoresizingMaskIntoConstraints = NO;
        icon.tintColor = [UIColor colorWithWhite:0.35 alpha:1.0];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:icon];

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = title;
        label.textColor = [UIColor colorWithWhite:0.72 alpha:1.0];
        label.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
        [self addSubview:label];

        [NSLayoutConstraint activateConstraints:@[
            [icon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [icon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-26.0],
            [icon.widthAnchor constraintEqualToConstant:64.0],
            [icon.heightAnchor constraintEqualToConstant:64.0],
            [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [label.topAnchor constraintEqualToAnchor:icon.bottomAnchor constant:18.0]
        ]];
    }
    return self;
}

@end

@interface BLPublishPageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) UIView *bottomTabBar;
@property (nonatomic, strong) UIStackView *tabStack;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) NSArray<UIView *> *tabIndicators;
@property (nonatomic, strong) BLCapturePublishView *captureView;
@property (nonatomic, strong) BLAlbumUploadView *uploadView;
@property (nonatomic, assign) BLPublishTab selectedTab;
@end

@implementation BLPublishPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor blackColor];
        self.selectedTab = BLPublishTabUpload;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.delegate = self;
    [self addSubview:self.contentScrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisHorizontal;
    self.contentStack.alignment = UIStackViewAlignmentFill;
    self.contentStack.distribution = UIStackViewDistributionFillEqually;
    [self.contentScrollView addSubview:self.contentStack];

    self.captureView = [[BLCapturePublishView alloc] init];
    self.uploadView = [[BLAlbumUploadView alloc] init];
    UIView *liveView = [[BLPublishPlaceholderView alloc] initWithTitle:@"开直播" symbol:@"dot.radiowaves.left.and.right"];
    UIView *articleView = [[BLPublishPlaceholderView alloc] initWithTitle:@"发图文" symbol:@"photo.badge.plus"];
    NSArray<UIView *> *pages = @[self.captureView, self.uploadView, liveView, articleView];
    for (UIView *page in pages) {
        [self.contentStack addArrangedSubview:page];
        [page.widthAnchor constraintEqualToAnchor:self.contentScrollView.frameLayoutGuide.widthAnchor].active = YES;
    }

    self.bottomTabBar = [[UIView alloc] init];
    self.bottomTabBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomTabBar.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bottomTabBar];

    self.tabStack = [[UIStackView alloc] init];
    self.tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabStack.axis = UILayoutConstraintAxisHorizontal;
    self.tabStack.distribution = UIStackViewDistributionFillEqually;
    self.tabStack.alignment = UIStackViewAlignmentCenter;
    [self.bottomTabBar addSubview:self.tabStack];

    NSArray *titles = @[@"拍摄", @"上传", @"开直播", @"发图文"];
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *indicators = [NSMutableArray array];
    for (NSInteger index = 0; index < titles.count; index++) {
        UIStackView *tab = [[UIStackView alloc] init];
        tab.axis = UILayoutConstraintAxisVertical;
        tab.alignment = UIStackViewAlignmentCenter;
        tab.spacing = 8.0;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightSemibold];
        [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tab addArrangedSubview:button];

        UIView *indicator = [[UIView alloc] init];
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        indicator.backgroundColor = BLPublishPink();
        indicator.layer.cornerRadius = 3.0;
        [indicator.widthAnchor constraintEqualToConstant:30.0].active = YES;
        [indicator.heightAnchor constraintEqualToConstant:6.0].active = YES;
        [tab addArrangedSubview:indicator];
        [self.tabStack addArrangedSubview:tab];
        [buttons addObject:button];
        [indicators addObject:indicator];
    }
    self.tabButtons = buttons;
    self.tabIndicators = indicators;

    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeButton.tintColor = [UIColor whiteColor];
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:26.0 weight:UIImageSymbolWeightRegular];
    [self.closeButton setImage:[[UIImage systemImageNamed:@"xmark"] imageWithConfiguration:config] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.contentScrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.contentScrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.contentScrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.contentScrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.contentScrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.contentScrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.contentScrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.contentScrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStack.heightAnchor constraintEqualToAnchor:self.contentScrollView.frameLayoutGuide.heightAnchor],
        [self.bottomTabBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.bottomTabBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.bottomTabBar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.bottomTabBar.heightAnchor constraintEqualToConstant:112.0],
        [self.tabStack.leadingAnchor constraintEqualToAnchor:self.bottomTabBar.leadingAnchor],
        [self.tabStack.trailingAnchor constraintEqualToAnchor:self.bottomTabBar.trailingAnchor],
        [self.tabStack.topAnchor constraintEqualToAnchor:self.bottomTabBar.topAnchor constant:12.0],
        [self.tabStack.heightAnchor constraintEqualToConstant:64.0],
        [self.closeButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:30.0],
        [self.closeButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:24.0],
        [self.closeButton.widthAnchor constraintEqualToConstant:42.0],
        [self.closeButton.heightAnchor constraintEqualToConstant:42.0]
    ]];
    [self updateSelectedTabAnimated:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSelectedTabAnimated:NO];
}

- (void)activate {
    [self.uploadView reloadAssets];
    [self updateCaptureState];
}

- (void)deactivate {
    [self.captureView stopCamera];
}

- (void)tabTapped:(UIButton *)button {
    self.selectedTab = button.tag;
    [self updateSelectedTabAnimated:YES];
}

- (void)updateSelectedTabAnimated:(BOOL)animated {
    CGFloat width = CGRectGetWidth(self.contentScrollView.bounds);
    if (width > 0.0) {
        CGPoint offset = CGPointMake(width * self.selectedTab, 0.0);
        [self.contentScrollView setContentOffset:offset animated:animated];
    }
    for (NSInteger index = 0; index < self.tabButtons.count; index++) {
        BOOL selected = index == self.selectedTab;
        UIButton *button = self.tabButtons[index];
        [button setTitleColor:selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateNormal];
        self.tabIndicators[index].hidden = !selected;
    }
    [self updateCaptureState];
}

- (void)updateCaptureState {
    if (self.selectedTab == BLPublishTabCapture && self.window != nil) {
        [self.captureView startCamera];
    } else {
        [self.captureView stopCamera];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = MAX(1.0, CGRectGetWidth(scrollView.bounds));
    self.selectedTab = (NSInteger)round(scrollView.contentOffset.x / width);
    [self updateSelectedTabAnimated:NO];
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

@end
