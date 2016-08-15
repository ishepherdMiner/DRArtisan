//
//  WaterFlowHorLayout.m
//  DRArtisan
//
//  Created by Jason on 8/13/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "WaterFlowHorLayout.h"

@interface WaterFlowHorLayout ()

@property(nonatomic,strong) NSMutableArray *originxArray;
@property(nonatomic,strong) NSMutableArray *originyArray;

@end

@implementation WaterFlowHorLayout

/**
 *  初始化方法
 *
 *  @param columnsCount   列数
 *  @param lineSpace      行间距
 *  @param interitemSpace item的间距
 *  @param sectionInset   行内间距
 *
 *  @return BaseCollectionViweFlowLayout object
 */
+ (instancetype)LayoutWithColumnsCount:(NSUInteger)columnsCount
                             lineSpace:(CGFloat)lineSpace
                        interitemSpace:(CGFloat)interitemSpace
                          sectionInset:(UIEdgeInsets)sectionInset{
    
    WaterFlowHorLayout *layout = [[WaterFlowHorLayout alloc] init];
    layout.minimumLineSpacing = lineSpace;
    layout.minimumInteritemSpacing = interitemSpace;
    layout.sectionInset = sectionInset;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.originxArray = [NSMutableArray array];
    layout.originyArray = [NSMutableArray array];
    return layout;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark - 处理所有的Item的layoutAttributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:array.count];
    for(UICollectionViewLayoutAttributes *attrs in array){
        UICollectionViewLayoutAttributes *theAttrs = [self layoutAttributesForItemAtIndexPath:attrs.indexPath];
        [mutArray addObject:theAttrs];
    }
    return mutArray;
}

#pragma mark - 处理单个的Item的layoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([self.delegate respondsToSelector:@selector(collectionView:waterFlowVerLayout:widthAtIndexPath:)]) {
        [self.delegate collectionView:self.collectionView waterFlowVerLayout:self widthAtIndexPath:indexPath];
    }
    CGFloat x = self.sectionInset.left;
    CGFloat y = self.sectionInset.top;
    //判断获得前一个cell的x和y
    NSInteger preRow = indexPath.row - 1;
    if(preRow >= 0){
        if(_originyArray.count > preRow){
            x = [_originxArray[preRow]floatValue];
            y = [_originyArray[preRow]floatValue];
        }
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preRow inSection:indexPath.section];
        CGFloat preWidth = [self.delegate collectionView:self.collectionView waterFlowVerLayout:self widthAtIndexPath:preIndexPath];
        x += preWidth + self.minimumInteritemSpacing;
    }
    
    CGFloat currentWidth = [self.delegate collectionView:self.collectionView waterFlowVerLayout:self widthAtIndexPath:indexPath];
    // 保证一个cell不超过最大宽度
    currentWidth = MIN(currentWidth, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right);
    if(x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right){
        // 超出范围，换行
        x = self.sectionInset.left;
        y += _rowHeight + self.minimumLineSpacing;
    }
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, currentWidth, _rowHeight);
    _originxArray[indexPath.row] = @(x);
    _originyArray[indexPath.row] = @(y);
    return attrs;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.frame.size.width;
    
    __block CGFloat maxY = 0;
    [_originyArray enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([number floatValue] > maxY) {
            maxY = [number floatValue];
        }
    }];
    
    return CGSizeMake(width, maxY + _rowHeight + self.sectionInset.bottom);
}

@end
