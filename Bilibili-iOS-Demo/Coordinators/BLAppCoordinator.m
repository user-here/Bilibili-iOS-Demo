#import "BLAppCoordinator.h"
#import "../Views/BLSearchPageView.h"
#import "../Views/BLMallSearchPageView.h"
#import "../Views/BLMallCouponPageView.h"
#import "../Views/BLHistoryPageView.h"
#import "../Views/BLFavoritePageView.h"
#import "../Views/BLWatchLaterPageView.h"
#import "../Views/BLOfflineCachePageView.h"
#import "../Views/BLProfileSpacePageView.h"
#import "../Views/BLMemberCenterPageView.h"
#import "../Views/BLContactServicePageView.h"
#import "../Views/BLPublishPageView.h"
#import "../Views/BLVideoDetailViewController.h"
#import "../Views/BLVideoURLProvider.h"
#import "../Views/BLFollowingPageView.h"

@interface BLAppCoordinator () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIView *rootView;
@property (nonatomic, weak) UIView *bottomBar;
@property (nonatomic, weak) UIViewController *presentingViewController;

@property (nonatomic, strong) BLSearchPageView *searchPageView;
@property (nonatomic, strong) NSLayoutConstraint *searchPageLeadingConstraint;

@property (nonatomic, strong) BLMallSearchPageView *mallSearchPageView;
@property (nonatomic, strong) NSLayoutConstraint *mallSearchPageLeadingConstraint;

@property (nonatomic, strong) BLMallCouponPageView *mallCouponPageView;
@property (nonatomic, strong) NSLayoutConstraint *mallCouponPageLeadingConstraint;

@property (nonatomic, strong) BLHistoryPageView *historyPageView;
@property (nonatomic, strong) NSLayoutConstraint *historyPageLeadingConstraint;

@property (nonatomic, strong) BLFavoritePageView *favoritePageView;
@property (nonatomic, strong) NSLayoutConstraint *favoritePageLeadingConstraint;

@property (nonatomic, strong) BLWatchLaterPageView *watchLaterPageView;
@property (nonatomic, strong) NSLayoutConstraint *watchLaterPageLeadingConstraint;

@property (nonatomic, strong) BLOfflineCachePageView *offlineCachePageView;
@property (nonatomic, strong) NSLayoutConstraint *offlineCachePageLeadingConstraint;

@property (nonatomic, strong) BLProfileSpacePageView *profileSpacePageView;
@property (nonatomic, strong) NSLayoutConstraint *profileSpacePageLeadingConstraint;

@property (nonatomic, strong) BLMemberCenterPageView *memberCenterPageView;
@property (nonatomic, strong) NSLayoutConstraint *memberCenterPageLeadingConstraint;

@property (nonatomic, strong) BLContactServicePageView *contactServicePageView;
@property (nonatomic, strong) NSLayoutConstraint *contactServicePageLeadingConstraint;

@property (nonatomic, strong) BLPublishPageView *publishPageView;
@property (nonatomic, strong) NSLayoutConstraint *publishPageLeadingConstraint;

@property (nonatomic, weak) BLFollowingPageView *followingPageViewRef;

@end

@implementation BLAppCoordinator

- (instancetype)initWithRootView:(UIView *)rootView
                       bottomBar:(UIView *)bottomBar
      presentingViewController:(UIViewController *)presentingViewController {
    self = [super init];
    if (self) {
        _rootView = rootView;
        _bottomBar = bottomBar;
        _presentingViewController = presentingViewController;
    }
    return self;
}

#pragma mark - Search

- (void)showSearchPage {
    [self buildSearchPageIfNeeded];
    self.searchPageView.hidden = NO;
    self.searchPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [self.rootView layoutIfNeeded];

    self.searchPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.searchPageView focusSearchField];
    }];
}

- (void)dismissSearchPage {
    [self.searchPageView resignSearchField];
    self.searchPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.searchPageView.hidden = YES;
    }];
}

