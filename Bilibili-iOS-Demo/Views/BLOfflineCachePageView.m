#import "BLOfflineCachePageView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLOfflineText(void) { return [UIColor colorWithRed:0.15 green:0.14 blue:0.16 alpha:1.0]; }
static UIColor *BLOfflineSubText(void) { return [UIColor colorWithWhite:0.58 alpha:1.0]; }
static NSString * const BLOfflineFallbackVideoURLString = @"https://flyable-overlay-alone.ngrok-free.dev/files/08058f33c8ab0aa4b78ce19063e7510f.mp4";

@implementation BLOfflineCacheItem

+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author dateText:(NSString *)dateText statusText:(NSString *)statusText videoURLString:(NSString *)videoURLString seed:(NSInteger)seed {
    BLOfflineCacheItem *item = [[BLOfflineCacheItem alloc] init];
    item.title = title ?: @"";
    item.author = author ?: @"";
    item.dateText = dateText ?: @"";
    item.statusText = statusText ?: @"";
    item.videoURLString = videoURLString;
    item.seed = seed;
    return item;
}

@end

@interface BLOfflineCacheCell : UITableViewCell
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UILabel *thumbLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *moreIcon;
- (void)configureWithItem:(BLOfflineCacheItem *)item;
@end

@implementation BLOfflineCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        self.thumbView = [[UIView alloc] init];
        self.thumbView.translatesAutoresizingMaskIntoConstraints = NO;
        self.thumbView.layer.cornerRadius = 4.0;
        self.thumbView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.thumbView];

        UIView *shade = [[UIView alloc] init];
        shade.translatesAutoresizingMaskIntoConstraints = NO;
        shade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.18];
        [self.thumbView addSubview:shade];

        self.thumbLabel = [self label:@"" size:18.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
        self.thumbLabel.textAlignment = NSTextAlignmentCenter;
        self.thumbLabel.numberOfLines = 2;
        [self.thumbView addSubview:self.thumbLabel];

        self.statusLabel = [self label:@"" size:11.0 weight:UIFontWeightMedium color:[UIColor whiteColor]];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        self.statusLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
        [self.thumbView addSubview:self.statusLabel];

        self.titleLabel = [self label:@"" size:15.0 weight:UIFontWeightRegular color:BLOfflineText()];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];

        self.authorLabel = [self label:@"" size:12.0 weight:UIFontWeightRegular color:BLOfflineSubText()];
        [self.contentView addSubview:self.authorLabel];

        self.dateLabel = [self label:@"" size:12.0 weight:UIFontWeightRegular color:BLOfflineSubText()];
        [self.contentView addSubview:self.dateLabel];

        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:17.0 weight:UIImageSymbolWeightRegular];
        self.moreIcon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:@"ellipsis"] imageWithConfiguration:config]];
        self.moreIcon.translatesAutoresizingMaskIntoConstraints = NO;
        self.moreIcon.tintColor = [UIColor colorWithWhite:0.72 alpha:1.0];
        self.moreIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.contentView addSubview:self.moreIcon];

        UIView *line = [[UIView alloc] init];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
        [self.contentView addSubview:line];

        [NSLayoutConstraint activateConstraints:@[
            [self.thumbView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12.0],
            [self.thumbView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:7.0],
            [self.thumbView.widthAnchor constraintEqualToConstant:148.0],
            [self.thumbView.heightAnchor constraintEqualToConstant:82.0],
            [shade.leadingAnchor constraintEqualToAnchor:self.thumbView.leadingAnchor],
            [shade.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor],
            [shade.topAnchor constraintEqualToAnchor:self.thumbView.topAnchor],
            [shade.bottomAnchor constraintEqualToAnchor:self.thumbView.bottomAnchor],
            [self.thumbLabel.leadingAnchor constraintEqualToAnchor:self.thumbView.leadingAnchor constant:6.0],
            [self.thumbLabel.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor constant:-6.0],
            [self.thumbLabel.centerYAnchor constraintEqualToAnchor:self.thumbView.centerYAnchor],
            [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor],
            [self.statusLabel.bottomAnchor constraintEqualToAnchor:self.thumbView.bottomAnchor],
            [self.statusLabel.heightAnchor constraintEqualToConstant:18.0],
            [self.statusLabel.widthAnchor constraintGreaterThanOrEqualToConstant:78.0],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.thumbView.trailingAnchor constant:10.0],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.moreIcon.leadingAnchor constant:-6.0],
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.thumbView.topAnchor constant:1.0],
            [self.authorLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [self.authorLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
            [self.authorLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6.0],
            [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
            [self.dateLabel.topAnchor constraintEqualToAnchor:self.authorLabel.bottomAnchor constant:4.0],
            [self.moreIcon.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10.0],
            [self.moreIcon.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.moreIcon.widthAnchor constraintEqualToConstant:18.0],
            [self.moreIcon.heightAnchor constraintEqualToConstant:18.0],
            [line.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [line.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [line.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [line.heightAnchor constraintEqualToConstant:0.5]
        ]];
    }
    return self;
}

- (void)configureWithItem:(BLOfflineCacheItem *)item {
    self.thumbView.backgroundColor = [self colorForSeed:item.seed];
    self.thumbLabel.text = [self thumbTextForItem:item];
    self.statusLabel.text = item.statusText.length > 0 ? item.statusText : @"已缓存";
    self.titleLabel.text = item.title;
    self.authorLabel.text = item.author.length > 0 ? [NSString stringWithFormat:@"UP  %@", item.author] : @"";
    self.dateLabel.text = item.dateText.length > 0 ? [NSString stringWithFormat:@"□  %@", item.dateText] : @"";
}

- (NSString *)thumbTextForItem:(BLOfflineCacheItem *)item {
    if (item.title.length <= 4) {
        return item.title;
    }
    return [item.title substringToIndex:MIN(4, item.title.length)];
}

- (UIColor *)colorForSeed:(NSInteger)seed {
    NSArray *colors = @[
        [UIColor colorWithRed:0.95 green:0.18 blue:0.17 alpha:1.0],
        [UIColor colorWithRed:0.07 green:0.13 blue:0.25 alpha:1.0],
        [UIColor colorWithRed:0.38 green:0.64 blue:0.88 alpha:1.0],
        [UIColor colorWithRed:0.70 green:0.25 blue:0.58 alpha:1.0],
        [UIColor colorWithRed:0.21 green:0.62 blue:0.32 alpha:1.0]
    ];
    return colors[labs((int)seed) % colors.count];
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

@interface BLOfflineCachePageView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) NSMutableArray<BLOfflineCacheItem *> *items;
@end

@implementation BLOfflineCachePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.items = [NSMutableArray array];
        [self buildView];
        [self refreshContentState];
    }
    return self;
}

