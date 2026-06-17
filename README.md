# Bilibili-iOS-Demo

Objective-C + UIKit 纯代码实现的仿 Bilibili iOS 客户端 Demo。

---

## 项目结构

```
Bilibili-iOS-Demo/
├── HomeViewController.h/.m       ← 首页入口，底部 Tab + 频道 Tab 管理
├── Common/                       ← 颜色常量、布局常量、UIView 工厂方法
│   ├── BLTheme.h
│   ├── BLConstants.h/.m
│   ├── BLCoverGradientView.h/.m
│   └── UIView+BLLayout.h/.m
├── Models/                       ← 数据模型
│   ├── BLVideoItem.h/.m
│   ├── BLFeedItem.h/.m
│   ├── BLHistoryItem.h/.m
│   ├── BLHotVideoItem.h/.m
│   └── BLMallProduct.h/.m
├── DataSource/                   ← 集中 Mock 数据
│   └── BLMockDataSource.h/.m
├── Coordinators/                 ← 页面跳转逻辑（Coordinator 模式）
│   └── BLAppCoordinator.h/.m
└── Views/                        ← 各功能页面和复用组件
    └── ...（50+ 个页面/组件文件）
```

---

## 架构说明（MVC）

本项目遵循标准 MVC 架构，分为以下四层：

| 层级 | 目录 | 职责 |
|------|------|------|
| Common | `Common/` | 颜色/字体/布局常量，UIView 工厂方法分类 |
| Model | `Models/` | 各业务模块的数据模型类 |
| DataSource | `DataSource/` | 集中管理所有 Mock 数据，接口预留 completion block，方便后续替换为真实 API |
| Coordinator | `Coordinators/` | `BLAppCoordinator` 持有 HomeViewController 的 rootView，统一负责所有子页面的 show/dismiss 动画逻辑，HomeViewController 只做 UI 构建和 Tab 状态管理 |

---

## 已实现功能

### 首页（HomeViewController）

- 顶部搜索栏、频道 Tab（直播 / 推荐 / 热门 / 动画 / 影视）
- 推荐流视频卡片，点击进入视频详情播放页
- 底部 Tab：首页 / 关注 / 发布 / 会员购 / 我的

### 关注页（BLFollowingPageView）

- "全部"和"视频"两个 Tab
- Feed 中视频 Cell 内嵌播放器，屏幕内自动播放，滑出后停止
- 点击 Cell 进入视频详情播放页
- 进入关注页后底部红点清除

### 直播页（BLLivePageView）

- 直播分类横向 Tab：推荐、人气、颜值、英雄联盟、虚拟主播等
- 颜值页（推荐 / 热门 / 最新 三个子 Tab）
- 英雄联盟页（自动轮播 + 多个子 Tab）
- 人气榜

### 热门页（BLHotPageView）

- 快捷入口、热门视频列表
- Cell 右下角省略号触发半屏分享面板（BLSharePanelView）

### 动画页（BLAnimePageView）

- 自动轮播（BLAnimeCarouselView）
- 功能标签、热门排行榜、继续看、多个横向榜单区块

### 影视页（BLFilmPageView）

- 自动轮播、影视功能标签
- 正在追进度卡（BLFilmProgressCardView）
- 正在热播、热门排行榜

### 发布页（BLPublishPageView）

- 从底部加号右侧推出
- 四个 Tab：拍摄 / 上传 / 开直播 / 发图文
- 拍摄接入摄像头（前置摄像头 + 自定义控制层）
- 上传接入系统相册（全部 / 视频 / 照片）

### 会员购首页（BLMallPageView）

- 紫色固定搜索栏、618 头图、横向分类
- 商品瀑布流、新人券包倒计时、底部浮动新人券包

### 会员购搜索页（BLMallSearchPageView）

- 搜索发现、热搜词
- 横向可滑动卡片：热搜商品榜、推荐 IP、推荐角色

### 新人券包页（BLMallCouponPageView）

- 四个 Tab：入坑必逛 / 双倍补贴 / 热销盲盒 / 爆款单品
- 顶部固定搜索栏，可跳转至会员购搜索页

### 我的页（BLMinePageView）

- 个人信息、年度大会员、B 币/硬币、动态/关注/粉丝
- 大会员中心卡片、快捷服务、我的服务等模块
- 入口已接入：离线缓存、历史记录、收藏、稍后再看、联系客服、大会员中心

