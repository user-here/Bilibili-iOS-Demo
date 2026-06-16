# Bilibili-iOS-Demo

## 当前开发进度快照（2026-06-16）

本节用于跨对话快速恢复项目上下文。当前项目是 Objective-C + UIKit 的 Bilibili iOS Demo，页面主要以纯代码实现，入口集中在 `Bilibili-iOS-Demo/HomeViewController.m`，自定义页面和组件集中在 `Bilibili-iOS-Demo/Views/`。

### 通用架构

- 底部导航包含：首页、关注、发布加号、会员购、我的。
- `HomeViewController` 负责底部 tab 状态、页面切换、右进右出页面动画，以及播放器详情页跳转。
- 通用播放链路由 `BLPlayerCore`、`BLPlayerRenderView`、`BLVideoPlayerView`、`BLVideoDetailViewController` 组成。
- 当前测试视频 URL 写在页面 mock 数据中，但历史记录、收藏、关注等入口都通过 `videoSelected(URL, title, author)` 这类回调设计，后续可以直接替换为后端返回的视频地址。

### 关注页

- 主要文件：`BLFollowingPageView.h/.m`。
- 已实现“全部”和“视频”两个 tab。
- 进入关注页后，底部关注图标红点会清除。
- “关注”标题固定，“最近访问”随内容滚出屏幕。
- feed 中的视频 cell 是播放器 + 默认封面图，不是单纯图片。
- 当前屏幕内的视频自动播放，滑出屏幕后停止；用户不能暂停，只能切换静音；点击 cell 会进入视频播放详情页。
- 已修复：首个视频不播放、tab 切换后首个 cell 只显示第一帧、滑回顶部时两个播放器同时播放、自动播放触发延迟等问题。

### 追番追剧

- 主要文件：`BLBangumiCollectionPageView.h/.m`。
- 关注页“视频”tab 中已实现“我的追番·追剧”模块。
- 点击“全部”会从右侧推出“我的收藏”式双层多 tab 页面。
- 支持管理模式：cell 前出现多选框，可标记为“想看”或“看过”。

### 发布页

- 主要文件：`BLPublishPageView.h/.m`、`BLCapturePublishView.h/.m`、`BLAlbumUploadView.h/.m`。
- 点击底部加号后，从右侧推出发布页。
- 底部有四个 tab：拍摄、上传、开直播、发图文，默认进入“上传”。
- “拍摄”会调用摄像头，默认前置摄像头，使用自定义控制层。
- “上传”接入系统相册，包含“全部 / 视频 / 照片”三个分类。
- 已修复发布页返回按钮过大、“最近项目”与下箭头中轴线不对齐、相册页中文乱码导致编译错误等问题。

### 会员购首页

- 主要文件：`BLMallPageView.h/.m`。
- 已实现紫色固定搜索栏、618 头图、横向分类、商品瀑布流、新人券包、底部浮动新人券包。
- 搜索栏固定不随页面滑动，顶部状态栏背景与搜索区保持紫色。
- 分类行中“分类”cell 固定在右侧，其他分类可横向滑动。
- 新人券包倒计时可运行，结束后隐藏。
- 新人券包浮层在原始券包滚出屏幕后显示。
- 已修复：搜索栏尺寸、紫色背景断裂、618 与搜索栏距离、价格字体过大、券包遮挡倒计时、商品价格标签缺失时仍预留空位等问题。

### 会员购搜索

- 主要文件：`BLMallSearchPageView.h/.m`。
- 从会员购搜索栏右侧推出。
- 搜索框中的“魔力赏”是 placeholder，不是可删除的实际文本。
- 已实现搜索发现、热搜词，以及可横向滑动的卡片：热搜商品榜、为你推荐的 IP、为你推荐的角色。

### 新人券包页

- 主要文件：`BLMallCouponPageView.h/.m`。
- 点击新人券包“立即领取”后从右侧推出。
- 已实现四个 tab：入坑必逛、双倍补贴、热销盲盒、爆款单品。
- 顶部搜索栏固定，点击搜索按钮会进入已实现的会员购搜索页。
- 商品列表支持滚动；商品价格区会根据是否存在小标签自适应垂直布局。

