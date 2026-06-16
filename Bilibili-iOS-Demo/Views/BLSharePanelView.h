#import <UIKit/UIKit.h>

@interface BLSharePanelView : UIView

@property (nonatomic, copy) void (^dismissRequested)(void);
@property (nonatomic, copy) void (^optionSelected)(NSString *title);

- (void)setPanelVerticalOffset:(CGFloat)offset;

@end
