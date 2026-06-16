#import "BLLiveBeautyPageView.h"
#import "BLLiveBeautyLiveCardView.h"

static UIColor *BLLiveBeautyPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLLiveBeautyMuted(void) {
    return [UIColor colorWithWhite:0.60 alpha:1.0];
}

@interface BLLiveBeautyItem : NSObject
@property (nonatomic, copy) NSString *anchor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *viewers;
@property (nonatomic, strong) NSArray<UIColor *> *colors;
+ (instancetype)itemWithAnchor:(NSString *)anchor title:(NSString *)title viewers:(NSString *)viewers colors:(NSArray<UIColor *> *)colors;
@end

@implementation BLLiveBeautyItem

+ (instancetype)itemWithAnchor:(NSString *)anchor title:(NSString *)title viewers:(NSString *)viewers colors:(NSArray<UIColor *> *)colors {
    BLLiveBeautyItem *item = [[BLLiveBeautyItem alloc] init];
    item.anchor = anchor;
    item.title = title;
    item.viewers = viewers;
    item.colors = colors;
    return item;
}

@end

@interface BLLiveBeautyPageView ()
@property (nonatomic, strong) UIStackView *tabStack;
@property (nonatomic, strong) UIStackView *gridStack;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<BLLiveBeautyItem *> *> *itemsByTab;
@property (nonatomic, copy) NSString *selectedTab;
@end

@implementation BLLiveBeautyPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildData];
        [self buildView];
        [self selectTab:@"推荐"];
    }
    return self;
}

- (void)buildData {
    UIColor *red = [UIColor colorWithRed:0.62 green:0.10 blue:0.12 alpha:1.0];
    UIColor *rose = [UIColor colorWithRed:0.88 green:0.38 blue:0.52 alpha:1.0];
    UIColor *teal = [UIColor colorWithRed:0.24 green:0.62 blue:0.58 alpha:1.0];
    UIColor *lake = [UIColor colorWithRed:0.16 green:0.45 blue:0.78 alpha:1.0];
    UIColor *violet = [UIColor colorWithRed:0.44 green:0.30 blue:0.74 alpha:1.0];
    UIColor *ink = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0.30 green:0.60 blue:0.36 alpha:1.0];
    UIColor *sand = [UIColor colorWithRed:0.83 green:0.66 blue:0.42 alpha:1.0];

    self.itemsByTab = @{
        @"推荐": @[
            [BLLiveBeautyItem itemWithAnchor:@"谢孟伟-团队招人" title:@"嘎子哥来了" viewers:@"15.3万" colors:@[ink, lake]],
            [BLLiveBeautyItem itemWithAnchor:@"安慕茜不喝酸奶" title:@"退役女演员，曾出演《我..." viewers:@"5295" colors:@[red, rose]],
            [BLLiveBeautyItem itemWithAnchor:@"朝朝-睡不醒版" title:@"偷偷播没人敢这么播" viewers:@"2915" colors:@[teal, lake]],
            [BLLiveBeautyItem itemWithAnchor:@"心碎小猫-v-" title:@"山西省花 曾入围形象大使" viewers:@"6470" colors:@[violet, ink]],
            [BLLiveBeautyItem itemWithAnchor:@"枝夏" title:@"想回国发展" viewers:@"5485" colors:@[green, sand]],
            [BLLiveBeautyItem itemWithAnchor:@"拾壹碎碎念拾壹最" title:@"我会唱跳、rap...我是..." viewers:@"179" colors:@[sand, violet]]
        ],
        @"热门": @[
            [BLLiveBeautyItem itemWithAnchor:@"甜妹营业中" title:@"今天也要认真直播" viewers:@"8.2万" colors:@[rose, violet]],
            [BLLiveBeautyItem itemWithAnchor:@"小鹿在海边" title:@"海风和晚霞都刚刚好" viewers:@"3.4万" colors:@[lake, teal]],
            [BLLiveBeautyItem itemWithAnchor:@"柠檬汽水" title:@"聊天点歌陪你到零点" viewers:@"2.9万" colors:@[green, lake]],
            [BLLiveBeautyItem itemWithAnchor:@"白桃乌龙" title:@"新妆试播，来看看吗" viewers:@"1.8万" colors:@[sand, rose]],
            [BLLiveBeautyItem itemWithAnchor:@"夜航星" title:@"深夜电台开播" viewers:@"9588" colors:@[ink, violet]],
            [BLLiveBeautyItem itemWithAnchor:@"晴天记录" title:@"今日份穿搭分享" viewers:@"7420" colors:@[teal, green]]
        ],
        @"最新": @[
            [BLLiveBeautyItem itemWithAnchor:@"初次见面呀" title:@"新人第一天开播" viewers:@"952" colors:@[rose, sand]],
            [BLLiveBeautyItem itemWithAnchor:@"阿栀今天早睡" title:@"边化妆边聊天" viewers:@"831" colors:@[violet, rose]],
            [BLLiveBeautyItem itemWithAnchor:@"风吹麦浪" title:@"户外散步直播中" viewers:@"620" colors:@[green, teal]],
            [BLLiveBeautyItem itemWithAnchor:@"慢半拍" title:@"随便聊聊最近生活" viewers:@"514" colors:@[lake, ink]],
            [BLLiveBeautyItem itemWithAnchor:@"小满要努力" title:@"舞蹈练习室打卡" viewers:@"386" colors:@[red, sand]],
            [BLLiveBeautyItem itemWithAnchor:@"月亮邮差" title:@"今天唱一些老歌" viewers:@"248" colors:@[ink, lake]]
        ]
    };
}

