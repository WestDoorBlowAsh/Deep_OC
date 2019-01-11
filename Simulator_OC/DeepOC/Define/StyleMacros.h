//
//  StyleMacros.h
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#ifndef StyleMacros_h
#define StyleMacros_h

#pragma mark - Size

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kScreenBounds       [UIScreen mainScreen].bounds

#define kBannerHeight       kScreenWidth / 2.f

#define kButtonHeight       44
#define kInputCellMargin    30

#define kCornerRadius   6

//#define kTableViewFrame     CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight)

#define isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
//#define kStatusBarHeight        (isIPhoneX ? 44.f : 20.f)
#define kStatusBarHeight        CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])

#define kIPhoneXBottomSafeArea  (isIPhoneX ? (34.f) : (0.f))

// 自定义TabBar属性
#define kTabBarHeight           (isIPhoneX ? (49.f + kIPhoneXBottomSafeArea) : (49.f))
#define kTabBarIconSide         25.f

// 自定义NavigationBar属性
#define kNavgationBarHeight     44.0f

#define kNavgationBarY          (kNavgationBarHeight + kStatusBarHeight)

// UI使用的是iPhone8 plus屏幕尺寸 5.5 inch
#define Iphone6ScaleWidth KScreenWidth/375.0f
#define Iphone6ScaleHeight KScreenHeight/667.0f
//根据ip6的屏幕来拉伸
#define kUIScale(with) ((with)*(KScreenWidth/375.0f))

#define kContent_X  (15.0f * UI_Scale)
#define kListCell_RowHeight (kScreenWidth /3.0f)
#define kBaseCellRowHeight      45.0f
#define kSellCellHeadHeight     30.0f
#define kSellTextViewHeight     155.0f
#define kBaseCellLeftMarginX    15.0f

// 列表cell高度
#define STMineReleaseCellRowHeigiht (kScreenWidth * 0.35)
#define STMineReleaseCellRowMargin kScreenWidth/37.5

#define kPasswordMinLength      5
#define kPasswordMaxLength      15

/*
 app标准尺寸
 */
#define kNavigationTitleFont    [UIFont systemFontOfSize:18.f]

/* --------------------------------- 字体 --------------------------------- */
#define DKDefaultFontSize 17.f
#define DKDefaultSmallFontSize 16.f

#define DKFontSize(_size)       [UIDevice currentDevice].isPad ? (_size) :(IS_IPHONE_6P?(_size):(IS_IPHONE_6?(_size-1):(_size-3)))
#define DKFont(_size)           ([UIFont systemFontOfSize:DKFontSize(_size)])
#define DKBoldFont(_size)       ([UIFont boldSystemFontOfSize:DKFontSize(_size)])
#define DKDefaultFont           DKFont(DKDefaultFontSize)
#define DKDefaultBoldFont       DKBoldFont(DKDefaultFontSize)
#define DKDefaultSmallFont      DKFont(DKDefaultSmallFontSize)

//默认间距
#define KNormalSpace 12.0f

#pragma mark - Color

/* --------------------------------- 颜色 --------------------------------- */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DKRGB(r, g, b)            RGBA(r, g, b, 1)

#define RGB_COLOR(r,g,b)        RGBA_COLOR(r,g,b,1.0f)
#define RGBA_COLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB_COLOR0(_f)          [UIColor colorWithRed:((float)((_f & 0xFF0000) >> 16))/255.0 green:((float)((_f & 0xFF00)>> 8))/255.0 blue:((float) (_f & 0xFF))/255.0 alpha:1.0f]
#define HEX(color) HEXA(color, 1)

#define HEXA(color, alpha)  [DKHelpTool colorWithHexString:color withAlpha:alpha]

// 随机色
#define kRandomColor     DKRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kColorMain              RGBA(30, 171, 254, 1.f)
#define kColorGreen             HEX(@"#1CBF63")
#define kColorSeperateLine      HEX(@"#d3d3d3")
#define kColorLine              HEX(@"#E2E2E2")
#define kColorMaskground        HEX(@"#000000")
#define kColorMaiRed            HEX(@"#dd2727")
#define kColorCellground        HEX(@"#ffffff")
#define kColorPlaceholder       HEX(@"#999999")
#define kColorTextGayPick       HEX(@"#f7f7f7")
#define kColorBlue              HEX(@"#5F7AF7")
#define kColorRed               kColorMaiRed
#define kColorBlack             HEX(@"#ffffff")
#define kColorWhite             HEX(@"#000000")
#define kColorOrange            [UIColor orangeColor]
#define kColorGray              [UIColor grayColor]
#define kColorTextBlack         HEX(@"#333333")
#define kColorTextLight         HEX(@"#ccccd2")
#define kColorTextGray          HEX(@"#999999")
#define kColorTextLighGay       HEX(@"#888888")
#define kColorPriceDrop         HEX(@"#3ec031")
#define kColorOrangeTextColor   HEX(@"#ff7400")
#define kColorBlueTextColor     HEX(@"#4891eb")
#define kColorClear             [UIColor clearColor]
#define KCoverColor             [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]

#define kGrayFontColor          RGB_COLOR(138, 138, 138)
#define kYellowFontColor        RGB_COLOR(252, 200, 0)
#define kNavigationWhiteColor   [UIColor whiteColor]
#define kNavigationBlackColor   [UIColor blackColor]

#define kCellLineColor          [UIColor grayColor]

#define kColorBackground        HEX(@"#FFFFFF")
#define kColorBackgroundGray    HEX(@"#F5F5F5")
#define kColorInfoText          [UIColor lightGrayColor]
#define kAppColor               HEX(@"#F16D3C")
#define kUnSelectColor          HEX(@"#999999")
#define kAlertColor             kColorRed

#pragma mark - 图片

/* --------------------------------- 图片 --------------------------------- */

#define kNavBackBlack           @"nav_back_black"
#define kNavBackWhite           @"nav_back"


#endif /* StyleMacros_h */
