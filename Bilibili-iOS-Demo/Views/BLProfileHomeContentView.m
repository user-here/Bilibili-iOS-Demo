#import "BLProfileHomeContentView.h"
#import <QuartzCore/QuartzCore.h>

static UIColor *BLPHBg(void) { return [UIColor colorWithWhite:0.95 alpha:1.0]; }
static UIColor *BLPHText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }
static UIColor *BLPHSub(void) { return [UIColor colorWithWhite:0.58 alpha:1.0]; }

@interface BLPHGradientCardView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLPHGradientCardView

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

@implementation BLProfileHomeContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = BLPHBg();
        [self buildView];
    }
    return self;
}

- (void)buildView {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 20.0;
    stack.layoutMargins = UIEdgeInsetsMake(18.0, 16.0, 28.0, 16.0);
    stack.layoutMarginsRelativeArrangement = YES;
    [self addSubview:stack];
    [stack addArrangedSubview:[self folderSection:@"收藏  55" more:YES folders:@[
        @{@"title": @"默认收藏夹", @"sub": @"156个内容 · 公开", @"mark": @"猫咪"},
        @{@"title": @"小郭", @"sub": @"29个内容 · 公开", @"mark": @"柯南"}
    ]]];
    [stack addArrangedSubview:[self posterSection:@"追番  33" items:@[@"牧神记\n更新至86话", @"名侦探柯南\n更新至1262话", @"OVERLORD\n全13话"]]];
    [stack addArrangedSubview:[self posterSection:@"追漫  3" items:@[@"小智怪谈\n更新至1206话", @"极刑·饭\n更新至331话", @"航海王\n更新至1185话"]]];
    [stack addArrangedSubview:[self videoSection:@"最近投币的视频" items:@[@"【乐乐爸爸220324】视频加载中，速速查收…", @"差点没能绷住吗…？你这家伙！"]]];
    [stack addArrangedSubview:[self videoSection:@"最近点赞的视频" items:@[@"【乐乐爸爸220324】视频加载中，速速查收…", @"网友：幸亏是老虎，这要是猫就咬你了"]]];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (UIView *)folderSection:(NSString *)title more:(BOOL)more folders:(NSArray<NSDictionary *> *)folders {
    UIStackView *section = [self sectionWithTitle:title];
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 16.0;
    row.distribution = UIStackViewDistributionFillEqually;
    for (NSDictionary *folder in folders) {
        [row addArrangedSubview:[self folderCard:folder]];
    }
    [section addArrangedSubview:row];
    return section;
}

- (UIView *)posterSection:(NSString *)title items:(NSArray<NSString *> *)items {
    UIStackView *section = [self sectionWithTitle:title];
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 14.0;
    row.distribution = UIStackViewDistributionFillEqually;
    for (NSString *item in items) {
        [row addArrangedSubview:[self posterCard:item]];
    }
    [section addArrangedSubview:row];
    return section;
}

- (UIView *)videoSection:(NSString *)title items:(NSArray<NSString *> *)items {
    UIStackView *section = [self sectionWithTitle:title];
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 12.0;
    row.distribution = UIStackViewDistributionFillEqually;
    for (NSString *item in items) {
        [row addArrangedSubview:[self videoCard:item]];
    }
    [section addArrangedSubview:row];
    return section;
}

- (UIStackView *)sectionWithTitle:(NSString *)title {
    UIStackView *section = [[UIStackView alloc] init];
    section.axis = UILayoutConstraintAxisVertical;
    section.spacing = 12.0;
    UIView *header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *label = [self label:title size:18.0 weight:UIFontWeightRegular color:BLPHText()];
    UILabel *hidden = [self label:@"◑" size:18.0 weight:UIFontWeightRegular color:BLPHSub()];
    UILabel *more = [self label:@"查看更多  ›" size:16.0 weight:UIFontWeightRegular color:BLPHSub()];
    [header addSubview:label];
    [header addSubview:hidden];
    [header addSubview:more];
    [header.heightAnchor constraintEqualToConstant:32.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:header.leadingAnchor],
        [label.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [hidden.leadingAnchor constraintEqualToAnchor:label.trailingAnchor constant:10.0],
        [hidden.centerYAnchor constraintEqualToAnchor:label.centerYAnchor],
        [more.trailingAnchor constraintEqualToAnchor:header.trailingAnchor],
        [more.centerYAnchor constraintEqualToAnchor:header.centerYAnchor]
    ]];
    [section addArrangedSubview:header];
    return section;
}

- (UIView *)folderCard:(NSDictionary *)folder {
    UIStackView *card = [[UIStackView alloc] init];
    card.axis = UILayoutConstraintAxisVertical;
    card.spacing = 8.0;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 6.0;
    card.layer.masksToBounds = YES;
    UIView *cover = [self coverWithText:folder[@"mark"] height:116.0];
    UILabel *title = [self label:folder[@"title"] size:17.0 weight:UIFontWeightRegular color:BLPHText()];
    UILabel *sub = [self label:folder[@"sub"] size:15.0 weight:UIFontWeightRegular color:BLPHSub()];
    title.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
    [card addArrangedSubview:cover];
    [card addArrangedSubview:[self padded:title]];
    [card addArrangedSubview:[self padded:sub]];
    [card.heightAnchor constraintEqualToConstant:196.0].active = YES;
    return card;
}

- (UIView *)posterCard:(NSString *)text {
    UIView *card = [self coverWithText:text height:178.0];
    [card.heightAnchor constraintEqualToConstant:178.0].active = YES;
    return card;
}

- (UIView *)videoCard:(NSString *)text {
    UIStackView *card = [[UIStackView alloc] init];
    card.axis = UILayoutConstraintAxisVertical;
    card.spacing = 6.0;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 5.0;
    card.layer.masksToBounds = YES;
    [card addArrangedSubview:[self coverWithText:@"5万  879     00:19" height:92.0]];
    UILabel *title = [self label:text size:15.0 weight:UIFontWeightRegular color:BLPHText()];
    title.numberOfLines = 2;
    [card addArrangedSubview:[self padded:title]];
    [card.heightAnchor constraintEqualToConstant:152.0].active = YES;
    return card;
}

- (UIView *)coverWithText:(NSString *)text height:(CGFloat)height {
    BLPHGradientCardView *cover = [[BLPHGradientCardView alloc] init];
    cover.translatesAutoresizingMaskIntoConstraints = NO;
    cover.colors = @[
        [UIColor colorWithRed:0.22 green:0.34 blue:0.38 alpha:1.0],
        [UIColor colorWithRed:0.30 green:0.49 blue:0.66 alpha:1.0],
        [UIColor colorWithRed:0.58 green:0.38 blue:0.51 alpha:1.0]
    ];
    cover.layer.cornerRadius = 4.0;
    cover.layer.masksToBounds = YES;
    UILabel *label = [self label:text size:17.0 weight:UIFontWeightRegular color:[UIColor whiteColor]];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentLeft;
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOpacity = 0.22;
    label.layer.shadowRadius = 3.0;
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    [cover addSubview:label];
    [cover.heightAnchor constraintEqualToConstant:height].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:cover.leadingAnchor constant:10.0],
        [label.trailingAnchor constraintEqualToAnchor:cover.trailingAnchor constant:-8.0],
        [label.bottomAnchor constraintEqualToAnchor:cover.bottomAnchor constant:-10.0]
    ]];
    return cover;
}

- (UIView *)padded:(UIView *)view {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:10.0],
        [view.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-10.0],
        [view.topAnchor constraintEqualToAnchor:container.topAnchor],
        [view.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
    return container;
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.75;
    return label;
}

@end
