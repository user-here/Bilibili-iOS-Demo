#import "BLMockDataSource.h"

@implementation BLMockDataSource

+ (instancetype)shared {
    static BLMockDataSource *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BLMockDataSource alloc] init];
    });
    return instance;
}

- (NSArray<BLVideoItem *> *)recommendFeedItems {
    UIColor *blue   = [UIColor colorWithRed:0.11 green:0.28 blue:0.78 alpha:1.0];
    UIColor *cyan   = [UIColor colorWithRed:0.18 green:0.76 blue:0.95 alpha:1.0];
    UIColor *rose   = [UIColor colorWithRed:0.96 green:0.45 blue:0.64 alpha:1.0];
    UIColor *purple = [UIColor colorWithRed:0.46 green:0.34 blue:0.86 alpha:1.0];
    UIColor *green  = [UIColor colorWithRed:0.18 green:0.64 blue:0.46 alpha:1.0];
    UIColor *gold   = [UIColor colorWithRed:0.98 green:0.73 blue:0.24 alpha:1.0];
    UIColor *ink    = [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1.0];
    return @[
        [BLVideoItem itemWithTitle:@"\u5982\u679c\u7eef\u96ea\u5728\u8336\u91cc\u6dfb\u52a0\u70ed\u6eb6\u7cd6\u679c\uff0c\u7136\u540e\u518d\u62ff\u53bb\u7ed9\u6d1b\u745f\u62c9\u559d\uff0c\u90a3\u4e48\u4e00\u5207\u53c8\u4f1a\u600e\u6837\u53d1\u5c55..." author:@"B\u7ad9\u52a8\u753b\u653e\u6620\u5ba4" views:@"81.5\u4e07" danmaku:@"2083" duration:@"4:18" badge:@"\u52a8\u753b\u6df7\u526a" colors:@[rose, purple]],
        [BLVideoItem itemWithTitle:@"3\u5206\u949dcodex\u684c\u9762\u7248\u63a5\u5165DeepSeek\uff0c\u65e0\u9700\u8d26\u53f7\u914d\u7f6e" author:@"\u5510\u5e08\u5144Terence" views:@"1479" danmaku:@"-" duration:@"2:36" badge:@"DeepSeek" colors:@[blue, cyan]],
        [BLVideoItem itemWithTitle:@"\u7231\u5f25\u65af\uff1a\u300c\u6765\u4eb2\u4eb2\u6211\uff0c\u4eb2\u4e00\u53e3\u5b66\u4e60\u4e00\u4e2a\u5c0f\u65f6\uff01\u300d" author:@"\u5bbf\u4e91\u738b\u5927\u53ef" views:@"4.3\u4e07" danmaku:@"119" duration:@"1:09" badge:@"\u65b0\u756a" colors:@[ink, rose]],
        [BLVideoItem itemWithTitle:@"\u8fd9\u6bb5\u52a8\u4f5c\u6234\u7684\u955c\u5934\u8c03\u5ea6\u592a\u723d\u4e86\uff0c\u53cd\u590d\u770b\u4e09\u9047" author:@"\u756a\u5267\u526a\u8f91\u793e" views:@"12.7\u4e07" danmaku:@"402" duration:@"3:44" badge:@"\u9ad8\u71c3" colors:@[ink, green]],
        [BLVideoItem itemWithTitle:@"\u4eca\u5929\u7684\u86cb\u7cd5\u88ab\u8c01\u5077\u5403\u4e86\uff1f\u73b0\u573a\u53ea\u7559\u4e0b\u4e00\u4e2a\u8868\u60c5\u5305" author:@"\u6e38\u620f\u89c2\u5bdf\u5458" views:@"26.8\u4e07" danmaku:@"285" duration:@"1:29" badge:@"\u65e5\u5e38" colors:@[gold, rose]],
        [BLVideoItem itemWithTitle:@"\u6bd5\u4e1a\u6b4c\u4f1a\u73b0\u573a\u56de\u987e\uff1a\u90a3\u4e9b\u719f\u6089\u65cb\u5f8b\u518d\u6b21\u54cd\u8d77" author:@"\u97f3\u4e50\u73b0\u573a" views:@"58.1\u4e07" danmaku:@"912" duration:@"5:20" badge:@"\u6bd5\u4e1a\u6b4c\u4f1a" colors:@[cyan, purple]]
    ];
}

