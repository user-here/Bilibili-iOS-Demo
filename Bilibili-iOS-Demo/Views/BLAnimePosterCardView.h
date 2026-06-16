#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLAnimePosterCardView : UIView

- (instancetype)initWithRank:(NSString *)rank title:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors;
- (instancetype)initWithRank:(NSString *)rank title:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors cardWidth:(CGFloat)cardWidth coverHeight:(CGFloat)coverHeight;

@end

NS_ASSUME_NONNULL_END
