#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLVideoItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *danmaku;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, strong) NSArray<UIColor *> *colors;

+ (instancetype)itemWithTitle:(NSString *)title
                       author:(NSString *)author
                        views:(NSString *)views
                      danmaku:(NSString *)danmaku
                     duration:(NSString *)duration
                        badge:(NSString *)badge
                       colors:(NSArray<UIColor *> *)colors;

@end

NS_ASSUME_NONNULL_END
