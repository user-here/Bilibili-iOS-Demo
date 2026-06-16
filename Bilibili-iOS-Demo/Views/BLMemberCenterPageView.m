#import "BLMemberCenterPageView.h"
#import "BLMemberAutoCarouselView.h"
#import "BLMemberPaymentBarView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLMemberPink(void) { return [UIColor colorWithRed:0.93 green:0.36 blue:0.57 alpha:1.0]; }
static UIColor *BLMemberText(void) { return [UIColor colorWithRed:0.13 green:0.12 blue:0.14 alpha:1.0]; }
static UIColor *BLMemberSubText(void) { return [UIColor colorWithWhite:0.58 alpha:1.0]; }
static UIColor *BLMemberPageBackground(void) { return [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1.0]; }

@interface BLMemberSnapScrollView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat itemWidth;
@end

@implementation BLMemberSnapScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat step = self.itemWidth + 14.0;
    if (step <= 0.0) {
        return;
    }
    NSInteger index = MAX(0, (NSInteger)llround(targetContentOffset->x / step));
    targetContentOffset->x = index * step;
}

@end

@interface BLMemberCenterPageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) BLMemberAutoCarouselView *assetCarouselView;
@property (nonatomic, strong) BLMemberPaymentBarView *paymentBarView;
@property (nonatomic, assign) BOOL paymentBarShown;
@end

@implementation BLMemberCenterPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = BLMemberPageBackground();
        [self buildView];
    }
    return self;
}

- (void)activate {
    [self.assetCarouselView startAutoScroll];
    if (self.paymentBarShown) {
        [self.paymentBarView startCountdown];
    }
}

- (void)deactivate {
    [self.assetCarouselView stopAutoScroll];
    [self.paymentBarView stopCountdown];
}

- (void)buildView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = BLMemberPageBackground();
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.scrollView];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 10.0;
    self.contentStack.layoutMargins = UIEdgeInsetsMake(0.0, 10.0, 176.0, 10.0);
    self.contentStack.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.contentStack];

    [self.contentStack addArrangedSubview:[self heroView]];
    [self.contentStack addArrangedSubview:[self userCard]];
    [self.contentStack addArrangedSubview:[self rightsAssetsBar]];

    self.assetCarouselView = [[BLMemberAutoCarouselView alloc] initWithItems:@[
        @"您的战庆福利已到账\n大会员限时118元",
        @"大会员漫展限时福利",
        @"购买大会员，和《凌探未来》一起为公益助力",
        @"大会员在现场 立即报名"
    ]];
    [self.contentStack addArrangedSubview:[self whiteCardWithContent:self.assetCarouselView height:126.0]];

    [self.contentStack addArrangedSubview:[self experienceCard]];
    [self.contentStack addArrangedSubview:[self benefitSection]];
    [self.contentStack addArrangedSubview:[self movieSection]];
    [self.contentStack addArrangedSubview:[self comicTicketSection]];
    [self.contentStack addArrangedSubview:[self decorateSection]];
    [self.contentStack addArrangedSubview:[self pointsSection]];
    [self.contentStack addArrangedSubview:[self exclusiveSection]];
    [self.contentStack addArrangedSubview:[self fortuneSection]];
    [self.contentStack addArrangedSubview:[self otherWaysSection]];

    [self buildNavBar];
    self.paymentBarView = [[BLMemberPaymentBarView alloc] init];
    self.paymentBarView.hidden = YES;
    [self addSubview:self.paymentBarView];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStack.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],
        [self.paymentBarView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.paymentBarView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.paymentBarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.paymentBarView.heightAnchor constraintEqualToConstant:148.0]
    ]];
    [self bringSubviewToFront:self.navBar];
    [self bringSubviewToFront:self.paymentBarView];
}

