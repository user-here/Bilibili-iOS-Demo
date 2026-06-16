#import "BLPlayerRenderView.h"
#import <AVFoundation/AVFoundation.h>

@implementation BLPlayerRenderView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    ((AVPlayerLayer *)self.layer).player = player;
}

- (AVPlayer *)player {
    return ((AVPlayerLayer *)self.layer).player;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    ((AVPlayerLayer *)self.layer).videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return ((AVPlayerLayer *)self.layer).videoGravity;
}

@end
