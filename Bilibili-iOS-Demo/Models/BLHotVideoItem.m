#import "BLHotVideoItem.h"

@implementation BLHotVideoItem

+ (instancetype)itemWithTitle:(NSString *)title
                       author:(NSString *)author
                        views:(NSString *)views
                     timeText:(NSString *)timeText
                     duration:(NSString *)duration
                          tag:(NSString *)tag
                       colors:(NSArray<UIColor *> *)colors {
    BLHotVideoItem *item = [[BLHotVideoItem alloc] init];
    item.title = title;
    item.author = author;
    item.views = views;
    item.timeText = timeText;
    item.duration = duration;
    item.tag = tag;
    item.colors = colors;
    return item;
}

@end