### 我的页

- 主要文件：`BLMinePageView.h/.m`。
- 我的页和客服页使用的 SVG 图标已整理为 `Assets.xcassets` 中的 iOS asset catalog 可用资源。
- 我的页顶部个人信息、大会员中心卡片固定；从“大会员中心”下方开始的内容可以滚动。
- 已实现：顶部工具、头像昵称、年度大会员、B 币/硬币、动态/关注/粉丝、大会员中心、快捷服务、发布卡片、游戏中心、我的服务、更多服务。
- 已修复：大会员卡片被遮挡、部分文字过大导致布局不接近原版等问题。
- 当前“离线缓存”“历史记录”“我的收藏”“稍后再看”“联系客服”“大会员中心”等入口已经接入 `HomeViewController` 的右侧推出页面。

### 大会员中心

- 主要文件：`BLMemberCenterPageView.h/.m`、`BLMemberAutoCarouselView.h/.m`、`BLMemberPaymentBarView.h/.m`。
- 从“我的”页大会员中心卡片进入。
- 已实现顶部会员信息、自动滚动权益卡片、领经验、大福袋、我的权益、我的资产、会员购权益、线下点映会等模块。
- 已修复：自动滚动卡片内图标/文字/按钮重叠、火箭图标过大、线下点映会标签宽度不随文字自适应、大福袋按钮与文本重叠等布局问题。

### 离线缓存

- 主要文件：`BLOfflineCachePageView.h/.m`。
- 从“我的”页“离线缓存”入口右侧推出。
- 当前按截图实现空状态页面，包含固定标题栏、返回、搜索、设置按钮和空状态插画/文案。
- 已预留 `BLOfflineCacheItem` 模型、`setOfflineItems:` 插入接口和 `videoSelected(URL, title, author)` 回调；每条记录设计为和历史记录一致的 cell 结构，后续接入数据源后可以直接渲染列表。

### 历史记录

- 主要文件：`BLHistoryPageView.h/.m`。
- 从“我的”页历史记录入口右侧推出。
- 已实现固定标题栏、搜索/更多按钮、分类 tab，以及按“今天 / 昨天”分组的视频列表。
- 点击历史记录 item 会进入 `BLVideoDetailViewController` 播放页。
- 当前使用测试视频 URL，但 item 模型已经预留 `videoURL`，后续接后端时直接替换数据源即可。

### 我的收藏

- 主要文件：`BLFavoritePageView.h/.m`。
- 从“我的”页“我的收藏”入口右侧推出。
- 已实现顶部“收藏 / 追更”tab、二级分类“收藏夹 / 全部 / 视频 / 图文”、搜索、添加和布局按钮。
- “收藏夹”模式展示收藏夹卡片；收藏夹预览数量不足 3 个时会自动补空位，避免数组越界崩溃。
- “全部”模式展示视频列表，点击视频进入播放页。
- 每个收藏夹都可以展开，展开时页面从右向左推出收藏夹详情。
- 详情页左上角返回按钮用于退出收藏夹详情并回到收藏夹列表；列表页左上角返回按钮用于退出收藏页面。
- 详情页已改用提供的点赞前、收藏前图标资源，并调小图标避免与文字重叠。

### 稍后再看

- 主要文件：`BLWatchLaterPageView.h/.m`。
- 从“我的”页“稍后再看”入口右侧推出。
- 已实现顶部标题栏、“全部 / 未看完”tab、最近添加排序入口、播放全部入口、视频列表、播放进度条和右下角时长/进度标签。
- “未看完”tab 复用“全部”列表结构，只过滤未播放完毕的视频。
- 已实现管理弹窗：点击“管理”后显示半屏操作面板和黑色半透明蒙版。
- 已实现“一键清除已看完视频”“一键清除已失效视频”“批量管理”。
- 批量管理模式中支持圆形复选框、全选/取消全选、取消选择、删除；底部操作栏会根据选中数量切换可用状态并显示选中数量。
- `BLWatchLaterItem` 预留 `finished`、`invalid`、`progress`、`progressText`、`videoURLString` 等字段，方便后续接入真实稍后再看数据。

