#import "BLWatchLaterPageView.h"
#import "BLVideoURLProvider.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLWatchPink(void) { return [UIColor colorWithRed:0.93 green:0.33 blue:0.57 alpha:1.0]; }
static UIColor *BLWatchText(void) { return [UIColor colorWithRed:0.14 green:0.13 blue:0.15 alpha:1.0]; }
static UIColor *BLWatchSubText(void) { return [UIColor colorWithWhite:0.58 alpha:1.0]; }
@implementation BLWatchLaterItem

+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views danmaku:(NSString *)danmaku durationText:(NSString *)durationText progressText:(NSString *)progressText progress:(CGFloat)progress finished:(BOOL)finished seed:(NSInteger)seed videoURLString:(NSString *)videoURLString {
    BLWatchLaterItem *item = [[BLWatchLaterItem alloc] init];
    item.title = title ?: @"";
    item.author = author ?: @"";
    item.views = views ?: @"";
    item.danmaku = danmaku ?: @"";
    item.durationText = durationText ?: @"";
    item.progressText = progressText;
    item.progress = MAX(0.0, MIN(1.0, progress));
    item.finished = finished;
    item.invalid = NO;
    item.seed = seed;
    item.videoURLString = videoURLString;
    return item;
}

@end

@interface BLWatchLaterCell : UITableViewCell
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UILabel *thumbTitleLabel;
@property (nonatomic, strong) UIView *durationPill;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIView *progressTrack;
@property (nonatomic, strong) UIView *progressFill;
@property (nonatomic, strong) NSLayoutConstraint *progressWidthConstraint;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *viewsLabel;
@property (nonatomic, strong) UILabel *danmakuLabel;
@property (nonatomic, strong) UIView *checkboxView;
@property (nonatomic, strong) UILabel *checkmarkLabel;
@property (nonatomic, strong) UIImageView *moreView;
@property (nonatomic, strong) NSLayoutConstraint *thumbLeadingConstraint;
- (void)configureWithItem:(BLWatchLaterItem *)item editing:(BOOL)editing selected:(BOOL)selected;
@end

