#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BLPlayerPlaybackState) {
    BLPlayerPlaybackStateIdle,
    BLPlayerPlaybackStateLoading,
    BLPlayerPlaybackStateReady,
    BLPlayerPlaybackStatePlaying,
    BLPlayerPlaybackStatePaused,
    BLPlayerPlaybackStateBuffering,
    BLPlayerPlaybackStateEnded,
    BLPlayerPlaybackStateFailed
};

@interface BLPlayerCore : NSObject

@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, assign, readonly) BLPlayerPlaybackState playbackState;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) CGFloat bufferProgress;
@property (nonatomic, assign) float preferredRate;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign, getter=isMuted) BOOL muted;
@property (nonatomic, copy, nullable) void (^stateChanged)(BLPlayerPlaybackState state);
@property (nonatomic, copy, nullable) void (^progressChanged)(NSTimeInterval currentTime, NSTimeInterval duration, CGFloat bufferProgress);
@property (nonatomic, copy, nullable) void (^errorOccurred)(NSError *error);

- (void)loadURL:(NSURL *)URL autoplay:(BOOL)autoplay;
- (void)play;
- (void)pause;
- (void)pauseAndCancelAutoplay;
- (void)seekToTime:(NSTimeInterval)time completion:(nullable void (^)(BOOL finished))completion;
- (void)setRate:(float)rate;
- (void)toggleMuted;

@end

NS_ASSUME_NONNULL_END
