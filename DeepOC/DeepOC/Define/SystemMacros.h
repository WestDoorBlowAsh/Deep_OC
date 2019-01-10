//
//  SystemMacros.h
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#ifndef SystemMacros_h
#define SystemMacros_h

/* ------------------------- 设备机型判断 -------------------------- */

//判断是否是iPhone6Plus的设备
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone7Plus iPhone6Plus  //判断是否是iPhone7Plus的尺寸
// 1334*750分辨率；iPhone6 Plus采用5.5寸屏，1920*1080分辨率
//判断是否是iPhone6的设备  375.000000    667.000000 - 在放大模式下不准确
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone7 iPhone6   //判断是否是iPhone7的尺寸
//判断是否是iphone5的设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphone4s的设备
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

// 设备机型判断
#define IS_IPAD                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA               ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT           ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS     (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5             (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6             (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P            (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/* ------------------------- 判断系统版本 -------------------------- */

#define FlostRepair(floatNum) (floatNum - 0.01)
#define IOS7 [[UIDevice currentDevice].systemVersion floatValue] >= FlostRepair(7.0) && [[UIDevice currentDevice].systemVersion floatValue] < 8.0
#define IOS8 [[UIDevice currentDevice].systemVersion floatValue] >= FlostRepair(8.0) && [[UIDevice currentDevice].systemVersion floatValue] < 9.0
#define IOS8_OVER [[UIDevice currentDevice].systemVersion floatValue] >= FlostRepair(8.0)
#define IOS9 [[UIDevice currentDevice].systemVersion floatValue] >= FlostRepair(9.0) && [[UIDevice currentDevice].systemVersion floatValue] < 10.0
#define IOS9_OVER [[UIDevice currentDevice].systemVersion floatValue] >= FlostRepair(9.0)
#define IOS10 [[UIDevice currentDevice].systemVersion floatValue] >= FlostRepair(10.0)

#define SYSTEM_VERSION          [[[UIDevice currentDevice] systemVersion] floatValue]

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
//发送通知
#define kPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])


#endif /* SystemMacros_h */
