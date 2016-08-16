//
//  XCTagChooserView.h
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCTagChooserView : UIView

@property (nonatomic,weak) BaseCollectionView *collect_v;

+ (instancetype)chooserViewWithFrame:(CGRect)frame
                        bottomHeight:(CGFloat)bHeight
                      maxSelectCount:(CGFloat)maxCount;

@end
