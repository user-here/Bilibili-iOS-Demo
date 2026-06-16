#import "BLLivePopularityView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLLiveRankPink(void) {
    return [UIColor colorWithRed:0.86 green:0.35 blue:0.56 alpha:1.0];
}

@interface BLLivePopularityItem : NSObject
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *helperText;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) UIColor *avatarColor;
+ (instancetype)itemWithRank:(NSInteger)rank name:(NSString *)name category:(NSString *)category helperText:(NSString *)helperText score:(NSInteger)score avatarColor:(UIColor *)avatarColor;
@end

@implementation BLLivePopularityItem

+ (instancetype)itemWithRank:(NSInteger)rank name:(NSString *)name category:(NSString *)category helperText:(NSString *)helperText score:(NSInteger)score avatarColor:(UIColor *)avatarColor {
    BLLivePopularityItem *item = [[BLLivePopularityItem alloc] init];
    item.rank = rank;
    item.name = name;
    item.category = category;
    item.helperText = helperText;
    item.score = score;
    item.avatarColor = avatarColor;
    return item;
}

@end

@interface BLLivePopularityCell : UITableViewCell
@property (nonatomic, strong) CAGradientLayer *rankGradientLayer;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *backgroundRankLabel;
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) UILabel *crownLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreTitleLabel;
@end

@implementation BLLivePopularityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.rankGradientLayer = [CAGradientLayer layer];
        self.rankGradientLayer.startPoint = CGPointMake(0.0, 0.5);
        self.rankGradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [self.contentView.layer insertSublayer:self.rankGradientLayer atIndex:0];

        self.backgroundRankLabel = [self labelWithFont:[UIFont systemFontOfSize:96.0 weight:UIFontWeightBold] color:[[UIColor whiteColor] colorWithAlphaComponent:0.42]];
        self.backgroundRankLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.backgroundRankLabel];

        self.rankLabel = [self labelWithFont:[UIFont italicSystemFontOfSize:24.0] color:[UIColor colorWithWhite:0.55 alpha:1.0]];
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.rankLabel];

        self.avatarView = [[UIView alloc] init];
        self.avatarView.layer.cornerRadius = 30.0;
        self.avatarView.layer.borderWidth = 1.4;
        self.avatarView.layer.borderColor = BLLiveRankPink().CGColor;
        self.avatarView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarView];

        self.avatarLabel = [self labelWithFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold] color:[UIColor whiteColor]];
        self.avatarLabel.textAlignment = NSTextAlignmentCenter;
        [self.avatarView addSubview:self.avatarLabel];

        self.crownLabel = [self labelWithFont:[UIFont systemFontOfSize:19.0 weight:UIFontWeightBold] color:[UIColor colorWithRed:0.98 green:0.74 blue:0.16 alpha:1.0]];
        self.crownLabel.text = @"♛";
        self.crownLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.crownLabel];

        self.nameLabel = [self labelWithFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular] color:[UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1.0]];
        [self.contentView addSubview:self.nameLabel];

        self.detailLabel = [self labelWithFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.50 alpha:1.0]];
        [self.contentView addSubview:self.detailLabel];

        self.scoreLabel = [self labelWithFont:[UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular] color:BLLiveRankPink()];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.scoreLabel];

        self.scoreTitleLabel = [self labelWithFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:0.48 alpha:1.0]];
        self.scoreTitleLabel.text = @"助力值";
        self.scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.scoreTitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = UIEdgeInsetsInsetRect(self.contentView.bounds, UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0));
    self.rankGradientLayer.frame = self.contentView.bounds;
    self.backgroundRankLabel.frame = CGRectMake(CGRectGetMaxX(bounds) - 170.0, CGRectGetMinY(bounds) - 14.0, 160.0, CGRectGetHeight(bounds) + 28.0);
    self.rankLabel.frame = CGRectMake(CGRectGetMinX(bounds) + 14.0, CGRectGetMinY(bounds) + 34.0, 36.0, 34.0);
    self.avatarView.frame = CGRectMake(CGRectGetMinX(bounds) + 58.0, CGRectGetMinY(bounds) + 22.0, 60.0, 60.0);
    self.avatarLabel.frame = self.avatarView.bounds;
    self.crownLabel.frame = CGRectMake(CGRectGetMinX(self.avatarView.frame) - 8.0, CGRectGetMinY(self.avatarView.frame) - 13.0, 28.0, 24.0);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 16.0, CGRectGetMinY(bounds) + 24.0, 260.0, 26.0);
    self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 4.0, 260.0, 22.0);
    self.scoreLabel.frame = CGRectMake(CGRectGetMaxX(bounds) - 112.0, CGRectGetMinY(bounds) + 24.0, 88.0, 28.0);
    self.scoreTitleLabel.frame = CGRectMake(CGRectGetMinX(self.scoreLabel.frame), CGRectGetMaxY(self.scoreLabel.frame) + 4.0, 88.0, 22.0);
}