- (void)buildSearchPageIfNeeded {
    if (self.searchPageView != nil) {
        return;
    }
    self.searchPageView = [[BLSearchPageView alloc] init];
    self.searchPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.searchPageView.backTapped = ^{
        [weakSelf dismissSearchPage];
    };
    [self.rootView addSubview:self.searchPageView];
    self.searchPageLeadingConstraint = [self.searchPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.searchPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.searchPageLeadingConstraint,
        [self.searchPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.searchPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
}

#pragma mark - Mall Search

- (void)showMallSearchPage {
    [self buildMallSearchPageIfNeeded];
    self.mallSearchPageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.mallSearchPageView];
    self.mallSearchPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissMallSearchPage {
    self.mallSearchPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.mallSearchPageView.hidden = YES;
    }];
}

- (void)buildMallSearchPageIfNeeded {
    if (self.mallSearchPageView != nil) {
        return;
    }
    self.mallSearchPageView = [[BLMallSearchPageView alloc] init];
    self.mallSearchPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.mallSearchPageView.closeTapped = ^{
        [weakSelf dismissMallSearchPage];
    };
    [self.rootView addSubview:self.mallSearchPageView];
    self.mallSearchPageLeadingConstraint = [self.mallSearchPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.mallSearchPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.mallSearchPageLeadingConstraint,
        [self.mallSearchPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.mallSearchPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Mall Coupon

- (void)showMallCouponPage {
    [self buildMallCouponPageIfNeeded];
    self.mallCouponPageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.mallCouponPageView];
    self.mallCouponPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissMallCouponPage {
    self.mallCouponPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.mallCouponPageView.hidden = YES;
    }];
}

- (void)buildMallCouponPageIfNeeded {
    if (self.mallCouponPageView != nil) {
        return;
    }
    self.mallCouponPageView = [[BLMallCouponPageView alloc] init];
    self.mallCouponPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.mallCouponPageView.closeTapped = ^{
        [weakSelf dismissMallCouponPage];
    };
    self.mallCouponPageView.searchTapped = ^{
        [weakSelf showMallSearchPage];
    };
    [self.rootView addSubview:self.mallCouponPageView];
    self.mallCouponPageLeadingConstraint = [self.mallCouponPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.mallCouponPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.mallCouponPageLeadingConstraint,
        [self.mallCouponPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.mallCouponPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - History

- (void)showHistoryPage {
    [self buildHistoryPageIfNeeded];
    self.historyPageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.historyPageView];
    self.historyPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissHistoryPage {
    self.historyPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.historyPageView.hidden = YES;
    }];
}

- (void)buildHistoryPageIfNeeded {
    if (self.historyPageView != nil) {
        return;
    }
    self.historyPageView = [[BLHistoryPageView alloc] init];
    self.historyPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.historyPageView.closeTapped = ^{
        [weakSelf dismissHistoryPage];
    };
    self.historyPageView.videoSelected = ^(NSURL *URL, NSString *title, NSString *author) {
        [weakSelf openPlayerWithURL:URL title:title author:author];
    };
    [self.rootView addSubview:self.historyPageView];
    self.historyPageLeadingConstraint = [self.historyPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.historyPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.historyPageLeadingConstraint,
        [self.historyPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.historyPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Favorite

- (void)showFavoritePage {
    [self buildFavoritePageIfNeeded];
    self.favoritePageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.favoritePageView];
    self.favoritePageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissFavoritePage {
    self.favoritePageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.favoritePageView.hidden = YES;
    }];
}

- (void)buildFavoritePageIfNeeded {
    if (self.favoritePageView != nil) {
        return;
    }
    self.favoritePageView = [[BLFavoritePageView alloc] init];
    self.favoritePageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.favoritePageView.closeTapped = ^{
        [weakSelf dismissFavoritePage];
    };
    self.favoritePageView.videoSelected = ^(NSURL *URL, NSString *title, NSString *author) {
        [weakSelf openPlayerWithURL:URL title:title author:author];
    };
    [self.rootView addSubview:self.favoritePageView];
    self.favoritePageLeadingConstraint = [self.favoritePageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.favoritePageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.favoritePageLeadingConstraint,
        [self.favoritePageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.favoritePageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Watch Later

- (void)showWatchLaterPage {
    [self buildWatchLaterPageIfNeeded];
    self.watchLaterPageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.watchLaterPageView];
    self.watchLaterPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissWatchLaterPage {
    self.watchLaterPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.watchLaterPageView.hidden = YES;
    }];
}

- (void)buildWatchLaterPageIfNeeded {
    if (self.watchLaterPageView != nil) {
        return;
    }
    self.watchLaterPageView = [[BLWatchLaterPageView alloc] init];
    self.watchLaterPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.watchLaterPageView.closeTapped = ^{
        [weakSelf dismissWatchLaterPage];
    };
    self.watchLaterPageView.videoSelected = ^(NSURL *URL, NSString *title, NSString *author) {
        [weakSelf openPlayerWithURL:URL title:title author:author];
    };
    [self.rootView addSubview:self.watchLaterPageView];
    self.watchLaterPageLeadingConstraint = [self.watchLaterPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.watchLaterPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.watchLaterPageLeadingConstraint,
        [self.watchLaterPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.watchLaterPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Offline Cache

- (void)showOfflineCachePage {
    [self buildOfflineCachePageIfNeeded];
    self.offlineCachePageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.offlineCachePageView];
    self.offlineCachePageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissOfflineCachePage {
    self.offlineCachePageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.offlineCachePageView.hidden = YES;
    }];
}

- (void)buildOfflineCachePageIfNeeded {
    if (self.offlineCachePageView != nil) {
        return;
    }
    self.offlineCachePageView = [[BLOfflineCachePageView alloc] init];
    self.offlineCachePageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.offlineCachePageView.closeTapped = ^{
        [weakSelf dismissOfflineCachePage];
    };
    self.offlineCachePageView.videoSelected = ^(NSURL *URL, NSString *title, NSString *author) {
        [weakSelf openPlayerWithURL:URL title:title author:author];
    };
    [self.rootView addSubview:self.offlineCachePageView];
    self.offlineCachePageLeadingConstraint = [self.offlineCachePageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.offlineCachePageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.offlineCachePageLeadingConstraint,
        [self.offlineCachePageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.offlineCachePageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Profile Space

- (void)showProfileSpacePage {
    [self buildProfileSpacePageIfNeeded];
    self.profileSpacePageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.profileSpacePageView];
    self.profileSpacePageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissProfileSpacePage {
    self.profileSpacePageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.profileSpacePageView.hidden = YES;
    }];
}

- (void)buildProfileSpacePageIfNeeded {
    if (self.profileSpacePageView != nil) {
        return;
    }
    self.profileSpacePageView = [[BLProfileSpacePageView alloc] init];
    self.profileSpacePageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.profileSpacePageView.closeTapped = ^{
        [weakSelf dismissProfileSpacePage];
    };
    self.profileSpacePageView.chooseBackgroundTapped = ^{
        [weakSelf showProfileBackgroundPicker];
    };
    [self.rootView addSubview:self.profileSpacePageView];
    self.profileSpacePageLeadingConstraint = [self.profileSpacePageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.profileSpacePageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.profileSpacePageLeadingConstraint,
        [self.profileSpacePageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.profileSpacePageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

- (void)showProfileBackgroundPicker {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self.presentingViewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (image != nil) {
        [self.profileSpacePageView setProfileBackgroundImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Member Center

- (void)showMemberCenterPage {
    [self buildMemberCenterPageIfNeeded];
    self.memberCenterPageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.memberCenterPageView];
    self.memberCenterPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.memberCenterPageView activate];
    }];
}

- (void)dismissMemberCenterPage {
    [self.memberCenterPageView deactivate];
    self.memberCenterPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.memberCenterPageView removeFromSuperview];
        self.memberCenterPageView = nil;
        self.memberCenterPageLeadingConstraint = nil;
    }];
}

- (void)buildMemberCenterPageIfNeeded {
    if (self.memberCenterPageView != nil) {
        return;
    }
    self.memberCenterPageView = [[BLMemberCenterPageView alloc] init];
    self.memberCenterPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.memberCenterPageView.closeTapped = ^{
        [weakSelf dismissMemberCenterPage];
    };
    [self.rootView addSubview:self.memberCenterPageView];
    self.memberCenterPageLeadingConstraint = [self.memberCenterPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.memberCenterPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.memberCenterPageLeadingConstraint,
        [self.memberCenterPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.memberCenterPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Contact Service

- (void)showContactServicePage {
    [self buildContactServicePageIfNeeded];
    self.contactServicePageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.contactServicePageView];
    self.contactServicePageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:nil];
}

- (void)dismissContactServicePage {
    self.contactServicePageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.contactServicePageView.hidden = YES;
    }];
}

- (void)buildContactServicePageIfNeeded {
    if (self.contactServicePageView != nil) {
        return;
    }
    self.contactServicePageView = [[BLContactServicePageView alloc] init];
    self.contactServicePageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.contactServicePageView.closeTapped = ^{
        [weakSelf dismissContactServicePage];
    };
    [self.rootView addSubview:self.contactServicePageView];
    self.contactServicePageLeadingConstraint = [self.contactServicePageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.contactServicePageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.contactServicePageLeadingConstraint,
        [self.contactServicePageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.contactServicePageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Publish

- (void)showPublishPageWithFollowingPageView:(BLFollowingPageView *)followingPageView {
    self.followingPageViewRef = followingPageView;
    [self buildPublishPageIfNeeded];
    [followingPageView deactivate];
    self.publishPageView.hidden = NO;
    [self.rootView bringSubviewToFront:self.publishPageView];
    self.publishPageLeadingConstraint.constant = 0.0;
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.publishPageView activate];
    }];
}

- (void)dismissPublishPage {
    [self.publishPageView deactivate];
    self.publishPageLeadingConstraint.constant = CGRectGetWidth(self.rootView.bounds);
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.rootView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.publishPageView.hidden = YES;
        BLFollowingPageView *following = self.followingPageViewRef;
        if (following != nil && !following.hidden) {
            [following activate];
        }
    }];
}

- (void)buildPublishPageIfNeeded {
    if (self.publishPageView != nil) {
        return;
    }
    self.publishPageView = [[BLPublishPageView alloc] init];
    self.publishPageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.publishPageView.closeTapped = ^{
        [weakSelf dismissPublishPage];
    };
    [self.rootView addSubview:self.publishPageView];
    self.publishPageLeadingConstraint = [self.publishPageView.leadingAnchor constraintEqualToAnchor:self.rootView.leadingAnchor constant:CGRectGetWidth(self.rootView.bounds)];
    [NSLayoutConstraint activateConstraints:@[
        [self.publishPageView.topAnchor constraintEqualToAnchor:self.rootView.topAnchor],
        self.publishPageLeadingConstraint,
        [self.publishPageView.widthAnchor constraintEqualToAnchor:self.rootView.widthAnchor],
        [self.publishPageView.bottomAnchor constraintEqualToAnchor:self.rootView.bottomAnchor]
    ]];
    [self.rootView layoutIfNeeded];
}

#pragma mark - Deactivate

- (void)deactivateAllPages {
    [self.publishPageView deactivate];
    [self.memberCenterPageView deactivate];
}

#pragma mark - Player

- (void)openPlayerWithURL:(NSURL *)URL title:(NSString *)title author:(NSString *)author {
    BLVideoDetailViewController *detail = [[BLVideoDetailViewController alloc] initWithVideoURL:URL title:title author:author];
    [self.presentingViewController presentViewController:detail animated:YES completion:nil];
}

@end
