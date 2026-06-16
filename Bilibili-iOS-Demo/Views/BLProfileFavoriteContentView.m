#import "BLProfileFavoriteContentView.h"

static UIColor *BLPFText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }
static UIColor *BLPFSub(void) { return [UIColor colorWithWhite:0.58 alpha:1.0]; }

@implementation BLProfileFavoriteContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
    }
    return self;
}

- (void)buildView {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 0.0;
    stack.layoutMargins = UIEdgeInsetsMake(0.0, 12.0, 26.0, 12.0);
    stack.layoutMarginsRelativeArrangement = YES;
    [self addSubview:stack];
    [stack addArrangedSubview:[self groupHeader:@"⌃  我创建的收藏夹  20"]];
    NSArray *folders = @[
        @[@"默认收藏夹", @"156个内容 · 公开", @"猫咪"],
        @[@"小郭", @"29个内容 · 公开", @"柯南"],
        @[@"深度学习", @"5个内容 · 公开", @"DL"],
        @[@"英语", @"20个内容 · 公开", @"ENG"],
        @[@"自然语言处理", @"12个内容 · 公开", @"NLP"],
        @[@"数学", @"7个内容 · 公开", @"Math"],
        @[@"数据", @"14个内容 · 公开", @"Data"],
        @[@"算法", @"1个内容 · 公开", @"算法"],
        @[@"机器学习", @"28个内容 · 公开", @"ML"],
        @[@"Java web", @"9个内容 · 公开", @"Java"],
        @[@"语言", @"7个内容 · 公开", @"BERT"],
        @[@"网络安全", @"1个内容 · 公开", @"安全"],
        @[@"matlab", @"1个内容 · 公开", @"MATLAB"],
        @[@"计算机组成原理", @"2个内容 · 公开", @"计组"],
        @[@"操作系统", @"1个内容 · 公开", @"OS"],
        @[@"数据库", @"3个内容 · 公开", @"DB"],
        @[@"计算机网络", @"2个内容 · 公开", @"网络"],
        @[@"网站设计", @"3个内容 · 公开", @"JS"]
    ];
    for (NSArray *folder in folders) {
        [stack addArrangedSubview:[self folderRow:folder]];
    }
    [stack addArrangedSubview:[self groupHeader:@"⌃  我的收藏与订阅  35"]];
    NSArray *subs = @[
        @[@"【更新中】AI论文精读", @"创建者：跟李沐学AI\n60个视频 · 1362.5万播放", @"AI"],
        @[@"多模态", @"创建者：瑞斯研习社\n7个视频 · 8884播放", @"多模态"],
        @[@"悬疑动画", @"创建者：睡觉人偶SickDoll\n19个视频 · 1280.9万播放", @"悬疑"]
    ];
    for (NSArray *folder in subs) {
        [stack addArrangedSubview:[self folderRow:folder]];
    }
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (UIView *)groupHeader:(NSString *)title {
    UILabel *label = [self label:title size:16.0 weight:UIFontWeightRegular color:BLPFText()];
    label.backgroundColor = [UIColor whiteColor];
    [label.heightAnchor constraintEqualToConstant:48.0].active = YES;
    return label;
}

- (UIView *)folderRow:(NSArray *)data {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *cover = [self cover:data[2]];
    UILabel *title = [self label:data[0] size:16.0 weight:UIFontWeightRegular color:BLPFText()];
    UILabel *sub = [self label:data[1] size:13.0 weight:UIFontWeightRegular color:BLPFSub()];
    sub.numberOfLines = 2;
    [row addSubview:cover];
    [row addSubview:title];
    [row addSubview:sub];
    [row.heightAnchor constraintEqualToConstant:84.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [cover.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [cover.topAnchor constraintEqualToAnchor:row.topAnchor constant:6.0],
        [cover.widthAnchor constraintEqualToConstant:112.0],
        [cover.heightAnchor constraintEqualToConstant:68.0],
        [title.leadingAnchor constraintEqualToAnchor:cover.trailingAnchor constant:14.0],
        [title.topAnchor constraintEqualToAnchor:cover.topAnchor constant:2.0],
        [title.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [sub.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [sub.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:12.0],
        [sub.trailingAnchor constraintEqualToAnchor:title.trailingAnchor]
    ]];
    return row;
}

- (UIView *)cover:(NSString *)text {
    UILabel *view = [self label:text size:20.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.textAlignment = NSTextAlignmentCenter;
    view.backgroundColor = [UIColor colorWithRed:0.34 green:0.49 blue:0.69 alpha:1.0];
    view.layer.cornerRadius = 2.0;
    view.layer.masksToBounds = YES;
    return view;
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
