//
//  GlobalConst.h
//  NormalCoder
//
//  Created by Jason on 7/6/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#ifndef GlobalConst_h
#define GlobalConst_h

#import "CategoryCollect.h"
#import "BaseCollect.h"
#import "AbstractCollect.h"


/**
 *  Setting switch service
 *
 *  @author  WangDL
 *  @version 1.0
 *  @date    20160706
 */
#if DEBUG
    #define JasLog(...) NSLog(@"\nJAS:" __VA_ARGS__)
    #define JasBaseURL  @""
    #define JasError    JasLog(@"\n\tclass => %@ \n\tfunction => %s",self,__func__)
#else
    #define JasLog(...) {}
    #define JasBaseURL  @""
    #define JasError    {}

#endif

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
#define Jas_device_version [[UIDevice currentDevice] systemVersion]
#define Jas_device_version_newer(version) [Jas_device_version compare:version options: NSNumericSearch] != NSOrderedAscending

/**
 *  Setting device bounds const
 *
 *  @author WangDL
 *  @version 1.1
 *  @date 20160706
 *  1.add Status,Navbar,Tabbar height const
 *  2.add iphone5 proporiton
 */
#define Jas_Screen_bounds  [UIScreen mainScreen].bounds
#define Jas_Screen_size [UIScreen mainScreen].bounds.size
#define Jas_Screen_height [UIScreen mainScreen].bounds.size.height
#define Jas_Screen_width [UIScreen mainScreen].bounds.size.width
#define Jas_Screen_scale [UIScreen mainScreen].scale
#define Jas_Status_bar_height 20
#define Jas_Nav_bar_height 64
#define Jas_Tab_bar_height 49
#define Jas_Proportion_iPhone5_w  Jas_Screen_width / 320.0f
#define Jas_Proporiton_iPhone5_h  Jas_Screen_height / 568.0f

/**
 * Setting abstract class need implemented
 */
#define AbstractMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
                               reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                             userInfo:nil]

#endif /* GlobalConst_h */
