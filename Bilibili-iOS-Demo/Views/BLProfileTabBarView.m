#import "BLProfileTabBarView.h"

static UIColor *BLProfileTabPink(void) { return [UIColor colorWithRed:0.93 green:0.36 blue:0.56 alpha:1.0]; }
static UIColor *BLProfileTabText(void) { return [UIColor colorWithWhite:0.33 alpha:1.0]; }

@interface BLProfileTabBarView ()
@property (nonatomic, strong) NSArray<UIButton *> *buttons;
@property (nonatomic, strong) NSArray<UIView *> *indicators;
@end

@implementation BLProfileTabBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
        [self selectIndex:0];
    }
    return self;
}

- (void)buildView {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:stack];
    NSArray *titles = @[@"主页", @"动态", @"投稿", @"收藏", @"追番"];
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *indicators = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIView *item = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular];
        [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIView *indicator = [[UIView alloc] init];
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        indicator.layer.cornerRadius = 1.5;
        [item addSubview:button];
        [item addSubview:indicator];
        [stack addArrangedSubview:item];
        [buttons addObject:button];
        [indicators addObject:indicator];
        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:item.topAnchor],
            [button.leadingAnchor constraintEqualToAnchor:item.leadingAnchor],
            [button.trailingAnchor constraintEqualToAnchor:item.trailingAnchor],
            [button.bottomAnchor constraintEqualToAnchor:item.bottomAnchor],
            [indicator.centerXAnchor constraintEqualToAnchor:item.centerXAnchor],
            [indicator.bottomAnchor constraintEqualToAnchor:item.bottomAnchor],
            [indicator.widthAnchor constraintEqualToConstant:46.0],
            [indicator.heightAnchor constraintEqualToConstant:3.0]
        ]];
    }
    self.buttons = buttons;
    self.indicators = indicators;

    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [self addSubview:line];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [line.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [line.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [line.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [line.heightAnchor constraintEqualToConstant:0.5]
    ]];
}

- (void)tabTapped:(UIButton *)sender {
    [self selectIndex:sender.tag];
    if (self.tabSelected) {
        self.tabSelected(sender.tag);
    }
}

- (void)selectIndex:(NSInteger)index {
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        BOOL selected = i == index;
        [self.buttons[i] setTitleColor:selected ? BLProfileTabPink() : BLProfileTabText() forState:UIControlStateNormal];
        self.indicators[i].backgroundColor = selected ? BLProfileTabPink() : [UIColor clearColor];
    }
}

@end
