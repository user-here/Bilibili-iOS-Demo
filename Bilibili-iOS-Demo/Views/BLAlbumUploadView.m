#import "BLAlbumUploadView.h"
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, BLAlbumFilter) {
    BLAlbumFilterAll,
    BLAlbumFilterVideo,
    BLAlbumFilterPhoto
};

static UIColor *BLAlbumPink(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

@interface BLAlbumAssetCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *addButton;
- (void)configureWithAsset:(PHAsset *)asset imageManager:(PHCachingImageManager *)imageManager targetSize:(CGSize)targetSize;
@end

@implementation BLAlbumAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1.0];
        self.clipsToBounds = YES;
        self.imageView = [[UIImageView alloc] init];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];

        self.durationLabel = [[UILabel alloc] init];
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.durationLabel.textColor = [UIColor whiteColor];
        self.durationLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.durationLabel];

        self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.addButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.addButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.30];
        self.addButton.tintColor = [UIColor whiteColor];
        self.addButton.layer.cornerRadius = 18.0;
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightBold];
        [self.addButton setImage:[[UIImage systemImageNamed:@"plus"] imageWithConfiguration:config] forState:UIControlStateNormal];
        [self.contentView addSubview:self.addButton];

        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [self.addButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16.0],
            [self.addButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16.0],
            [self.addButton.widthAnchor constraintEqualToConstant:36.0],
            [self.addButton.heightAnchor constraintEqualToConstant:36.0],
            [self.durationLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-12.0],
            [self.durationLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10.0]
        ]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.durationLabel.text = nil;
}

- (void)configureWithAsset:(PHAsset *)asset imageManager:(PHCachingImageManager *)imageManager targetSize:(CGSize)targetSize {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
    }];
    self.durationLabel.text = asset.mediaType == PHAssetMediaTypeVideo ? [self durationText:asset.duration] : @"";
}

- (NSString *)durationText:(NSTimeInterval)duration {
    NSInteger total = (NSInteger)round(duration);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)(total / 60), (long)(total % 60)];
}

@end

@interface BLAlbumUploadView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleArrowLabel;
@property (nonatomic, strong) UIStackView *titleStack;
@property (nonatomic, strong) UIStackView *filterStack;
@property (nonatomic, strong) NSArray<UIButton *> *filterButtons;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) NSArray<PHAsset *> *allAssets;
@property (nonatomic, strong) NSArray<PHAsset *> *filteredAssets;
@property (nonatomic, assign) BLAlbumFilter selectedFilter;
@end

@implementation BLAlbumUploadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor blackColor];
        self.imageManager = [[PHCachingImageManager alloc] init];
        self.selectedFilter = BLAlbumFilterVideo;
        self.allAssets = @[];
        self.filteredAssets = @[];
        [self buildView];
    }
    return self;
}

