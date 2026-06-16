#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLOfflineCacheItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *dateText;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy, nullable) NSString *videoURLString;
@property (nonatomic, assign) NSInteger seed;

+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author dateText:(NSString *)dateText statusText:(NSString *)statusText videoURLString:(nullable NSString *)videoURLString seed:(NSInteger)seed;

@end

@interface BLOfflineCachePageView : UIView

@property (nonatomic, copy, nullable) void (^closeTapped)(void);
@property (nonatomic, copy, nullable) void (^videoSelected)(NSURL *URL, NSString *title, NSString *author);

- (void)setOfflineItems:(NSArray<BLOfflineCacheItem *> *)items;
- (void)addOfflineItem:(BLOfflineCacheItem *)item;

@end

NS_ASSUME_NONNULL_END
