#import "BLCapturePublishView.h"
#import <AVFoundation/AVFoundation.h>

@interface BLCapturePublishView ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UILabel *permissionLabel;
@property (nonatomic, strong) UIStackView *toolStack;
@end

@implementation BLCapturePublishView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor blackColor];
        [self buildView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = self.previewView.bounds;
}

- (void)buildView {
    self.previewView = [[UIView alloc] init];
    self.previewView.translatesAutoresizingMaskIntoConstraints = NO;
    self.previewView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    [self addSubview:self.previewView];

    self.permissionLabel = [[UILabel alloc] init];
    self.permissionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.permissionLabel.text = @"需要相机权限";
    self.permissionLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    self.permissionLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    self.permissionLabel.textAlignment = NSTextAlignmentCenter;
    self.permissionLabel.hidden = YES;
    [self.previewView addSubview:self.permissionLabel];

    self.toolStack = [[UIStackView alloc] init];
    self.toolStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolStack.axis = UILayoutConstraintAxisVertical;
    self.toolStack.alignment = UIStackViewAlignmentCenter;
    self.toolStack.spacing = 22.0;
    [self addSubview:self.toolStack];

    NSArray<NSArray *> *tools = @[
        @[@"arrow.triangle.2.circlepath.camera", @"翻转"],
        @[@"wand.and.stars", @"美颜"],
        @[@"timer", @"计时"],
        @[@"bolt.slash", @"闪光"]
    ];
    for (NSArray *tool in tools) {
        [self.toolStack addArrangedSubview:[self toolButtonWithSymbol:tool[0] title:tool[1]]];
    }

    UIButton *albumButton = [self smallBottomButtonWithTitle:@"相册" symbol:@"photo.on.rectangle"];
    UIButton *shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shootButton.translatesAutoresizingMaskIntoConstraints = NO;
    shootButton.backgroundColor = [UIColor whiteColor];
    shootButton.layer.cornerRadius = 38.0;
    shootButton.layer.borderWidth = 6.0;
    shootButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.45].CGColor;
    UIButton *effectButton = [self smallBottomButtonWithTitle:@"道具" symbol:@"sparkles"];
    [self addSubview:albumButton];
    [self addSubview:shootButton];
    [self addSubview:effectButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.previewView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.previewView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.previewView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.previewView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.permissionLabel.centerXAnchor constraintEqualToAnchor:self.previewView.centerXAnchor],
        [self.permissionLabel.centerYAnchor constraintEqualToAnchor:self.previewView.centerYAnchor],
        [self.toolStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18.0],
        [self.toolStack.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:74.0],
        [shootButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [shootButton.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-84.0],
        [shootButton.widthAnchor constraintEqualToConstant:76.0],
        [shootButton.heightAnchor constraintEqualToConstant:76.0],
        [albumButton.centerYAnchor constraintEqualToAnchor:shootButton.centerYAnchor],
        [albumButton.trailingAnchor constraintEqualToAnchor:shootButton.leadingAnchor constant:-54.0],
        [effectButton.centerYAnchor constraintEqualToAnchor:shootButton.centerYAnchor],
        [effectButton.leadingAnchor constraintEqualToAnchor:shootButton.trailingAnchor constant:54.0]
    ]];
}

- (UIView *)toolButtonWithSymbol:(NSString *)symbol title:(NSString *)title {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 4.0;

    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightRegular];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:config]];
    icon.tintColor = [UIColor whiteColor];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [icon.widthAnchor constraintEqualToConstant:32.0].active = YES;
    [icon.heightAnchor constraintEqualToConstant:32.0].active = YES;

    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:1.0 alpha:0.88];
    label.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium];
    [stack addArrangedSubview:icon];
    [stack addArrangedSubview:label];
    return stack;
}

- (UIButton *)smallBottomButtonWithTitle:(NSString *)title symbol:(NSString *)symbol {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightRegular];
    [button setImage:[[UIImage systemImageNamed:symbol] imageWithConfiguration:config] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"\n%@", title] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

- (void)startCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        [self configureAndRunSession];
        return;
    }
    if (status == AVAuthorizationStatusNotDetermined) {
        __weak typeof(self) weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [weakSelf configureAndRunSession];
                } else {
                    [weakSelf showPermissionDenied];
                }
            });
        }];
        return;
    }
    [self showPermissionDenied];
}

- (void)stopCamera {
    if (self.session.isRunning) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self.session stopRunning];
        });
    }
}

- (void)configureAndRunSession {
    self.permissionLabel.hidden = YES;
    if (self.session == nil) {
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        AVCaptureDevice *device = [self frontCameraDevice];
        NSError *error = nil;
        AVCaptureDeviceInput *input = device ? [AVCaptureDeviceInput deviceInputWithDevice:device error:&error] : nil;
        if (input != nil && [self.session canAddInput:input]) {
            [self.session addInput:input];
        } else {
            [self showPermissionDenied];
            return;
        }
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.previewView.layer insertSublayer:self.previewLayer atIndex:0];
        self.previewLayer.frame = self.previewView.bounds;
    }
    if (!self.session.isRunning) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self.session startRunning];
        });
    }
}

- (AVCaptureDevice *)frontCameraDevice {
    if (@available(iOS 10.0, *)) {
        AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        return session.devices.firstObject;
    }
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)showPermissionDenied {
    self.permissionLabel.hidden = NO;
}

@end
