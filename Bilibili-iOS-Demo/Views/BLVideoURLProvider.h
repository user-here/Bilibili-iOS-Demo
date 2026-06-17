#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BLDefaultLocalVideoRelativePath;

@interface BLVideoURLProvider : NSObject

+ (NSURL *)defaultVideoURL;
+ (NSURL *)videoURLForRelativePath:(NSString *)relativePath;

@end

NS_ASSUME_NONNULL_END