@implementation BLWatchLaterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        self.checkboxView = [[UIView alloc] init];
        self.checkboxView.translatesAutoresizingMaskIntoConstraints = NO;
        self.checkboxView.layer.cornerRadius = 14.0;
        self.checkboxView.layer.borderWidth = 1.2;
        self.checkboxView.layer.masksToBounds = YES;
        self.checkboxView.hidden = YES;
        [self.contentView addSubview:self.checkboxView];

        self.checkmarkLabel = [self label:@"✓" size:19.0 weight:UIFontWeightRegular color:[UIColor whiteColor]];
        self.checkmarkLabel.textAlignment = NSTextAlignmentCenter;
        [self.checkboxView addSubview:self.checkmarkLabel];

        self.thumbView = [[UIView alloc] init];
        self.thumbView.translatesAutoresizingMaskIntoConstraints = NO;
        self.thumbView.layer.cornerRadius = 5.0;
        self.thumbView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.thumbView];

        UIView *shade = [[UIView alloc] init];
        shade.translatesAutoresizingMaskIntoConstraints = NO;
        shade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.20];
        [self.thumbView addSubview:shade];

        self.thumbTitleLabel = [self label:@"" size:18.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
        self.thumbTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.thumbTitleLabel.numberOfLines = 2;
        [self.thumbView addSubview:self.thumbTitleLabel];

        self.durationPill = [[UIView alloc] init];
        self.durationPill.translatesAutoresizingMaskIntoConstraints = NO;
        self.durationPill.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.42];
        self.durationPill.layer.cornerRadius = 3.0;
        self.durationPill.layer.masksToBounds = YES;
        [self.thumbView addSubview:self.durationPill];

        self.durationLabel = [self label:@"" size:12.0 weight:UIFontWeightMedium color:[UIColor whiteColor]];
        self.durationLabel.textAlignment = NSTextAlignmentCenter;
        [self.durationPill addSubview:self.durationLabel];

        self.progressTrack = [[UIView alloc] init];
        self.progressTrack.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressTrack.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.45];
        [self.thumbView addSubview:self.progressTrack];

        self.progressFill = [[UIView alloc] init];
        self.progressFill.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressFill.backgroundColor = BLWatchPink();
        [self.progressTrack addSubview:self.progressFill];

        self.titleLabel = [self label:@"" size:17.0 weight:UIFontWeightRegular color:BLWatchText()];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];

        self.authorLabel = [self metaLabel:@"" prefix:@"UP"];
        [self.contentView addSubview:self.authorLabel];
        self.viewsLabel = [self metaLabel:@"" prefix:@"▶"];
        [self.contentView addSubview:self.viewsLabel];
        self.danmakuLabel = [self metaLabel:@"" prefix:@"▤"];
        [self.contentView addSubview:self.danmakuLabel];

        UIImageSymbolConfiguration *moreConfig = [UIImageSymbolConfiguration configurationWithPointSize:17.0 weight:UIImageSymbolWeightRegular];
        self.moreView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:@"ellipsis"] imageWithConfiguration:moreConfig]];
        self.moreView.translatesAutoresizingMaskIntoConstraints = NO;
        self.moreView.tintColor = [UIColor colorWithWhite:0.74 alpha:1.0];
        self.moreView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.contentView addSubview:self.moreView];

        UIView *line = [[UIView alloc] init];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
        [self.contentView addSubview:line];

        self.thumbLeadingConstraint = [self.thumbView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15.0];
        self.progressWidthConstraint = [self.progressFill.widthAnchor constraintEqualToConstant:0.0];
        [NSLayoutConstraint activateConstraints:@[
            [self.checkboxView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18.0],
            [self.checkboxView.centerYAnchor constraintEqualToAnchor:self.thumbView.centerYAnchor],
            [self.checkboxView.widthAnchor constraintEqualToConstant:28.0],
            [self.checkboxView.heightAnchor constraintEqualToConstant:28.0],
            [self.checkmarkLabel.centerXAnchor constraintEqualToAnchor:self.checkboxView.centerXAnchor],
            [self.checkmarkLabel.centerYAnchor constraintEqualToAnchor:self.checkboxView.centerYAnchor constant:-1.0],
            [self.checkmarkLabel.widthAnchor constraintEqualToAnchor:self.checkboxView.widthAnchor],
            [self.checkmarkLabel.heightAnchor constraintEqualToAnchor:self.checkboxView.heightAnchor],
            self.thumbLeadingConstraint,
            [self.thumbView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:14.0],
            [self.thumbView.widthAnchor constraintEqualToConstant:180.0],
            [self.thumbView.heightAnchor constraintEqualToConstant:101.0],
            [shade.leadingAnchor constraintEqualToAnchor:self.thumbView.leadingAnchor],
            [shade.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor],
            [shade.topAnchor constraintEqualToAnchor:self.thumbView.topAnchor],
            [shade.bottomAnchor constraintEqualToAnchor:self.thumbView.bottomAnchor],
            [self.thumbTitleLabel.leadingAnchor constraintEqualToAnchor:self.thumbView.leadingAnchor constant:8.0],
            [self.thumbTitleLabel.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor constant:-8.0],
            [self.thumbTitleLabel.centerYAnchor constraintEqualToAnchor:self.thumbView.centerYAnchor],
            [self.durationPill.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor constant:-6.0],
            [self.durationPill.bottomAnchor constraintEqualToAnchor:self.thumbView.bottomAnchor constant:-7.0],
            [self.durationPill.heightAnchor constraintEqualToConstant:19.0],
            [self.durationLabel.leadingAnchor constraintEqualToAnchor:self.durationPill.leadingAnchor constant:6.0],
            [self.durationLabel.trailingAnchor constraintEqualToAnchor:self.durationPill.trailingAnchor constant:-6.0],
            [self.durationLabel.centerYAnchor constraintEqualToAnchor:self.durationPill.centerYAnchor],
            [self.progressTrack.leadingAnchor constraintEqualToAnchor:self.thumbView.leadingAnchor],
            [self.progressTrack.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor],
            [self.progressTrack.bottomAnchor constraintEqualToAnchor:self.thumbView.bottomAnchor],
            [self.progressTrack.heightAnchor constraintEqualToConstant:3.0],
            [self.progressFill.leadingAnchor constraintEqualToAnchor:self.progressTrack.leadingAnchor],
            [self.progressFill.topAnchor constraintEqualToAnchor:self.progressTrack.topAnchor],
            [self.progressFill.bottomAnchor constraintEqualToAnchor:self.progressTrack.bottomAnchor],
            self.progressWidthConstraint,
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor constant:13.0],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.moreView.leadingAnchor constant:-8.0],
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.thumbView.topAnchor constant:0.0],
            [self.authorLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [self.authorLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
            [self.authorLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:13.0],
            [self.viewsLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [self.viewsLabel.topAnchor constraintEqualToAnchor:self.authorLabel.bottomAnchor constant:7.0],
            [self.danmakuLabel.leadingAnchor constraintEqualToAnchor:self.viewsLabel.trailingAnchor constant:18.0],
            [self.danmakuLabel.centerYAnchor constraintEqualToAnchor:self.viewsLabel.centerYAnchor],
            [self.moreView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-14.0],
            [self.moreView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.moreView.widthAnchor constraintEqualToConstant:18.0],
            [self.moreView.heightAnchor constraintEqualToConstant:18.0],
            [line.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [line.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [line.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [line.heightAnchor constraintEqualToConstant:0.5]
        ]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.progressWidthConstraint.active = NO;
}

- (void)configureWithItem:(BLWatchLaterItem *)item editing:(BOOL)editing selected:(BOOL)selected {
    self.thumbView.backgroundColor = [self colorForSeed:item.seed];
    self.thumbTitleLabel.text = [self thumbTextForItem:item];
    self.durationLabel.text = item.isFinished ? @"已看完" : item.durationText;
    self.titleLabel.text = item.title;
    self.authorLabel.text = [NSString stringWithFormat:@"UP  %@", item.author];
    self.viewsLabel.text = [NSString stringWithFormat:@"▶ %@", item.views];
    self.danmakuLabel.text = [NSString stringWithFormat:@"▤ %@", item.danmaku];
    self.checkboxView.hidden = !editing;
    self.moreView.hidden = editing;
    self.thumbLeadingConstraint.constant = editing ? 59.0 : 15.0;
    self.checkboxView.backgroundColor = selected ? BLWatchPink() : [UIColor whiteColor];
    self.checkboxView.layer.borderColor = (selected ? BLWatchPink() : [UIColor colorWithWhite:0.82 alpha:1.0]).CGColor;
    self.checkmarkLabel.hidden = !selected;
    self.progressTrack.hidden = item.isFinished;
    self.progressWidthConstraint.active = NO;
    CGFloat visibleProgress = item.isFinished ? 0.0 : MAX(0.02, item.progress);
    if (visibleProgress > 0.0) {
        self.progressWidthConstraint = [self.progressFill.widthAnchor constraintEqualToAnchor:self.progressTrack.widthAnchor multiplier:visibleProgress];
    } else {
        self.progressWidthConstraint = [self.progressFill.widthAnchor constraintEqualToConstant:0.0];
    }
    self.progressWidthConstraint.active = YES;
}

- (NSString *)thumbTextForItem:(BLWatchLaterItem *)item {
    NSArray<NSString *> *texts = @[@"鸣潮", @"鬼味", @"隧夜轮回", @"金泳三", @"剧本线", @"LeetCode", @"高数", @"专升本"];
    return texts[labs((int)item.seed) % texts.count];
}

- (UIColor *)colorForSeed:(NSInteger)seed {
    NSArray<UIColor *> *colors = @[
        [UIColor colorWithRed:0.95 green:0.55 blue:0.75 alpha:1.0],
        [UIColor colorWithRed:0.11 green:0.12 blue:0.18 alpha:1.0],
        [UIColor colorWithRed:0.21 green:0.43 blue:0.31 alpha:1.0],
        [UIColor colorWithRed:0.27 green:0.29 blue:0.33 alpha:1.0],
        [UIColor colorWithRed:0.57 green:0.70 blue:0.86 alpha:1.0],
        [UIColor colorWithRed:0.95 green:0.95 blue:0.91 alpha:1.0],
        [UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:1.0],
        [UIColor colorWithRed:0.56 green:0.18 blue:0.16 alpha:1.0]
    ];
    return colors[labs((int)seed) % colors.count];
}

- (UILabel *)metaLabel:(NSString *)text prefix:(NSString *)prefix {
    return [self label:[NSString stringWithFormat:@"%@ %@", prefix, text] size:14.0 weight:UIFontWeightRegular color:BLWatchSubText()];
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.72;
    return label;
}

@end

@interface BLWatchLaterPageView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *filterBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<BLWatchLaterItem *> *items;
@property (nonatomic, copy) NSArray<BLWatchLaterItem *> *displayItems;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *unfinishedButton;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIView *managementSheet;
@property (nonatomic, strong) NSLayoutConstraint *managementSheetBottomConstraint;
@property (nonatomic, strong) UIButton *manageButton;
@property (nonatomic, strong) UIView *batchToolbar;
@property (nonatomic, strong) UIView *selectAllCircle;
@property (nonatomic, strong) UILabel *selectAllLabel;
@property (nonatomic, strong) UIButton *cancelSelectionButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *duplicateButton;
@property (nonatomic, strong) UIButton *moveButton;
@property (nonatomic, strong) NSLayoutConstraint *batchToolbarBottomConstraint;
@property (nonatomic, strong) NSMutableSet<BLWatchLaterItem *> *selectedItems;
@property (nonatomic, strong) UILabel *selectAllCheckmarkLabel;
@property (nonatomic, assign) NSInteger selectedTabIndex;
@property (nonatomic, assign, getter=isBatchEditing) BOOL batchEditing;
@end

@implementation BLWatchLaterPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.items = [[self defaultItems] mutableCopy];
        self.displayItems = [self.items copy];
        self.selectedItems = [NSMutableSet set];
        self.selectedTabIndex = 0;
        [self buildView];
    }
    return self;
}

- (void)setWatchLaterItems:(NSArray<BLWatchLaterItem *> *)items {
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items ?: @[]];
    [self reloadDisplayItems];
}

- (void)addWatchLaterItem:(BLWatchLaterItem *)item {
    if (item == nil) {
        return;
    }
    [self.items insertObject:item atIndex:0];
    [self reloadDisplayItems];
}

- (void)buildView {
    [self buildHeader];
    [self buildFilterBar];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 129.0;
    [self.tableView registerClass:[BLWatchLaterCell class] forCellReuseIdentifier:@"BLWatchLaterCell"];
    [self addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.filterBar.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];

    [self buildManagementSheet];
    [self buildBatchToolbar];
}

- (void)buildHeader {
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerView];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    back.tintColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [back setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:back];

    UILabel *title = [self labelWithText:@"稍后再看" size:22.0 weight:UIFontWeightSemibold color:BLWatchText()];
    title.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:title];

    self.manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manageButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.manageButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    [self.manageButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.manageButton setTitleColor:[UIColor colorWithWhite:0.33 alpha:1.0] forState:UIControlStateNormal];
    [self.manageButton addTarget:self action:@selector(manageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.manageButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:60.0],
        [back.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:18.0],
        [back.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [back.widthAnchor constraintEqualToConstant:40.0],
        [back.heightAnchor constraintEqualToConstant:40.0],
        [title.centerXAnchor constraintEqualToAnchor:self.headerView.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [self.manageButton.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-22.0],
        [self.manageButton.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],
        [self.manageButton.widthAnchor constraintEqualToConstant:86.0]
    ]];
}

