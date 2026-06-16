#import "BLProfileDynamicContentView.h"

static UIColor *BLPDText(void) { return [UIColor colorWithRed:0.16 green:0.15 blue:0.17 alpha:1.0]; }
static UIColor *BLPDSub(void) { return [UIColor colorWithWhite:0.56 alpha:1.0]; }
static UIColor *BLPDBlue(void) { return [UIColor colorWithRed:0.18 green:0.45 blue:0.58 alpha:1.0]; }
static UIColor *BLPDPink(void) { return [UIColor colorWithRed:0.93 green:0.36 blue:0.56 alpha:1.0]; }

@implementation BLProfileDynamicContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self buildView];
    }
    return self;
}

- (void)buildView {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 0.0;
    [self addSubview:stack];
    [stack addArrangedSubview:[self dynamicCard]];
    UILabel *end = [self label:@"到达尽头了" size:17.0 weight:UIFontWeightRegular color:BLPDSub()];
    end.textAlignment = NSTextAlignmentCenter;
    UIView *endBox = [[UIView alloc] init];
    endBox.translatesAutoresizingMaskIntoConstraints = NO;
    [endBox addSubview:end];
    [endBox.heightAnchor constraintEqualToConstant:86.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [end.centerXAnchor constraintEqualToAnchor:endBox.centerXAnchor],
        [end.centerYAnchor constraintEqualToAnchor:endBox.centerYAnchor]
    ]];
    [stack addArrangedSubview:endBox];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (UIView *)dynamicCard {
    UIStackView *card = [[UIStackView alloc] init];
    card.axis = UILayoutConstraintAxisVertical;
    card.spacing = 14.0;
    card.backgroundColor = [UIColor whiteColor];
    card.layoutMargins = UIEdgeInsetsMake(14.0, 16.0, 0.0, 16.0);
    card.layoutMarginsRelativeArrangement = YES;
    [card addArrangedSubview:[self authorRow]];
    [card addArrangedSubview:[self label:@"转发动态" size:24.0 weight:UIFontWeightRegular color:BLPDText()]];
    UILabel *body = [self label:@"@天才李杰灵\n🎁 互动抽奖 我们又双叒来抽奖啦！总价值约50000元！本期大奖是  ▷ 主力机怒升iOS17，母公司技术又下放了？诚邀9位同学和我一起体验  里提到的9台iPhone14 256GB 国行…  全文" size:22.0 weight:UIFontWeightRegular color:BLPDBlue()];
    body.numberOfLines = 0;
    [card addArrangedSubview:body];
    [card addArrangedSubview:[self grid]];
    [card addArrangedSubview:[self actions]];
    return card;
}

- (UIView *)authorRow {
    UIView *row = [[UIView alloc] init];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *avatar = [[UIView alloc] init];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.layer.cornerRadius = 28.0;
    avatar.backgroundColor = [UIColor colorWithRed:0.88 green:0.95 blue:0.97 alpha:1.0];
    UILabel *mark = [self label:@"狸" size:24.0 weight:UIFontWeightHeavy color:BLPDText()];
    mark.textAlignment = NSTextAlignmentCenter;
    [avatar addSubview:mark];
    UILabel *name = [self label:@"阿狸爱吃狐狸" size:19.0 weight:UIFontWeightSemibold color:BLPDPink()];
    UILabel *date = [self label:@"2023年6月11日" size:17.0 weight:UIFontWeightRegular color:BLPDSub()];
    UILabel *more = [self label:@"⋮" size:28.0 weight:UIFontWeightRegular color:BLPDSub()];
    [row addSubview:avatar];
    [row addSubview:name];
    [row addSubview:date];
    [row addSubview:more];
    [row.heightAnchor constraintEqualToConstant:64.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [avatar.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [avatar.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [avatar.widthAnchor constraintEqualToConstant:56.0],
        [avatar.heightAnchor constraintEqualToConstant:56.0],
        [mark.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [mark.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor],
        [name.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:14.0],
        [name.topAnchor constraintEqualToAnchor:avatar.topAnchor constant:3.0],
        [date.leadingAnchor constraintEqualToAnchor:name.leadingAnchor],
        [date.topAnchor constraintEqualToAnchor:name.bottomAnchor constant:4.0],
        [more.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [more.centerYAnchor constraintEqualToAnchor:row.centerYAnchor]
    ]];
    return row;
}

- (UIView *)grid {
    UIStackView *grid = [[UIStackView alloc] init];
    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 8.0;
    NSArray *texts = @[@"转", @"√", @"发", @"关", @"iPhone14\nx9", @"注", @"抽", @"11个大会员", @"奖"];
    NSInteger idx = 0;
    for (NSInteger r = 0; r < 3; r++) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 8.0;
        row.distribution = UIStackViewDistributionFillEqually;
        for (NSInteger c = 0; c < 3; c++) {
            [row addArrangedSubview:[self prizeCell:texts[idx++]]];
        }
        [grid addArrangedSubview:row];
    }
    return grid;
}

- (UIView *)prizeCell:(NSString *)text {
    UILabel *cell = [self label:text size:42.0 weight:UIFontWeightHeavy color:[UIColor whiteColor]];
    cell.textAlignment = NSTextAlignmentCenter;
    cell.numberOfLines = 2;
    cell.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:1.0];
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    [cell.heightAnchor constraintEqualToConstant:132.0].active = YES;
    return cell;
}

- (UIView *)actions {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.distribution = UIStackViewDistributionFillEqually;
    row.backgroundColor = [UIColor whiteColor];
    [row addArrangedSubview:[self action:@"↗  转发"]];
    [row addArrangedSubview:[self action:@"○  评论"]];
    [row addArrangedSubview:[self action:@"♡  点赞"]];
    [row.heightAnchor constraintEqualToConstant:72.0].active = YES;
    return row;
}

- (UILabel *)action:(NSString *)text {
    UILabel *label = [self label:text size:18.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.43 alpha:1.0]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
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