### 联系客服

- 主要文件：`BLContactServicePageView.h/.m`。
- 从“我的”页“联系客服”入口右侧推出。
- 已实现仿客服中心页面：顶部返回/关闭/更多按钮、自助服务宫格、猜你想问、联系客服分类列表和底部热线信息。
- 自助服务图标使用用户提供的 SVG，已转换为 Xcode asset catalog 可直接使用的矢量 imageset。
- 自助服务图标当前使用较小图标加浅色圆形背景，背景色会按图标主色生成浅色版本，文字保持可见。

### 常用文件定位

- 首页与全局导航：`Bilibili-iOS-Demo/HomeViewController.m`
- 播放器核心：`Bilibili-iOS-Demo/Views/BLPlayerCore.m`
- 播放器 UI：`Bilibili-iOS-Demo/Views/BLVideoPlayerView.m`
- 视频详情页：`Bilibili-iOS-Demo/Views/BLVideoDetailViewController.m`
- 关注页：`Bilibili-iOS-Demo/Views/BLFollowingPageView.m`
- 追番追剧收藏页：`Bilibili-iOS-Demo/Views/BLBangumiCollectionPageView.m`
- 发布页：`Bilibili-iOS-Demo/Views/BLPublishPageView.m`
- 会员购首页：`Bilibili-iOS-Demo/Views/BLMallPageView.m`
- 会员购搜索页：`Bilibili-iOS-Demo/Views/BLMallSearchPageView.m`
- 新人券包页：`Bilibili-iOS-Demo/Views/BLMallCouponPageView.m`
- 我的页：`Bilibili-iOS-Demo/Views/BLMinePageView.m`
- 历史记录页：`Bilibili-iOS-Demo/Views/BLHistoryPageView.m`
- 我的收藏页：`Bilibili-iOS-Demo/Views/BLFavoritePageView.m`
- 大会员中心页：`Bilibili-iOS-Demo/Views/BLMemberCenterPageView.m`
- 离线缓存页：`Bilibili-iOS-Demo/Views/BLOfflineCachePageView.m`
- 稍后再看页：`Bilibili-iOS-Demo/Views/BLWatchLaterPageView.m`
- 联系客服页：`Bilibili-iOS-Demo/Views/BLContactServicePageView.m`

### 后续接入建议

- 优先把首页、关注、历史记录、收藏夹的数据源抽象成 repository/service 层，当前 mock 数据可以作为 fallback。
- 视频播放入口保持 `URL + title + author` 的统一调用方式，避免每个页面直接依赖播放器实现；历史记录、收藏、离线缓存、稍后再看目前都按这个回调形态设计。
- 新增 `.m` 文件后需要确认已加入 `Bilibili-iOS-Demo.xcodeproj/project.pbxproj` 的 target sources。
- 当前机器存在两个 Xcode：`/Applications/Xcode.app` 和 `/Users/guozhengkun03/Downloads/Xcode.app`。当前 `xcode-select` 指向 `/Applications/Xcode.app/Contents/Developer`。
- 截至 2026-06-16，本机未找到 iOS 26.3 SDK/Simulator runtime；命令行构建会在 storyboard/assets 阶段因缺少可用 simulator runtime 报错。单个 `.m` 文件仍可通过 `xcodebuild ... | rg "文件名|error:"` 做编译级检查。

这是一个使用 Objective-C + UIKit 纯代码实现的仿 Bilibili iOS Demo。当前项目重点是复刻首页多 tab 内容、直播/热门/动画/影视页面，以及一个可复用的视频播放器内核和视频详情页。

项目入口是 `Bilibili-iOS-Demo/HomeViewController.m`，所有自定义页面和组件都放在 `Bilibili-iOS-Demo/Views/`。

## 当前能力

