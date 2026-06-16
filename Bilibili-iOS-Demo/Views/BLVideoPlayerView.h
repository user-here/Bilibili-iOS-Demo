#import <UIKit/UIKit.h>
#import "BLPlayerCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLVideoPlayerView : UIView

@property (nonatomic, strong, readonly) BLPlayerCore *playerCore;
@property (nonatomic, strong, readonly) UIView *danmakuContainerView;
@property (nonatomic, assign, readonly) float playbackRate;
@property (nonatomic, copy, nullable) void (^closeTapped)(void);
@property (nonatomic, copy, nullable) void (^settingsTapped)(void);

- (void)loadURL:(NSURL *)URL autoplay:(BOOL)autoplay;
- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity;
- (void)setPlaybackRate:(float)rate;

@end

NS_ASSUME_NONNULL_END
