#import "BLProfileSpacePageView.h"
#import "BLProfileHeaderView.h"
#import "BLProfileTabBarView.h"
#import "BLProfileHomeContentView.h"
#import "BLProfileDynamicContentView.h"
#import "BLProfileSubmissionContentView.h"
#import "BLProfileFavoriteContentView.h"
#import "BLProfileBangumiContentView.h"

static UIColor *BLProfileSpaceText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }

@interface BLProfileSpacePageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UIImageView *moreIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *navSeparator;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) BLProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) BLProfileTabBarView *inlineTabBarView;
@property (nonatomic, strong) BLProfileTabBarView *tabBarView;
@property (nonatomic, strong) UIView *currentContentView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation BLProfileSpacePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
        [self switchToIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.selectedIndex != 0 && self.currentContentView != nil) {
        CGFloat topInset = CGRectGetHeight(self.navBar.bounds) + CGRectGetHeight(self.tabBarView.bounds);
        if (topInset > 64.0 && fabs(self.scrollView.contentInset.top - topInset) > 0.5) {
            [self updateScrollInsetsForSelectedIndex];
        }
    }
}

- (void)setProfileBackgroundImage:(UIImage *)image {
    [self.profileHeaderView updateBackgroundImage:image];
}

- (void)buildView {
    self.navBar = [[UIView alloc] init];
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.navBar.backgroundColor = [UIColor clearColor];
    [self addSubview:self.navBar];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    back.tintColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [back setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = back;
    [self.navBar addSubview:back];

    UILabel *title = [[UILabel alloc] init];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = @"阿狸爱吃狐狸";
    title.font = [UIFont systemFontOfSize:19.0 weight:UIFontWeightRegular];
    title.textColor = BLProfileSpaceText();
    title.textAlignment = NSTextAlignmentCenter;
    title.hidden = YES;
    self.titleLabel = title;
    [self.navBar addSubview:title];

    UIImageView *search = [self icon:@"magnifyingglass"];
    UIImageView *more = [self icon:@"ellipsis"];
    more.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.searchIcon = search;
    self.moreIcon = more;
    [self.navBar addSubview:search];
    [self.navBar addSubview:more];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    line.hidden = YES;
    self.navSeparator = line;
    [self.navBar addSubview:line];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 0.0;
    [self.scrollView addSubview:self.contentStack];

    self.profileHeaderView = [[BLProfileHeaderView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.profileHeaderView.backgroundTapped = ^{
        if (weakSelf.chooseBackgroundTapped) {
            weakSelf.chooseBackgroundTapped();
        }
    };
    [self.contentStack addArrangedSubview:self.profileHeaderView];
    [self.profileHeaderView.heightAnchor constraintEqualToConstant:500.0].active = YES;

    self.inlineTabBarView = [[BLProfileTabBarView alloc] init];
    self.inlineTabBarView.tabSelected = ^(NSInteger index) {
        [weakSelf switchToIndex:index];
    };
    [self.contentStack addArrangedSubview:self.inlineTabBarView];
    [self.inlineTabBarView.heightAnchor constraintEqualToConstant:64.0].active = YES;

    self.tabBarView = [[BLProfileTabBarView alloc] init];
    self.tabBarView.tabSelected = ^(NSInteger index) {
        [weakSelf switchToIndex:index];
    };
    self.tabBarView.hidden = YES;
    [self addSubview:self.tabBarView];

    [NSLayoutConstraint activateConstraints:@[
        [self.navBar.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.navBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.navBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.navBar.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:56.0],
        [back.leadingAnchor constraintEqualToAnchor:self.navBar.leadingAnchor constant:12.0],
        [back.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [back.widthAnchor constraintEqualToConstant:40.0],
        [back.heightAnchor constraintEqualToConstant:40.0],
        [title.centerXAnchor constraintEqualToAnchor:self.navBar.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [title.leadingAnchor constraintGreaterThanOrEqualToAnchor:back.trailingAnchor constant:12.0],
        [more.trailingAnchor constraintEqualToAnchor:self.navBar.trailingAnchor constant:-18.0],
        [more.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:24.0],
        [more.heightAnchor constraintEqualToConstant:24.0],
        [search.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-28.0],
        [search.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [search.widthAnchor constraintEqualToConstant:28.0],
        [search.heightAnchor constraintEqualToConstant:28.0],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:search.leadingAnchor constant:-12.0],
        [line.leadingAnchor constraintEqualToAnchor:self.navBar.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:self.navBar.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:self.navBar.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5],
        [self.tabBarView.topAnchor constraintEqualToAnchor:self.navBar.bottomAnchor],
        [self.tabBarView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tabBarView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tabBarView.heightAnchor constraintEqualToConstant:64.0],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
    [self bringSubviewToFront:self.navBar];
    [self bringSubviewToFront:self.tabBarView];
}

- (void)switchToIndex:(NSInteger)index {
    self.selectedIndex = index;
    [self.tabBarView selectIndex:index];
    [self.inlineTabBarView selectIndex:index];
    if (self.currentContentView != nil) {
        [self.contentStack removeArrangedSubview:self.currentContentView];
        [self.currentContentView removeFromSuperview];
    }
    self.profileHeaderView.hidden = index != 0;
    self.inlineTabBarView.hidden = index != 0;
    self.navBar.backgroundColor = index == 0 ? [UIColor clearColor] : [UIColor whiteColor];
    self.titleLabel.hidden = index == 0;
    self.navSeparator.hidden = index == 0;
    [self updateNavigationStylePinned:index != 0];
    UIView *content = [self contentViewForIndex:index];
    self.currentContentView = content;
    [self.contentStack addArrangedSubview:content];
    [self updateScrollInsetsForSelectedIndex];
    [self scrollViewDidScroll:self.scrollView];
}

- (void)updateScrollInsetsForSelectedIndex {
    if (self.selectedIndex == 0) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
        [self.scrollView setContentOffset:CGPointZero animated:NO];
        self.scrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return;
    }
    CGFloat topInset = CGRectGetHeight(self.navBar.bounds) + CGRectGetHeight(self.tabBarView.bounds);
    if (topInset <= 64.0) {
        topInset = 120.0;
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(topInset, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;
    self.scrollView.backgroundColor = [self backgroundColorForSelectedIndex];
    [self.scrollView setContentOffset:CGPointMake(0.0, -topInset) animated:NO];
}

- (UIColor *)backgroundColorForSelectedIndex {
    if (self.selectedIndex == 4) {
        return [UIColor colorWithWhite:0.95 alpha:1.0];
    }
    return [UIColor whiteColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.selectedIndex != 0) {
        return;
    }
    BOOL pinned = scrollView.contentOffset.y > 380.0;
    [self updateNavigationStylePinned:pinned];
    self.tabBarView.hidden = !pinned;
}

- (void)updateNavigationStylePinned:(BOOL)pinned {
    self.navBar.backgroundColor = pinned ? [UIColor whiteColor] : [UIColor clearColor];
    self.titleLabel.hidden = !pinned;
    self.navSeparator.hidden = !pinned;
    self.tabBarView.hidden = self.selectedIndex == 0 ? !pinned : NO;
    UIColor *color = pinned ? [UIColor colorWithWhite:0.32 alpha:1.0] : [UIColor whiteColor];
    self.backButton.tintColor = color;
    self.searchIcon.tintColor = color;
    self.moreIcon.tintColor = color;
}

- (UIView *)contentViewForIndex:(NSInteger)index {
    switch (index) {
        case 1:
            return [[BLProfileDynamicContentView alloc] init];
        case 2:
            return [[BLProfileSubmissionContentView alloc] init];
        case 3:
            return [[BLProfileFavoriteContentView alloc] init];
        case 4:
            return [[BLProfileBangumiContentView alloc] init];
        default:
            return [[BLProfileHomeContentView alloc] init];
    }
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (UIImageView *)icon:(NSString *)name {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:25.0 weight:UIImageSymbolWeightRegular];
    UIImageView *view = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.tintColor = [UIColor colorWithWhite:0.32 alpha:1.0];
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

@end