- (void)buildManagementSheet {
    self.dimView = [[UIView alloc] init];
    self.dimView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.32];
    self.dimView.alpha = 0.0;
    self.dimView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideManagementSheet)];
    [self.dimView addGestureRecognizer:tap];
    [self addSubview:self.dimView];

    self.managementSheet = [[UIView alloc] init];
    self.managementSheet.translatesAutoresizingMaskIntoConstraints = NO;
    self.managementSheet.backgroundColor = [UIColor colorWithRed:0.97 green:0.98 blue:1.0 alpha:1.0];
    self.managementSheet.layer.cornerRadius = 16.0;
    self.managementSheet.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.managementSheet.layer.masksToBounds = YES;
    [self addSubview:self.managementSheet];

    UIView *handle = [[UIView alloc] init];
    handle.translatesAutoresizingMaskIntoConstraints = NO;
    handle.backgroundColor = [UIColor colorWithWhite:0.76 alpha:1.0];
    handle.layer.cornerRadius = 2.0;
    handle.layer.masksToBounds = YES;
    [self.managementSheet addSubview:handle];

    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 8.0;
    card.layer.masksToBounds = YES;
    [self.managementSheet addSubview:card];

    UIButton *clearWatched = [self managementActionButtonWithTitle:@"一键清除已看完视频" symbolName:@"trash"];
    UIButton *clearExpired = [self managementActionButtonWithTitle:@"一键清除已失效视频" symbolName:@"trash"];
    UIButton *batchManage = [self managementActionButtonWithTitle:@"批量管理" symbolName:@"list.bullet"];
    [clearWatched addTarget:self action:@selector(clearWatchedItems) forControlEvents:UIControlEventTouchUpInside];
    [clearExpired addTarget:self action:@selector(clearInvalidItems) forControlEvents:UIControlEventTouchUpInside];
    [batchManage addTarget:self action:@selector(enterBatchEditingFromSheet) forControlEvents:UIControlEventTouchUpInside];
    UIView *line1 = [self separatorLine];
    UIView *line2 = [self separatorLine];
    [card addSubview:clearWatched];
    [card addSubview:line1];
    [card addSubview:clearExpired];
    [card addSubview:line2];
    [card addSubview:batchManage];

    CGFloat sheetHeight = 316.0;
    self.managementSheetBottomConstraint = [self.managementSheet.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:sheetHeight];
    [NSLayoutConstraint activateConstraints:@[
        [self.dimView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.dimView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.dimView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.dimView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.managementSheet.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.managementSheet.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.managementSheet.heightAnchor constraintEqualToConstant:sheetHeight],
        self.managementSheetBottomConstraint,
        [handle.topAnchor constraintEqualToAnchor:self.managementSheet.topAnchor constant:13.0],
        [handle.centerXAnchor constraintEqualToAnchor:self.managementSheet.centerXAnchor],
        [handle.widthAnchor constraintEqualToConstant:38.0],
        [handle.heightAnchor constraintEqualToConstant:4.0],
        [card.leadingAnchor constraintEqualToAnchor:self.managementSheet.leadingAnchor constant:20.0],
        [card.trailingAnchor constraintEqualToAnchor:self.managementSheet.trailingAnchor constant:-20.0],
        [card.topAnchor constraintEqualToAnchor:self.managementSheet.topAnchor constant:48.0],
        [card.heightAnchor constraintEqualToConstant:216.0],
        [clearWatched.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [clearWatched.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [clearWatched.topAnchor constraintEqualToAnchor:card.topAnchor],
        [clearWatched.heightAnchor constraintEqualToConstant:72.0],
        [line1.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:56.0],
        [line1.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [line1.topAnchor constraintEqualToAnchor:clearWatched.bottomAnchor],
        [line1.heightAnchor constraintEqualToConstant:0.5],
        [clearExpired.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [clearExpired.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [clearExpired.topAnchor constraintEqualToAnchor:line1.bottomAnchor],
        [clearExpired.heightAnchor constraintEqualToConstant:72.0],
        [line2.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:56.0],
        [line2.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [line2.topAnchor constraintEqualToAnchor:clearExpired.bottomAnchor],
        [line2.heightAnchor constraintEqualToConstant:0.5],
        [batchManage.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [batchManage.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [batchManage.topAnchor constraintEqualToAnchor:line2.bottomAnchor],
        [batchManage.bottomAnchor constraintEqualToAnchor:card.bottomAnchor]
    ]];
}

- (void)buildBatchToolbar {
    self.batchToolbar = [[UIView alloc] init];
    self.batchToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    self.batchToolbar.backgroundColor = [UIColor whiteColor];
    self.batchToolbar.hidden = YES;
    [self addSubview:self.batchToolbar];

    UIView *topLine = [[UIView alloc] init];
    topLine.translatesAutoresizingMaskIntoConstraints = NO;
    topLine.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.batchToolbar addSubview:topLine];

    UIButton *selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.translatesAutoresizingMaskIntoConstraints = NO;
    [selectAllButton addTarget:self action:@selector(toggleSelectAll) forControlEvents:UIControlEventTouchUpInside];
    [self.batchToolbar addSubview:selectAllButton];

    self.selectAllCircle = [[UIView alloc] init];
    self.selectAllCircle.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectAllCircle.layer.cornerRadius = 14.0;
    self.selectAllCircle.layer.borderWidth = 1.2;
    self.selectAllCircle.layer.masksToBounds = YES;
    [selectAllButton addSubview:self.selectAllCircle];

    self.selectAllCheckmarkLabel = [self labelWithText:@"✓" size:19.0 weight:UIFontWeightRegular color:[UIColor whiteColor]];
    self.selectAllCheckmarkLabel.textAlignment = NSTextAlignmentCenter;
    [self.selectAllCircle addSubview:self.selectAllCheckmarkLabel];

    self.selectAllLabel = [self labelWithText:@"全选" size:16.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.35 alpha:1.0]];
    [selectAllButton addSubview:self.selectAllLabel];

    self.cancelSelectionButton = [self toolbarButtonWithTitle:@"取消选择"];
    self.deleteButton = [self toolbarButtonWithTitle:@"删除"];
    self.duplicateButton = [self toolbarButtonWithTitle:@"复制到"];
    self.moveButton = [self toolbarButtonWithTitle:@"移动到"];
    [self.cancelSelectionButton addTarget:self action:@selector(cancelSelectedItems) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteSelectedItems) forControlEvents:UIControlEventTouchUpInside];
    [self.batchToolbar addSubview:self.cancelSelectionButton];
    [self.batchToolbar addSubview:self.deleteButton];
    [self.batchToolbar addSubview:self.duplicateButton];
    [self.batchToolbar addSubview:self.moveButton];

    self.batchToolbarBottomConstraint = [self.batchToolbar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:84.0];
    [NSLayoutConstraint activateConstraints:@[
        [self.batchToolbar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.batchToolbar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.batchToolbar.heightAnchor constraintEqualToConstant:84.0],
        self.batchToolbarBottomConstraint,
        [topLine.leadingAnchor constraintEqualToAnchor:self.batchToolbar.leadingAnchor],
        [topLine.trailingAnchor constraintEqualToAnchor:self.batchToolbar.trailingAnchor],
        [topLine.topAnchor constraintEqualToAnchor:self.batchToolbar.topAnchor],
        [topLine.heightAnchor constraintEqualToConstant:0.5],
        [selectAllButton.leadingAnchor constraintEqualToAnchor:self.batchToolbar.leadingAnchor],
        [selectAllButton.topAnchor constraintEqualToAnchor:self.batchToolbar.topAnchor],
        [selectAllButton.widthAnchor constraintEqualToConstant:94.0],
        [selectAllButton.heightAnchor constraintEqualToConstant:64.0],
        [self.selectAllCircle.leadingAnchor constraintEqualToAnchor:selectAllButton.leadingAnchor constant:16.0],
        [self.selectAllCircle.centerYAnchor constraintEqualToAnchor:selectAllButton.centerYAnchor],
        [self.selectAllCircle.widthAnchor constraintEqualToConstant:28.0],
        [self.selectAllCircle.heightAnchor constraintEqualToConstant:28.0],
        [self.selectAllCheckmarkLabel.centerXAnchor constraintEqualToAnchor:self.selectAllCircle.centerXAnchor],
        [self.selectAllCheckmarkLabel.centerYAnchor constraintEqualToAnchor:self.selectAllCircle.centerYAnchor constant:-1.0],
        [self.selectAllCheckmarkLabel.widthAnchor constraintEqualToAnchor:self.selectAllCircle.widthAnchor],
        [self.selectAllCheckmarkLabel.heightAnchor constraintEqualToAnchor:self.selectAllCircle.heightAnchor],
        [self.selectAllLabel.leadingAnchor constraintEqualToAnchor:self.selectAllCircle.trailingAnchor constant:10.0],
        [self.selectAllLabel.centerYAnchor constraintEqualToAnchor:self.selectAllCircle.centerYAnchor],
        [self.cancelSelectionButton.leadingAnchor constraintEqualToAnchor:selectAllButton.trailingAnchor],
        [self.cancelSelectionButton.topAnchor constraintEqualToAnchor:self.batchToolbar.topAnchor],
        [self.cancelSelectionButton.widthAnchor constraintEqualToConstant:142.0],
        [self.cancelSelectionButton.heightAnchor constraintEqualToConstant:64.0],
        [self.deleteButton.leadingAnchor constraintEqualToAnchor:self.cancelSelectionButton.trailingAnchor],
        [self.deleteButton.topAnchor constraintEqualToAnchor:self.batchToolbar.topAnchor],
        [self.deleteButton.heightAnchor constraintEqualToConstant:64.0],
        [self.duplicateButton.leadingAnchor constraintEqualToAnchor:self.deleteButton.trailingAnchor],
        [self.duplicateButton.topAnchor constraintEqualToAnchor:self.batchToolbar.topAnchor],
        [self.duplicateButton.heightAnchor constraintEqualToConstant:64.0],
        [self.moveButton.leadingAnchor constraintEqualToAnchor:self.duplicateButton.trailingAnchor],
        [self.moveButton.trailingAnchor constraintEqualToAnchor:self.batchToolbar.trailingAnchor],
        [self.moveButton.topAnchor constraintEqualToAnchor:self.batchToolbar.topAnchor],
        [self.moveButton.heightAnchor constraintEqualToConstant:64.0],
        [self.deleteButton.widthAnchor constraintEqualToAnchor:self.duplicateButton.widthAnchor],
        [self.duplicateButton.widthAnchor constraintEqualToAnchor:self.moveButton.widthAnchor]
    ]];
    [self updateBatchToolbarState];
}

- (void)buildFilterBar {
    self.filterBar = [[UIView alloc] init];
    self.filterBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.filterBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.filterBar];

    self.allButton = [self tabButtonWithTitle:@"全部" index:0];
    self.unfinishedButton = [self tabButtonWithTitle:@"未看完" index:1];
    UILabel *sort = [self labelWithText:@"☰ 最近添加" size:16.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.42 alpha:1.0]];
    UILabel *playAll = [self labelWithText:@"▶ 播放全部" size:16.0 weight:UIFontWeightSemibold color:BLWatchPink()];
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [self.filterBar addSubview:self.allButton];
    [self.filterBar addSubview:self.unfinishedButton];
    [self.filterBar addSubview:sort];
    [self.filterBar addSubview:playAll];
    [self.filterBar addSubview:line];

    [NSLayoutConstraint activateConstraints:@[
        [self.filterBar.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.filterBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.filterBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.filterBar.heightAnchor constraintEqualToConstant:72.0],
        [self.allButton.leadingAnchor constraintEqualToAnchor:self.filterBar.leadingAnchor constant:16.0],
        [self.allButton.centerYAnchor constraintEqualToAnchor:self.filterBar.centerYAnchor],
        [self.allButton.widthAnchor constraintEqualToConstant:54.0],
        [self.allButton.heightAnchor constraintEqualToConstant:32.0],
        [self.unfinishedButton.leadingAnchor constraintEqualToAnchor:self.allButton.trailingAnchor constant:22.0],
        [self.unfinishedButton.centerYAnchor constraintEqualToAnchor:self.allButton.centerYAnchor],
        [self.unfinishedButton.widthAnchor constraintEqualToConstant:72.0],
        [self.unfinishedButton.heightAnchor constraintEqualToConstant:32.0],
        [sort.trailingAnchor constraintEqualToAnchor:playAll.leadingAnchor constant:-22.0],
        [sort.centerYAnchor constraintEqualToAnchor:self.allButton.centerYAnchor],
        [playAll.trailingAnchor constraintEqualToAnchor:self.filterBar.trailingAnchor constant:-18.0],
        [playAll.centerYAnchor constraintEqualToAnchor:self.allButton.centerYAnchor],
        [line.leadingAnchor constraintEqualToAnchor:self.filterBar.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:self.filterBar.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:self.filterBar.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5]
    ]];
    [self updateTabButtons];
}

- (NSArray<BLWatchLaterItem *> *)defaultItems {
    return @[
        [BLWatchLaterItem itemWithTitle:@"鸣潮手绘动画 / 笑一笑吧~" author:@"再逐夏" views:@"74.5万" danmaku:@"4228" durationText:@"00:26 / 01:42" progressText:nil progress:0.26 finished:NO seed:0 videoURLString:nil],
        [BLWatchLaterItem itemWithTitle:@"【全网首发】一口气看：无限恐怖《我能闻到鬼味》（天..." author:@"姜盐醋" views:@"63.5万" danmaku:@"2850" durationText:@"00:01 / 01:54:07" progressText:nil progress:0.01 finished:NO seed:1 videoURLString:nil],
        [BLWatchLaterItem itemWithTitle:@"隧夜轮回（福生村）合集一口气看完 动画 悬疑 微恐怖" author:@"萧一白呀" views:@"471.5万" danmaku:@"9.1万" durationText:@"01:22 / 04:10:20" progressText:nil progress:0.32 finished:NO seed:2 videoURLString:nil],
        [BLWatchLaterItem itemWithTitle:@"“回旋镖式的民主总统”？金泳三时代的韩国有哪些挫折与..." author:@"世界见闻录" views:@"13.8万" danmaku:@"20" durationText:@"13:13" progressText:nil progress:0.0 finished:NO seed:3 videoURLString:nil],
        [BLWatchLaterItem itemWithTitle:@"“他们就像游戏里隐藏的剧本线，隐晦且美好。”" author:@"南朝十二家" views:@"108.3万" danmaku:@"634" durationText:@"已看完" progressText:nil progress:1.0 finished:YES seed:4 videoURLString:nil],
        [BLWatchLaterItem itemWithTitle:@"一周刷爆LeetCode，算法大神左神（左程云）耗时100..." author:@"马士兵官方账号" views:@"316万" danmaku:@"17.4万" durationText:@"82:14:52" progressText:nil progress:0.0 finished:NO seed:5 videoURLString:nil],
        [BLWatchLaterItem itemWithTitle:@"【2026】【专升本预备知识】【专插本数学基础】【零基..." author:@"飞哥专升本" views:@"22.8万" danmaku:@"1.2万" durationText:@"43:20" progressText:nil progress:0.0 finished:NO seed:6 videoURLString:nil]
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLWatchLaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLWatchLaterCell" forIndexPath:indexPath];
    BLWatchLaterItem *item = self.displayItems[indexPath.row];
    [cell configureWithItem:item editing:self.isBatchEditing selected:[self.selectedItems containsObject:item]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLWatchLaterItem *item = self.displayItems[indexPath.row];
    if (self.isBatchEditing) {
        if ([self.selectedItems containsObject:item]) {
            [self.selectedItems removeObject:item];
        } else {
            [self.selectedItems addObject:item];
        }
        [self updateBatchToolbarState];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    NSString *URLString = item.videoURLString.length > 0 ? item.videoURLString : BLDefaultLocalVideoRelativePath;
    NSURL *URL = [BLVideoURLProvider videoURLForRelativePath:URLString];
    if (URL != nil && self.videoSelected) {
        self.videoSelected(URL, item.title, item.author);
    }
}

- (UIButton *)tabButtonWithTitle:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = index;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tabButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tabButtonTapped:(UIButton *)sender {
    if (self.selectedTabIndex == sender.tag) {
        return;
    }
    self.selectedTabIndex = sender.tag;
    [self reloadDisplayItems];
}

- (void)reloadDisplayItems {
    if (self.selectedTabIndex == 1) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(BLWatchLaterItem *item, NSDictionary<NSString *,id> *bindings) {
            return !item.isFinished;
        }];
        self.displayItems = [self.items filteredArrayUsingPredicate:predicate];
    } else {
        self.displayItems = [self.items copy];
    }
    [self updateTabButtons];
    [self pruneSelectedItems];
    [self updateBatchToolbarState];
    [self.tableView reloadData];
}

- (void)updateTabButtons {
    [self applySelected:self.selectedTabIndex == 0 toButton:self.allButton];
    [self applySelected:self.selectedTabIndex == 1 toButton:self.unfinishedButton];
}

- (void)applySelected:(BOOL)selected toButton:(UIButton *)button {
    if (button == nil) {
        return;
    }
    UIColor *titleColor = selected ? BLWatchPink() : [UIColor colorWithWhite:0.34 alpha:1.0];
    button.backgroundColor = selected ? [UIColor colorWithRed:1.0 green:0.91 blue:0.95 alpha:1.0] : [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:selected ? UIFontWeightSemibold : UIFontWeightRegular];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
}

- (UIButton *)managementActionButtonWithTitle:(NSString *)title symbolName:(NSString *)symbolName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor whiteColor];

    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:22.0 weight:UIImageSymbolWeightRegular];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:symbolName] imageWithConfiguration:config]];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.tintColor = BLWatchText();
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [button addSubview:iconView];

    UILabel *titleLabel = [self labelWithText:title size:18.0 weight:UIFontWeightRegular color:BLWatchText()];
    titleLabel.adjustsFontSizeToFitWidth = NO;
    [button addSubview:titleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [iconView.leadingAnchor constraintEqualToAnchor:button.leadingAnchor constant:24.0],
        [iconView.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:25.0],
        [iconView.heightAnchor constraintEqualToConstant:25.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:24.0],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:button.trailingAnchor constant:-18.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:button.centerYAnchor]
    ]];
    return button;
}

