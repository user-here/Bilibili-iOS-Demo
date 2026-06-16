#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AVPlayer;

@interface BLPlayerRenderView : UIView

@property (nonatomic, strong, nullable) AVPlayer *player;
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

@end

NS_ASSUME_NONNULL_END
