#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLHistoryItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *videoURLString;

+ (instancetype)itemWithTitle:(NSString *)title
                       author:(NSString *)author
                         date:(NSString *)date
                         time:(NSString *)time
               videoURLString:(NSString *)videoURLString;

@end

NS_ASSUME_NONNULL_END
