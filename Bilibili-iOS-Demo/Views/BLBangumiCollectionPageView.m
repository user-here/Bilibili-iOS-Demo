#import "BLBangumiCollectionPageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLBangumiPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static UIColor *BLBangumiText(void) {
    return [UIColor colorWithRed:0.14 green:0.14 blue:0.16 alpha:1.0];
}

@interface BLBangumiGradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLBangumiGradientView

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

@interface BLBangumiCollectionItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updateText;
@property (nonatomic, copy) NSString *progressText;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, assign) BOOL selected;
@end

@implementation BLBangumiCollectionItem
@end

@interface BLBangumiCollectionCell : UITableViewCell
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) NSLayoutConstraint *checkWidthConstraint;
@property (nonatomic, strong) BLBangumiGradientView *coverView;
@property (nonatomic, strong) UILabel *coverMarkLabel;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *updateLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, copy) void (^selectionToggled)(void);
- (void)configureWithItem:(BLBangumiCollectionItem *)item managing:(BOOL)managing;
@end

@implementation BLBangumiCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.checkButton.layer.cornerRadius = 3.0;
    self.checkButton.layer.borderWidth = 1.0;
    self.checkButton.layer.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0].CGColor;
    [self.checkButton addTarget:self action:@selector(checkTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkButton];

    self.coverView = [[BLBangumiGradientView alloc] init];
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    self.coverView.layer.cornerRadius = 4.0;
    self.coverView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.coverView];

    self.coverMarkLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightHeavy] color:[UIColor whiteColor]];
    self.coverMarkLabel.numberOfLines = 2;
    self.coverMarkLabel.textAlignment = NSTextAlignmentCenter;
    [self.coverView addSubview:self.coverMarkLabel];

    self.badgeLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.backgroundColor = [UIColor colorWithRed:0.22 green:0.72 blue:0.90 alpha:1.0];
    self.badgeLabel.layer.cornerRadius = 4.0;
    self.badgeLabel.layer.masksToBounds = YES;
    [self.coverView addSubview:self.badgeLabel];

    self.titleLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular] color:BLBangumiText()];
    [self.contentView addSubview:self.titleLabel];

    self.updateLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular] color:BLBangumiPink()];
    [self.contentView addSubview:self.updateLabel];

    self.progressLabel = [self labelWithText:@"" font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    [self.contentView addSubview:self.progressLabel];

    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.moreButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    self.moreButton.tintColor = [UIColor colorWithWhite:0.72 alpha:1.0];
    [self.contentView addSubview:self.moreButton];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    [self.contentView addSubview:line];

    self.checkWidthConstraint = [self.checkButton.widthAnchor constraintEqualToConstant:0.0];
    [NSLayoutConstraint activateConstraints:@[
        [self.checkButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16.0],
        [self.checkButton.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor],
        self.checkWidthConstraint,
        [self.checkButton.heightAnchor constraintEqualToConstant:30.0],
        [self.coverView.leadingAnchor constraintEqualToAnchor:self.checkButton.trailingAnchor constant:12.0],
        [self.coverView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12.0],
        [self.coverView.widthAnchor constraintEqualToConstant:86.0],
        [self.coverView.heightAnchor constraintEqualToConstant:116.0],
        [self.coverMarkLabel.centerXAnchor constraintEqualToAnchor:self.coverView.centerXAnchor],
        [self.coverMarkLabel.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor],
        [self.coverMarkLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.coverView.leadingAnchor constant:8.0],
        [self.coverMarkLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.coverView.trailingAnchor constant:-8.0],
        [self.badgeLabel.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:-4.0],
        [self.badgeLabel.topAnchor constraintEqualToAnchor:self.coverView.topAnchor constant:5.0],
        [self.badgeLabel.widthAnchor constraintEqualToConstant:38.0],
        [self.badgeLabel.heightAnchor constraintEqualToConstant:23.0],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:14.0],
        [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.moreButton.leadingAnchor constant:-8.0],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.coverView.topAnchor constant:4.0],
        [self.updateLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.updateLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.moreButton.leadingAnchor constant:-8.0],
        [self.updateLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10.0],
        [self.progressLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.progressLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.moreButton.leadingAnchor constant:-8.0],
        [self.progressLabel.topAnchor constraintEqualToAnchor:self.updateLabel.bottomAnchor constant:9.0],
        [self.moreButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16.0],
        [self.moreButton.centerYAnchor constraintEqualToAnchor:self.coverView.centerYAnchor],
        [self.moreButton.widthAnchor constraintEqualToConstant:28.0],
        [self.moreButton.heightAnchor constraintEqualToConstant:40.0],
        [line.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:1.0],
        [self.contentView.heightAnchor constraintEqualToConstant:140.0]
    ]];
}

