#import "BLFollowingPageView.h"
#import "BLBangumiCollectionPageView.h"
#import "BLPlayerCore.h"
#import "BLPlayerRenderView.h"
#import "BLVideoURLProvider.h"
#import "../Models/BLFeedItem.h"
#import "../DataSource/BLMockDataSource.h"

typedef BLFeedItem BLFollowingFeedItem;

static UIColor *BLFollowingPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLFollowingText(void) {
    return [UIColor colorWithRed:0.14 green:0.14 blue:0.16 alpha:1.0];
}

typedef NS_ENUM(NSInteger, BLFollowingTab) {
    BLFollowingTabAll,
    BLFollowingTabVideo
};

@interface BLFollowingGradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLFollowingGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.colors = cgColors;
    layer.startPoint = CGPointMake(0.0, 0.0);
    layer.endPoint = CGPointMake(1.0, 1.0);
}

@end

@interface BLFollowingHeaderView : UIView
- (instancetype)initWithSelectedTab:(BLFollowingTab)selectedTab;
@property (nonatomic, copy) void (^tabSelected)(BLFollowingTab tab);
@property (nonatomic, copy) void (^bangumiAllTapped)(void);
@property (nonatomic, assign) BLFollowingTab selectedTab;
@end

@implementation BLFollowingHeaderView

- (instancetype)initWithSelectedTab:(BLFollowingTab)selectedTab {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _selectedTab = selectedTab;
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
    }
    return self;
}

