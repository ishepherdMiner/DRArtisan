//
//  JXTagChooserView.m
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXTagChooserView.h"
#import "JXTagChooserCell.h"
#import "JXTagChooserModel.h"

@interface JXTagChooserView () <JXTagChooserViewDelegate> {
    NSMutableArray  *selectedTags; // 选择的tag数组
}

/// 指定白色背景高度
@property (nonatomic,assign) CGFloat    bottomHeight;

/// 最多可选择数量
@property (nonatomic,assign) NSInteger  maxSelectCount;

@end
@implementation JXTagChooserView

+ (instancetype)chooserViewWithFrame:(CGRect)frame
                        bottomHeight:(CGFloat)bHeight
                      maxSelectCount:(CGFloat)maxCount{
    
    JXTagChooserView *chooserView = [[JXTagChooserView alloc] initWithFrame:frame];
    
    chooserView->selectedTags = [NSMutableArray array];
    chooserView.alpha = 1.0;
    chooserView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    chooserView.frame = frame;
    chooserView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    chooserView.bottomHeight = bHeight;
    chooserView.maxSelectCount = maxCount;
    chooserView.delegate = chooserView;
    [chooserView addSubview:[chooserView.delegate tagChooserView:chooserView]];
    return chooserView;
}

#pragma mark - JXTagChooserViewDelegate
- (JXBaseCollectionView *)tagChooserView:(JXTagChooserView *)chooserView {
    if (_collect_v == nil) {
        JXWaterFlowHorLayout *flowLayout = [JXWaterFlowHorLayout LayoutWithColumnsCount:4 lineSpace:5 interitemSpace:10 sectionInset:UIEdgeInsetsMake(0, 5, 5, 5) layoutTactics:JXLayoutTacticsColumns];
        
        flowLayout.rowHeight = 40;
        
        JXBaseCollectionView *collect_v = [JXBaseCollectionView collectionViewWithFrame:self.bounds layout:flowLayout classType:JXCollectionViewClassTypeFlexHor clickItemBlock:nil];
        flowLayout.delegate = collect_v;
        
        [collect_v registerCellClass:[JXTagChooserCell class]];
        [collect_v registerModelClass:[JXTagChooserModel class]];
        collect_v.backgroundColor = HexRGB(0xffffff);
        _collect_v = collect_v;
    }
    return _collect_v;
}


@end
