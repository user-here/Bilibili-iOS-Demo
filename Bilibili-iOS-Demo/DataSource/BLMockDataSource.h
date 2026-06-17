#import <Foundation/Foundation.h>
#import "../Models/BLVideoItem.h"
#import "../Models/BLFeedItem.h"
#import "../Models/BLHistoryItem.h"
#import "../Models/BLHotVideoItem.h"
#import "../Models/BLMallProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLMockDataSource : NSObject

+ (instancetype)shared;

- (NSArray<BLVideoItem *> *)recommendFeedItems;

- (NSArray<BLHotVideoItem *> *)hotVideoItems;

- (NSArray<BLFeedItem *> *)followingAllItems;
- (NSArray<BLFeedItem *> *)followingVideoItems;

- (NSDictionary<NSString *, NSArray<BLHistoryItem *> *> *)historyItemGroups;

- (NSArray<NSDictionary *> *)favoriteFolders;
- (NSArray<BLVideoItem *> *)favoriteVideos;

- (NSArray<BLMallProduct *> *)mallProducts;

@end

NS_ASSUME_NONNULL_END
