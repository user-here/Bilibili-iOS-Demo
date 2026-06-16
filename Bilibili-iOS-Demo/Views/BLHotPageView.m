#import "BLHotPageView.h"
#import "BLSharePanelView.h"
#import "BLHotVideoCellView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLHotPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

@interface BLHotShortcutItemView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation BLHotShortcutItemView

- (instancetype)initWithTitle:(NSString *)title symbol:(NSString *)symbol colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        UIView *circle = [[UIView alloc] init];
        circle.translatesAutoresizingMaskIntoConstraints = NO;
        circle.layer.cornerRadius = 32.0;
        circle.layer.masksToBounds = YES;
        [self addSubview:circle];

        UIColor *startColor = colors.firstObject ?: BLHotPink();
        UIColor *endColor = colors.lastObject ?: BLHotPink();
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [circle.layer insertSublayer:self.gradientLayer atIndex:0];

        UIImageView *icon = [self iconViewWithName:symbol];
        [circle addSubview:icon];

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = title;
        label.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
        label.textColor = [UIColor colorWithWhite:0.34 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

        [NSLayoutConstraint activateConstraints:@[
            [self.widthAnchor constraintEqualToConstant:92.0],
            [self.heightAnchor constraintEqualToConstant:104.0],
            [circle.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0],
            [circle.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [circle.widthAnchor constraintEqualToConstant:64.0],
            [circle.heightAnchor constraintEqualToConstant:64.0],
            [icon.centerXAnchor constraintEqualToAnchor:circle.centerXAnchor],
            [icon.centerYAnchor constraintEqualToAnchor:circle.centerYAnchor],
            [icon.widthAnchor constraintEqualToConstant:30.0],
            [icon.heightAnchor constraintEqualToConstant:30.0],
            [label.topAnchor constraintEqualToAnchor:circle.bottomAnchor constant:8.0],
            [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
        ]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *circle = self.subviews.firstObject;
    self.gradientLayer.frame = circle.bounds;
}

- (UIImageView *)iconViewWithName:(NSString *)name {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:28.0 weight:UIImageSymbolWeightSemibold];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = [UIColor whiteColor];
    return imageView;
}

@end

@interface BLHotVideoItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray<UIColor *> *colors;
+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views timeText:(NSString *)timeText duration:(NSString *)duration tag:(NSString *)tag colors:(NSArray<UIColor *> *)colors;
@end

@implementation BLHotVideoItem

+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views timeText:(NSString *)timeText duration:(NSString *)duration tag:(NSString *)tag colors:(NSArray<UIColor *> *)colors {
    BLHotVideoItem *item = [[BLHotVideoItem alloc] init];
    item.title = title;
    item.author = author;
    item.views = views;
    item.timeText = timeText;
    item.duration = duration;
    item.tag = tag;
    item.colors = colors;
    return item;
}

@end

@interface BLHotPageView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) NSArray<BLHotVideoItem *> *items;
@property (nonatomic, strong) BLSharePanelView *sharePanelView;
@end

@implementation BLHotPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildData];
        [self buildView];
    }
    return self;
}

- (void)buildData {
    UIColor *pink = [UIColor colorWithRed:0.92 green:0.35 blue:0.58 alpha:1.0];
    UIColor *gold = [UIColor colorWithRed:0.96 green:0.70 blue:0.18 alpha:1.0];
    UIColor *orange = [UIColor colorWithRed:0.90 green:0.45 blue:0.12 alpha:1.0];
    UIColor *brown = [UIColor colorWithRed:0.46 green:0.20 blue:0.10 alpha:1.0];
    UIColor *blue = [UIColor colorWithRed:0.18 green:0.36 blue:0.82 alpha:1.0];
    UIColor *ink = [UIColor colorWithRed:0.10 green:0.12 blue:0.16 alpha:1.0];
    UIColor *violet = [UIColor colorWithRed:0.46 green:0.24 blue:0.70 alpha:1.0];
    UIColor *cyan = [UIColor colorWithRed:0.14 green:0.58 blue:0.76 alpha:1.0];

    self.items = @[
        [BLHotVideoItem itemWithTitle:@"信不信，你炒不过我" author:@"豆油酱 等联合创作" views:@"25.7万" timeText:@"23小时前" duration:@"5:10" tag:@"" colors:@[pink, gold]],
        [BLHotVideoItem itemWithTitle:@"《鸣潮》2026夏日游戏节宣传视频" author:@"鸣潮" views:@"27.7万" timeText:@"3小时前" duration:@"4:18" tag:@"人气飙升" colors:@[ink, cyan]],
        [BLHotVideoItem itemWithTitle:@"《露西亚·逆冕》深渊，为我俯首！！！" author:@"旋风博文" views:@"16.6万" timeText:@"15小时前" duration:@"0:41" tag:@"" colors:@[violet, ink]],
        [BLHotVideoItem itemWithTitle:@"将夜：第8话 长夜将至" author:@"哔哩哔哩国创" views:@"76.2万" timeText:@"昨天 12:00" duration:@"22:33" tag:@"" colors:@[ink, blue]],
        [BLHotVideoItem itemWithTitle:@"【硬核实测】把夏凉被叫“雪糕被”，水星家纺..." author:@"花火实验室" views:@"31.4万" timeText:@"昨天" duration:@"8:06" tag:@"花火精选" colors:@[orange, brown]]
    ];
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 0.0;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self shortcutSection]];
    [self.contentStack addArrangedSubview:[self divider]];
    for (BLHotVideoItem *item in self.items) {
        BLHotVideoCellView *cell = [[BLHotVideoCellView alloc] initWithTitle:item.title author:item.author views:item.views timeText:item.timeText duration:item.duration tag:item.tag colors:item.colors];
        __weak typeof(self) weakSelf = self;
        cell.moreTapped = ^{
            [weakSelf showSharePanel];
        };
        [self.contentStack addArrangedSubview:cell];
        [self.contentStack addArrangedSubview:[self divider]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-12.0],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor]
    ]];
}