- 首页顶部搜索栏、频道 tab 和底部 tab。
- 推荐流视频卡片，支持点击进入视频详情页。
- 直播 tab 页面，包含直播分类、关注卡片、轮播、颜值页、英雄联盟页、人气榜。
- 热门 tab 页面，包含快捷入口、热门视频列表、右下角更多按钮弹出分享半屏面板。
- 动画 tab 页面，包含自动轮播、功能标签、热门排行榜、继续看和多个横向榜单区块。
- 影视 tab 页面，结构类似动画页，包含自动轮播、影视功能标签、正在追进度卡、正在热播、热门排行榜和推荐区块。
- 视频播放器详情页，顶部真实播放网络 mp4，下面是简介、作者、互动区和推荐列表。

## 首页结构

核心文件：

- `Bilibili-iOS-Demo/HomeViewController.m`
- `Bilibili-iOS-Demo/HomeViewController.h`

`HomeViewController` 负责：

- 构建顶部栏、频道 tab、推荐 feed、底部 tab。
- 管理当前选中的频道：`直播`、`推荐`、`热门`、`动画`、`影视`。
- 延迟创建对应页面：
  - `buildLivePageIfNeeded`
  - `buildHotPageIfNeeded`
  - `buildAnimePageIfNeeded`
  - `buildFilmPageIfNeeded`
- 通过 `showSelectedContent` 控制各页面显隐。
- 推荐页视频卡片点击后打开 `BLVideoDetailViewController`。

当前测试视频 URL 写在 `HomeViewController.m`：

```objc
static NSString * const BLDefaultVideoURLString = @"https://flyable-overlay-alone.ngrok-free.dev/files/08058f33c8ab0aa4b78ce19063e7510f.mp4";
```

如果后端地址变化，优先修改这里。

## 直播页

核心文件：

- `Views/BLLivePageView.h/.m`
- `Views/BLLiveCarouselView.h/.m`
- `Views/BLLivePopularityView.h/.m`
- `Views/BLLiveBeautyPageView.h/.m`
- `Views/BLLiveBeautyLiveCardView.h/.m`
- `Views/BLLiveLeaguePageView.h/.m`
- `Views/BLLiveLeagueLiveCardView.h/.m`

结构说明：

- `BLLivePageView` 是直播 tab 的总容器。
- 顶部包含直播分类横向 tab：推荐、人气、颜值、英雄联盟、虚拟主播等。
- 推荐区包含关注卡片、轮播和直播卡片。
- 颜值页使用 `BLLiveBeautyPageView`，内部有 `推荐 / 热门 / 最新` 三个子 tab。
- 英雄联盟页使用 `BLLiveLeaguePageView`，顶部有自动轮播卡片，下方有 `综合 / 云顶之弈 / 巅峰王者 / 颜值声优` 四个子 tab。
- 人气榜使用 `BLLivePopularityView`。

## 热门页

核心文件：

- `Views/BLHotPageView.h/.m`
- `Views/BLHotVideoCellView.h/.m`
- `Views/BLSharePanelView.h/.m`

结构说明：

- `BLHotPageView` 构建热门页整体内容。
- 顶部是快捷入口：排行榜、每周必看、入站必刷、UP动画等。
- 列表 cell 使用 `BLHotVideoCellView`。
- cell 右下角垂直省略号触发 `moreTapped` 回调。
- `BLHotPageView` 收到回调后展示 `BLSharePanelView`。
- `BLSharePanelView` 是半屏分享面板，带黑色半透明蒙版，支持点击蒙版或取消关闭。

## 动画页

核心文件：

- `Views/BLAnimePageView.h/.m`
- `Views/BLAnimeCarouselView.h/.m`
- `Views/BLAnimePosterCardView.h/.m`

结构说明：

- `BLAnimePageView` 是动画 tab 总容器，内部是纵向 `UIScrollView + UIStackView`。
- `contentStack.spacing = 0.0`，各 section 紧密衔接。
- 顶部使用 `BLAnimeCarouselView` 自动轮播，当前配置 10 张卡片。
- 轮播下方是功能标签，不是 tab：找番看、时间表、番剧、国创、UP动画、少儿、动画种草。
- 热门排行榜区域包含横向可滚动榜单 tab：番剧榜、国创榜、资讯榜、热搜榜、会员榜等。
- 后续区块使用 `BLAnimePosterCardView` 横向展示卡片，例如继续看、萌系榜、搞笑榜、期待榜、战斗榜。

