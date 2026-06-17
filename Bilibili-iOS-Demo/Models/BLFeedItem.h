#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLFeedItem : NSObject

@property (nonatomic, copy) NSString *avatarText;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@end

NS_ASSUME_NONNULL_END