- (void)setOfflineItems:(NSArray<BLOfflineCacheItem *> *)items {
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items ?: @[]];
    [self.tableView reloadData];
    [self refreshContentState];
}

- (void)addOfflineItem:(BLOfflineCacheItem *)item {
    if (item == nil) {
        return;
    }
    [self.items insertObject:item atIndex:0];
    [self.tableView reloadData];
    [self refreshContentState];
}

- (void)buildView {
    [self buildHeader];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 96.0;
    [self.tableView registerClass:[BLOfflineCacheCell class] forCellReuseIdentifier:@"BLOfflineCacheCell"];
    [self addSubview:self.tableView];

    self.emptyView = [self buildEmptyView];
    [self addSubview:self.emptyView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.emptyView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.emptyView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.emptyView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.emptyView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
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

    UILabel *title = [self labelWithText:@"离线缓存" size:20.0 weight:UIFontWeightSemibold color:BLOfflineText()];
    title.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:title];

    UIImageView *search = [self systemIcon:@"magnifyingglass" size:26.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.headerView addSubview:search];
    UIImageView *settings = [self systemIcon:@"hexagon" size:27.0 color:[UIColor colorWithWhite:0.28 alpha:1.0]];
    [self.headerView addSubview:settings];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:58.0],
        [back.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:12.0],
        [back.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:8.0],
        [back.widthAnchor constraintEqualToConstant:40.0],
        [back.heightAnchor constraintEqualToConstant:40.0],
        [title.centerXAnchor constraintEqualToAnchor:self.headerView.centerXAnchor],
        [title.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [settings.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-17.0],
        [settings.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [settings.widthAnchor constraintEqualToConstant:30.0],
        [settings.heightAnchor constraintEqualToConstant:30.0],
        [search.trailingAnchor constraintEqualToAnchor:settings.leadingAnchor constant:-24.0],
        [search.centerYAnchor constraintEqualToAnchor:back.centerYAnchor],
        [search.widthAnchor constraintEqualToConstant:30.0],
        [search.heightAnchor constraintEqualToConstant:30.0]
    ]];
}