- (UIButton *)toolbarButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:15.5 weight:UIFontWeightRegular];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.78;
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.35 alpha:1.0] forState:UIControlStateNormal];
    return button;
}

- (UIView *)separatorLine {
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    return line;
}

- (void)manageButtonTapped {
    if (self.isBatchEditing) {
        [self exitBatchEditing];
    } else {
        [self showManagementSheet];
    }
}

- (void)showManagementSheet {
    self.dimView.hidden = NO;
    [self bringSubviewToFront:self.dimView];
    [self bringSubviewToFront:self.managementSheet];
    [self layoutIfNeeded];
    self.managementSheetBottomConstraint.constant = 0.0;
    [UIView animateWithDuration:0.26 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dimView.alpha = 1.0;
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)hideManagementSheet {
    self.managementSheetBottomConstraint.constant = 316.0;
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.dimView.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.dimView.hidden = YES;
    }];
}

- (void)clearWatchedItems {
    NSIndexSet *indexes = [self.items indexesOfObjectsPassingTest:^BOOL(BLWatchLaterItem *item, NSUInteger idx, BOOL *stop) {
        return item.isFinished;
    }];
    if (indexes.count > 0) {
        [self.items removeObjectsAtIndexes:indexes];
    }
    [self hideManagementSheet];
    [self reloadDisplayItems];
}