- (NSArray<BLHotVideoItem *> *)hotVideoItems {
    UIColor *pink   = [UIColor colorWithRed:0.92 green:0.35 blue:0.58 alpha:1.0];
    UIColor *gold   = [UIColor colorWithRed:0.96 green:0.70 blue:0.18 alpha:1.0];
    UIColor *ink    = [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1.0];
    UIColor *cyan   = [UIColor colorWithRed:0.18 green:0.76 blue:0.90 alpha:1.0];
    UIColor *violet = [UIColor colorWithRed:0.46 green:0.26 blue:0.82 alpha:1.0];
    UIColor *blue   = [UIColor colorWithRed:0.14 green:0.36 blue:0.78 alpha:1.0];
    UIColor *orange = [UIColor colorWithRed:0.96 green:0.55 blue:0.18 alpha:1.0];
    UIColor *brown  = [UIColor colorWithRed:0.56 green:0.42 blue:0.28 alpha:1.0];
    return @[
        [BLHotVideoItem itemWithTitle:@"\u4fe1\u4e0d\u4fe1\uff0c\u4f60\u7092\u4e0d\u8fc7\u6211" author:@"\u8c46\u6cb9\u9171 \u7b49\u8054\u5408\u521b\u4f5c" views:@"25.7\u4e07" timeText:@"23\u5c0f\u65f6\u524d" duration:@"5:10" tag:@"" colors:@[pink, gold]],
        [BLHotVideoItem itemWithTitle:@"\u300a\u9e23\u6f6e\u300b2026\u590f\u65e5\u6e38\u620f\u8282\u5ba3\u4f20\u89c6\u9891" author:@"\u9e23\u6f6e" views:@"27.7\u4e07" timeText:@"3\u5c0f\u65f6\u524d" duration:@"4:18" tag:@"\u4eba\u6c14\u98d9\u5347" colors:@[ink, cyan]],
        [BLHotVideoItem itemWithTitle:@"\u300a\u9732\u897f\u4e9a\u00b7\u9006\u5195\u300b\u6df1\u6e0a\uff0c\u4e3a\u6211\u4fe6\u9996\uff01\uff01\uff01" author:@"\u65cb\u98ce\u535a\u6587" views:@"16.6\u4e07" timeText:@"15\u5c0f\u65f6\u524d" duration:@"0:41" tag:@"" colors:@[violet, ink]],
        [BLHotVideoItem itemWithTitle:@"\u5c06\u591c\uff1a\u7b2c8\u8bdd \u957f\u591c\u5c06\u81f3" author:@"\u54d4\u54e9\u54d4\u54e9\u56fd\u521b" views:@"76.2\u4e07" timeText:@"\u6628\u5929 12:00" duration:@"22:33" tag:@"" colors:@[ink, blue]],
        [BLHotVideoItem itemWithTitle:@"\u300a\u786c\u6838\u5b9e\u6d4b\u300b\u628a\u590f\u51c9\u88ab\u53eb\u300c\u96ea\u7cd5\u88ab\u300d\uff0c\u6c34\u661f\u5bb6\u7eb3..." author:@"\u82b1\u706b\u5b9e\u9a8c\u5ba4" views:@"31.4\u4e07" timeText:@"\u6628\u5929" duration:@"8:06" tag:@"\u82b1\u706b\u7cbe\u9009" colors:@[orange, brown]]
    ];
}

- (BLFeedItem *)bl_feedItemWithAvatar:(NSString *)avatar author:(NSString *)author time:(NSString *)time action:(NSString *)action source:(NSString *)source title:(NSString *)title views:(NSString *)views duration:(NSString *)duration comments:(NSString *)comments likes:(NSString *)likes startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    BLFeedItem *item = [[BLFeedItem alloc] init];
    item.avatarText = avatar;
    item.author = author;
    item.time = time;
    item.action = action;
    item.source = source;
    item.title = title;
    item.views = views;
    item.duration = duration;
    item.comments = comments;
    item.likes = likes;
    item.startColor = startColor;
    item.endColor = endColor;
    return item;
}

