#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLPlaybackSettingsPanelView : UIView

@property (nonatomic, copy, nullable) void (^dismissRequested)(void);
@property (nonatomic, copy, nullable) void (^rateSelected)(float rate);

- (void)setSelectedRate:(float)rate;
- (void)setPanelVerticalOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
