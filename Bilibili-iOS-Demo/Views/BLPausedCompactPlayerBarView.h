#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLPausedCompactPlayerBarView : UIView

@property (nonatomic, copy, nullable) void (^backTapped)(void);
@property (nonatomic, copy, nullable) void (^homeTapped)(void);
@property (nonatomic, copy, nullable) void (^continueTapped)(void);
@property (nonatomic, copy, nullable) void (^settingsTapped)(void);

- (void)setPinkProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
