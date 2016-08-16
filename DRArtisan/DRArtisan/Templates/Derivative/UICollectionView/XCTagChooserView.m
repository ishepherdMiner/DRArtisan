//
//  XCTagChooserView.m
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "XCTagChooserView.h"

@interface XCTagChooserView (){
//    NSArray         *orignalTags;  // 默认tag数组
    NSMutableArray  *selectedTags; // 选择的tag数组
}

/// 指定白色背景高度
@property (nonatomic,assign) CGFloat    bottomHeight;

/// 最多可选择数量
@property (nonatomic,assign) NSInteger  maxSelectCount;

@end
@implementation XCTagChooserView

+ (instancetype)chooserViewWithFrame:(CGRect)frame
                        bottomHeight:(CGFloat)bHeight
                      maxSelectCount:(CGFloat)maxCount{
    
    XCTagChooserView *chooserView = [[XCTagChooserView alloc] initWithFrame:frame];
    
    chooserView->selectedTags = [NSMutableArray array];
    chooserView.alpha = 0;
    chooserView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    chooserView.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    chooserView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    chooserView.bottomHeight = bHeight;
    chooserView.maxSelectCount = maxCount;
    
    WaterFlowHorLayout *flowLayout = [WaterFlowHorLayout LayoutWithColumnsCount:2 lineSpace:5 interitemSpace:5 sectionInset:UIEdgeInsetsMake(0, 5, 5, 5)];

    BaseCollectionView *collect_v = [BaseCollectionView collectionViewWithFrame:frame layout:flowLayout classType:XCCollectionViewClassTypeFlexHor clickItemBlock:nil];
    
    [chooserView addSubview:chooserView.collect_v = collect_v];
    
    return chooserView;
}


@end
