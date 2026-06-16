#import "BLMemberPaymentBarView.h"

@interface BLMemberPaymentBarView ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong, nullable) NSTimer *timer;
@property (nonatomic, assign) NSInteger remainSeconds;
@end

@implementation BLMemberPaymentBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.10;
        self.layer.shadowRadius = 10.0;
        self.layer.shadowOffset = CGSizeMake(0.0, -3.0);
        self.remainSeconds = 23 * 3600 + 44 * 60 + 52;
        [self buildView];
    }
    return self;
}

- (void)dealloc {
    [self stopCountdown];
}

- (void)buildView {
    UILabel *title = [self label:@"连续包年首年 ︿" size:18.0 weight:UIFontWeightSemibold color:[UIColor colorWithWhite:0.12 alpha:1.0]];
    UILabel *sub = [self label:@"自动续费可随时取消" size:13.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeSystem];
    pay.translatesAutoresizingMaskIntoConstraints = NO;
    pay.backgroundColor = [UIColor colorWithRed:0.93 green:0.36 blue:0.57 alpha:1.0];
    pay.layer.cornerRadius = 24.0;
    [pay setTitle:@"确认协议并支付¥118" forState:UIControlStateNormal];
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pay.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    self.timeLabel = [self label:@"" size:14.0 weight:UIFontWeightRegular color:[UIColor colorWithRed:0.93 green:0.36 blue:0.57 alpha:1.0]];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.88 blue:0.93 alpha:1.0];
    self.timeLabel.layer.cornerRadius = 9.0;
    self.timeLabel.layer.masksToBounds = YES;
    UILabel *agreement = [self label:@"☐ 开通前请阅读《大会员服务协议》《大会员自动续费服务规则》" size:12.0 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.58 alpha:1.0]];
    [self addSubview:title];
    [self addSubview:sub];
    [self addSubview:pay];
    [self addSubview:self.timeLabel];
    [self addSubview:agreement];
    [NSLayoutConstraint activateConstraints:@[
        [title.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [title.topAnchor constraintEqualToAnchor:self.topAnchor constant:30.0],
        [sub.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [sub.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:5.0],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:pay.leadingAnchor constant:-12.0],
        [sub.trailingAnchor constraintLessThanOrEqualToAnchor:pay.leadingAnchor constant:-12.0],
        [pay.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
        [pay.topAnchor constraintEqualToAnchor:self.topAnchor constant:32.0],
        [pay.widthAnchor constraintEqualToConstant:196.0],
        [pay.heightAnchor constraintEqualToConstant:48.0],
        [self.timeLabel.trailingAnchor constraintEqualToAnchor:pay.trailingAnchor constant:-8.0],
        [self.timeLabel.bottomAnchor constraintEqualToAnchor:pay.topAnchor constant:-4.0],
        [self.timeLabel.widthAnchor constraintEqualToConstant:134.0],
        [self.timeLabel.heightAnchor constraintEqualToConstant:22.0],
        [agreement.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18.0],
        [agreement.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18.0],
        [agreement.topAnchor constraintEqualToAnchor:pay.bottomAnchor constant:14.0]
    ]];
    [self refreshTimeLabel];
}

- (void)startCountdown {
    [self stopCountdown];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)stopCountdown {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)tick {
    self.remainSeconds = MAX(0, self.remainSeconds - 1);
    [self refreshTimeLabel];
}

- (void)refreshTimeLabel {
    NSInteger h = self.remainSeconds / 3600;
    NSInteger m = (self.remainSeconds % 3600) / 60;
    NSInteger s = self.remainSeconds % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"优惠限时%02ld:%02ld:%02ld", (long)h, (long)m, (long)s];
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