- (void)clearInvalidItems {
    NSIndexSet *indexes = [self.items indexesOfObjectsPassingTest:^BOOL(BLWatchLaterItem *item, NSUInteger idx, BOOL *stop) {
        return item.isInvalid;
    }];
    if (indexes.count > 0) {
        [self.items removeObjectsAtIndexes:indexes];
    }
    [self hideManagementSheet];
    [self reloadDisplayItems];
}

- (void)enterBatchEditingFromSheet {
    [self hideManagementSheet];
    [self enterBatchEditing];
}

- (void)enterBatchEditing {
    self.batchEditing = YES;
    [self.selectedItems removeAllObjects];
    [self.manageButton setTitle:@"取消管理" forState:UIControlStateNormal];
    self.batchToolbar.hidden = NO;
    self.batchToolbarBottomConstraint.constant = 0.0;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 84.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self updateBatchToolbarState];
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    [self.tableView reloadData];
}

- (void)exitBatchEditing {
    self.batchEditing = NO;
    [self.selectedItems removeAllObjects];
    [self.manageButton setTitle:@"管理" forState:UIControlStateNormal];
    self.batchToolbarBottomConstraint.constant = 84.0;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self updateBatchToolbarState];
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.batchToolbar.hidden = YES;
    }];
    [self.tableView reloadData];
}