- (void)buildView {
    UIStackView *tabs = [[UIStackView alloc] init];
    tabs.translatesAutoresizingMaskIntoConstraints = NO;
    tabs.axis = UILayoutConstraintAxisHorizontal;
    tabs.distribution = UIStackViewDistributionFillEqually;
    tabs.spacing = 8.0;
    [self addSubview:tabs];

    [tabs addArrangedSubview:[self tabControlWithText:@"全部" tab:BLFollowingTabAll]];
    [tabs addArrangedSubview:[self tabControlWithText:@"视频" tab:BLFollowingTabVideo]];

    UIView *visitSection = [self frequentVisitSection];
    [self addSubview:visitSection];

    UIView *bangumiSection = nil;
    if (self.selectedTab == BLFollowingTabVideo) {
        bangumiSection = [self bangumiSection];
        [self addSubview:bangumiSection];
    }

    UIView *divider = [[UIView alloc] init];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    divider.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    [self addSubview:divider];

    [NSLayoutConstraint activateConstraints:@[
        [tabs.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14.0],
        [tabs.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14.0],
        [tabs.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0],
        [tabs.heightAnchor constraintEqualToConstant:30.0],

        [visitSection.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [visitSection.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [visitSection.topAnchor constraintEqualToAnchor:tabs.bottomAnchor constant:13.0],
        [visitSection.heightAnchor constraintEqualToConstant:134.0],
        [divider.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [divider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [divider.heightAnchor constraintEqualToConstant:8.0]
    ]];
    if (bangumiSection != nil) {
        [NSLayoutConstraint activateConstraints:@[
            [bangumiSection.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [bangumiSection.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [bangumiSection.topAnchor constraintEqualToAnchor:visitSection.bottomAnchor constant:8.0],
            [bangumiSection.heightAnchor constraintEqualToConstant:154.0]
        ]];
    }
}

- (UIView *)tabControlWithText:(NSString *)text tab:(BLFollowingTab)tab {
    BOOL selected = tab == self.selectedTab;
    UILabel *label = [self labelWithText:text font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium] color:(selected ? BLFollowingPink() : [UIColor colorWithWhite:0.40 alpha:1.0])];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    label.layer.cornerRadius = 3.0;
    label.layer.masksToBounds = YES;
    label.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = tab;
    [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.topAnchor constraintEqualToAnchor:label.topAnchor],
        [button.leadingAnchor constraintEqualToAnchor:label.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:label.trailingAnchor],
        [button.bottomAnchor constraintEqualToAnchor:label.bottomAnchor]
    ]];
    return label;
}

- (void)tabTapped:(UIButton *)sender {
    BLFollowingTab tab = sender.tag == BLFollowingTabVideo ? BLFollowingTabVideo : BLFollowingTabAll;
    if (self.tabSelected) {
        self.tabSelected(tab);
    }
}

- (UIView *)frequentVisitSection {
    UIView *section = [[UIView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.backgroundColor = [UIColor whiteColor];

    UILabel *visit = [self labelWithText:@"最常访问" font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold] color:BLFollowingText()];
    [section addSubview:visit];

    UILabel *live = [self labelWithText:@"3人直播中 · 更多 >" font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.62 alpha:1.0]];
    live.textAlignment = NSTextAlignmentRight;
    [section addSubview:live];

    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [section addSubview:scroll];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 14.0;
    [scroll addSubview:stack];

    NSArray<NSArray<NSString *> *> *users = @[
        @[@"世界见闻录", @"世"],
        @[@"麻薯波比呀", @"麻"],
        @[@"Meetfood觅食", @"M"],
        @[@"行者道荣", @"行"],
        @[@"潘痴奈奈", @"潘"],
        @[@"新石器公园", @"新"],
        @[@"木鱼水心", @"木"]
    ];
    for (NSArray<NSString *> *user in users) {
        [stack addArrangedSubview:[self avatarItemWithName:user[0] mark:user[1]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [visit.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:12.0],
        [visit.topAnchor constraintEqualToAnchor:section.topAnchor constant:2.0],
        [live.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-12.0],
        [live.centerYAnchor constraintEqualToAnchor:visit.centerYAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:section.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [scroll.topAnchor constraintEqualToAnchor:visit.bottomAnchor constant:10.0],
        [scroll.heightAnchor constraintEqualToConstant:96.0],
        [stack.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor constant:12.0],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor constant:-12.0],
        [stack.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.heightAnchor]
    ]];
    return section;
}

- (UIView *)bangumiSection {
    UIView *section = [[UIView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    section.backgroundColor = [UIColor whiteColor];

    UILabel *title = [self labelWithText:@"我的追番·追剧" font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold] color:BLFollowingText()];
    [section addSubview:title];

    UILabel *more = [self labelWithText:@"全部 >" font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.42 alpha:1.0]];
    more.textAlignment = NSTextAlignmentRight;
    more.userInteractionEnabled = YES;
    [section addSubview:more];
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [moreButton addTarget:self action:@selector(bangumiAllButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [more addSubview:moreButton];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 6.0;
    stack.distribution = UIStackViewDistributionFillEqually;
    [section addSubview:stack];

    NSArray<NSArray *> *items = @[
        @[@"牧神记", @"更新至第86话", [UIColor colorWithRed:0.35 green:0.16 blue:0.10 alpha:1.0], [UIColor colorWithRed:0.82 green:0.46 blue:0.22 alpha:1.0]],
        @[@"名侦探柯南", @"更新至第1262话", [UIColor colorWithRed:0.20 green:0.42 blue:0.66 alpha:1.0], [UIColor colorWithRed:0.92 green:0.74 blue:0.30 alpha:1.0]],
        @[@"OVERLORD", @"全13话", [UIColor colorWithRed:0.18 green:0.22 blue:0.38 alpha:1.0], [UIColor colorWithRed:0.66 green:0.74 blue:0.90 alpha:1.0]]
    ];
    for (NSArray *item in items) {
        [stack addArrangedSubview:[self bangumiCardWithTitle:item[0] episode:item[1] startColor:item[2] endColor:item[3]]];
    }

    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:12.0],
        [title.topAnchor constraintEqualToAnchor:section.topAnchor constant:14.0],
        [more.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-12.0],
        [more.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:76.0],
        [moreButton.topAnchor constraintEqualToAnchor:more.topAnchor],
        [moreButton.leadingAnchor constraintEqualToAnchor:more.leadingAnchor],
        [moreButton.trailingAnchor constraintEqualToAnchor:more.trailingAnchor],
        [moreButton.bottomAnchor constraintEqualToAnchor:more.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:12.0],
        [stack.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-12.0],
        [stack.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:12.0],
        [stack.heightAnchor constraintEqualToConstant:104.0]
    ]];
    return section;
}

- (void)bangumiAllButtonTapped {
    if (self.bangumiAllTapped) {
        self.bangumiAllTapped();
    }
}

- (UIView *)bangumiCardWithTitle:(NSString *)title episode:(NSString *)episode startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;

    BLFollowingGradientView *cover = [[BLFollowingGradientView alloc] init];
    cover.translatesAutoresizingMaskIntoConstraints = NO;
    cover.colors = @[startColor, endColor];
    cover.layer.cornerRadius = 4.0;
    cover.layer.masksToBounds = YES;
    [card addSubview:cover];

    UILabel *mark = [self labelWithText:episode font:[UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
    mark.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    mark.textAlignment = NSTextAlignmentCenter;
    [cover addSubview:mark];

    UILabel *name = [self labelWithText:title font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:BLFollowingText()];
    [card addSubview:name];

    [NSLayoutConstraint activateConstraints:@[
        [cover.topAnchor constraintEqualToAnchor:card.topAnchor],
        [cover.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [cover.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [cover.heightAnchor constraintEqualToConstant:70.0],
        [mark.leadingAnchor constraintEqualToAnchor:cover.leadingAnchor],
        [mark.trailingAnchor constraintEqualToAnchor:cover.trailingAnchor],
        [mark.bottomAnchor constraintEqualToAnchor:cover.bottomAnchor],
        [mark.heightAnchor constraintEqualToConstant:18.0],
        [name.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [name.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [name.topAnchor constraintEqualToAnchor:cover.bottomAnchor constant:8.0]
    ]];
    return card;
}

- (UIView *)avatarItemWithName:(NSString *)name mark:(NSString *)markText {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.backgroundColor = [UIColor colorWithRed:0.88 green:0.91 blue:0.95 alpha:1.0];
    avatar.layer.cornerRadius = 25.0;
    avatar.layer.masksToBounds = YES;
    [container addSubview:avatar];

    UILabel *mark = [self labelWithText:markText font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightHeavy] color:BLFollowingText()];
    mark.textAlignment = NSTextAlignmentCenter;
    [avatar addSubview:mark];

    UIView *dot = [[UIView alloc] init];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    dot.backgroundColor = BLFollowingPink();
    dot.layer.cornerRadius = 3.0;
    [container addSubview:dot];

    UILabel *nameLabel = [self labelWithText:name font:[UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.34 alpha:1.0]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:nameLabel];

    [NSLayoutConstraint activateConstraints:@[
        [container.widthAnchor constraintEqualToConstant:58.0],
        [avatar.topAnchor constraintEqualToAnchor:container.topAnchor],
        [avatar.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [avatar.widthAnchor constraintEqualToConstant:50.0],
        [avatar.heightAnchor constraintEqualToConstant:50.0],
        [mark.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [mark.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [dot.trailingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:-2.0],
        [dot.bottomAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:-2.0],
        [dot.widthAnchor constraintEqualToConstant:6.0],
        [dot.heightAnchor constraintEqualToConstant:6.0],
        [nameLabel.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [nameLabel.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [nameLabel.topAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:8.0]
    ]];
    return container;
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

- (UIImageView *)imageViewWithSystemName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = color;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

@end

@interface BLFollowingVideoCell : UITableViewCell
@property (nonatomic, strong) BLFollowingFeedItem *item;
@property (nonatomic, strong) BLPlayerCore *playerCore;
@property (nonatomic, strong) BLPlayerRenderView *renderView;
@property (nonatomic, strong) BLFollowingGradientView *coverView;
@property (nonatomic, strong) UILabel *coverTextLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, assign) BOOL videoLoaded;
- (void)configureWithItem:(BLFollowingFeedItem *)item;
- (void)startPlayback;
- (void)stopPlayback;
@end

@implementation BLFollowingVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.playerCore = [[BLPlayerCore alloc] init];
        self.playerCore.muted = YES;
        __weak typeof(self) weakSelf = self;
        self.playerCore.stateChanged = ^(BLPlayerPlaybackState state) {
            if (state == BLPlayerPlaybackStatePlaying) {
                [weakSelf.coverView.layer removeAllAnimations];
                weakSelf.coverView.hidden = NO;
                [UIView animateWithDuration:0.16 animations:^{
                    weakSelf.coverView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    weakSelf.coverView.hidden = YES;
                    weakSelf.coverView.alpha = 1.0;
                }];
            } else if (state == BLPlayerPlaybackStateEnded || state == BLPlayerPlaybackStateFailed) {
                weakSelf.coverView.alpha = 1.0;
                weakSelf.coverView.hidden = NO;
            }
        };
        [self buildView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self stopPlayback];
    self.videoLoaded = NO;
    self.item = nil;
}

- (void)buildView {
    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.backgroundColor = [UIColor colorWithRed:0.12 green:0.30 blue:0.68 alpha:1.0];
    avatar.layer.cornerRadius = 18.0;
    avatar.layer.masksToBounds = YES;
    avatar.tag = 201;
    [self.contentView addSubview:avatar];

    UILabel *avatarText = [self labelWithText:@"" font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightHeavy] color:[UIColor whiteColor]];
    avatarText.textAlignment = NSTextAlignmentCenter;
    avatarText.tag = 202;
    [avatar addSubview:avatarText];

    UILabel *author = [self labelWithText:@"" font:[UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold] color:BLFollowingPink()];
    author.tag = 203;
    [self.contentView addSubview:author];

    UILabel *meta = [self labelWithText:@"" font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    meta.tag = 204;
    [self.contentView addSubview:meta];

    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.translatesAutoresizingMaskIntoConstraints = NO;
    [more setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    more.tintColor = [UIColor colorWithWhite:0.40 alpha:1.0];
    [self.contentView addSubview:more];

    UIView *playerContainer = [[UIView alloc] init];
    playerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    playerContainer.backgroundColor = [UIColor blackColor];
    playerContainer.layer.cornerRadius = 3.0;
    playerContainer.layer.masksToBounds = YES;
    playerContainer.tag = 205;
    [self.contentView addSubview:playerContainer];

    self.renderView = [[BLPlayerRenderView alloc] init];
    self.renderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.renderView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.renderView.player = self.playerCore.player;
    [playerContainer addSubview:self.renderView];

    self.coverView = [[BLFollowingGradientView alloc] init];
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    [playerContainer addSubview:self.coverView];

    self.coverTextLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:34.0 weight:UIFontWeightHeavy] color:[UIColor whiteColor]];
    self.coverTextLabel.numberOfLines = 2;
    self.coverTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.coverView addSubview:self.coverTextLabel];

    self.durationLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] color:[UIColor whiteColor]];
    self.durationLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.42];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.layer.cornerRadius = 2.0;
    self.durationLabel.layer.masksToBounds = YES;
    [playerContainer addSubview:self.durationLabel];

    self.muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.muteButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.muteButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.30];
    self.muteButton.layer.cornerRadius = 16.0;
    [self.muteButton setImage:[UIImage systemImageNamed:@"speaker.slash.fill"] forState:UIControlStateNormal];
    [self.muteButton setImage:[UIImage systemImageNamed:@"speaker.wave.2.fill"] forState:UIControlStateSelected];
    self.muteButton.tintColor = [UIColor whiteColor];
    [self.muteButton addTarget:self action:@selector(muteTapped:) forControlEvents:UIControlEventTouchUpInside];
    [playerContainer addSubview:self.muteButton];

    UILabel *title = [self labelWithText:@"" font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold] color:BLFollowingText()];
    title.numberOfLines = 2;
    title.tag = 206;
    [self.contentView addSubview:title];

    UIStackView *actions = [[UIStackView alloc] init];
    actions.translatesAutoresizingMaskIntoConstraints = NO;
    actions.axis = UILayoutConstraintAxisHorizontal;
    actions.distribution = UIStackViewDistributionEqualSpacing;
    actions.alignment = UIStackViewAlignmentCenter;
    actions.tag = 207;
    [self.contentView addSubview:actions];

    [actions addArrangedSubview:[self actionViewWithIcon:@"arrowshape.turn.up.right" text:@"2"]];
    [actions addArrangedSubview:[self actionViewWithIcon:@"bubble" text:@"33"]];
    [actions addArrangedSubview:[self actionViewWithIcon:@"hand.thumbsup" text:@"659"]];

    UIView *separator = [[UIView alloc] init];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    [self.contentView addSubview:separator];

    [NSLayoutConstraint activateConstraints:@[
        [avatar.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.0],
        [avatar.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12.0],
        [avatar.widthAnchor constraintEqualToConstant:36.0],
        [avatar.heightAnchor constraintEqualToConstant:36.0],
        [avatarText.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [avatarText.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [author.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:8.0],
        [author.topAnchor constraintEqualToAnchor:avatar.topAnchor],
        [author.trailingAnchor constraintLessThanOrEqualToAnchor:more.leadingAnchor constant:-8.0],
        [meta.leadingAnchor constraintEqualToAnchor:author.leadingAnchor],
        [meta.topAnchor constraintEqualToAnchor:author.bottomAnchor constant:4.0],
        [more.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8.0],
        [more.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:30.0],
        [more.heightAnchor constraintEqualToConstant:36.0],

        [playerContainer.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.0],
        [playerContainer.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10.0],
        [playerContainer.topAnchor constraintEqualToAnchor:avatar.bottomAnchor constant:10.0],
        [playerContainer.heightAnchor constraintEqualToAnchor:playerContainer.widthAnchor multiplier:0.56],
        [self.renderView.topAnchor constraintEqualToAnchor:playerContainer.topAnchor],
        [self.renderView.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor],
        [self.renderView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor],
        [self.renderView.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor],
        [self.coverView.topAnchor constraintEqualToAnchor:playerContainer.topAnchor],
        [self.coverView.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor],
        [self.coverView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor],
        [self.coverView.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor],
        [self.coverTextLabel.centerXAnchor constraintEqualToAnchor:self.coverView.centerXAnchor],
        [self.coverTextLabel.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor],
        [self.coverTextLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.coverView.leadingAnchor constant:20.0],
        [self.coverTextLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.coverView.trailingAnchor constant:-20.0],
        [self.durationLabel.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor constant:8.0],
        [self.durationLabel.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:-8.0],
        [self.durationLabel.widthAnchor constraintGreaterThanOrEqualToConstant:42.0],
        [self.durationLabel.heightAnchor constraintEqualToConstant:20.0],
        [self.muteButton.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor constant:-10.0],
        [self.muteButton.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:-10.0],
        [self.muteButton.widthAnchor constraintEqualToConstant:32.0],
        [self.muteButton.heightAnchor constraintEqualToConstant:32.0],

        [title.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor],
        [title.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor],
        [title.topAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:10.0],
        [actions.leadingAnchor constraintEqualToAnchor:title.leadingAnchor constant:18.0],
        [actions.trailingAnchor constraintEqualToAnchor:title.trailingAnchor constant:-18.0],
        [actions.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:12.0],
        [actions.heightAnchor constraintEqualToConstant:26.0],
        [separator.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [separator.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [separator.topAnchor constraintEqualToAnchor:actions.bottomAnchor constant:12.0],
        [separator.heightAnchor constraintEqualToConstant:8.0],
        [separator.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

- (void)configureWithItem:(BLFollowingFeedItem *)item {
    if (self.item != nil && self.item != item) {
        [self stopPlayback];
        self.videoLoaded = NO;
    }
    self.item = item;
    UILabel *avatarText = [self.contentView viewWithTag:202];
    UILabel *author = [self.contentView viewWithTag:203];
    UILabel *meta = [self.contentView viewWithTag:204];
    UILabel *title = [self.contentView viewWithTag:206];

    avatarText.text = item.avatarText;
    author.text = item.author;
    meta.text = [NSString stringWithFormat:@"%@ · %@", item.time, item.action];
    title.text = item.title;
    self.coverTextLabel.text = item.source;
    self.durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
    self.coverView.colors = @[item.startColor, item.endColor];
    [self.coverView.layer removeAllAnimations];
    self.coverView.alpha = 1.0;
    self.coverView.hidden = NO;
    self.muteButton.selected = !self.playerCore.isMuted;

    UIStackView *actions = [self.contentView viewWithTag:207];
    NSArray<NSString *> *texts = @[@"2", item.comments, item.likes];
    for (NSUInteger index = 0; index < actions.arrangedSubviews.count && index < texts.count; index++) {
        UILabel *label = [actions.arrangedSubviews[index] viewWithTag:302];
        label.text = texts[index];
    }
}

- (void)startPlayback {
    if (self.item == nil) {
        return;
    }
    NSURL *URL = [BLVideoURLProvider defaultVideoURL];
    if (!self.videoLoaded && URL != nil) {
        self.videoLoaded = YES;
        [self.playerCore loadURL:URL autoplay:YES];
    } else {
        [self.playerCore play];
    }
}

- (void)stopPlayback {
    [self.playerCore pauseAndCancelAutoplay];
    [self.playerCore seekToTime:0.0 completion:nil];
    [self.coverView.layer removeAllAnimations];
    self.coverView.alpha = 1.0;
    self.coverView.hidden = NO;
}

- (void)muteTapped:(UIButton *)button {
    [self.playerCore toggleMuted];
    button.selected = !self.playerCore.isMuted;
}

- (UIView *)actionViewWithIcon:(NSString *)icon text:(NSString *)text {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 5.0;
    UIImageView *image = [self imageViewWithSystemName:icon pointSize:16.0 color:[UIColor colorWithWhite:0.48 alpha:1.0]];
    [image.widthAnchor constraintEqualToConstant:18.0].active = YES;
    [image.heightAnchor constraintEqualToConstant:18.0].active = YES;
    [stack addArrangedSubview:image];
    UILabel *label = [self labelWithText:text font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.46 alpha:1.0]];
    label.tag = 302;
    [stack addArrangedSubview:label];
    return stack;
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

- (UIImageView *)imageViewWithSystemName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = color;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

@end

@interface BLFollowingPageView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) NSArray<BLFollowingFeedItem *> *items;
@property (nonatomic, strong) NSArray<BLFollowingFeedItem *> *allItems;
@property (nonatomic, strong) NSArray<BLFollowingFeedItem *> *videoItems;
@property (nonatomic, strong) BLBangumiCollectionPageView *collectionPageView;
@property (nonatomic, strong) NSLayoutConstraint *collectionPageLeadingConstraint;
@property (nonatomic, weak) BLFollowingVideoCell *activeCell;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL reloadingForTabSwitch;
@property (nonatomic, assign) BLFollowingTab selectedTab;
@end

@implementation BLFollowingPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.selectedTab = BLFollowingTabAll;
        [self buildData];
        [self buildView];
    }
    return self;
}

- (void)buildData {
    self.allItems = [[BLMockDataSource shared] followingAllItems];
    self.videoItems = [[BLMockDataSource shared] followingVideoItems];
    self.items = self.allItems;
}

- (void)buildView {
    self.navBar = [[UIView alloc] init];
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.navBar];

    UILabel *title = [self labelWithText:@"关注" font:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold] color:BLFollowingText()];
    title.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:title];

    UIImageView *edit = [self imageViewWithSystemName:@"square.and.pencil" pointSize:21.0 color:[UIColor colorWithWhite:0.40 alpha:1.0]];
    [self.navBar addSubview:edit];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 330.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:BLFollowingVideoCell.class forCellReuseIdentifier:@"BLFollowingVideoCell"];
    [self updateTableHeader];
    [self addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.navBar.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.navBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.navBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.navBar.heightAnchor constraintEqualToConstant:44.0],
        [title.centerXAnchor constraintEqualToAnchor:self.navBar.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:self.navBar.centerYAnchor],
        [edit.trailingAnchor constraintEqualToAnchor:self.navBar.trailingAnchor constant:-16.0],
        [edit.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [edit.widthAnchor constraintEqualToConstant:28.0],
        [edit.heightAnchor constraintEqualToConstant:28.0],
        [self.tableView.topAnchor constraintEqualToAnchor:self.navBar.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)updateTableHeader {
    BLFollowingHeaderView *header = [[BLFollowingHeaderView alloc] initWithSelectedTab:self.selectedTab];
    header.frame = CGRectMake(0.0, 0.0, UIScreen.mainScreen.bounds.size.width, [self headerHeightForSelectedTab]);
    __weak typeof(self) weakSelf = self;
    header.tabSelected = ^(BLFollowingTab tab) {
        [weakSelf selectTab:tab];
    };
    header.bangumiAllTapped = ^{
        [weakSelf showBangumiCollectionPage];
    };
    self.tableView.tableHeaderView = header;
}

- (CGFloat)headerHeightForSelectedTab {
    return self.selectedTab == BLFollowingTabVideo ? 357.0 : 195.0;
}

- (void)selectTab:(BLFollowingTab)tab {
    if (tab == self.selectedTab) {
        return;
    }
    self.reloadingForTabSwitch = YES;
    [self.activeCell stopPlayback];
    self.activeCell = nil;
    self.selectedTab = tab;
    self.items = tab == BLFollowingTabVideo ? self.videoItems : self.allItems;
    [self updateTableHeader];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    if (self.active) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView layoutIfNeeded];
            self.activeCell = nil;
            self.reloadingForTabSwitch = NO;
            [self updateActiveVideoCell];
        });
    } else {
        self.reloadingForTabSwitch = NO;
    }
}

- (void)showBangumiCollectionPage {
    [self.activeCell stopPlayback];
    self.activeCell = nil;
    if (self.collectionPageView != nil) {
        [self.collectionPageView removeFromSuperview];
        self.collectionPageView = nil;
        self.collectionPageLeadingConstraint = nil;
    }
    self.collectionPageView = [[BLBangumiCollectionPageView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.collectionPageView.closeTapped = ^{
        [weakSelf dismissBangumiCollectionPage];
    };
    [self addSubview:self.collectionPageView];
    self.collectionPageLeadingConstraint = [self.collectionPageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:CGRectGetWidth(UIScreen.mainScreen.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionPageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        self.collectionPageLeadingConstraint,
        [self.collectionPageView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
        [self.collectionPageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    [self layoutIfNeeded];
    self.collectionPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dismissBangumiCollectionPage {
    self.collectionPageLeadingConstraint.constant = CGRectGetWidth(self.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.collectionPageView removeFromSuperview];
        self.collectionPageView = nil;
        self.collectionPageLeadingConstraint = nil;
        if (self.active) {
            [self updateActiveVideoCell];
        }
    }];
}

- (void)activate {
    self.active = YES;
    [self.tableView layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateActiveVideoCell];
    });
}

- (void)deactivate {
    self.active = NO;
    [self.activeCell stopPlayback];
    self.activeCell = nil;
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

- (UIImageView *)imageViewWithSystemName:(NSString *)name pointSize:(CGFloat)pointSize color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightRegular];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = color;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLFollowingVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLFollowingVideoCell" forIndexPath:indexPath];
    [cell configureWithItem:self.items[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell == self.activeCell) {
        [self.activeCell stopPlayback];
        self.activeCell = nil;
    }
    if ([cell isKindOfClass:BLFollowingVideoCell.class]) {
        [(BLFollowingVideoCell *)cell stopPlayback];
    }
    [self updateActiveVideoCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLFollowingFeedItem *item = self.items[indexPath.row];
    NSURL *URL = [BLVideoURLProvider defaultVideoURL];
    if (URL != nil && self.videoSelected) {
        self.videoSelected(URL, item.title, item.author);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateActiveVideoCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updateActiveVideoCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateActiveVideoCell];
}

- (void)updateActiveVideoCell {
    if (!self.active || self.hidden || self.window == nil || self.collectionPageView != nil || self.reloadingForTabSwitch) {
        return;
    }
    NSArray<BLFollowingVideoCell *> *visibleCells = (NSArray<BLFollowingVideoCell *> *)self.tableView.visibleCells;
    if (self.activeCell != nil && ![visibleCells containsObject:self.activeCell]) {
        [self.activeCell stopPlayback];
        self.activeCell = nil;
    }
    BLFollowingVideoCell *candidate = nil;
    CGFloat bestVisibility = 0.0;
    CGRect tableBounds = self.tableView.bounds;
    for (BLFollowingVideoCell *cell in visibleCells) {
        if (![cell isKindOfClass:BLFollowingVideoCell.class]) {
            continue;
        }
        CGRect cellFrame = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:cell]];
        CGRect visibleFrame = CGRectIntersection(tableBounds, cellFrame);
        CGFloat visibility = CGRectGetHeight(visibleFrame) / MAX(1.0, CGRectGetHeight(cellFrame));
        if (visibility > bestVisibility) {
            bestVisibility = visibility;
            candidate = cell;
        }
    }
    if (candidate == self.activeCell || bestVisibility < 0.45) {
        for (BLFollowingVideoCell *cell in visibleCells) {
            if ([cell isKindOfClass:BLFollowingVideoCell.class] && cell != self.activeCell) {
                [cell stopPlayback];
            }
        }
        return;
    }
    for (BLFollowingVideoCell *cell in visibleCells) {
        if ([cell isKindOfClass:BLFollowingVideoCell.class] && cell != candidate) {
            [cell stopPlayback];
        }
    }
    if (self.activeCell != nil && self.activeCell != candidate) {
        [self.activeCell stopPlayback];
    }
    self.activeCell = candidate;
    [self.activeCell startPlayback];
}

@end
