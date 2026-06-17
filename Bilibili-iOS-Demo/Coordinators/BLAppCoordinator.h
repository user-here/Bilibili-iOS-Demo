#import <UIKit/UIKit.h>

@class BLFollowingPageView;

@interface BLAppCoordinator : NSObject

- (instancetype)initWithRootView:(UIView *)rootView
                       bottomBar:(UIView *)bottomBar
              presentingViewController:(UIViewController *)presentingViewController;

- (void)deactivateAllPages;

- (void)showSearchPage;
- (void)showMallSearchPage;
- (void)showMallCouponPage;
- (void)showHistoryPage;
- (void)showFavoritePage;
- (void)showWatchLaterPage;
- (void)showOfflineCachePage;
- (void)showProfileSpacePage;
- (void)showMemberCenterPage;
- (void)showContactServicePage;
- (void)showPublishPageWithFollowingPageView:(BLFollowingPageView *)followingPageView;
- (void)openPlayerWithURL:(NSURL *)URL title:(NSString *)title author:(NSString *)author;

@end
