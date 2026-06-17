#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLHotVideoItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray<UIColor *> *colors;

+ (instancetype)itemWithTitle:(NSString *)title
                       author:(NSString *)author
                        views:(NSString *)views
                     timeText:(NSString *)timeText
                     duration:(NSString *)duration
                          tag:(NSString *)tag
                       colors:(NSArray<UIColor *> *)colors;

@end

NS_ASSUME_NONNULL_END
