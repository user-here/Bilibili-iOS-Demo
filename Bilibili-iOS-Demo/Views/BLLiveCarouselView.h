#import <UIKit/UIKit.h>

@interface BLLiveCarouselItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, strong) NSArray<UIColor *> *colors;

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle badge:(NSString *)badge colors:(NSArray<UIColor *> *)colors;

@end

@interface BLLiveCarouselView : UIView

- (instancetype)initWithItems:(NSArray<BLLiveCarouselItem *> *)items;

@end
