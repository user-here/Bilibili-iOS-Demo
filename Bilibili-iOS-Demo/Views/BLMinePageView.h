#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMinePageView : UIView

@property (nonatomic, copy, nullable) void (^offlineCacheTapped)(void);
@property (nonatomic, copy, nullable) void (^historyTapped)(void);
@property (nonatomic, copy, nullable) void (^favoriteTapped)(void);
@property (nonatomic, copy, nullable) void (^watchLaterTapped)(void);
@property (nonatomic, copy, nullable) void (^profileTapped)(void);
@property (nonatomic, copy, nullable) void (^memberCenterTapped)(void);
@property (nonatomic, copy, nullable) void (^contactServiceTapped)(void);

@end

NS_ASSUME_NONNULL_END
