#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMemberAutoCarouselView : UIView

- (instancetype)initWithItems:(NSArray<NSString *> *)items;
- (void)startAutoScroll;
- (void)stopAutoScroll;

@end

NS_ASSUME_NONNULL_END