- (void)configureWithItem:(BLBangumiCollectionItem *)item managing:(BOOL)managing {
    self.coverView.colors = @[item.startColor, item.endColor];
    self.coverMarkLabel.text = [item.title substringToIndex:MIN(3, item.title.length)];
    self.badgeLabel.text = item.badge;
    self.badgeLabel.hidden = item.badge.length == 0;
    self.titleLabel.text = item.title;
    self.updateLabel.text = item.updateText;
    self.updateLabel.textColor = item.updateText.length > 0 && ![item.updateText isEqualToString:@"尚未观看"] ? BLBangumiPink() : [UIColor colorWithWhite:0.58 alpha:1.0];
    self.progressLabel.text = item.progressText;
    self.moreButton.hidden = managing;
    self.checkWidthConstraint.constant = managing ? 30.0 : 0.0;
    self.checkButton.hidden = !managing;
    [self updateCheckAppearance:item.selected];
}

- (void)checkTapped {
    if (self.selectionToggled) {
        self.selectionToggled();
    }
}

- (void)updateCheckAppearance:(BOOL)checked {
    self.checkButton.backgroundColor = checked ? BLBangumiPink() : [UIColor whiteColor];
    self.checkButton.layer.borderColor = checked ? BLBangumiPink().CGColor : [UIColor colorWithWhite:0.84 alpha:1.0].CGColor;
    [self.checkButton setImage:(checked ? [UIImage systemImageNamed:@"checkmark"] : nil) forState:UIControlStateNormal];
    self.checkButton.tintColor = [UIColor whiteColor];
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

@interface BLBangumiCollectionPageView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *manageButton;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) NSMutableArray<BLBangumiCollectionItem *> *items;
@property (nonatomic, assign) BOOL managing;
@property (nonatomic, assign) BOOL finishHintHidden;
@end

@implementation BLBangumiCollectionPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self buildData];
        [self buildView];
    }
    return self;
}

- (void)buildData {
    NSArray<NSArray *> *rawItems = @[
        @[@"牧神记", @"更新至第86话", @"看到第84集预告 0:44", @"出品", [UIColor colorWithRed:0.36 green:0.48 blue:0.42 alpha:1.0], [UIColor colorWithRed:0.78 green:0.70 blue:0.58 alpha:1.0]],
        @[@"名侦探柯南", @"更新至第1262话", @"看到第479话 22:07", @"大会员", [UIColor colorWithRed:0.18 green:0.38 blue:0.82 alpha:1.0], [UIColor colorWithRed:0.92 green:0.78 blue:0.26 alpha:1.0]],
        @[@"OVERLORD", @"全13话", @"看到第11话 0:09", @"独播", [UIColor colorWithRed:0.10 green:0.08 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.32 green:0.20 blue:0.58 alpha:1.0]],
        @[@"凡人修仙传", @"更新至第176话", @"看到第136话 9:22", @"出品", [UIColor colorWithRed:0.12 green:0.58 blue:0.62 alpha:1.0], [UIColor colorWithRed:0.62 green:0.84 blue:0.76 alpha:1.0]],
        @[@"间谍过家家 第三季", @"尚未观看", @"", @"大会员", [UIColor colorWithRed:0.92 green:0.58 blue:0.66 alpha:1.0], [UIColor colorWithRed:0.98 green:0.82 blue:0.76 alpha:1.0]],
        @[@"少年歌行 血染天启篇", @"全26话", @"尚未观看", @"出品", [UIColor colorWithRed:0.46 green:0.08 blue:0.10 alpha:1.0], [UIColor colorWithRed:0.82 green:0.22 blue:0.26 alpha:1.0]],
        @[@"鬼灭之刃 柱训练篇", @"全8话", @"已看完第8话", @"大会员", [UIColor colorWithRed:0.18 green:0.28 blue:0.26 alpha:1.0], [UIColor colorWithRed:0.54 green:0.66 blue:0.52 alpha:1.0]]
    ];
    self.items = [NSMutableArray array];
    for (NSArray *row in rawItems) {
        BLBangumiCollectionItem *item = [[BLBangumiCollectionItem alloc] init];
        item.title = row[0];
        item.updateText = row[1];
        item.progressText = row[2];
        item.badge = row[3];
        item.startColor = row[4];
        item.endColor = row[5];
        [self.items addObject:item];
    }
    self.items.firstObject.selected = YES;
}

