//
//  Constant.h
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/*
 RootDirectory 是Ryan创建的一个基本的项目模板，包含内容如下：
 RYUtils.framework v1.4      - Ryan定义的私人framework，使用是替换是最新版本
 AppDelegate                 - 包含了start - pannel的切换动画，后EnterBackground后的缓存处理及云备份处理
 StartViewController         - 启动view，可加载广告
 PannelViewController        - root view，管理项目中所有子模块
 ModuleViewControlers        - 所有子模块
 
 ---------------------改版--------------------------
 修改当前单模板为两种模板形式
 kIsNaviTemplate = 1 使用StartViewController - ContentNaviController(HomeViewController as root)
 标识使用root vc为UINavigationViewController
 
 kIsNaviTemplate = 0 使用StartViewController - PannelViewController
 标识使用root vc为UIViewController
 ---------------------2013-10-29--------------------
 
 使用方法：
 1. 复制一份原项目文件
 2. 替换项目名称
 3. 重新建立项目名称匹配的scheme
 4. 替换最新的RYUtils.framework, 引入framework所依赖框架
 5. 讲各子模块加入ViewControlers中
 
 注：
 dir: group对应目录下建立实际目录
 group: 项目文件下的虚拟目录结构
 
 使用过程中的group管理：
 1. ThirdLibrary: 管理项目中应用的第三方框架内容
 3. ViewControllers dir: 管理所有页面逻辑，主模块用对应sub dir实现，再次级用sub group实现
 4. Resources
 - Images dir: 管理除icon和启动图的其他所有图片资源，分类可用sub group 实现
 - Files  dir: 管理所有文件类资源，分类可用sub group实现
 
 ====================================
 添加ios7的支持
 --------------------------------------
 旧版：
 添加ios7的支持，兼容到6.0版本
 7.0 显示区域为全屏（含status bar）
 6.0 显示区域不包含statusbar
 -------------------------------------
 新版：
 - RootDirectory是基于ARC/Autolayout/Storyboard新建的一份项目模板
 - 兼容版本ios7.0及以上
 --------------------------------------
 Utilities - Ryan的常用库，可替换最新版本
 */

#ifndef RootDirectory_Constant_h
#define RootDirectory_Constant_h

/*
    0 - 标识使用root vc = PannelViewController
    1 - 标识使用root vc = RootNaviViewController - HomeViewController as root
    2 - 标识使用root vc = RootTabBarViewController - CommonNaviController - HomeViewController as root
 */
#define kRootTemplateType 0

//apple api
#define kAppAppleId         @"563444753"
#define kAppRateUrl         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
#define kAppDownloadUrl     @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"

//Constant Values
#define kMaxCacheSize       500*1024*1024
#define IsIPad()            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsDevicePhone5      [UIScreen mainScreen].bounds.size.height==568.f?YES:NO
#define IsIos7Later         [[UIDevice currentDevice].systemVersion floatValue]>=7.0?YES:NO
#define IsIos8Later         [[UIDevice currentDevice].systemVersion floatValue]>=8.0?YES:NO
#define IsIos9Later         [[UIDevice currentDevice].systemVersion floatValue]>=9.0?YES:NO
#define Is3_5Inch           [UIScreen mainScreen].bounds.size.height==480.f?YES:NO
#define Is4Inch             [UIScreen mainScreen].bounds.size.height==568.f?YES:NO
#define Is4_7Inch           [UIScreen mainScreen].bounds.size.height==667.f?YES:NO
#define Is5_5Inch           [UIScreen mainScreen].bounds.size.height==736.f?YES:NO
#define kStatusBarHeight    [UIApplication sharedApplication].statusBarFrame.size.height
#define kAPPInitialOriginY  (IsIos7Later)?kStatusBarHeight:0
#define kMainProjColor      [UIColor colorWithRed:22.f/255 green:152.f/255 blue:152.f/255 alpha:1.f]
#define DOCUMENTS_FOLDER    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]
#define kAllDataLoaded      @"已加载完所有数据"
//3.5inch 高度当做4inch来计算 - 一般是用来计算动态列表单元高度，4inch的设计高度保持和3.5inch一致
#define kUIXValue           320.f           //设计图宽度基准
#define kUIYValue           568.f           //设计图高度基准
#define kUIXScaleValue      [UIScreen mainScreen].bounds.size.width/kUIXValue
#define kUIYScaleValue      ((Is3_5Inch)?568.f:[UIScreen mainScreen].bounds.size.height)/kUIYValue
#define kWeakSelf           __weak typeof(self) weakSelf = self;
#define kStrongSelf         __strong typeof(self) strongSelf = self;


//APP Values
#define kOnColor            [UIColor colorWithRed:86.f/255 green:188.f/255 blue:138.f/255 alpha:1.f]
#define kOffColor           [UIColor colorWithRed:135.f/255 green:155.f/255 blue:170.f/255 alpha:1.f]
#define kOfflineColor       [UIColor redColor]
#define kSelectedColor      [UIColor whiteColor]
#define kLocalHomeFile      @"LocalHomeFile"
//Notification Keys
#define kShowPannelViewNotification         @"ShowPannelViewNotification"
#define kShowEntranceViewNotification       @"ShowEntranceViewNotification"
#define kRoomDeviceChangedNotification      @"RoomDeviceChangedNotification"
#define kListDeviceChangedNotification      @"ListDeviceChangedNotification"
#define kRoomListChangedNotification        @"RoomListChangedNotification"

//App Constant Values
#define kIPAddress                          (RYAN_DEBUG)?@"http://www.test.com":@"http://www.production.com"
#define kServerAddress                      [NSString stringWithFormat:@"%@",kIPAddress]

//MQTT Constant Values
#define kMQTTServerHost                     @"192.168.0.250"//@"192.168.0.250"//@"test.mosquitto.org"//iot.eclipse.org
#define kMQTTServerPort                     1883
#define kHubAddress                         @"00124B00071E8C6B"

#define kNetWorkErrorString                 @"网络已断开"
#define kConnectingServer                   @"服务器连接中..."
#define kConnectingError                    @"连接失败"
#define kConnectingClosed                   @"连接已关闭"
#define kConnectSucceed                     @"连接成功"
#define kInvalidName                        @"请输入1-8位合法名称"
#define kDefaultRoomName                    @"我的房间"
#define kDefaultDeviceName                  @"默认设备"
#define kUnknownDeviceName                  @"未知设备"
#define kRenameDevice                       @"设备重命名"
#define kRenameDeviceTip                    @"请输入设备名称"
#define kRenameRoom                         @"房间重命名"
#define kRenameRoomTip                      @"请输入房间名称"

#endif
