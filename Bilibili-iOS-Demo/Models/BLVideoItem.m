#import "BLVideoItem.h"

@implementation BLVideoItem

+ (instancetype)itemWithTitle:(NSString *)title
                       author:(NSString *)author
                        views:(NSString *)views
                      danmaku:(NSString *)danmaku
                     duration:(NSString *)duration
                        badge:(NSString *)badge
                       colors:(NSArray<UIColor *> *)colors {
    BLVideoItem *item = [[BLVideoItem alloc] init];
    item.title = title;
    item.author = author;
    item.views = views;
    item.danmaku = danmaku;
    item.duration = duration;
    item.badge = badge;
    item.colors = colors;
    return item;
}

@end
