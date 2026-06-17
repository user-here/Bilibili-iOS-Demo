#import "BLVideoURLProvider.h"

NSString * const BLDefaultLocalVideoRelativePath = @"Videos/2112888954.mp4";

@implementation BLVideoURLProvider

+ (NSURL *)defaultVideoURL {
    return [self videoURLForRelativePath:BLDefaultLocalVideoRelativePath];
}

+ (NSURL *)videoURLForRelativePath:(NSString *)relativePath {
    NSString *path = relativePath.length > 0 ? relativePath : BLDefaultLocalVideoRelativePath;
    NSURL *remoteURL = [NSURL URLWithString:path];
    if (remoteURL.scheme.length > 0) {
        return remoteURL;
    }

    NSString *directory = path.stringByDeletingLastPathComponent;
    NSString *filename = path.lastPathComponent.stringByDeletingPathExtension;
    NSString *extension = path.pathExtension;
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:filename withExtension:extension subdirectory:directory.length > 0 ? directory : nil];
    if (bundleURL != nil) {
        return bundleURL;
    }

    return [[NSBundle mainBundle].resourceURL URLByAppendingPathComponent:path];
}

@end
