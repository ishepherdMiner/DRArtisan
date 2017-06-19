//
//  UIScreen+JACoder.m
//  RssMoney
//
//  Created by Jason on 12/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UIScreen+JACoder.h"

@implementation UIScreen (JACoder)

+ (CGFloat)w {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)h {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGRect)mainBounds {
    return [UIScreen mainScreen].bounds;
}
@end