可复用组件：

- `BLAnimeCarouselView`：自动轮播卡片，内部使用 `UIScrollView + UIPageControl + NSTimer`。
- `BLAnimePosterCardView`：海报卡片，支持默认尺寸，也支持自定义 `cardWidth` 和 `coverHeight`。

## 影视页

核心文件：

- `Views/BLFilmPageView.h/.m`
- `Views/BLFilmProgressCardView.h/.m`
- 复用 `BLAnimeCarouselView`
- 复用 `BLAnimePosterCardView`

结构说明：

- `BLFilmPageView` 是影视 tab 总容器，结构和动画页类似。
- `contentStack.spacing = 0.0`。
- 顶部是自动滚动大卡片。
- 功能标签包括：找片看、片单、电影、电视剧、纪录片、综艺、短剧、我的追剧。
- `正在追` 使用 `BLFilmProgressCardView`，卡片尺寸和排行榜卡片一致，封面底部有白色观看进度条。
- `正在热播` 使用更大的海报卡片，调用 `BLAnimePosterCardView` 的自定义尺寸初始化方法。
- 当前没有实现“大会员线下点映会”，因为缺少资源。

## 播放器架构

播放器相关文件：

- `Views/BLPlayerCore.h/.m`
- `Views/BLPlayerRenderView.h/.m`
- `Views/BLVideoPlayerView.h/.m`
- `Views/BLVideoDetailViewController.h/.m`

分层说明：

### BLPlayerCore

`BLPlayerCore` 是播放器内核，封装 `AVPlayer`。

当前能力：

- 加载网络 URL。
- 播放 / 暂停。
- seek。
- 倍速。
- 静音。
- 当前时间、总时长、缓冲进度监听。
- 播放状态回调。
- 错误回调。

状态枚举：

```objc
typedef NS_ENUM(NSInteger, BLPlayerPlaybackState) {
    BLPlayerPlaybackStateIdle,
    BLPlayerPlaybackStateLoading,
    BLPlayerPlaybackStateReady,
    BLPlayerPlaybackStatePlaying,
    BLPlayerPlaybackStatePaused,
    BLPlayerPlaybackStateBuffering,
    BLPlayerPlaybackStateEnded,
    BLPlayerPlaybackStateFailed
};
```

注意：当前测试 URL 是 ngrok 地址，所以 `BLPlayerCore` 创建 `AVURLAsset` 时带了请求头：

```objc
@"ngrok-skip-browser-warning": @"1"
@"User-Agent": @"Mozilla/5.0"
```

这是为了避免 ngrok 返回浏览器提示页导致 `AVPlayer` 播放失败。

### BLPlayerRenderView

`BLPlayerRenderView` 只负责显示视频画面。

- 内部 layer 是 `AVPlayerLayer`。
- 暴露 `player`。
- 暴露 `videoGravity`，可以控制等比显示、填充裁剪等。

### BLVideoPlayerView

`BLVideoPlayerView` 是播放器组合 UI。

包含：

- `BLPlayerRenderView` 视频画面。
- `danmakuContainerView` 弹幕预留层，目前没有弹幕数据。
- 顶部透明控制层：返回按钮、观看人数。
- 底部半透明控制层：播放/暂停、进度条、缓冲条、时间、倍速、静音、弹幕按钮。
- 点击视频区域可以显示/隐藏顶部和底部控制层。

已处理的安全区逻辑：

- 顶部返回栏没有半透明背景，只保留按钮和文字。
- 播放器详情页根视图背景是黑色，顶部 safe area 区域不会出现白色留白。
- 视频播放器放在 `safeAreaLayoutGuide.topAnchor` 下方，避免被 iPhone 摄像头开孔遮挡。

### BLVideoDetailViewController

`BLVideoDetailViewController` 是首版视频详情页。

结构：

