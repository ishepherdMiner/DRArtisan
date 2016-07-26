//
//  CategoryCoder.h
//  NormalCoder
//
//  Created by Jason on 6/29/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//˜



#ifndef CategoryCollect_h
#define CategoryCollect_h

#import "NSObject+Coder.h"
#import "NSString+Coder.h"
#import "NSArray+Coder.h"
#import "NSDictionary+Coder.h"
#import "NSDate+Coder.h"
#import "NSURL+Coder.h"
#import "NSNumber+Coder.h"
// if you define it, you should manual link libz.x.x.x.tbd framework at present
// #define Add_Data_Zip_Capability
#ifdef Add_Data_Zip_Capability
    #import <zlib.h>
#endif

#import "NSData+Coder.h"
#import "UIDevice+Coder.h"
#import "UIView+Coder.h"
#import "UIImage+Coder.h"
#import "UIViewController+Coder.h"

#endif /* CategoryCollect_h */
