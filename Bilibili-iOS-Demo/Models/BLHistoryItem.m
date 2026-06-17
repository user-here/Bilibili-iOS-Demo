#import "BLHistoryItem.h"

@implementation BLHistoryItem

+ (instancetype)itemWithTitle:(NSString *)title
                       author:(NSString *)author
                         date:(NSString *)date
                         time:(NSString *)time
               videoURLString:(NSString *)videoURLString {
    BLHistoryItem *item = [[BLHistoryItem alloc] init];
    item.title = title;
    item.author = author;
    item.date = date;
    item.time = time;
    item.videoURLString = videoURLString;
    return item;
}

@end
