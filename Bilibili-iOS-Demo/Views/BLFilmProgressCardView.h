#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLFilmProgressCardView : UIView

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle progress:(CGFloat)progress colors:(NSArray<UIColor *> *)colors;

@end

NS_ASSUME_NONNULL_END