- (void)buildView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

    self.tabStack = [[UIStackView alloc] init];
    self.tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabStack.axis = UILayoutConstraintAxisHorizontal;
    self.tabStack.spacing = 18.0;
    self.tabStack.alignment = UIStackViewAlignmentCenter;
    [self addSubview:self.tabStack];

    NSMutableArray *buttons = [NSMutableArray array];
    for (NSString *title in @[@"推荐", @"热门", @"最新"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        button.layer.cornerRadius = 16.0;
        button.layer.borderWidth = 1.2;
        button.accessibilityIdentifier = title;
        [button addTarget:self action:@selector(tabButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabStack addArrangedSubview:button];
        [buttons addObject:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.widthAnchor constraintEqualToConstant:70.0],
            [button.heightAnchor constraintEqualToConstant:34.0]
        ]];
    }
    self.tabButtons = buttons.copy;

    self.gridStack = [[UIStackView alloc] init];
    self.gridStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.gridStack.axis = UILayoutConstraintAxisVertical;
    self.gridStack.spacing = 8.0;
    [self addSubview:self.gridStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.tabStack.topAnchor constraintEqualToAnchor:self.topAnchor constant:4.0],
        [self.tabStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [self.tabStack.heightAnchor constraintEqualToConstant:50.0],

        [self.gridStack.topAnchor constraintEqualToAnchor:self.tabStack.bottomAnchor constant:6.0],
        [self.gridStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12.0],
        [self.gridStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12.0],
        [self.gridStack.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)tabButtonTapped:(UIButton *)sender {
    [self selectTab:sender.accessibilityIdentifier ?: @"推荐"];
}

- (void)selectTab:(NSString *)tab {
    self.selectedTab = tab;
    for (UIButton *button in self.tabButtons) {
        BOOL selected = [button.accessibilityIdentifier isEqualToString:tab];
        UIColor *color = selected ? BLLiveBeautyPink() : BLLiveBeautyMuted();
        [button setTitleColor:color forState:UIControlStateNormal];
        button.layer.borderColor = color.CGColor;
        button.backgroundColor = selected ? [[UIColor whiteColor] colorWithAlphaComponent:0.96] : [UIColor clearColor];
    }
    [self reloadGrid];
}

- (void)reloadGrid {
    for (UIView *view in self.gridStack.arrangedSubviews.copy) {
        [self.gridStack removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    NSArray<BLLiveBeautyItem *> *items = self.itemsByTab[self.selectedTab] ?: @[];
    for (NSUInteger index = 0; index < items.count; index += 2) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 10.0;
        row.distribution = UIStackViewDistributionFillEqually;
        [self.gridStack addArrangedSubview:row];

        BLLiveBeautyItem *left = items[index];
        [row addArrangedSubview:[[BLLiveBeautyLiveCardView alloc] initWithAnchor:left.anchor title:left.title viewers:left.viewers colors:left.colors]];
        if (index + 1 < items.count) {
            BLLiveBeautyItem *right = items[index + 1];
            [row addArrangedSubview:[[BLLiveBeautyLiveCardView alloc] initWithAnchor:right.anchor title:right.title viewers:right.viewers colors:right.colors]];
        } else {
            [row addArrangedSubview:[[UIView alloc] init]];
        }
    }
}

@end
