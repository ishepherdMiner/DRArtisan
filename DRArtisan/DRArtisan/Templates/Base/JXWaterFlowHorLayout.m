//
//  JXWaterFlowHorLayout.m
//  DRArtisan
//
//  Created by Jason on 8/13/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXWaterFlowHorLayout.h"

@interface JXWaterFlowHorLayout ()

@property(nonatomic,strong) NSMutableArray *originxArray;
@property(nonatomic,strong) NSMutableArray *originyArray;

@property (nonatomic,assign) NSUInteger columnsCount;

@property (nonatomic,assign) CGFloat preWidth;

@property (nonatomic,assign) JXLayoutTactics layoutTactics;

@end

@implementation JXWaterFlowHorLayout

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
    
    return [self LayoutWithColumnsCount:columnsCount
                              lineSpace:lineSpace
                         interitemSpace:interitemSpace
                           sectionInset:sectionInset
                          layoutTactics:JXLayoutTacticsDefault];

}

#pragma mark - 重写父类的方法，实现瀑布流布局
+ (instancetype)LayoutWithColumnsCount:(NSUInteger)columnsCount
                             lineSpace:(CGFloat)lineSpace
                        interitemSpace:(CGFloat)interitemSpace
                          sectionInset:(UIEdgeInsets)sectionInset
                         layoutTactics:(JXLayoutTactics)layoutTactics {
    
    JXWaterFlowHorLayout *layout = [[JXWaterFlowHorLayout alloc] init];
    layout.minimumLineSpacing = lineSpace;
    layout.columnsCount = columnsCount;
    layout.minimumInteritemSpacing = interitemSpace;
    layout.sectionInset = sectionInset;
    layout.layoutTactics = layoutTactics;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.originxArray = [NSMutableArray array];
    layout.originyArray = [NSMutableArray array];
    return layout;
}

#pragma mark - 当尺寸/偏移量变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    CGPoint oldOffset = self.collectionView.contentOffset;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return true;
    }
    
    if (CGRectGetHeight(newBounds) != CGRectGetHeight(oldBounds)) {
        return true;
    }
    
    // 当偏移量大于行高时,刷新 - 数量变大后还是会与问题额
    if (oldOffset.y > self.rowHeight) {
        return true;
    }
    

    return false;
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
   
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:widthForItemAtIndexPath:itemHeight:)]) {
        [self.delegate collectionView:self.collectionView layout:self widthForItemAtIndexPath:indexPath itemHeight:_rowHeight];
    }
    CGFloat x = self.sectionInset.left;
    CGFloat y = self.sectionInset.top;
    // 判断获得前一个cell的x和y
    NSInteger preRow = indexPath.row - 1;
    
    // 至少是第二个
    if(preRow >= 0){
        if(_originyArray.count > preRow){
            x = [_originxArray[preRow]floatValue];
            y = [_originyArray[preRow]floatValue];
        }
        
        /*
        // 采用随机方式测试会影响,因此修改了策略
//        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preRow inSection:indexPath.section];
//        CGFloat preWidth = [self.delegate collectionView:self.collectionView layout:self widthForItemAtIndexPath:preIndexPath itemHeight:_rowHeight];
         x += preWidth + self.minimumInteritemSpacing;
         */
        
        x += self.preWidth + self.minimumInteritemSpacing;
    }
    
    CGFloat currentWidth = [self.delegate collectionView:self.collectionView layout:self widthForItemAtIndexPath:indexPath itemHeight:_rowHeight];
    // 保证一个cell不超过最大宽度
    currentWidth = MIN(currentWidth, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right);
    
    if (self.layoutTactics == JXLayoutTacticsDefault) {
        if((x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right) || (preRow > 0 && (preRow % self.columnsCount) == self.columnsCount - 1)){
            
            // 超出范围，换行
            x = self.sectionInset.left;
            y += _rowHeight + self.minimumLineSpacing;
        }
    }else if(self.layoutTactics == JXLayoutTacticsColumns) {
        if ((preRow > 0 && (preRow % self.columnsCount) == self.columnsCount - 1)) {
            
            // 超出范围，换行
            x = self.sectionInset.left;
            y += _rowHeight + self.minimumLineSpacing;
            
        }else if (x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right) {
            // 没到指定列数,但是加上这个cell宽度已经超过了
            currentWidth = (self.collectionView.frame.size.width - x - self.sectionInset.left) / (self.columnsCount - indexPath.row % self.columnsCount);
        }
    }
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, currentWidth, _rowHeight);
    _originxArray[indexPath.row] = @(x);
    _originyArray[indexPath.row] = @(y);
    
    // 记录上一个的长度
    self.preWidth = currentWidth;
    
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