- (void)toggleSelectAll {
    if (self.displayItems.count == 0) {
        return;
    }
    BOOL allSelected = self.selectedItems.count == self.displayItems.count;
    if (allSelected) {
        [self.selectedItems removeAllObjects];
    } else {
        [self.selectedItems removeAllObjects];
        [self.selectedItems addObjectsFromArray:self.displayItems];
    }
    [self updateBatchToolbarState];
    [self.tableView reloadData];
}

- (void)cancelSelectedItems {
    if (self.selectedItems.count == 0) {
        return;
    }
    [self.selectedItems removeAllObjects];
    [self updateBatchToolbarState];
    [self.tableView reloadData];
}

- (void)deleteSelectedItems {
    if (self.selectedItems.count == 0) {
        return;
    }
    NSSet<BLWatchLaterItem *> *itemsToDelete = [self.selectedItems copy];
    NSIndexSet *indexes = [self.items indexesOfObjectsPassingTest:^BOOL(BLWatchLaterItem *item, NSUInteger idx, BOOL *stop) {
        return [itemsToDelete containsObject:item];
    }];
    if (indexes.count > 0) {
        [self.items removeObjectsAtIndexes:indexes];
    }
    [self.selectedItems removeAllObjects];
    [self reloadDisplayItems];
}