- (void)showSharePanel {
    [self buildSharePanelIfNeeded];
    self.sharePanelView.hidden = NO;
    self.sharePanelView.alpha = 0.0;
    [self.sharePanelView.superview layoutIfNeeded];
    [self.sharePanelView setPanelVerticalOffset:CGRectGetHeight(self.sharePanelView.bounds) * 0.42];

    [UIView animateWithDuration:0.26 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.sharePanelView.alpha = 1.0;
        [self.sharePanelView setPanelVerticalOffset:0.0];
    } completion:nil];
}

- (void)dismissSharePanel {
    if (self.sharePanelView.hidden) {
        return;
    }
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sharePanelView.alpha = 0.0;
        [self.sharePanelView setPanelVerticalOffset:CGRectGetHeight(self.sharePanelView.bounds) * 0.42];
    } completion:^(BOOL finished) {
        self.sharePanelView.hidden = YES;
        [self.sharePanelView setPanelVerticalOffset:0.0];
    }];
}

- (void)buildSharePanelIfNeeded {
    if (self.sharePanelView != nil) {
        return;
    }

    UIView *host = self.window ?: self;
    self.sharePanelView = [[BLSharePanelView alloc] init];
    self.sharePanelView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.sharePanelView.dismissRequested = ^{
        [weakSelf dismissSharePanel];
    };
    [host addSubview:self.sharePanelView];

    [NSLayoutConstraint activateConstraints:@[
        [self.sharePanelView.topAnchor constraintEqualToAnchor:host.topAnchor],
        [self.sharePanelView.leadingAnchor constraintEqualToAnchor:host.leadingAnchor],
        [self.sharePanelView.trailingAnchor constraintEqualToAnchor:host.trailingAnchor],
        [self.sharePanelView.bottomAnchor constraintEqualToAnchor:host.bottomAnchor]
    ]];
}

- (UIView *)shortcutSection {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor whiteColor];

    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [container addSubview:scroll];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 22.0;
    [scroll addSubview:stack];

    NSArray *items = @[
        @[@"排行榜", @"chart.bar.fill", @[[UIColor colorWithRed:0.91 green:0.34 blue:0.56 alpha:1.0], [UIColor colorWithRed:0.91 green:0.34 blue:0.56 alpha:1.0]]],
        @[@"每周必看", @"calendar.badge.star", @[[UIColor colorWithRed:0.97 green:0.78 blue:0.23 alpha:1.0], [UIColor colorWithRed:0.98 green:0.88 blue:0.42 alpha:1.0]]],
        @[@"入站必刷", @"medal.fill", @[[UIColor colorWithRed:0.93 green:0.50 blue:0.13 alpha:1.0], [UIColor colorWithRed:0.96 green:0.64 blue:0.22 alpha:1.0]]],
        @[@"UP动画", @"paintbrush.pointed.fill", @[[UIColor colorWithRed:0.52 green:0.23 blue:0.10 alpha:1.0], [UIColor colorWithRed:0.36 green:0.13 blue:0.06 alpha:1.0]]],
        @[@"AI新鲜事", @"sparkles", @[[UIColor colorWithRed:0.22 green:0.40 blue:0.90 alpha:1.0], [UIColor colorWithRed:0.38 green:0.58 blue:0.98 alpha:1.0]]]
    ];

    for (NSArray *item in items) {
        [stack addArrangedSubview:[[BLHotShortcutItemView alloc] initWithTitle:item[0] symbol:item[1] colors:item[2]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintEqualToConstant:132.0],
        [scroll.topAnchor constraintEqualToAnchor:container.topAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor constant:18.0],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor constant:-18.0],
        [stack.centerYAnchor constraintEqualToAnchor:scroll.centerYAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.heightAnchor constant:-18.0]
    ]];
    return container;
}

- (UIView *)divider {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    [view.heightAnchor constraintEqualToConstant:1.0].active = YES;
    return view;
}

@end
