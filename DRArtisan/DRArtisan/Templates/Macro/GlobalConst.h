//
//  GlobalConst.h
//  NormalCoder
//
//  Created by Jason on 7/6/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#ifndef GlobalConst_h
#define GlobalConst_h

/**
 *  Setting frame const
 *
 *  @author  WangDL
 *  @version 1.0
 *  @date    20160617
 */
#define fRect(x,y,w,h)  CGRectMake(x,y,w,h)
#define fSize(w,h)      CGSizeMake(w,h)
#define fPoint(x,y)     CGPointMake(x,y)
#define fRange(loc,len) NSMakeRange(loc,len)
#define fMaxX(frame)    CGRectGetMaxX(frame)
#define fMidX(frame)    CGRectGetMidX(frame)
#define fMinX(frame)    CGRectGetMinX(frame)
#define fMaxY(frame)    CGRectGetMaxY(frame)
#define fMidY(frame)    CGRectGetMidY(frame)
#define fMinY(frame)    CGRectGetMinY(frame)
#define fHeight(frame)  CGRectGetHeight(frame)
#define fWidth(frame)   CGRectGetWidth(frame)

/**
 *  Setting device version const
 *
 *  @author  WangDL
 *  @version 1.0
 *  @date    20160617
 */
#define device_version [[UIDevice currentDevice] systemVersion]
#define device_version_newer(version) [device_version compare:version options: NSNumericSearch] != NSOrderedAscending

/**
 *  Setting device bounds const
 *
 *  @author WangDL
 *  @version 1.1
 *  @date 20160706
 *  1.add Status,Navbar,Tabbar height const
 *  2.add iphone5 proporiton
 */
#define Screen_bounds         [UIScreen mainScreen].bounds
#define Screen_size           [UIScreen mainScreen].bounds.size
#define Screen_height         [UIScreen mainScreen].bounds.size.height
#define Screen_width          [UIScreen mainScreen].bounds.size.width
#define Screen_scale          [UIScreen mainScreen].scale
#define Status_bar_height     20
#define Nav_bar_height        64
#define Tab_bar_height        49
#define Proportion_iPhone5_w  Screen_width / 320.0f
#define Proporiton_iPhone5_h  Screen_height / 568.0f

/**
 *  Setting constant numbers
 */
#define kZero  0
#define kOne   1
#define kTwo   2
#define kThree 3
#define kFour  4
#define kFive  5
#define kSix   6
#define kSeven 7
#define kEight 8
#define kNine  9
#define kTen  10
#define kTwentyFour  24
#define kSixty       60
#define kNegativeOne -1
#define kMoreMagnitude 1024.0

// description thing status
#define kStatusSuccess  kZero
#define kStatusFail     kNegativeOne

/**
 *  Setting color const
 *  Author  WangDL
 *  Version 1.0
 *  Create Date 20160617
 */
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]

#define DEFAULT_COLOR HexRGB(0x59a7ff)

// 字体色调
// 文字-浅颜色 日期,placeholder的字体
#define DEFAULT_LIGTH_COLOR  HexRGB(0xa6a6a6)

// 文字-默认颜色
#define DEFAULT_FONT_COLOR   HexRGB(0x2d2a2a)

//判断是否为pad
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  Setting network status code const
 *  Author  WangDL
 *  Version 1.0
 *  Create Date 20160617
 */
/// Success
#define Network_success_code kZero

/// Client error
#define Network_client_error_low_code  400
#define Network_client_error_high_code 499
// #define Network_client_error_esp_codes @[Jas,Jas,Jas]

/// Server error
#define Network_server_error_low_code  500
#define Network_server_error_high_code 599
// #define Network_server_error_esp_codes @[Jas,Jas,Jas]

/// Indicate
#define Network_indicate_delay_normal_time 2.0
#define Network_indicate_delay_more_tiem   3.0

#define XCTAssertTrue(expression, format...) \
    _XCTPrimitiveAssertTrue(expression, ## format)

#define _XCTPrimitiveAssertTrue(expression, format...) \
    ({ \
        @try { \
            BOOL _evaluatedExpression = !!(expression); \
            if (!_evaluatedExpression) { \
                _XCTRegisterFailure(_XCTFailureDescription(_XCTAssertion_True, 0, @#expression),format); \
            } \
        } \
        @catch (id exception) { \
            _XCTRegisterFailure(_XCTFailureDescription(_XCTAssertion_True, 1, @#expression, [exception reason]),format); \
        }\
    })

/// Type check is strict,if kTypecheck is equal to 1
#define kTypecheck  kOne

// ============================================================================
// Approach simplifies macro
/**
 * Setting abstract class need implemented
 */
#define AbstractMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]

/**
 *  Is base object class
 *
 */
#define kFoundationProperty(property)   ([property isKindOfClass:[NSNumber class]]  \
|| [property isKindOfClass:[NSValue class]]   \
|| [property isKindOfClass:[NSString class]]) \
|| [property isKindOfClass:[NSDate class]]    \
|| [property isKindOfClass:[NSData class]]

/**
 *  Is collection object class
 */
#define kCollectionProperty(property)   ([property isKindOfClass:[NSArray class]]      \
|| [property isKindOfClass:[NSDictionary class]] \
|| [property isKindOfClass:[NSSet class]])

/**
 * SingletonClassMethod
 */
#define SingletonClassMethod(classname) \
+ (instancetype)shared##classname { \
static id instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
}

/// NavigationBar back
#define SET_NAV_BTN(__arg__, __item__,__ftn__,__title__) UIButton * __arg__=[UIButton buttonWithType:UIButtonTypeCustom];__arg__.frame=CGRectMake(0, 0, 35, 20);[__arg__ setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];[__arg__ setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];[__arg__ addTarget:self action:@selector(__ftn__) forControlEvents:UIControlEventTouchUpInside];self.navigationItem.__item__=[[UIBarButtonItem alloc]initWithCustomView:__arg__];


/// return Timestamp
#define NowTimestamp  NSUInteger(^timestamp)() = ^() { \
                            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0]; \
                            return (NSUInteger)[date timeIntervalSince1970]; \
                      };
// ============================================================================

#endif /* GlobalConst_h */



