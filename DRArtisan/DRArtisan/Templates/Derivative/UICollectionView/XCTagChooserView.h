//
//  XCTagChooserView.h
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCTagChooserView : UIView

/// 指定白色背景高度
@property (nonatomic,assign) CGFloat    bottomHeight;

/// 最多可选择数量
@property (nonatomic,assign) NSInteger  maxSelectCount;

@end
