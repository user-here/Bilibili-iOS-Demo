#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLWatchLaterItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *danmaku;
@property (nonatomic, copy) NSString *durationText;
@property (nonatomic, copy, nullable) NSString *progressText;
@property (nonatomic, copy, nullable) NSString *videoURLString;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) NSInteger seed;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isInvalid) BOOL invalid;

+ (instancetype)itemWithTitle:(NSString *)title author:(NSString *)author views:(NSString *)views danmaku:(NSString *)danmaku durationText:(NSString *)durationText progressText:(nullable NSString *)progressText progress:(CGFloat)progress finished:(BOOL)finished seed:(NSInteger)seed videoURLString:(nullable NSString *)videoURLString;

@end

@interface BLWatchLaterPageView : UIView

@property (nonatomic, copy, nullable) void (^closeTapped)(void);
@property (nonatomic, copy, nullable) void (^videoSelected)(NSURL *URL, NSString *title, NSString *author);

- (void)setWatchLaterItems:(NSArray<BLWatchLaterItem *> *)items;
- (void)addWatchLaterItem:(BLWatchLaterItem *)item;

@end

NS_ASSUME_NONNULL_END