- (NSArray<BLFeedItem *> *)followingAllItems {
    return @[
        [self bl_feedItemWithAvatar:@"\u592e" author:@"\u592e\u89c6\u65b0\u95fb" time:@"7\u5206\u949d\u524d" action:@"\u6295\u7a3f\u4e86\u89c6\u9891" source:@"\u592e\u89c6\u65b0\u95fb" title:@"\u300a\u4e16\u754c\u676f\u300b\u8d85\u7ea7\u300c\u5398\u5c14\u5c3c\u8bfa\u300d\u8981\u6765\u4e86\uff1f" views:@"7186\u64ad\u653e" duration:@"17:10" comments:@"33" likes:@"659" startColor:[UIColor colorWithRed:0.18 green:0.48 blue:0.34 alpha:1.0] endColor:[UIColor colorWithRed:0.46 green:0.66 blue:0.48 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"\u592e" author:@"\u592e\u89c6\u65b0\u95fb" time:@"19\u5206\u949d\u524d" action:@"\u4e0e\u4ed6\u4eba\u8054\u5408\u521b\u4f5c" source:@"\u6218\u706b\u91cd\u71c3" title:@"\u300a\u4e16\u754c\u676f\u300b\u9ece\u4ee5\u6218\u706b\u91cd\u71c3" views:@"6321\u64ad\u653e" duration:@"24:49" comments:@"68" likes:@"1651" startColor:[UIColor colorWithRed:0.16 green:0.16 blue:0.20 alpha:1.0] endColor:[UIColor colorWithRed:0.82 green:0.18 blue:0.18 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"TED" author:@"TED\u82f1\u8bed\u5b98\u65b9" time:@"1\u5c0f\u65f6\u524d" action:@"\u5206\u4eab\u52a8\u6001" source:@"\u8d44\u672c\u4e3b\u4e49\u80fd\u62ef\u6551\u6c14\u5019\u5417\uff1f" title:@"\u300aTED\u6f14\u8bb2\u300b\u8d44\u672c\u4e3b\u4e49\u7834\u574f\u4e86\u6c14\u5019\uff0c\u5982\u4eca\u5b83\u4e5f\u80fd\u4fee\u590d\u5417\uff1f" views:@"1085\u64ad\u653e" duration:@"41:48" comments:@"\u8bc4\u8bba" likes:@"2" startColor:[UIColor colorWithWhite:0.68 alpha:1.0] endColor:[UIColor colorWithWhite:0.86 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"\u8001" author:@"\u8001\u90ed\u7f8e\u98df" time:@"\u6295\u7a3f\u4e86\u89c6\u9891" action:@"\u63a2\u79d8\u6a31\u6843\u79cd\u690d\u4e4b\u5904" source:@"\u5927\u8fde\u6a31\u6843" title:@"\u63a2\u79d8\u6a31\u6843\u79cd\u690d\u4e4b\u5904\uff0c\u8bc4\u6d4b\u9274\u522b\u4f18\u8d28\u7684\u5927\u8fde\u6a31\u6843" views:@"247\u64ad\u653e" duration:@"05:42" comments:@"618" likes:@"6072" startColor:[UIColor colorWithRed:0.92 green:0.86 blue:0.78 alpha:1.0] endColor:[UIColor colorWithRed:0.86 green:0.22 blue:0.28 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"TED" author:@"TED\u82f1\u8bed\u5b98\u65b9" time:@"1\u5c0f\u65f6\u524d" action:@"\u5206\u4eab\u52a8\u6001" source:@"\u592a\u9633\u80fd \u5982\u4f55\u6539\u53d8\u5370\u5ea6" title:@"\u300aTED\u6f14\u8bb2\u300b\u8d44\u672c\u4e3b\u4e49\u7834\u574f\u4e86\u6c14\u5019\uff0c\u5982\u4eca\u5b83\u4e5f\u80fd\u4fee\u590d\u5417\uff1f" views:@"219\u64ad\u653e" duration:@"41:48" comments:@"\u8bc4\u8bba" likes:@"1" startColor:[UIColor colorWithRed:0.86 green:0.84 blue:0.72 alpha:1.0] endColor:[UIColor colorWithRed:0.95 green:0.72 blue:0.16 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"TED" author:@"TED\u82f1\u8bed\u5b98\u65b9" time:@"1\u5c0f\u65f6\u524d" action:@"\u5206\u4eab\u52a8\u6001" source:@"\u51b0\u6de1\u6de1\u5546 \u4e3a\u4f55\u6015\u70ed\u6d6a\uff1f" title:@"\u300aTED\u6f14\u8bb2\u300b\u51b0\u6de1\u6de1\u5546\u4e1a\u5982\u4f55\u5e94\u5bf9\u70ed\u6d6a\u548c\u6c14\u5019\u53d8\u5316" views:@"209\u64ad\u653e" duration:@"41:48" comments:@"\u8bc4\u8bba" likes:@"2" startColor:[UIColor colorWithWhite:0.70 alpha:1.0] endColor:[UIColor colorWithRed:0.86 green:0.22 blue:0.18 alpha:1.0]]
    ];
}

- (NSArray<BLFeedItem *> *)followingVideoItems {
    return @[
        [self bl_feedItemWithAvatar:@"You" author:@"YouTube\u7cbe\u5f69\u89c6\u9891" time:@"18\u5206\u949d\u524d" action:@"\u6295\u7a3f\u4e86\u89c6\u9891" source:@"Claude Code\u521b\u59cb\u4eba\uff1a\u6559\u4f60\u6b63\u786e\u7f16\u5199AI\u63d0\u793a\u8bcd" title:@"Claude Code\u521b\u59cb\u4eba:\u6559\u4f60\u6b63\u786e\u5199\u51faAI\u63d0\u793a\u8bcd\uff0c\u8fd8..." views:@"1662\u64ad\u653e" duration:@"27:27" comments:@"2" likes:@"106" startColor:[UIColor colorWithRed:0.72 green:0.58 blue:0.38 alpha:1.0] endColor:[UIColor colorWithRed:0.34 green:0.30 blue:0.24 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"\u592e" author:@"\u592e\u89c6\u65b0\u95fb" time:@"30\u5206\u949d\u524d" action:@"\u6295\u7a3f\u4e86\u89c6\u9891" source:@"\u5316\u5de5\u5e9f\u6876 \u5e9f\u5f03\u53e3\u7f69 \u62d6\u978b\u8fb9\u89d2\u6599\u2026\u2026" title:@"\u300a\u8d22\u7ecf\u8c03\u67e5\u300b\u592e\u89c6\u66b4\u5149\u52a3\u8d28\u56de\u6536\u6599\u7259\u5237" views:@"1.9\u4e07\u64ad\u653e" duration:@"09:38" comments:@"153" likes:@"1694" startColor:[UIColor colorWithRed:0.72 green:0.76 blue:0.72 alpha:1.0] endColor:[UIColor colorWithRed:0.86 green:0.78 blue:0.34 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"\u6c34" author:@"\u6c34\u8bba\u6587\u7684\u7a0b\u5e8f\u733f-\u6c34\u5bfc" time:@"2\u5c0f\u65f6\u524d" action:@"\u6295\u7a3f\u4e86\u89c6\u9891" source:@"10\u540d\u989d9244\u62a5\u540d \u53ef\u4ee5\u5b66\u672f\u6253\u5047 \u4f46\u4e0d\u80fd\u8131\u79bb\u7fa4\u4f17" title:@"\u7855\u58eb\u6269\u62db\u7684\u82e6\u679c\u5df2\u7ecf\u663e\u73b0\uff0c\u8fd8\u8bfb\u535a\u58eb\uff1f\u4e00\u6b21\u4e0d\u591f\u6765\u7b2c\u4e8c\u6b21\uff1f" views:@"1.2\u4e07\u64ad\u653e" duration:@"14:13" comments:@"87" likes:@"546" startColor:[UIColor colorWithRed:0.90 green:0.92 blue:0.84 alpha:1.0] endColor:[UIColor colorWithRed:0.90 green:0.18 blue:0.18 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"You" author:@"YouTube\u7cbe\u5f69\u89c6\u9891" time:@"2\u5c0f\u65f6\u524d" action:@"\u6295\u7a3f\u4e86\u89c6\u9891" source:@"\u9ec4\u4ec1\u52cb: AI\u65f6\u4ee3\uff0c\u4eba\u6700\u7a00\u7f3a\u7684\u80fd\u529b" title:@"\u82f1\u4f1f\u8fbe\u9ec4\u4ec1\u52cb\uff1aAI\u65f6\u4ee3\uff0c\u4eba\u6700\u7a00\u7f3a\u7684\u80fd\u529b\u5230\u5e95\u662f..." views:@"3840\u64ad\u653e" duration:@"18:22" comments:@"10" likes:@"266" startColor:[UIColor colorWithRed:0.52 green:0.62 blue:0.52 alpha:1.0] endColor:[UIColor colorWithRed:0.24 green:0.24 blue:0.20 alpha:1.0]],
        [self bl_feedItemWithAvatar:@"\u7070" author:@"\u7070\u7075\u72d0\u5b66\u82f1\u8bed" time:@"3\u5c0f\u65f6\u524d" action:@"\u6295\u7a3f\u4e86\u89c6\u9891" source:@"\u82f1\u8bed\u5b66\u4e60 \u6bcf\u65e5\u542c\u529b\u8bad\u7ec3" title:@"\u7528\u771f\u5b9e\u6f14\u8bb2\u7ec3\u4e60\u542c\u529b\uff0c\u4eca\u5929\u8fd9\u6bb5\u5f88\u9002\u5408\u8ddf\u8bfb" views:@"3104\u64ad\u653e" duration:@"08:12" comments:@"21" likes:@"188" startColor:[UIColor colorWithRed:0.60 green:0.70 blue:0.84 alpha:1.0] endColor:[UIColor colorWithRed:0.24 green:0.36 blue:0.58 alpha:1.0]]
    ];
}

- (NSDictionary<NSString *, NSArray<BLHistoryItem *> *> *)historyItemGroups {
    NSArray<BLHistoryItem *> *today = @[
        [BLHistoryItem itemWithTitle:@"\u58f0\u4e50\u8001\u5e08\u9510\u8bc4\u6797\u4fca\u6770\u795e\u7ea7Live\u300a\u8d77\u98ce\u4e86\u300b\uff01\u6700\u96be\u5531..." author:@"Jason-\u8001\u6e7f" date:@"2026\u5e746\u670811\u65e5 00:12" time:@"13:54 / 14:07" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u7237\u7237\u7684\u70c2\u83dc\u677f #\u67d3\u5b50 #\u8bb0\u5f55\u8001\u4eba #\u83dc\u677f #\u5236\u4f5c\u8fc7\u7a0b" author:@"\u5c0f\u4e8c\u54e5\u5f53\u5bb6" date:@"2026\u5e746\u670811\u65e5 00:09" time:@"02:36 / 02:45" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u3010\u4e2d\u5b57\u3011\u6d77\u5916\u535a\u4e3b\u7206\uff1aAnt\u4e09\u8fdb\u3001GPT5.6\u5c06\u81f3" author:@"\u67ab\u53f6\u8fb9\u57ce" date:@"2026\u5e746\u670811\u65e5 00:06" time:@"00:17 / 08:31" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"Codex \u6700\u72e0\u5347\u7ea7" author:@"\u65b0\u667a\u5143AIera" date:@"2026\u5e746\u670811\u65e5 00:06" time:@"00:20 / 01:12" videoURLString:@""]
    ];
    NSArray<BLHistoryItem *> *yesterday = @[
        [BLHistoryItem itemWithTitle:@"\u7ef4\u96eaCV\u674e\u5355\u5982\u76f4\u64ad\u300c\u5077\u5403\u300d\u98df\u7269\uff0c\u6211\u624d\u6ca1\u6709\u5427\u54ea\u54ea..." author:@"\u7ef4\u91cc\u5948\u9ebb\u9ebb" date:@"2026\u5e746\u670810\u65e5 23:58" time:@"00:55 / 03:28" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u53d8\u6001\uff01\u592a\u53ef\u6076\u4e86\uff01\u574e\u7279\u83b1\u62c9CV\u88ab\u6f6e\u53cb\u6b3a\u9a97\uff0c\u53d1\u51fa\u8d85..." author:@"\u7ef4\u91cc\u5948\u9ebb\u9ebb" date:@"2026\u5e746\u670810\u65e5 23:57" time:@"00:59 / 03:58" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u7b11\u4e0d\u6d3b\u4e86\uff01\u9e23\u6f6e\u4e8c\u521b\u4e00\u59d0\u300c\u6c89\u7761\u8857\u300d\u7528\u4e1c\u6728\u53e3\u97f3\u5531\u54c8\u57fa..." author:@"\u7ef4\u91cc\u5948\u9ebb\u9ebb" date:@"2026\u5e746\u670810\u65e5 23:56" time:@"00:01 / 02:19" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"AI\u5708\u6cb8\u817e\uff01\u72d9\u51fbMythos\uff0c\u667a\u8c31 GLM-5.2 \u6216\u5c06\u53d1\u5e03\u5f15..." author:@"\u9ed1\u9e2dHeya" date:@"2026\u5e746\u670810\u65e5 23:55" time:@"00:09 / 01:42" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u5730\u72f1\u9ed1\u6770\u514b\uff08PC+\u5b89\u5353+\u6574\u5408\u5305\uff09\u8d85\u597d\u73a9\u768421\u70b9\u8089\u9e3d\u5427..." author:@"\u714c\u7130\u706b\u5c71" date:@"2026\u5e746\u670810\u65e5 23:54" time:@"00:08 / 01:03" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u8d85\u4e0a\u5934\u7684\u8089\u9e3d\u5361\u724c\u3010\u5730\u72f1\u9ed1\u6770\u514b\u3011\uff08\u9644\u5730\u5740\uff09PC+\u5b89\u5353..." author:@"\u7231\u6e38\u732b\u624bAiu" date:@"2026\u5e746\u670810\u65e5 23:53" time:@"\u5df2\u770b\u5b8c" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u5168\u7f51\u9996\u53d1\uff013\u4eba\u56e2\u961f\u663c\u591c\u4e0d\u505c\u6210\u529f\u79fb\u690d\u51fa\u300a\u5730\u72f1\u9ed1\u6770\u514b\u300b..." author:@"\u5e73\u5e73\u65e0\u5947\u7684\u8def\u4eba\u82af" date:@"2026\u5e746\u670810\u65e5 23:52" time:@"\u5df2\u770b\u5b8c" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u8fd9\u662f\u4e00\u6b3e\u53ef\u4ee5\u8d4c\u4e0a\u7075\u9b42\u7684\u6e38\u620f\u2026\u2026\u3010\u5730\u72f1\u9ed1\u6770\u514b\u3011" author:@"\u72ec\u7acb\u6e38\u620f\u7f16\u8f91\u8005" date:@"2026\u5e746\u670810\u65e5 23:49" time:@"\u5df2\u770b\u5b8c" videoURLString:@""],
        [BLHistoryItem itemWithTitle:@"\u54c6\u5566A\u68a6\uff1a\u4f34\u6211\u540c\u884c" author:@"" date:@"2026\u5e746\u670810\u65e5 23:14" time:@"07:09 / 01:34:24" videoURLString:@""]
    ];
    return @{@"\u4eca\u5929": today, @"\u6628\u5929": yesterday};
}

- (NSArray<NSDictionary *> *)favoriteFolders {
    return @[
        @{@"title": @"\u9ed8\u8ba4\u6536\u85cf\u5939", @"count": @"47", @"public": @YES},
        @{@"title": @"AI\u5de5\u5177\u5408\u96c6", @"count": @"23", @"public": @NO},
        @{@"title": @"\u9e23\u6f6e\u76f8\u5173", @"count": @"18", @"public": @YES},
        @{@"title": @"\u5b66\u4e60\u8d44\u6599", @"count": @"35", @"public": @NO},
        @{@"title": @"\u97f3\u4e50\u6536\u85cf", @"count": @"12", @"public": @YES},
        @{@"title": @"\u641e\u7b11\u5408\u8f91", @"count": @"8", @"public": @YES},
        @{@"title": @"\u5f85\u770b\u6e05\u5355", @"count": @"29", @"public": @NO}
    ];
}

- (NSArray<BLVideoItem *> *)favoriteVideos {
    UIColor *blue   = [UIColor colorWithRed:0.11 green:0.28 blue:0.78 alpha:1.0];
    UIColor *cyan   = [UIColor colorWithRed:0.18 green:0.76 blue:0.95 alpha:1.0];
    UIColor *rose   = [UIColor colorWithRed:0.96 green:0.45 blue:0.64 alpha:1.0];
    UIColor *purple = [UIColor colorWithRed:0.46 green:0.34 blue:0.86 alpha:1.0];
    UIColor *green  = [UIColor colorWithRed:0.18 green:0.64 blue:0.46 alpha:1.0];
    UIColor *gold   = [UIColor colorWithRed:0.98 green:0.73 blue:0.24 alpha:1.0];
    UIColor *ink    = [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1.0];
    return @[
        [BLVideoItem itemWithTitle:@"\u5982\u679c\u7eef\u96ea\u5728\u8336\u91cc\u6dfb\u52a0\u70ed\u6eb6\u7cd5\u679c..." author:@"B\u7ad9\u52a8\u753b\u653e\u6620\u5ba4" views:@"81.5\u4e07" danmaku:@"2083" duration:@"4:18" badge:@"\u52a8\u753b\u6df7\u526a" colors:@[rose, purple]],
        [BLVideoItem itemWithTitle:@"3\u5206\u949dcodex\u684c\u9762\u7248\u63a5\u5165DeepSeek" author:@"\u5510\u5e08\u5144Terence" views:@"1479" danmaku:@"-" duration:@"2:36" badge:@"DeepSeek" colors:@[blue, cyan]],
        [BLVideoItem itemWithTitle:@"\u7231\u5f25\u65af\uff1a\u300c\u6765\u4eb2\u4eb2\u6211\uff0c\u4eb2\u4e00\u53e3\u5b66\u4e60\u4e00\u4e2a\u5c0f\u65f6\uff01\u300d" author:@"\u5bbf\u4e91\u738b\u5927\u53ef" views:@"4.3\u4e07" danmaku:@"119" duration:@"1:09" badge:@"\u65b0\u756a" colors:@[ink, rose]],
        [BLVideoItem itemWithTitle:@"\u8fd9\u6bb5\u52a8\u4f5c\u6234\u7684\u955c\u5934\u8c03\u5ea6\u592a\u723d\u4e86" author:@"\u756a\u5267\u526a\u8f91\u793e" views:@"12.7\u4e07" danmaku:@"402" duration:@"3:44" badge:@"\u9ad8\u71c3" colors:@[ink, green]],
        [BLVideoItem itemWithTitle:@"\u4eca\u5929\u7684\u86cb\u7cd5\u88ab\u8c01\u5077\u5403\u4e86\uff1f" author:@"\u6e38\u620f\u89c2\u5bdf\u5458" views:@"26.8\u4e07" danmaku:@"285" duration:@"1:29" badge:@"\u65e5\u5e38" colors:@[gold, rose]],
        [BLVideoItem itemWithTitle:@"\u6bd5\u4e1a\u6b4c\u4f1a\u73b0\u573a\u56de\u987e" author:@"\u97f3\u4e50\u73b0\u573a" views:@"58.1\u4e07" danmaku:@"912" duration:@"5:20" badge:@"\u6bd5\u4e1a\u6b4c\u4f1a" colors:@[cyan, purple]]
    ];
}

- (NSArray<BLMallProduct *> *)mallProducts {
    return @[
        [BLMallProduct productWithTitle:@"SONGX \u51e1\u4eba\u89e6\u5c4f\u964d\u566a\u8033\u673a" price:@"\u5b9a\u91d1\u00a559.85" tag:@"618\u81ea\u8425" cardHeight:174.0],
        [BLMallProduct productWithTitle:@"\u9884\u552e\u00b7ADK Emoti \u9650\u91cf\u7248\u624b\u529e" price:@"\u5b9a\u91d1\u00a5222" tag:@"\u81ea\u8425" cardHeight:218.0],
        [BLMallProduct productWithTitle:@"10\u5143\u62bdswitch2\u5468\u8fb9" price:@"\u00a510/\u6296" tag:@"\u60ca\u559c\u8d4f" cardHeight:174.0],
        [BLMallProduct productWithTitle:@"Hobby Rangers \u9e23\u6f6e\u8054\u540d" price:@"\u5b9a\u91d1\u00a535.85" tag:@"618\u81ea\u8425" cardHeight:174.0],
        [BLMallProduct productWithTitle:@"10\u5143\u6b27\uff01\u6d1b\u514b\u738b\u56fd\u6bdb\u7ed2\u6302\u4ef6" price:@"\u00a510" tag:@"\u6bdb\u7ed2\u6302\u4ef6" cardHeight:218.0]
    ];
}

@end