### 历史记录页（BLHistoryPageView）

- 分类 Tab、按"今天 / 昨天"分组的视频列表
- 点击 Item 进入视频播放页

### 我的收藏页（BLFavoritePageView）

- 收藏 / 追更 Tab，二级分类：收藏夹 / 全部 / 视频 / 图文
- 收藏夹可展开为详情页，支持视频播放

### 稍后再看页（BLWatchLaterPageView）

- 全部 / 未看完 Tab、播放进度条
- 管理弹窗：一键清除、批量管理（多选 / 全选 / 删除）

### 大会员中心（BLMemberCenterPageView）

- 自动滚动权益卡片、领经验、大福袋、我的权益、我的资产等模块

### 离线缓存页（BLOfflineCachePageView）

- 固定标题栏、空状态页面，预留 `setOfflineItems:` 和 `videoSelected` 接口

### 联系客服页（BLContactServicePageView）

- 自助服务宫格、猜你想问、联系客服分类、底部热线

---

## 播放器架构

```
BLPlayerCore          ← AVPlayer 封装（播放/暂停/seek/倍速/静音/状态回调）
BLPlayerRenderView    ← AVPlayerLayer 显示层
BLVideoPlayerView     ← 播放器组合 UI（控制层/进度条/弹幕层/倍速面板）
BLVideoDetailViewController ← 视频详情页（播放器 + 简介 + 推荐列表）
```

已实现的交互：点击卡片进入详情页、自动播放、播放/暂停、进度条拖动 seek、缓冲进度、倍速切换（0.75x / 1x / 1.25x / 1.5x / 2x）、静音切换、点击控制层显隐。

---

## 开发说明

### 打开项目

```sh
open Bilibili-iOS-Demo.xcodeproj
```

### 命令行构建验证

```sh
xcodebuild -project Bilibili-iOS-Demo.xcodeproj \
  -scheme Bilibili-iOS-Demo \
  -configuration Debug \
  -sdk iphonesimulator build 2>&1 | rg "error:"
```

### 新增文件注意事项

新增 `.m` 文件后，必须手动加入 `project.pbxproj` 的三处位置：

1. `PBXFileReference`（.h 和 .m 各一条）
2. `PBXBuildFile`（只有 .m）
3. `PBXSourcesBuildPhase`（只有 .m）

UUID 分配约定：

| 目录 | UUID 前缀 |
|------|-----------|
| Common | `0A0B****` |
| Models | `0A0C****` |
| DataSource | `0A0D****` |
| Coordinators | `0A0E****` |

### 后续接入建议

- 将 `BLMockDataSource` 中的各方法替换为真实 API 调用（接口签名保持不变）
- 视频播放统一通过 `BLAppCoordinator openPlayerWithURL:title:author:` 触发，不要直接依赖播放器实现
- 相机/相册权限已在 `Info.plist` 配置，增加新权限时需同步更新

---

## 常用文件定位

| 功能 | 文件 |
|------|------|
| 首页入口 | `HomeViewController.m` |
| 页面跳转协调 | `Coordinators/BLAppCoordinator.m` |
| Mock 数据 | `DataSource/BLMockDataSource.m` |
| 播放器内核 | `Views/BLPlayerCore.m` |
| 播放器 UI | `Views/BLVideoPlayerView.m` |
| 视频详情页 | `Views/BLVideoDetailViewController.m` |
| 关注页 | `Views/BLFollowingPageView.m` |
| 热门页 | `Views/BLHotPageView.m` |
| 直播页 | `Views/BLLivePageView.m` |
| 动画页 | `Views/BLAnimePageView.m` |
| 影视页 | `Views/BLFilmPageView.m` |
| 发布页 | `Views/BLPublishPageView.m` |
| 会员购首页 | `Views/BLMallPageView.m` |
| 我的页 | `Views/BLMinePageView.m` |
| 历史记录 | `Views/BLHistoryPageView.m` |
| 我的收藏 | `Views/BLFavoritePageView.m` |
| 稍后再看 | `Views/BLWatchLaterPageView.m` |
| 大会员中心 | `Views/BLMemberCenterPageView.m` |
| 离线缓存 | `Views/BLOfflineCachePageView.m` |
| 联系客服 | `Views/BLContactServicePageView.m` |