- 顶部是 `BLVideoPlayerView`。
- 下方是白色详情内容区。
- 包含简介/评论 tab、弹幕入口、UP 主信息、标题、播放数据、点赞/不喜欢/投币/收藏/分享、话题按钮、推荐视频列表。

当前从首页推荐卡片进入：

```objc
BLVideoDetailViewController *detail =
    [[BLVideoDetailViewController alloc] initWithVideoURL:URL title:title author:author];
[self presentViewController:detail animated:YES completion:nil];
```

## 已实现的播放器交互

- 点击推荐页卡片进入视频详情页。
- 打开详情页后自动播放。
- 返回按钮关闭详情页。
- 点击视频区域切换控制层显隐。
- 播放/暂停按钮。
- 拖动进度条 seek。
- 展示缓冲进度。
- 倍速切换：`1.0x / 1.25x / 1.5x / 2.0x / 0.75x`。
- 静音切换。

## 后续建议

播放器后续可以继续扩展：

- 横屏全屏模式。
- 竖屏沉浸模式。
- 小窗播放。
- 长按倍速播放。
- 拖动进度条时显示预览小窗。
- 真实弹幕数据接入。
- 播放失败重试按钮。
- 进入后台、来电、耳机拔出等生命周期处理。
- 视频缓存或预加载。

页面后续可以继续扩展：

- 动画/影视页面接入真实图片资源。
- 首页卡片复用更通用的数据模型。
- 热门/动画/影视 cell 点击统一进入视频详情页。
- 三种播放器尺寸之间做同一个 `BLVideoPlayerView` 的容器切换，而不是重新创建播放器。

## 工程注意事项

- 当前项目是 Objective-C + UIKit 纯代码布局，没有 Storyboard 页面逻辑。
- 新增 `.m` 文件后必须同时加入 `Bilibili-iOS-Demo.xcodeproj/project.pbxproj` 的 Sources。
- 当前开发环境是 macOS，机器上存在 `/Applications/Xcode.app` 和 `/Users/guozhengkun03/Downloads/Xcode.app` 两个 Xcode；当前命令行开发者目录指向 `/Applications/Xcode.app/Contents/Developer`。
- 截至 2026-06-16，本机没有可用的 iOS 26.3 SDK/Simulator runtime；当前命令行完整构建会在 LaunchScreen storyboard 或 asset catalog 编译阶段被 simulator runtime 环境问题阻断。
- 如果在 Mac/Xcode 中运行，建议优先检查：
  - 新增文件是否在 target membership 中。
  - 测试视频 URL 是否仍然可访问。
  - 真机顶部 safe area 和底部 home indicator 的视觉表现。

## 常用定位

- 首页入口：`Bilibili-iOS-Demo/HomeViewController.m`
- 热门页：`Bilibili-iOS-Demo/Views/BLHotPageView.m`
- 直播页：`Bilibili-iOS-Demo/Views/BLLivePageView.m`
- 动画页：`Bilibili-iOS-Demo/Views/BLAnimePageView.m`
- 影视页：`Bilibili-iOS-Demo/Views/BLFilmPageView.m`
- 我的页：`Bilibili-iOS-Demo/Views/BLMinePageView.m`
- 历史记录页：`Bilibili-iOS-Demo/Views/BLHistoryPageView.m`
- 我的收藏页：`Bilibili-iOS-Demo/Views/BLFavoritePageView.m`
- 离线缓存页：`Bilibili-iOS-Demo/Views/BLOfflineCachePageView.m`
- 稍后再看页：`Bilibili-iOS-Demo/Views/BLWatchLaterPageView.m`
- 大会员中心页：`Bilibili-iOS-Demo/Views/BLMemberCenterPageView.m`
- 联系客服页：`Bilibili-iOS-Demo/Views/BLContactServicePageView.m`
- 播放器内核：`Bilibili-iOS-Demo/Views/BLPlayerCore.m`
- 播放器 UI：`Bilibili-iOS-Demo/Views/BLVideoPlayerView.m`
- 视频详情页：`Bilibili-iOS-Demo/Views/BLVideoDetailViewController.m`