- (void)configureWithItem:(BLLivePopularityItem *)item {
    self.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)item.rank];
    self.backgroundRankLabel.text = [NSString stringWithFormat:@"%ld", (long)item.rank];
    self.nameLabel.text = item.name;
    self.detailLabel.text = [NSString stringWithFormat:@"%@  |  %@", item.category, item.helperText];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)item.score];
    self.avatarView.backgroundColor = item.avatarColor;
    self.avatarLabel.text = [item.name substringToIndex:MIN(1, item.name.length)];
    self.crownLabel.hidden = item.rank != 1;

    self.contentView.layer.cornerRadius = 0.0;
    self.contentView.layer.masksToBounds = NO;
    if (item.rank == 1) {
        self.rankGradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:1.00 green:0.92 blue:0.58 alpha:0.55].CGColor,
            (__bridge id)[UIColor whiteColor].CGColor
        ];
        self.rankLabel.textColor = [UIColor colorWithRed:0.96 green:0.76 blue:0.22 alpha:0.8];
    } else if (item.rank == 2) {
        self.rankGradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:0.65 green:0.78 blue:1.00 alpha:0.42].CGColor,
            (__bridge id)[UIColor whiteColor].CGColor
        ];
        self.rankLabel.textColor = [UIColor colorWithRed:0.48 green:0.58 blue:0.82 alpha:0.8];
    } else if (item.rank == 3) {
        self.rankGradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:1.00 green:0.71 blue:0.50 alpha:0.38].CGColor,
            (__bridge id)[UIColor whiteColor].CGColor
        ];
        self.rankLabel.textColor = [UIColor colorWithRed:0.96 green:0.58 blue:0.38 alpha:0.8];
    } else {
        self.rankGradientLayer.colors = @[
            (__bridge id)[UIColor whiteColor].CGColor,
            (__bridge id)[UIColor whiteColor].CGColor
        ];
        self.rankLabel.textColor = [UIColor colorWithWhite:0.58 alpha:1.0];
        self.backgroundRankLabel.text = @"";
    }
}

- (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end

@interface BLLivePopularityView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<BLLivePopularityItem *> *items;
@end

@implementation BLLivePopularityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        [self buildData];
        [self buildView];
    }
    return self;
}

- (void)buildData {
    self.items = @[
        [BLLivePopularityItem itemWithRank:1 name:@"元气の阿呦" category:@"虚拟日常" helperText:@"6人助力中" score:1024 avatarColor:[UIColor colorWithRed:0.58 green:0.61 blue:0.78 alpha:1.0]],
        [BLLivePopularityItem itemWithRank:2 name:@"意可Echo" category:@"聊天电台" helperText:@"4人助力中" score:800 avatarColor:[UIColor colorWithRed:0.42 green:0.28 blue:0.26 alpha:1.0]],
        [BLLivePopularityItem itemWithRank:3 name:@"嘻嘻要嘻嘻oVO" category:@"颜值" helperText:@"3人助力中" score:600 avatarColor:[UIColor colorWithRed:0.53 green:0.59 blue:0.43 alpha:1.0]],
        [BLLivePopularityItem itemWithRank:4 name:@"悠屿兔" category:@"虚拟声优" helperText:@"3人助力中" score:514 avatarColor:[UIColor colorWithRed:0.95 green:0.86 blue:0.64 alpha:1.0]],
        [BLLivePopularityItem itemWithRank:5 name:@"橘子味柚子" category:@"虚拟日常" helperText:@"4人助力中" score:414 avatarColor:[UIColor colorWithRed:0.93 green:0.78 blue:0.69 alpha:1.0]],
        [BLLivePopularityItem itemWithRank:6 name:@"Kiki向前冲呀" category:@"萌宅领域" helperText:@"2人助力中" score:400 avatarColor:[UIColor colorWithRed:0.28 green:0.22 blue:0.27 alpha:1.0]],
        [BLLivePopularityItem itemWithRank:7 name:@"花锦耶" category:@"沉浸体验" helperText:@"2人助力中" score:400 avatarColor:[UIColor colorWithRed:0.42 green:0.63 blue:0.86 alpha:1.0]]
    ];
}

- (void)buildView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 6.0;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.rowHeight = 108.0;
    [self.tableView registerClass:BLLivePopularityCell.class forCellReuseIdentifier:@"BLLivePopularityCell"];
    [self addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:6.0],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-6.0],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLLivePopularityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLLivePopularityCell" forIndexPath:indexPath];
    [cell configureWithItem:self.items[indexPath.row]];
    return cell;
}

@end
