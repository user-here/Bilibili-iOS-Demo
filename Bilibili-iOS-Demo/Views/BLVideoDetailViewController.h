#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLVideoDetailViewController : UIViewController

- (instancetype)initWithVideoURL:(NSURL *)videoURL title:(NSString *)title author:(NSString *)author;

@end

NS_ASSUME_NONNULL_END
