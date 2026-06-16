#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLHistoryPageView : UIView

@property (nonatomic, copy, nullable) void (^closeTapped)(void);
@property (nonatomic, copy, nullable) void (^videoSelected)(NSURL *URL, NSString *title, NSString *author);

@end

NS_ASSUME_NONNULL_END
