#import "BLProfileBangumiContentView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLPBGradientCardView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation BLPBGradientCardView

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

@implementation BLProfileBangumiContentView

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
    stack.spacing = 18.0;
    stack.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 28.0, 16.0);
    stack.layoutMarginsRelativeArrangement = YES;
    [self addSubview:stack];
    NSArray *items = @[
        @"牧神记\n更新至86话", @"名侦探柯南\n更新至1262话", @"OVERLORD\n全13话",
        @"凡人修仙传\n更新至176话", @"间谍过家家\n连载中", @"少年歌行 血…\n全26话",
        @"鬼灭之刃 柱…\n全8话", @"间谍过家家!!\n全12话", @"名侦探柯南…\n全1话",
        @"少年歌行 海…\n全26话", @"物理魔法使…\n全12话", @"间谍过家家\n全12话",
        @"海绵宝宝", @"百妖谱", @"西游记之大圣"
    ];
    for (NSInteger i = 0; i < items.count; i += 3) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.spacing = 16.0;
        row.distribution = UIStackViewDistributionFillEqually;
        for (NSInteger j = 0; j < 3; j++) {
            if (i + j < items.count) {
                [row addArrangedSubview:[self poster:items[i + j] index:i + j]];
            } else {
                [row addArrangedSubview:[[UIView alloc] init]];
            }
        }
        [stack addArrangedSubview:row];
    }
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (UIView *)poster:(NSString *)text index:(NSInteger)index {
    BLPBGradientCardView *poster = [[BLPBGradientCardView alloc] init];
    poster.translatesAutoresizingMaskIntoConstraints = NO;
    poster.colors = [self colorsForIndex:index];
    poster.layer.cornerRadius = 6.0;
    poster.layer.masksToBounds = YES;

    NSArray<NSString *> *parts = [text componentsSeparatedByString:@"\n"];
    UILabel *title = [self label:parts.firstObject ?: text size:17.0 weight:UIFontWeightRegular];
    UILabel *subtitle = [self label:parts.count > 1 ? parts[1] : @"" size:15.0 weight:UIFontWeightRegular];
    subtitle.alpha = 0.92;
    [poster addSubview:title];
    [poster addSubview:subtitle];
    [poster.heightAnchor constraintEqualToConstant:178.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:poster.leadingAnchor constant:10.0],
        [title.trailingAnchor constraintEqualToAnchor:poster.trailingAnchor constant:-8.0],
        [title.bottomAnchor constraintEqualToAnchor:subtitle.topAnchor constant:-4.0],
        [subtitle.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [subtitle.trailingAnchor constraintEqualToAnchor:title.trailingAnchor],
        [subtitle.bottomAnchor constraintEqualToAnchor:poster.bottomAnchor constant:-12.0]
    ]];
    return poster;
}

- (NSArray<UIColor *> *)colorsForIndex:(NSInteger)index {
    NSArray *colors = @[
        @[[UIColor colorWithRed:0.22 green:0.32 blue:0.25 alpha:1.0], [UIColor colorWithRed:0.38 green:0.50 blue:0.40 alpha:1.0]],
        @[[UIColor colorWithRed:0.24 green:0.39 blue:0.70 alpha:1.0], [UIColor colorWithRed:0.40 green:0.55 blue:0.84 alpha:1.0]],
        @[[UIColor colorWithRed:0.12 green:0.10 blue:0.28 alpha:1.0], [UIColor colorWithRed:0.23 green:0.18 blue:0.42 alpha:1.0]],
        @[[UIColor colorWithRed:0.25 green:0.52 blue:0.49 alpha:1.0], [UIColor colorWithRed:0.39 green:0.65 blue:0.61 alpha:1.0]],
        @[[UIColor colorWithRed:0.75 green:0.55 blue:0.40 alpha:1.0], [UIColor colorWithRed:0.90 green:0.70 blue:0.54 alpha:1.0]],
        @[[UIColor colorWithRed:0.50 green:0.17 blue:0.18 alpha:1.0], [UIColor colorWithRed:0.65 green:0.28 blue:0.28 alpha:1.0]]
    ];
    return colors[index % colors.count];
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.72;
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOpacity = 0.25;
    label.layer.shadowRadius = 3.0;
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    return label;
}

@end