- (UIView *)buildEmptyView {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor whiteColor];

    UIView *box = [[UIView alloc] init];
    box.translatesAutoresizingMaskIntoConstraints = NO;
    box.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    box.layer.cornerRadius = 10.0;
    box.transform = CGAffineTransformMakeRotation(-0.12);
    [container addSubview:box];

    UIView *slot = [[UIView alloc] init];
    slot.translatesAutoresizingMaskIntoConstraints = NO;
    slot.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
    slot.layer.cornerRadius = 5.0;
    [box addSubview:slot];

    UIView *base = [[UIView alloc] init];
    base.translatesAutoresizingMaskIntoConstraints = NO;
    base.backgroundColor = [UIColor colorWithWhite:0.86 alpha:1.0];
    base.layer.cornerRadius = 7.0;
    [container addSubview:base];

    UILabel *spark1 = [self labelWithText:@"◢" size:18.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.86 alpha:1.0]];
    UILabel *spark2 = [self labelWithText:@"◣" size:14.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.86 alpha:1.0]];
    [container addSubview:spark1];
    [container addSubview:spark2];

    UILabel *tip = [self labelWithText:@"这里还什么都没有呢~" size:17.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.64 alpha:1.0]];
    tip.textAlignment = NSTextAlignmentCenter;
    [container addSubview:tip];

    [NSLayoutConstraint activateConstraints:@[
        [box.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [box.centerYAnchor constraintEqualToAnchor:container.centerYAnchor constant:-82.0],
        [box.widthAnchor constraintEqualToConstant:116.0],
        [box.heightAnchor constraintEqualToConstant:96.0],
        [slot.centerXAnchor constraintEqualToAnchor:box.centerXAnchor],
        [slot.centerYAnchor constraintEqualToAnchor:box.centerYAnchor constant:12.0],
        [slot.widthAnchor constraintEqualToConstant:36.0],
        [slot.heightAnchor constraintEqualToConstant:10.0],
        [base.centerXAnchor constraintEqualToAnchor:box.centerXAnchor constant:22.0],
        [base.topAnchor constraintEqualToAnchor:box.bottomAnchor constant:-14.0],
        [base.widthAnchor constraintEqualToConstant:126.0],
        [base.heightAnchor constraintEqualToConstant:18.0],
        [spark1.leadingAnchor constraintEqualToAnchor:box.trailingAnchor constant:13.0],
        [spark1.topAnchor constraintEqualToAnchor:box.topAnchor constant:-6.0],
        [spark2.leadingAnchor constraintEqualToAnchor:box.trailingAnchor constant:20.0],
        [spark2.topAnchor constraintEqualToAnchor:spark1.bottomAnchor constant:1.0],
        [tip.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [tip.topAnchor constraintEqualToAnchor:base.bottomAnchor constant:58.0],
        [tip.leadingAnchor constraintGreaterThanOrEqualToAnchor:container.leadingAnchor constant:30.0],
        [tip.trailingAnchor constraintLessThanOrEqualToAnchor:container.trailingAnchor constant:-30.0]
    ]];
    return container;
}

- (void)refreshContentState {
    BOOL empty = self.items.count == 0;
    self.emptyView.hidden = !empty;
    self.tableView.hidden = empty;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLOfflineCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLOfflineCacheCell" forIndexPath:indexPath];
    [cell configureWithItem:self.items[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLOfflineCacheItem *item = self.items[indexPath.row];
    NSString *URLString = item.videoURLString.length > 0 ? item.videoURLString : BLOfflineFallbackVideoURLString;
    NSURL *URL = [NSURL URLWithString:URLString];
    if (URL != nil && self.videoSelected) {
        self.videoSelected(URL, item.title ?: @"", item.author ?: @"");
    }
}

- (void)closeButtonTapped {
    if (self.closeTapped) {
        self.closeTapped();
    }
}

- (UIImageView *)systemIcon:(NSString *)name size:(CGFloat)size color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:size weight:UIImageSymbolWeightRegular];
    UIImageView *view = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:name] imageWithConfiguration:config]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.tintColor = color;
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
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