- (void)buildNavBar {
    self.navBar = [[UIView alloc] init];
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.navBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.58];
    [self addSubview:self.navBar];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    back.tintColor = [UIColor blackColor];
    [back setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UILabel *title = [self label:@"会员中心" size:21.0 weight:UIFontWeightSemibold color:[UIColor blackColor]];
    title.textAlignment = NSTextAlignmentCenter;
    UIImageView *grid = [self icon:@"square.grid.2x2"];
    UIImageView *more = [self icon:@"ellipsis"];
    more.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.navBar addSubview:back];
    [self.navBar addSubview:title];
    [self.navBar addSubview:grid];
    [self.navBar addSubview:more];
    [NSLayoutConstraint activateConstraints:@[
        [self.navBar.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.navBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.navBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.navBar.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:56.0],
        [back.leadingAnchor constraintEqualToAnchor:self.navBar.leadingAnchor constant:14.0],
        [back.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [back.widthAnchor constraintEqualToConstant:42.0],
        [back.heightAnchor constraintEqualToConstant:42.0],
        [title.centerXAnchor constraintEqualToAnchor:self.navBar.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [more.trailingAnchor constraintEqualToAnchor:self.navBar.trailingAnchor constant:-16.0],
        [more.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [more.widthAnchor constraintEqualToConstant:26.0],
        [more.heightAnchor constraintEqualToConstant:26.0],
        [grid.trailingAnchor constraintEqualToAnchor:more.leadingAnchor constant:-22.0],
        [grid.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [grid.widthAnchor constraintEqualToConstant:30.0],
        [grid.heightAnchor constraintEqualToConstant:30.0]
    ]];
}

- (UIView *)heroView {
    UIView *hero = [[UIView alloc] init];
    hero.translatesAutoresizingMaskIntoConstraints = NO;
    hero.backgroundColor = [UIColor colorWithRed:0.78 green:0.93 blue:0.94 alpha:1.0];
    hero.layer.cornerRadius = 14.0;
    hero.layer.masksToBounds = YES;

    UIView *glow = [[UIView alloc] init];
    glow.translatesAutoresizingMaskIntoConstraints = NO;
    glow.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.36];
    glow.layer.cornerRadius = 64.0;

    UILabel *days = [self label:@"大\n1595天" size:22.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    days.textAlignment = NSTextAlignmentCenter;
    days.numberOfLines = 2;
    days.backgroundColor = BLMemberPink();
    days.layer.cornerRadius = 36.0;
    days.layer.masksToBounds = YES;
    UILabel *scene = [self label:@"会员中心" size:18.0 weight:UIFontWeightSemibold color:[[UIColor blackColor] colorWithAlphaComponent:0.14]];
    scene.textAlignment = NSTextAlignmentCenter;
    UIImageView *rocket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bl_member_rocket"]];
    rocket.translatesAutoresizingMaskIntoConstraints = NO;
    rocket.contentMode = UIViewContentModeScaleAspectFit;
    [hero addSubview:glow];
    [hero addSubview:days];
    [hero addSubview:scene];
    [hero addSubview:rocket];
    [hero.heightAnchor constraintEqualToConstant:246.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [glow.centerXAnchor constraintEqualToAnchor:rocket.centerXAnchor],
        [glow.centerYAnchor constraintEqualToAnchor:rocket.centerYAnchor],
        [glow.widthAnchor constraintEqualToConstant:128.0],
        [glow.heightAnchor constraintEqualToConstant:128.0],
        [days.leadingAnchor constraintEqualToAnchor:hero.leadingAnchor constant:42.0],
        [days.bottomAnchor constraintEqualToAnchor:hero.bottomAnchor constant:-46.0],
        [days.widthAnchor constraintEqualToConstant:92.0],
        [days.heightAnchor constraintEqualToConstant:88.0],
        [rocket.trailingAnchor constraintEqualToAnchor:hero.trailingAnchor constant:-38.0],
        [rocket.centerYAnchor constraintEqualToAnchor:days.centerYAnchor constant:-4.0],
        [rocket.widthAnchor constraintEqualToConstant:88.0],
        [rocket.heightAnchor constraintEqualToConstant:88.0],
        [rocket.leadingAnchor constraintGreaterThanOrEqualToAnchor:days.trailingAnchor constant:24.0],
        [scene.leadingAnchor constraintEqualToAnchor:hero.leadingAnchor],
        [scene.trailingAnchor constraintEqualToAnchor:hero.trailingAnchor],
        [scene.bottomAnchor constraintEqualToAnchor:hero.bottomAnchor constant:-18.0]
    ]];
    return hero;
}

- (UIView *)userCard {
    UIView *card = [self roundedCard];
    UILabel *avatar = [self label:@"大" size:23.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    avatar.textAlignment = NSTextAlignmentCenter;
    avatar.backgroundColor = BLMemberPink();
    avatar.layer.cornerRadius = 30.0;
    avatar.layer.masksToBounds = YES;
    UILabel *name = [self label:@"阿狸爱吃狐狸  年度大会员" size:16.0 weight:UIFontWeightSemibold color:BLMemberPink()];
    UILabel *sub = [self label:@"大会员已连续陪伴1595天 ⓘ" size:14.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    UIButton *renew = [self pillButton:@"立即续费" filled:YES];
    [card addSubview:avatar];
    [card addSubview:name];
    [card addSubview:sub];
    [card addSubview:renew];
    [card.heightAnchor constraintEqualToConstant:88.0].active = YES;
    [renew setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [name setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [sub setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [NSLayoutConstraint activateConstraints:@[
        [avatar.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [avatar.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [avatar.widthAnchor constraintEqualToConstant:56.0],
        [avatar.heightAnchor constraintEqualToConstant:56.0],
        [name.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:14.0],
        [name.topAnchor constraintEqualToAnchor:avatar.topAnchor constant:6.0],
        [sub.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [sub.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:9.0],
        [renew.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18.0],
        [renew.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
        [renew.widthAnchor constraintEqualToConstant:96.0],
        [renew.heightAnchor constraintEqualToConstant:40.0],
        [name.trailingAnchor constraintLessThanOrEqualToAnchor:renew.leadingAnchor constant:-12.0],
        [sub.trailingAnchor constraintLessThanOrEqualToAnchor:renew.leadingAnchor constant:-12.0]
    ]];
    return card;
}

- (UIView *)rightsAssetsBar {
    UIView *bar = [self roundedCard];
    UIView *split = [[UIView alloc] init];
    split.translatesAutoresizingMaskIntoConstraints = NO;
    split.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    UILabel *rights = [self label:@"我的权益 ›" size:18.0 weight:UIFontWeightRegular color:BLMemberText()];
    rights.textAlignment = NSTextAlignmentCenter;
    UILabel *assets = [self label:@"我的资产 ›" size:18.0 weight:UIFontWeightRegular color:BLMemberText()];
    assets.textAlignment = NSTextAlignmentCenter;
    UILabel *dot = [self label:@"●" size:16.0 weight:UIFontWeightRegular color:BLMemberPink()];
    [bar addSubview:rights];
    [bar addSubview:assets];
    [bar addSubview:split];
    [bar addSubview:dot];
    [bar.heightAnchor constraintEqualToConstant:56.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [split.centerXAnchor constraintEqualToAnchor:bar.centerXAnchor],
        [split.centerYAnchor constraintEqualToAnchor:bar.centerYAnchor],
        [split.widthAnchor constraintEqualToConstant:1.0],
        [split.heightAnchor constraintEqualToConstant:30.0],
        [rights.leadingAnchor constraintEqualToAnchor:bar.leadingAnchor],
        [rights.trailingAnchor constraintEqualToAnchor:split.leadingAnchor],
        [rights.centerYAnchor constraintEqualToAnchor:bar.centerYAnchor],
        [assets.leadingAnchor constraintEqualToAnchor:split.trailingAnchor],
        [assets.trailingAnchor constraintEqualToAnchor:bar.trailingAnchor],
        [assets.centerYAnchor constraintEqualToAnchor:bar.centerYAnchor],
        [dot.leadingAnchor constraintEqualToAnchor:assets.centerXAnchor constant:58.0],
        [dot.topAnchor constraintEqualToAnchor:bar.topAnchor constant:11.0]
    ]];
    return bar;
}

- (UIView *)experienceCard {
    UIView *card = [self roundedCard];
    UILabel *title = [self label:@"领经验  当前 LV5  距下个等级仅需 95 经验  ⓘ" size:15.0 weight:UIFontWeightRegular color:BLMemberText()];
    UIImageView *rocket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bl_member_rocket"]];
    rocket.translatesAutoresizingMaskIntoConstraints = NO;
    rocket.contentMode = UIViewContentModeScaleAspectFit;
    rocket.backgroundColor = [UIColor colorWithRed:1.0 green:0.90 blue:0.95 alpha:1.0];
    rocket.layer.cornerRadius = 26.0;
    UILabel *main = [self label:@"专属等级加速包（每日10经验）" size:16.0 weight:UIFontWeightRegular color:BLMemberText()];
    UILabel *sub = [self label:@"会员观看视频1分钟领取，日限1次" size:13.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    UIButton *receive = [self pillButton:@"领取" filled:NO];
    [card addSubview:title];
    [card addSubview:rocket];
    [card addSubview:main];
    [card addSubview:sub];
    [card addSubview:receive];
    [card.heightAnchor constraintEqualToConstant:132.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:16.0],
        [title.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [rocket.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18.0],
        [rocket.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:22.0],
        [rocket.widthAnchor constraintEqualToConstant:52.0],
        [rocket.heightAnchor constraintEqualToConstant:52.0],
        [main.leadingAnchor constraintEqualToAnchor:rocket.trailingAnchor constant:14.0],
        [main.topAnchor constraintEqualToAnchor:rocket.topAnchor constant:2.0],
        [sub.leadingAnchor constraintEqualToAnchor:main.leadingAnchor],
        [sub.topAnchor constraintEqualToAnchor:main.bottomAnchor constant:8.0],
        [receive.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18.0],
        [receive.centerYAnchor constraintEqualToAnchor:rocket.centerYAnchor],
        [receive.widthAnchor constraintEqualToConstant:76.0],
        [receive.heightAnchor constraintEqualToConstant:36.0],
        [main.trailingAnchor constraintLessThanOrEqualToAnchor:receive.leadingAnchor constant:-10.0],
        [sub.trailingAnchor constraintLessThanOrEqualToAnchor:receive.leadingAnchor constant:-10.0]
    ]];
    return card;
}

- (UIView *)benefitSection {
    return [self horizontalSection:@"领福利" subtitle:nil more:@"查看更多 ›" cards:@[
        @[@"大会员专属儒意电影特权", @"抽免费券 看钟值大电影", @"立即使用"],
        @[@"券包最高减120元", @"大会员多重福利", @"天天领"],
        @[@"会员购专属优惠", @"潮玩手办限时福利", @"去看看"],
        @[@"免费看漫画", @"热门国漫立即解锁", @"立即领取"],
        @[@"游戏礼包", @"专属道具限量兑换", @"领取"],
        @[@"装扮折扣", @"头像挂件限时免费", @"使用"]
    ] snapping:NO];
}

- (UIView *)movieSection {
    UIView *section = [self roundedCard];
    UILabel *title = [self label:@"线下点映会  大会员专享免费观看" size:17.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UILabel *more = [self label:@"查看更多 ›" size:16.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    UILabel *active = [self label:@"正在进行" size:17.0 weight:UIFontWeightSemibold color:BLMemberPink()];
    UILabel *history = [self label:@"历史活动" size:17.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UIView *current = [self movieCard:@"《神奇数字马戏团》大会员点映会" tag:@"特邀观影  超大专属名额" city:@"上海、北京、深圳" button:@"立即报名"];
    BLMemberSnapScrollView *scroll = [self snapScrollWithCards:@[
        [self movieCard:@"《钟馗》大会员点映会" tag:@"全国多城  超大专属名额" city:@"活动回顾" button:nil],
        [self movieCard:@"《星球大战：曼达洛人》" tag:@"特邀观影" city:@"活动回顾" button:nil],
        [self movieCard:@"《凌探未来》公益专场" tag:@"公益助力" city:@"活动回顾" button:nil]
    ] height:160.0 itemWidth:320.0];
    [section addSubview:title];
    [section addSubview:more];
    [section addSubview:active];
    [section addSubview:history];
    [section addSubview:current];
    [section addSubview:scroll];
    [section.heightAnchor constraintEqualToConstant:430.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:section.topAnchor constant:18.0],
        [more.leadingAnchor constraintGreaterThanOrEqualToAnchor:title.trailingAnchor constant:10.0],
        [more.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-16.0],
        [more.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [active.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [active.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:22.0],
        [history.leadingAnchor constraintEqualToAnchor:active.trailingAnchor constant:36.0],
        [history.centerYAnchor constraintEqualToAnchor:active.centerYAnchor],
        [current.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [current.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-16.0],
        [current.topAnchor constraintEqualToAnchor:active.bottomAnchor constant:18.0],
        [current.heightAnchor constraintEqualToConstant:152.0],
        [scroll.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [scroll.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [scroll.topAnchor constraintEqualToAnchor:current.bottomAnchor constant:18.0],
        [scroll.heightAnchor constraintEqualToConstant:160.0]
    ]];
    return section;
}

- (UIView *)comicTicketSection {
    UIView *section = [self roundedCard];
    UILabel *title = [self label:@"漫展演出权益" size:19.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UILabel *more = [self label:@"查看更多 ›" size:15.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    UIView *coupon = [self couponView];
    BLMemberSnapScrollView *scroll = [self snapScrollWithCards:@[
        [self posterCard:@"洛天依全国巡回演唱会\n大会员专属提前抢！" status:@"去看看"],
        [self posterCard:@"上海·世界树动漫游戏嘉年华" status:@"热卖中"],
        [self posterCard:@"上海·第四届综合创作探索" status:@"热卖中"]
    ] height:240.0 itemWidth:150.0];
    [section addSubview:title];
    [section addSubview:more];
    [section addSubview:coupon];
    [section addSubview:scroll];
    [section.heightAnchor constraintEqualToConstant:390.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:section.topAnchor constant:18.0],
        [more.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-16.0],
        [more.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [coupon.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [coupon.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-16.0],
        [coupon.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:16.0],
        [coupon.heightAnchor constraintEqualToConstant:70.0],
        [scroll.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [scroll.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [scroll.topAnchor constraintEqualToAnchor:coupon.bottomAnchor constant:16.0],
        [scroll.heightAnchor constraintEqualToConstant:240.0]
    ]];
    return section;
}

- (UIView *)decorateSection {
    return [self horizontalSection:@"装扮福利" subtitle:@"了解的装扮" more:@"查看更多 ›" cards:@[
        @[@"大会员专属装扮", @"会员在服装扮有戏", @"领取并佩戴"],
        @[@"精选IP", @"诡秘之主·愚者", @"去领取"],
        @[@"表情包", @"Phigros 环形", @"已领10万+份"],
        @[@"头像挂件", @"主播女孩重度依赖", @"已领20万+份"]
    ] snapping:YES];
}

- (UIView *)pointsSection {
    UIView *card = [self roundedCard];
    UILabel *title = [self label:@"领大积分  0 大积分" size:18.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UILabel *sign = [self label:@"签到限时福利" size:17.0 weight:UIFontWeightRegular color:BLMemberText()];
    UILabel *sub = [self label:@"7天内累计3天可得积分，剩余时间7天" size:14.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    UIStackView *row = [[UIStackView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 10.0;
    row.distribution = UIStackViewDistributionFillEqually;
    for (NSString *item in @[@"+50\n第1天", @"+50\n第2天", @"+100\n第3天", @"签到"]) {
        [row addArrangedSubview:[self miniPinkCard:item]];
    }
    [card addSubview:title];
    [card addSubview:sign];
    [card addSubview:sub];
    [card addSubview:row];
    [card.heightAnchor constraintEqualToConstant:190.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:18.0],
        [sign.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [sign.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:18.0],
        [sub.leadingAnchor constraintEqualToAnchor:sign.leadingAnchor],
        [sub.topAnchor constraintEqualToAnchor:sign.bottomAnchor constant:6.0],
        [row.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [row.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [row.topAnchor constraintEqualToAnchor:sub.bottomAnchor constant:16.0],
        [row.heightAnchor constraintEqualToConstant:66.0]
    ]];
    return card;
}

- (UIView *)exclusiveSection {
    UIView *section = [self roundedCard];
    UILabel *title = [self label:@"大会员专享" size:18.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UIStackView *grid = [[UIStackView alloc] init];
    grid.translatesAutoresizingMaskIntoConstraints = NO;
    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 10.0;
    NSArray *movies = @[@"复仇者联盟", @"D·STONE", @"钢铁侠", @"复仇者联盟2", @"美国队长", @"美国队长2"];
    for (NSInteger r = 0; r < 2; r++) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 10.0;
        row.distribution = UIStackViewDistributionFillEqually;
        for (NSInteger c = 0; c < 3; c++) {
            [row addArrangedSubview:[self videoPoster:movies[r * 3 + c]]];
        }
        [grid addArrangedSubview:row];
    }
    [section addSubview:title];
    [section addSubview:grid];
    [section.heightAnchor constraintEqualToConstant:360.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:section.topAnchor constant:16.0],
        [grid.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [grid.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-16.0],
        [grid.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:14.0],
        [grid.bottomAnchor constraintEqualToAnchor:section.bottomAnchor constant:-16.0]
    ]];
    return section;
}

- (UIView *)fortuneSection {
    return [self horizontalSection:@"大福袋" subtitle:nil more:@"查看更多 ›" cards:@[
        @[@"24天生日动态大会员", @"天天抽奖", @"去看看"],
        @[@"通网龄，领流量", @"会员福利", @"领取"]
    ] snapping:NO];
}

- (UIView *)otherWaysSection {
    UIView *card = [self roundedCard];
    UILabel *title = [self label:@"其他开通方式" size:16.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UIStackView *row = [[UIStackView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 12.0;
    row.distribution = UIStackViewDistributionFillEqually;
    [row addArrangedSubview:[self simpleWay:@"赠送好友\n与好友一起干杯"]];
    [row addArrangedSubview:[self simpleWay:@"激活码开通\n使用开通大会员"]];
    [card addSubview:title];
    [card addSubview:row];
    [card.heightAnchor constraintEqualToConstant:132.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:16.0],
        [row.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.0],
        [row.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.0],
        [row.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:14.0],
        [row.heightAnchor constraintEqualToConstant:64.0]
    ]];
    return card;
}

- (UIView *)horizontalSection:(NSString *)title subtitle:(NSString *)subtitle more:(NSString *)moreText cards:(NSArray<NSArray *> *)cards snapping:(BOOL)snapping {
    UIView *section = [self roundedCard];
    UILabel *titleLabel = [self label:subtitle.length > 0 ? [NSString stringWithFormat:@"%@  %@", title, subtitle] : title size:18.0 weight:UIFontWeightSemibold color:BLMemberText()];
    UILabel *more = [self label:moreText ?: @"" size:15.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    UIScrollView *scroll = snapping ? [[BLMemberSnapScrollView alloc] init] : [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 14.0;
    [scroll addSubview:stack];
    for (NSArray *cardData in cards) {
        [stack addArrangedSubview:[self benefitCard:cardData]];
    }
    if ([scroll isKindOfClass:[BLMemberSnapScrollView class]]) {
        ((BLMemberSnapScrollView *)scroll).itemWidth = 212.0;
    }
    [section addSubview:titleLabel];
    [section addSubview:more];
    [section addSubview:scroll];
    [section.heightAnchor constraintEqualToConstant:244.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [titleLabel.topAnchor constraintEqualToAnchor:section.topAnchor constant:16.0],
        [more.trailingAnchor constraintEqualToAnchor:section.trailingAnchor constant:-16.0],
        [more.centerYAnchor constraintEqualToAnchor:titleLabel.centerYAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:section.leadingAnchor constant:16.0],
        [scroll.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [scroll.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16.0],
        [scroll.heightAnchor constraintEqualToConstant:168.0],
        [stack.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor],
        [stack.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.heightAnchor]
    ]];
    return section;
}

- (UIView *)benefitCard:(NSArray *)data {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor colorWithRed:0.91 green:0.66 blue:0.25 alpha:1.0];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;
    UILabel *main = [self label:data[0] size:16.0 weight:UIFontWeightRegular color:BLMemberText()];
    main.numberOfLines = 2;
    UILabel *sub = [self label:data[1] size:13.0 weight:UIFontWeightRegular color:[[UIColor blackColor] colorWithAlphaComponent:0.45]];
    sub.numberOfLines = 2;
    UIButton *button = [self pillButton:data[2] filled:NO];
    button.backgroundColor = [UIColor whiteColor];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [card addSubview:main];
    [card addSubview:sub];
    [card addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [card.widthAnchor constraintEqualToConstant:212.0],
        [main.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14.0],
        [main.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [main.topAnchor constraintEqualToAnchor:card.topAnchor constant:18.0],
        [sub.leadingAnchor constraintEqualToAnchor:main.leadingAnchor],
        [sub.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [sub.topAnchor constraintEqualToAnchor:main.bottomAnchor constant:8.0],
        [sub.bottomAnchor constraintLessThanOrEqualToAnchor:button.topAnchor constant:-10.0],
        [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [button.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14.0],
        [button.widthAnchor constraintEqualToConstant:90.0],
        [button.heightAnchor constraintEqualToConstant:38.0]
    ]];
    return card;
}

- (BLMemberSnapScrollView *)snapScrollWithCards:(NSArray<UIView *> *)cards height:(CGFloat)height itemWidth:(CGFloat)itemWidth {
    BLMemberSnapScrollView *scroll = [[BLMemberSnapScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.itemWidth = itemWidth;
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 14.0;
    [scroll addSubview:stack];
    for (UIView *card in cards) {
        [stack addArrangedSubview:card];
        [card.widthAnchor constraintEqualToConstant:itemWidth].active = YES;
    }
    [NSLayoutConstraint activateConstraints:@[
        [stack.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor],
        [stack.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [stack.heightAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.heightAnchor]
    ]];
    return scroll;
}

- (UIView *)movieCard:(NSString *)title tag:(NSString *)tag city:(NSString *)city button:(NSString *)buttonTitle {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor colorWithRed:1.0 green:0.96 blue:0.98 alpha:1.0];
    card.layer.cornerRadius = 10.0;
    UIView *poster = [[UIView alloc] init];
    poster.translatesAutoresizingMaskIntoConstraints = NO;
    poster.backgroundColor = [UIColor colorWithRed:0.22 green:0.18 blue:0.26 alpha:1.0];
    poster.layer.cornerRadius = 6.0;
    UILabel *time = [self label:@"活动时间\n05.30 15:00" size:15.0 weight:UIFontWeightSemibold color:[UIColor whiteColor]];
    time.numberOfLines = 2;
    UILabel *name = [self label:title size:16.0 weight:UIFontWeightSemibold color:BLMemberText()];
    name.numberOfLines = 2;
    UILabel *tagLabel = [self label:[NSString stringWithFormat:@"  %@  ", tag] size:12.0 weight:UIFontWeightSemibold color:[UIColor whiteColor]];
    tagLabel.backgroundColor = BLMemberPink();
    tagLabel.layer.cornerRadius = 4.0;
    tagLabel.layer.masksToBounds = YES;
    UILabel *cityLabel = [self label:city size:13.0 weight:UIFontWeightRegular color:BLMemberSubText()];
    [poster addSubview:time];
    [card addSubview:poster];
    [card addSubview:name];
    [card addSubview:tagLabel];
    [card addSubview:cityLabel];
    if (buttonTitle.length > 0) {
        UIButton *button = [self pillButton:buttonTitle filled:YES];
        [card addSubview:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18.0],
            [button.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14.0],
            [button.widthAnchor constraintEqualToConstant:124.0],
            [button.heightAnchor constraintEqualToConstant:34.0]
        ]];
    }
    [NSLayoutConstraint activateConstraints:@[
        [poster.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14.0],
        [poster.topAnchor constraintEqualToAnchor:card.topAnchor constant:14.0],
        [poster.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14.0],
        [poster.widthAnchor constraintEqualToConstant:110.0],
        [time.leadingAnchor constraintEqualToAnchor:poster.leadingAnchor constant:10.0],
        [time.bottomAnchor constraintEqualToAnchor:poster.bottomAnchor constant:-10.0],
        [name.leadingAnchor constraintEqualToAnchor:poster.trailingAnchor constant:14.0],
        [name.topAnchor constraintEqualToAnchor:poster.topAnchor constant:6.0],
        [name.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [tagLabel.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [tagLabel.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:10.0],
        [tagLabel.trailingAnchor constraintLessThanOrEqualToAnchor:card.trailingAnchor constant:-14.0],
        [tagLabel.heightAnchor constraintEqualToConstant:26.0],
        [cityLabel.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [cityLabel.topAnchor constraintEqualToAnchor:tagLabel.bottomAnchor constant:12.0]
    ]];
    return card;
}

- (UIView *)couponView {
    UIView *coupon = [[UIView alloc] init];
    coupon.translatesAutoresizingMaskIntoConstraints = NO;
    coupon.backgroundColor = [UIColor colorWithRed:1.0 green:0.88 blue:0.93 alpha:1.0];
    coupon.layer.cornerRadius = 8.0;
    coupon.layer.borderColor = BLMemberPink().CGColor;
    coupon.layer.borderWidth = 1.0;
    UILabel *num = [self label:@"2 张" size:26.0 weight:UIFontWeightHeavy color:BLMemberPink()];
    UILabel *text = [self label:@"大会员专属票务优惠券\n立减2元  |  满120减5" size:14.0 weight:UIFontWeightRegular color:BLMemberText()];
    text.numberOfLines = 2;
    UIButton *button = [self pillButton:@"限时领取" filled:YES];
    [coupon addSubview:num];
    [coupon addSubview:text];
    [coupon addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [num.leadingAnchor constraintEqualToAnchor:coupon.leadingAnchor constant:24.0],
        [num.centerYAnchor constraintEqualToAnchor:coupon.centerYAnchor],
        [text.leadingAnchor constraintEqualToAnchor:coupon.leadingAnchor constant:104.0],
        [text.trailingAnchor constraintLessThanOrEqualToAnchor:button.leadingAnchor constant:-10.0],
        [text.centerYAnchor constraintEqualToAnchor:coupon.centerYAnchor],
        [button.trailingAnchor constraintEqualToAnchor:coupon.trailingAnchor constant:-18.0],
        [button.centerYAnchor constraintEqualToAnchor:coupon.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:86.0],
        [button.heightAnchor constraintEqualToConstant:34.0]
    ]];
    return coupon;
}

- (UIView *)posterCard:(NSString *)title status:(NSString *)status {
    UIStackView *card = [[UIStackView alloc] init];
    card.axis = UILayoutConstraintAxisVertical;
    card.spacing = 8.0;
    UIView *poster = [[UIView alloc] init];
    poster.translatesAutoresizingMaskIntoConstraints = NO;
    poster.backgroundColor = [UIColor colorWithRed:0.35 green:0.48 blue:0.67 alpha:1.0];
    poster.layer.cornerRadius = 6.0;
    UILabel *label = [self label:title size:15.0 weight:UIFontWeightRegular color:BLMemberText()];
    label.numberOfLines = 2;
    UILabel *state = [self label:status size:15.0 weight:UIFontWeightRegular color:BLMemberPink()];
    state.textAlignment = NSTextAlignmentCenter;
    state.backgroundColor = [UIColor colorWithRed:1.0 green:0.90 blue:0.94 alpha:1.0];
    [poster.heightAnchor constraintEqualToConstant:150.0].active = YES;
    [state.heightAnchor constraintEqualToConstant:28.0].active = YES;
    [card addArrangedSubview:poster];
    [card addArrangedSubview:label];
    [card addArrangedSubview:state];
    return card;
}

- (UIView *)videoPoster:(NSString *)title {
    UIStackView *card = [[UIStackView alloc] init];
    card.axis = UILayoutConstraintAxisVertical;
    card.spacing = 6.0;
    UIView *cover = [[UIView alloc] init];
    cover.translatesAutoresizingMaskIntoConstraints = NO;
    cover.backgroundColor = [UIColor colorWithRed:0.18 green:0.28 blue:0.42 alpha:1.0];
    cover.layer.cornerRadius = 5.0;
    UILabel *label = [self label:title size:14.0 weight:UIFontWeightRegular color:BLMemberText()];
    label.numberOfLines = 2;
    [cover.heightAnchor constraintEqualToConstant:118.0].active = YES;
    [card addArrangedSubview:cover];
    [card addArrangedSubview:label];
    return card;
}

- (UIView *)miniPinkCard:(NSString *)text {
    UILabel *card = [self label:text size:14.0 weight:UIFontWeightRegular color:BLMemberPink()];
    card.textAlignment = NSTextAlignmentCenter;
    card.numberOfLines = 2;
    card.backgroundColor = [UIColor colorWithRed:1.0 green:0.91 blue:0.95 alpha:1.0];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;
    return card;
}

- (UIView *)simpleWay:(NSString *)text {
    UILabel *view = [self label:text size:14.0 weight:UIFontWeightRegular color:BLMemberText()];
    view.numberOfLines = 2;
    view.textAlignment = NSTextAlignmentCenter;
    view.backgroundColor = [UIColor colorWithRed:1.0 green:0.94 blue:0.97 alpha:1.0];
    view.layer.cornerRadius = 8.0;
    view.layer.masksToBounds = YES;
    return view;
}

- (UIView *)whiteCardWithContent:(UIView *)content height:(CGFloat)height {
    UIView *card = [self roundedCard];
    [card addSubview:content];
    [card.heightAnchor constraintEqualToConstant:height].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [content.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14.0],
        [content.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14.0],
        [content.topAnchor constraintEqualToAnchor:card.topAnchor constant:14.0],
        [content.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14.0]
    ]];
    return card;
}

- (UIView *)roundedCard {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 14.0;
    card.layer.masksToBounds = YES;
    return card;
}

- (UIButton *)pillButton:(NSString *)title filled:(BOOL)filled {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = 20.0;
    button.layer.borderWidth = filled ? 0.0 : 1.0;
    button.layer.borderColor = BLMemberPink().CGColor;
    button.backgroundColor = filled ? BLMemberPink() : [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:filled ? [UIColor whiteColor] : BLMemberPink() forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    return button;
}

- (UIImageView *)icon:(NSString *)name {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:26.0 weight:UIImageSymbolWeightRegular];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    icon.tintColor = [UIColor blackColor];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    return icon;
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.72;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.paymentBarShown && scrollView.contentOffset.y > 290.0) {
        self.paymentBarShown = YES;
        self.paymentBarView.hidden = NO;
        [self.paymentBarView startCountdown];
    }
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

@end