- (void)buildView {
    UIButton *closeSpace = [UIButton buttonWithType:UIButtonTypeCustom];
    closeSpace.translatesAutoresizingMaskIntoConstraints = NO;
    closeSpace.userInteractionEnabled = NO;
    [self addSubview:closeSpace];

    self.titleStack = [[UIStackView alloc] init];
    self.titleStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleStack.axis = UILayoutConstraintAxisHorizontal;
    self.titleStack.alignment = UIStackViewAlignmentCenter;
    self.titleStack.spacing = 5.0;
    [self addSubview:self.titleStack];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"最近项目";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightSemibold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleStack addArrangedSubview:self.titleLabel];

    self.titleArrowLabel = [[UILabel alloc] init];
    self.titleArrowLabel.text = @"⌄";
    self.titleArrowLabel.textColor = [UIColor whiteColor];
    self.titleArrowLabel.font = [UIFont systemFontOfSize:23.0 weight:UIFontWeightSemibold];
    self.titleArrowLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleStack addArrangedSubview:self.titleArrowLabel];

    UILabel *draft = [[UILabel alloc] init];
    draft.translatesAutoresizingMaskIntoConstraints = NO;
    draft.text = @"草稿箱";
    draft.textColor = BLAlbumPink();
    draft.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    draft.textAlignment = NSTextAlignmentRight;
    [self addSubview:draft];
    self.filterStack = [[UIStackView alloc] init];
    self.filterStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.filterStack.axis = UILayoutConstraintAxisHorizontal;
    self.filterStack.distribution = UIStackViewDistributionFillEqually;
    self.filterStack.alignment = UIStackViewAlignmentCenter;
    [self addSubview:self.filterStack];

    NSArray *titles = @[@"全部", @"视频", @"照片"];
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger index = 0; index < titles.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightSemibold];
        [button addTarget:self action:@selector(filterTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterStack addArrangedSubview:button];
        [buttons addObject:button];
    }
    self.filterButtons = buttons;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2.0;
    layout.minimumLineSpacing = 2.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:BLAlbumAssetCell.class forCellWithReuseIdentifier:@"BLAlbumAssetCell"];
    [self addSubview:self.collectionView];

    self.emptyLabel = [[UILabel alloc] init];
    self.emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyLabel.textColor = [UIColor colorWithWhite:0.62 alpha:1.0];
    self.emptyLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.numberOfLines = 0;
    self.emptyLabel.hidden = YES;
    [self addSubview:self.emptyLabel];

    [NSLayoutConstraint activateConstraints:@[
        [closeSpace.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [closeSpace.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:26.0],
        [closeSpace.widthAnchor constraintEqualToConstant:86.0],
        [closeSpace.heightAnchor constraintEqualToConstant:44.0],
        [self.titleStack.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.titleStack.centerYAnchor constraintEqualToAnchor:closeSpace.centerYAnchor],
        [draft.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-28.0],
        [draft.centerYAnchor constraintEqualToAnchor:self.titleStack.centerYAnchor],
        [self.filterStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.filterStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.filterStack.topAnchor constraintEqualToAnchor:self.titleStack.bottomAnchor constant:46.0],
        [self.filterStack.heightAnchor constraintEqualToConstant:58.0],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.filterStack.bottomAnchor constant:18.0],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-96.0],
        [self.emptyLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.emptyLabel.centerYAnchor constraintEqualToAnchor:self.collectionView.centerYAnchor],
        [self.emptyLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40.0],
        [self.emptyLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40.0]
    ]];
    [self updateFilterButtons];
}

- (void)reloadAssets {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if ([self isPhotoStatusAuthorized:status]) {
        [self fetchAssets];
        return;
    }
    if (status == PHAuthorizationStatusNotDetermined) {
        __weak typeof(self) weakSelf = self;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus newStatus) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf isPhotoStatusAuthorized:newStatus]) {
                    [weakSelf fetchAssets];
                } else {
                    [weakSelf showMessage:@"需要相册权限"];
                }
            });
        }];
        return;
    }
    [self showMessage:@"需要相册权限"];
}

- (BOOL)isPhotoStatusAuthorized:(PHAuthorizationStatus)status {
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    if (@available(iOS 14.0, *)) {
        return status == PHAuthorizationStatusLimited;
    }
    return NO;
}

- (void)fetchAssets {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithOptions:options];
    NSMutableArray *assets = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaType == PHAssetMediaTypeImage) {
            [assets addObject:asset];
        }
    }];
    self.allAssets = assets;
    [self applyFilter];
}

- (void)filterTapped:(UIButton *)button {
    self.selectedFilter = button.tag;
    [self updateFilterButtons];
    [self applyFilter];
}

- (void)updateFilterButtons {
    for (UIButton *button in self.filterButtons) {
        BOOL selected = button.tag == self.selectedFilter;
        [button setTitleColor:selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0.48 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)applyFilter {
    NSPredicate *predicate = nil;
    if (self.selectedFilter == BLAlbumFilterVideo) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(PHAsset *asset, NSDictionary *bindings) {
            return asset.mediaType == PHAssetMediaTypeVideo;
        }];
    } else if (self.selectedFilter == BLAlbumFilterPhoto) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(PHAsset *asset, NSDictionary *bindings) {
            return asset.mediaType == PHAssetMediaTypeImage;
        }];
    }
    self.filteredAssets = predicate ? [self.allAssets filteredArrayUsingPredicate:predicate] : self.allAssets;
    self.emptyLabel.hidden = self.filteredAssets.count > 0;
    self.emptyLabel.text = self.filteredAssets.count > 0 ? @"" : @"暂无可选项目";
    [self.collectionView reloadData];
}

- (void)showMessage:(NSString *)message {
    self.filteredAssets = @[];
    self.emptyLabel.text = message;
    self.emptyLabel.hidden = NO;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredAssets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLAlbumAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLAlbumAssetCell" forIndexPath:indexPath];
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat side = floor((CGRectGetWidth(collectionView.bounds) - 2.0) / 2.0);
    [cell configureWithAsset:self.filteredAssets[indexPath.item] imageManager:self.imageManager targetSize:CGSizeMake(side * scale, side * scale)];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat side = floor((CGRectGetWidth(collectionView.bounds) - 2.0) / 2.0);
    return CGSizeMake(side, side);
}

@end