- (void)pruneSelectedItems {
    NSSet<BLWatchLaterItem *> *validItems = [NSSet setWithArray:self.displayItems];
    [self.selectedItems intersectSet:validItems];
}

- (void)updateBatchToolbarState {
    NSUInteger selectedCount = self.selectedItems.count;
    BOOL hasSelection = selectedCount > 0;
    BOOL allSelected = self.displayItems.count > 0 && selectedCount == self.displayItems.count;
    UIColor *enabledColor = [UIColor colorWithWhite:0.16 alpha:1.0];
    UIColor *disabledColor = [UIColor colorWithWhite:0.78 alpha:1.0];

    self.selectAllCircle.backgroundColor = allSelected ? BLWatchPink() : [UIColor whiteColor];
    self.selectAllCircle.layer.borderColor = (allSelected ? BLWatchPink() : [UIColor colorWithWhite:0.82 alpha:1.0]).CGColor;
    self.selectAllCheckmarkLabel.hidden = !allSelected;
    self.selectAllLabel.text = allSelected ? @"取消" : @"全选";
    [self.cancelSelectionButton setTitle:selectedCount > 0 ? [NSString stringWithFormat:@"取消选择（%lu）", (unsigned long)selectedCount] : @"取消选择" forState:UIControlStateNormal];

    NSArray<UIButton *> *dependentButtons = @[self.cancelSelectionButton, self.deleteButton, self.duplicateButton, self.moveButton];
    for (UIButton *button in dependentButtons) {
        button.enabled = hasSelection;
        [button setTitleColor:hasSelection ? enabledColor : disabledColor forState:UIControlStateNormal];
    }
    [self.selectAllLabel setTextColor:[UIColor colorWithWhite:0.35 alpha:1.0]];
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (UILabel *)labelWithText:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.72;
    return label;
}

@end
