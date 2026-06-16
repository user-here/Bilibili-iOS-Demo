#import <UIKit/UIKit.h>

@interface BLSearchPageView : UIView

@property (nonatomic, copy) void (^backTapped)(void);

- (void)focusSearchField;
- (void)resignSearchField;

@end
