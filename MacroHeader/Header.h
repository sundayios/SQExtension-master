//
//  Header.h
//  SQExtension
//
//  Created by cb_2018 on 2019/3/23.
//  Copyright © 2019 cfwf. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define NotificationCenter [NSNotificationCenter defaultCenter]

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

#define LogsPath [DocumentPath stringByAppendingPathComponent:@"logs"]

#define CachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

// 根据屏幕尺寸判断是否 iPhone X
#define JudgePhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航条高度
#define kNavBarHeight 44.0

// 状态栏+导航条
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

// 注意：应直接获取系统的tabbar高度，若没有用系统tabbar，建议判断屏幕高度；判断状态栏高度的方法不妥，如果正在通话状态栏会变高，导致判断异常
#define kTabBarHeight self.tabBarController.tabBar.frame.size.height

#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(weak##type) strong##type = weak##type;


#define SQMargin 12.5f
#define SQFont(sizef) [UIFont systemFontOfSize:sizef]
#define SQFontWeight(sizef,FontWeight) [UIFont systemFontOfSize:sizef weight:FontWeight]
#define SQFontName(name,sizef) [UIFont fontWithName:name size:sizef]

#define Font12 SQFont(12)
#define Font14 SQFont(14)
#define Font_Nav_Item SQFont(16)
#define Font_Bold_Nav_Item [UIFont boldSystemFontOfSize:17]
#define Font_Lable_Gray_Tip SQFont(12)
#define Font_UITableViewCell_TextLabel Font14
#define Font_Label_Left_title Font14


//提示文字
#define Color_Tip_Gray [ToolUtils getColor:@"999999"]

//导航栏item的颜色
#define Color_Nav_Item [ToolUtils getColor:@"333333"]
//默认view背景
#define Color_BG_View [ToolUtils getColor:@"f5f5fa"]
//主题文字颜色
#define Color_Comon_Black_Darken [ToolUtils getColor:@"333333"]
//UITableView Title的颜色 51,51,51
#define Color_Cell_textLabel [ToolUtils getColor:@"333333"]
//二重提示文字 153, 153,153
#define Color_Cell_Subtitle_Gray [ToolUtils getColor:@"999999"]
//UITableview分割颜色 229
#define Color_Separator_Cell_Line [ToolUtils getColor:@"e5e5e5"]
//下拉滑动时view的颜色
#define Color_Drop_View_BG [ToolUtils getColor:@"c4c4c8"]
//自定义蓝色 3,169,244
#define Color_Blue_Custom_BG [ToolUtils getColor:@"03a9f4"]
//
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define APPColor RGBA(0,0,0,1)
//默认占位图
#define HomeImagePlaceHolderName @"icon_pic_5"
//URL
#define URLFromStr(str) [NSURL URLWithString:str]
#pragma mark - 当前系统
static inline bool isIPhoneX () {
    UIUserInterfaceIdiom idiom = [UIDevice currentDevice].userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return [NSStringFromCGSize([UIScreen mainScreen].bounds.size) isEqualToString:@"{375, 812}"];
    }
    return NO;
}

/**
 iOS11之前导航栏默认高度为64pt(这里高度指statusBar + NavigationBar)
 iOS11之后如果设置了prefersLargeTitles = YES则为96pt，默认情况下还是64pt，但在iPhoneX上由于刘海的出现statusBar由以前的20pt变成了44pt，所以iPhoneX上高度变为88pt.
 */
static inline CGFloat zh_statusBarHeight () {
    return isIPhoneX() ? 44 : 20;
}

static inline CGFloat zh_safeAreaHeight () {
    return isIPhoneX() ? 34 : 0;
}
// 此限制为用户密码的限制字符，➋➌➍➎➏➐➑➒是系统自带九宫格输入法的占位字符
#define limitedWords @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$()*+_=-@➋➌➍➎➏➐➑➒"


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// 强制去除Xcode的部分编译警告
//#pragma clang diagnostic ignored "-Wshorten-64-to-32"
//#pragma clang diagnostic ignored "-Wmismatched-return-types"
//#pragma clang diagnostic ignored "-Wmismatched-parameter-types"
#endif /* Header_h */
