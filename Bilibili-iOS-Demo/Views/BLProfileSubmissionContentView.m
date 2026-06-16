#import "BLProfileSubmissionContentView.h"

static UIColor *BLPSPink(void) { return [UIColor colorWithRed:0.93 green:0.36 blue:0.56 alpha:1.0]; }
static UIColor *BLPSSub(void) { return [UIColor colorWithWhite:0.56 alpha:1.0]; }

@implementation BLProfileSubmissionContentView

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
    UIView *filter = [[UIView alloc] init];
    filter.translatesAutoresizingMaskIntoConstraints = NO;
    filter.backgroundColor = [UIColor whiteColor];
    UILabel *type = [self label:@"图文 ▾" size:18.0 color:BLPSPink()];
    type.textAlignment = NSTextAlignmentCenter;
    type.backgroundColor = [UIColor colorWithRed:1.0 green:0.92 blue:0.95 alpha:1.0];
    type.layer.cornerRadius = 4.0;
    type.layer.masksToBounds = YES;
    UILabel *all = [self label:@"全部 ›" size:17.0 color:BLPSSub()];
    [filter addSubview:type];
    [filter addSubview:all];
    [filter.heightAnchor constraintEqualToConstant:84.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [type.leadingAnchor constraintEqualToAnchor:filter.leadingAnchor constant:16.0],
        [type.topAnchor constraintEqualToAnchor:filter.topAnchor constant:14.0],
        [type.widthAnchor constraintEqualToConstant:78.0],
        [type.heightAnchor constraintEqualToConstant:42.0],
        [all.trailingAnchor constraintEqualToAnchor:filter.trailingAnchor constant:-18.0],
        [all.centerYAnchor constraintEqualToAnchor:type.centerYAnchor]
    ]];
    [stack addArrangedSubview:filter];
    UIView *empty = [[UIView alloc] init];
    empty.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *end = [self label:@"到达尽头了" size:17.0 color:BLPSSub()];
    [empty addSubview:end];
    [empty.heightAnchor constraintEqualToConstant:620.0].active = YES;
    [NSLayoutConstraint activateConstraints:@[
        [end.centerXAnchor constraintEqualToAnchor:empty.centerXAnchor],
        [end.topAnchor constraintEqualToAnchor:empty.topAnchor constant:160.0]
    ]];
    [stack addArrangedSubview:empty];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    label.textColor = color;
    return label;
}

@end
