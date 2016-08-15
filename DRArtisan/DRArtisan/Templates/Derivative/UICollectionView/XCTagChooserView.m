//
//  XCTagChooserView.m
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "XCTagChooserView.h"

@interface XCTagChooserView (){
    NSArray         *orignalTags;  // 默认tag数组
    NSMutableArray  *selectedTags; // 选择的tag数组
}

@property (nonatomic,weak) FlexibleWidthCollectionView *collect_v;

@end
@implementation XCTagChooserView

+ (instancetype)chooserViewWithFrame:(CGRect)frame
                        bottomHeight:(CGFloat)bHeight
                      maxSelectCount:(CGFloat)maxCount{
    
    XCTagChooserView *chooserView = [[XCTagChooserView alloc] initWithFrame:frame];
    
    chooserView->selectedTags = [NSMutableArray array];
    
    
    return chooserView;
}


@end