- (void)buildView {
    UIView *nav = [[UIView alloc] init];
    nav.translatesAutoresizingMaskIntoConstraints = NO;
    nav.backgroundColor = [UIColor whiteColor];
    [self addSubview:nav];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    [back setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    back.tintColor = [UIColor colorWithWhite:0.34 alpha:1.0];
    [back addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];

    UILabel *title = [self labelWithText:@"我的收藏" font:[UIFont systemFontOfSize:22.0 weight:UIFontWeightRegular] color:BLBangumiText()];
    [nav addSubview:title];

    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.translatesAutoresizingMaskIntoConstraints = NO;
    [plus setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
    plus.tintColor = [UIColor colorWithWhite:0.30 alpha:1.0];
    [nav addSubview:plus];

    UIView *primaryTabs = [self primaryTabsView];
    [self addSubview:primaryTabs];
    UIView *secondaryTabs = [self secondaryTabsView];
    [self addSubview:secondaryTabs];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 140.0;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:BLBangumiCollectionCell.class forCellReuseIdentifier:@"BLBangumiCollectionCell"];
    [self addSubview:self.tableView];

    self.bottomBar = [self managementBottomBar];
    self.bottomBar.hidden = YES;
    [self addSubview:self.bottomBar];

    [NSLayoutConstraint activateConstraints:@[
        [nav.topAnchor constraintEqualToAnchor:self.topAnchor],
        [nav.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [nav.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [nav.heightAnchor constraintEqualToConstant:70.0],
        [back.leadingAnchor constraintEqualToAnchor:nav.leadingAnchor constant:14.0],
        [back.bottomAnchor constraintEqualToAnchor:nav.bottomAnchor constant:-10.0],
        [back.widthAnchor constraintEqualToConstant:38.0],
        [back.heightAnchor constraintEqualToConstant:38.0],
        [title.leadingAnchor constraintEqualToAnchor:back.trailingAnchor constant:18.0],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [plus.trailingAnchor constraintEqualToAnchor:nav.trailingAnchor constant:-20.0],
        [plus.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [plus.widthAnchor constraintEqualToConstant:40.0],
        [plus.heightAnchor constraintEqualToConstant:40.0],
        [primaryTabs.topAnchor constraintEqualToAnchor:nav.bottomAnchor],
        [primaryTabs.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [primaryTabs.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [primaryTabs.heightAnchor constraintEqualToConstant:56.0],
        [secondaryTabs.topAnchor constraintEqualToAnchor:primaryTabs.bottomAnchor],
        [secondaryTabs.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [secondaryTabs.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [secondaryTabs.heightAnchor constraintEqualToConstant:54.0],
        [self.tableView.topAnchor constraintEqualToAnchor:secondaryTabs.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.bottomBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.bottomBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.bottomBar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.bottomBar.heightAnchor constraintEqualToConstant:76.0]
    ]];
}

- (UIView *)primaryTabsView {
    return [self tabBarWithTitles:@[@"视频", @"追番", @"追剧", @"追漫", @"图文", @"笔记"] selectedTitle:@"追番" large:YES];
}

- (UIView *)secondaryTabsView {
    UIView *container = [self tabBarWithTitles:@[@"想看", @"在看", @"看过"] selectedTitle:@"在看" large:NO];
    self.manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.manageButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.manageButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.manageButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0] forState:UIControlStateNormal];
    self.manageButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    [self.manageButton addTarget:self action:@selector(manageTapped) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.manageButton];

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [container addSubview:line];
    [NSLayoutConstraint activateConstraints:@[
        [self.manageButton.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16.0],
        [self.manageButton.centerYAnchor constraintEqualToAnchor:container.centerYAnchor constant:-3.0],
        [self.manageButton.widthAnchor constraintEqualToConstant:58.0],
        [self.manageButton.heightAnchor constraintEqualToConstant:42.0],
        [line.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:1.0]
    ]];
    return container;
}

- (UIView *)tabBarWithTitles:(NSArray<NSString *> *)titles selectedTitle:(NSString *)selectedTitle large:(BOOL)large {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    [container addSubview:stack];
    for (NSString *title in titles) {
        [stack addArrangedSubview:[self tabLabelWithText:title selected:[title isEqualToString:selectedTitle] large:large]];
    }
    CGFloat widthMultiplier = large ? 1.0 : 0.48;
    CGFloat leading = large ? 0.0 : 10.0;
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:container.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:leading],
        [stack.widthAnchor constraintEqualToAnchor:container.widthAnchor multiplier:widthMultiplier],
        [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
    return container;
}

- (UIView *)managementBottomBar {
    UIView *bar = [[UIView alloc] init];
    bar.translatesAutoresizingMaskIntoConstraints = NO;
    bar.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [bar addSubview:line];

    self.selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.selectAllButton setTitle:@"  全选" forState:UIControlStateNormal];
    [self.selectAllButton setTitleColor:BLBangumiText() forState:UIControlStateNormal];
    self.selectAllButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.selectAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.selectAllButton addTarget:self action:@selector(selectAllTapped) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:self.selectAllButton];

    UIButton *want = [self bottomActionButtonWithTitle:@"标记为想看" action:@selector(markWantTapped)];
    UIButton *watched = [self bottomActionButtonWithTitle:@"标记为看过" action:@selector(markWatchedTapped)];
    [bar addSubview:want];
    [bar addSubview:watched];

    [NSLayoutConstraint activateConstraints:@[
        [line.topAnchor constraintEqualToAnchor:bar.topAnchor],
        [line.leadingAnchor constraintEqualToAnchor:bar.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:bar.trailingAnchor],
        [line.heightAnchor constraintEqualToConstant:1.0],
        [self.selectAllButton.leadingAnchor constraintEqualToAnchor:bar.leadingAnchor constant:16.0],
        [self.selectAllButton.topAnchor constraintEqualToAnchor:bar.topAnchor],
        [self.selectAllButton.widthAnchor constraintEqualToConstant:120.0],
        [self.selectAllButton.heightAnchor constraintEqualToConstant:58.0],
        [watched.trailingAnchor constraintEqualToAnchor:bar.trailingAnchor constant:-18.0],
        [watched.topAnchor constraintEqualToAnchor:bar.topAnchor],
        [watched.widthAnchor constraintEqualToConstant:126.0],
        [watched.heightAnchor constraintEqualToConstant:58.0],
        [want.trailingAnchor constraintEqualToAnchor:watched.leadingAnchor constant:-18.0],
        [want.topAnchor constraintEqualToAnchor:bar.topAnchor],
        [want.widthAnchor constraintEqualToConstant:136.0],
        [want.heightAnchor constraintEqualToConstant:58.0]
    ]];
    return bar;
}

- (UIButton *)bottomActionButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:BLBangumiText() forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)tabLabelWithText:(NSString *)text selected:(BOOL)selected large:(BOOL)large {
    UILabel *label = [self labelWithText:text font:[UIFont systemFontOfSize:(large ? 20.0 : 18.0) weight:UIFontWeightRegular] color:(selected ? BLBangumiPink() : [UIColor colorWithWhite:0.36 alpha:1.0])];
    label.textAlignment = NSTextAlignmentCenter;
    if (selected) {
        if (large) {
            UIView *line = [[UIView alloc] init];
            line.translatesAutoresizingMaskIntoConstraints = NO;
            line.backgroundColor = BLBangumiPink();
            line.layer.cornerRadius = 1.5;
            [label addSubview:line];
            [NSLayoutConstraint activateConstraints:@[
                [line.centerXAnchor constraintEqualToAnchor:label.centerXAnchor],
                [line.bottomAnchor constraintEqualToAnchor:label.bottomAnchor constant:-2.0],
                [line.widthAnchor constraintEqualToConstant:42.0],
                [line.heightAnchor constraintEqualToConstant:3.0]
            ]];
        } else {
            label.backgroundColor = [BLBangumiPink() colorWithAlphaComponent:0.12];
            label.layer.cornerRadius = 5.0;
            label.layer.masksToBounds = YES;
        }
    }
    return label;
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (void)manageTapped {
    self.managing = !self.managing;
    self.manageButton.selected = self.managing;
    self.bottomBar.hidden = !self.managing;
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = self.managing ? 76.0 : 0.0;
    self.tableView.contentInset = inset;
    [self.tableView reloadData];
}

- (void)selectAllTapped {
    BOOL shouldSelect = NO;
    for (BLBangumiCollectionItem *item in self.items) {
        if (!item.selected) {
            shouldSelect = YES;
            break;
        }
    }
    for (BLBangumiCollectionItem *item in self.items) {
        item.selected = shouldSelect;
    }
    [self.tableView reloadData];
}

- (void)markWantTapped {
    [self updateSelectedItemsWithStatus:@"尚未观看" progress:@""];
}

- (void)markWatchedTapped {
    [self updateSelectedItemsWithStatus:@"已看完" progress:@""];
}

- (void)updateSelectedItemsWithStatus:(NSString *)status progress:(NSString *)progress {
    for (BLBangumiCollectionItem *item in self.items) {
        if (item.selected) {
            item.updateText = status;
            item.progressText = progress;
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count + (self.finishHintHidden ? 0 : 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (!self.finishHintHidden && indexPath.row == 0) ? 82.0 : 140.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.finishHintHidden && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self finishHintView]];
        UIView *hint = cell.contentView.subviews.lastObject;
        [NSLayoutConstraint activateConstraints:@[
            [hint.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16.0],
            [hint.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16.0],
            [hint.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:14.0],
            [hint.heightAnchor constraintEqualToConstant:54.0]
        ]];
        return cell;
    }
    BLBangumiCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLBangumiCollectionCell" forIndexPath:indexPath];
    BLBangumiCollectionItem *item = self.items[[self itemIndexForIndexPath:indexPath]];
    [cell configureWithItem:item managing:self.managing];
    __weak typeof(self) weakSelf = self;
    cell.selectionToggled = ^{
        item.selected = !item.selected;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.managing || (!self.finishHintHidden && indexPath.row == 0)) {
        return;
    }
    BLBangumiCollectionItem *item = self.items[[self itemIndexForIndexPath:indexPath]];
    item.selected = !item.selected;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSUInteger)itemIndexForIndexPath:(NSIndexPath *)indexPath {
    return self.finishHintHidden ? indexPath.row : indexPath.row - 1;
}

- (UIView *)finishHintView {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    view.layer.cornerRadius = 4.0;

    NSArray<UIColor *> *colors = @[
        [UIColor colorWithRed:0.38 green:0.36 blue:0.32 alpha:1.0],
        [UIColor colorWithRed:0.66 green:0.18 blue:0.24 alpha:1.0],
        [UIColor colorWithRed:0.16 green:0.36 blue:0.42 alpha:1.0]
    ];
    UIView *previous = nil;
    for (UIColor *color in colors) {
        UIView *avatar = [[UIView alloc] init];
        avatar.translatesAutoresizingMaskIntoConstraints = NO;
        avatar.backgroundColor = color;
        avatar.layer.cornerRadius = 6.0;
        avatar.layer.masksToBounds = YES;
        [view addSubview:avatar];
        NSLayoutXAxisAnchor *leadingAnchor = previous == nil ? view.leadingAnchor : previous.trailingAnchor;
        CGFloat leadingConstant = previous == nil ? 18.0 : 8.0;
        [NSLayoutConstraint activateConstraints:@[
            [avatar.leadingAnchor constraintEqualToAnchor:leadingAnchor constant:leadingConstant],
            [avatar.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
            [avatar.widthAnchor constraintEqualToConstant:42.0],
            [avatar.heightAnchor constraintEqualToConstant:42.0]
        ]];
        previous = avatar;
    }
    UILabel *label = [self labelWithText:@"有5部番可能看完了哦" font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.30 alpha:1.0]];
    [view addSubview:label];
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.translatesAutoresizingMaskIntoConstraints = NO;
    [close setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    close.tintColor = [UIColor colorWithWhite:0.54 alpha:1.0];
    [close addTarget:self action:@selector(closeFinishHintTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:close];
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:previous.trailingAnchor constant:20.0],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [close.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-14.0],
        [close.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [close.widthAnchor constraintEqualToConstant:32.0],
        [close.heightAnchor constraintEqualToConstant:32.0]
    ]];
    return view;
}

- (void)closeFinishHintTapped {
    self.finishHintHidden = YES;
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
