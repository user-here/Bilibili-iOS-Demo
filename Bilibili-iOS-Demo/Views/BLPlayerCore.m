#import "BLPlayerCore.h"

static void *BLPlayerCoreItemStatusContext = &BLPlayerCoreItemStatusContext;
static void *BLPlayerCoreItemBufferContext = &BLPlayerCoreItemBufferContext;
static void *BLPlayerCoreTimeControlContext = &BLPlayerCoreTimeControlContext;

@interface BLPlayerCore ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong, nullable) AVPlayerItem *currentItem;
@property (nonatomic, strong, nullable) id timeObserver;
@property (nonatomic, assign) BLPlayerPlaybackState playbackState;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat bufferProgress;
@property (nonatomic, assign) BOOL autoplayWhenReady;
@end

@implementation BLPlayerCore

- (instancetype)init {
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        _preferredRate = 1.0;
        _volume = 1.0;
        _player.volume = _volume;
        [_player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:BLPlayerCoreTimeControlContext];
        [self addPeriodicTimeObserver];
    }
    return self;
}

- (void)dealloc {
    [self removeCurrentItemObservers];
    if (self.timeObserver != nil) {
        [self.player removeTimeObserver:self.timeObserver];
    }
    [self.player removeObserver:self forKeyPath:@"timeControlStatus" context:BLPlayerCoreTimeControlContext];
}

- (void)loadURL:(NSURL *)URL autoplay:(BOOL)autoplay {
    self.autoplayWhenReady = autoplay;
    [self updateState:BLPlayerPlaybackStateLoading];
    [self removeCurrentItemObservers];

    NSDictionary *headers = @{
        @"User-Agent": @"Mozilla/5.0",
        @"ngrok-skip-browser-warning": @"1"
    };
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:@{@"AVURLAssetHTTPHeaderFieldsKey": headers}];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    self.currentItem = item;
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:BLPlayerCoreItemStatusContext];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:BLPlayerCoreItemBufferContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    [self.player replaceCurrentItemWithPlayerItem:item];
}

- (void)play {
    if (self.player.currentItem == nil) {
        return;
    }
    self.autoplayWhenReady = YES;
    [self.player playImmediatelyAtRate:self.preferredRate];
    [self updateState:BLPlayerPlaybackStatePlaying];
}

- (void)pause {
    [self.player pause];
    [self updateState:BLPlayerPlaybackStatePaused];
}

- (void)pauseAndCancelAutoplay {
    self.autoplayWhenReady = NO;
    [self pause];
}

- (void)setRate:(float)rate {
    self.preferredRate = MAX(0.1, rate);
    if (self.player.rate > 0.0) {
        self.player.rate = self.preferredRate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

- (void)setVolume:(float)volume {
    _volume = MIN(1.0, MAX(0.0, volume));
    self.player.volume = _volume;
    self.muted = (_volume <= 0.01);
}

- (void)toggleMuted {
    self.muted = !self.isMuted;
}

- (void)seekToTime:(NSTimeInterval)time completion:(void (^)(BOOL))completion {
    CMTime target = CMTimeMakeWithSeconds(MAX(0.0, time), NSEC_PER_SEC);
    [self.player seekToTime:target toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)addPeriodicTimeObserver {
    __weak typeof(self) weakSelf = self;
    CMTime interval = CMTimeMakeWithSeconds(0.25, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf refreshPlaybackProgress];
    }];
}

- (void)refreshPlaybackProgress {
    AVPlayerItem *item = self.player.currentItem;
    if (item == nil) {
        return;
    }
    NSTimeInterval current = CMTimeGetSeconds(item.currentTime);
    NSTimeInterval duration = CMTimeGetSeconds(item.duration);
    self.currentTime = isfinite(current) ? current : 0.0;
    self.duration = isfinite(duration) ? duration : 0.0;
    [self refreshBufferProgress];
    if (self.progressChanged) {
        self.progressChanged(self.currentTime, self.duration, self.bufferProgress);
    }
}

- (void)refreshBufferProgress {
    AVPlayerItem *item = self.player.currentItem;
    NSValue *rangeValue = item.loadedTimeRanges.firstObject;
    if (rangeValue == nil) {
        self.bufferProgress = 0.0;
        return;
    }
    CMTimeRange range = rangeValue.CMTimeRangeValue;
    NSTimeInterval start = CMTimeGetSeconds(range.start);
    NSTimeInterval length = CMTimeGetSeconds(range.duration);
    NSTimeInterval duration = CMTimeGetSeconds(item.duration);
    if (isfinite(start) && isfinite(length) && isfinite(duration) && duration > 0.0) {
        self.bufferProgress = MIN(1.0, MAX(0.0, (start + length) / duration));
    } else {
        self.bufferProgress = 0.0;
    }
}

- (void)removeCurrentItemObservers {
    if (self.currentItem == nil) {
        return;
    }
    @try {
        [self.currentItem removeObserver:self forKeyPath:@"status" context:BLPlayerCoreItemStatusContext];
        [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:BLPlayerCoreItemBufferContext];
    } @catch (__unused NSException *exception) {
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
    self.currentItem = nil;
}

- (void)itemDidPlayToEnd:(NSNotification *)notification {
    [self updateState:BLPlayerPlaybackStateEnded];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == BLPlayerCoreItemStatusContext) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            [self refreshPlaybackProgress];
            [self updateState:BLPlayerPlaybackStateReady];
            if (self.autoplayWhenReady) {
                [self play];
            }
        } else if (item.status == AVPlayerItemStatusFailed) {
            [self updateState:BLPlayerPlaybackStateFailed];
            if (self.errorOccurred && item.error) {
                self.errorOccurred(item.error);
            }
        }
        return;
    }
    if (context == BLPlayerCoreItemBufferContext) {
        [self refreshPlaybackProgress];
        return;
    }
    if (context == BLPlayerCoreTimeControlContext) {
        if (self.player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            [self updateState:BLPlayerPlaybackStateBuffering];
        } else if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            [self updateState:BLPlayerPlaybackStatePlaying];
        }
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)updateState:(BLPlayerPlaybackState)state {
    if (_playbackState == state) {
        return;
    }
    _playbackState = state;
    if (self.stateChanged) {
        self.stateChanged(state);
    }
}

@end
