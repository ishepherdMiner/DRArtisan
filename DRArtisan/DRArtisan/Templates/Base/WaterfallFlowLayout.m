//
//  WaterfallFlowLayout.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "WaterfallFlowLayout.h"
#define kDefaultCollectionCellHeight 60

NSString *const XC_UICollectionElementKindSectionHeader = @"XC_HeadView";
NSString *const XC_UICollectionElementKindSectionFooter = @"XC_FootView";

@interface WaterfallFlowLayout ()

/// 瀑布流的列数
@property (assign, nonatomic) NSInteger numberOfColumns;

/// cell之间的间距
@property (assign, nonatomic) CGFloat interitemSpace;   // cellDistance;

/// cell到顶部与底部的间距 就是行间距
@property (assign, nonatomic) CGFloat lineSpace;

/// 头视图的高度
@property (assign, nonatomic) CGFloat headerViewHeight;

/// 尾视图的高度
@property (assign, nonatomic) CGFloat footViewHeight;

/// 保存cell的布局
@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;

// 保存头视图的布局
@property (strong, nonatomic) NSMutableDictionary *headLayoutInfo;

// 保存尾视图的布局
@property (strong, nonatomic) NSMutableDictionary *footLayoutInfo;

/// 记录开始的Y
@property (assign, nonatomic) CGFloat startY;

/// 记录瀑布流每列最下面那个cell的底部y值
@property (strong, nonatomic) NSMutableDictionary *maxYForColumn;

/// 记录需要添加动画的NSIndexPath
@property (strong, nonatomic) NSMutableArray *shouldanimationArr;

@property (nonatomic,assign) NSUInteger columns;
@property (nonatomic,strong) NSMutableDictionary *lastYValueForColumn;
@property (nonatomic,strong) NSMutableDictionary *layoutInfo;

@end

@implementation WaterfallFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numberOfColumns = 3;
        self.lineSpace = 10;
        self.interitemSpace = 10;
        _headerViewHeight = 0;
        _footViewHeight = 0;
        self.startY = 0;
        self.maxYForColumn = [NSMutableDictionary dictionary];
        self.shouldanimationArr = [NSMutableArray array];
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.headLayoutInfo = [NSMutableDictionary dictionary];
        self.footLayoutInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)layoutWithNumOfColumns:(NSUInteger)numberOfColumns
                             lineSpace:(CGFloat)lineSpacing
                       interItemHSpace:(CGFloat)interItemSpacing
                                startY:(CGFloat)startYValue{
    
    WaterfallFlowLayout *obj = [[self alloc] init];
    obj.numberOfColumns = numberOfColumns;
    obj.lineSpace = lineSpacing;
    obj.interitemSpace = interItemSpacing;
    obj.startY = startYValue;
    obj.maxYForColumn = [NSMutableDictionary dictionary];
    obj.cellLayoutInfo = [NSMutableDictionary dictionary];
    obj.headLayoutInfo = [NSMutableDictionary dictionary];
    obj.footLayoutInfo = [NSMutableDictionary dictionary];
    obj.shouldanimationArr = [NSMutableArray array];
    return obj;
}

- (void)heightWithHeader:(CGFloat)hHeight footer:(CGFloat)fHeight {
    self.headerViewHeight = hHeight;
    self.footViewHeight = fHeight;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //重新布局需要清空
    [self.cellLayoutInfo removeAllObjects];
    [self.headLayoutInfo removeAllObjects];
    [self.footLayoutInfo removeAllObjects];
    [self.maxYForColumn removeAllObjects];
    self.startY = 0;
    
    
    CGFloat viewWidth = self.collectionView.frame.size.width;
    //代理里面只取了高度，所以cell的宽度有列数还有cell的间距计算出来
    CGFloat itemWidth = (viewWidth - self.interitemSpace*(self.numberOfColumns + 1))/self.numberOfColumns;
    
    //取有多少个section
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < sectionsCount; section++) {
        //存储headerView属性
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        //头视图的高度不为0并且根据代理方法能取到对应的头视图的时候，添加对应头视图的布局对象
        if (_headerViewHeight>0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView: viewForSupplementaryElementOfKind: atIndexPath:)]) {
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:XC_UICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
            //设置frame
            attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, _headerViewHeight);
            //保存布局对象
            self.headLayoutInfo[supplementaryViewIndexPath] = attribute;
            //设置下个布局对象的开始Y值
            self.startY = self.startY + _headerViewHeight + _lineSpace;
        }else{
            //没有头视图的时候，也要设置section的第一排cell到顶部的距离
            self.startY += _lineSpace;
        }
        
        //将Section第一排cell的frame的Y值进行设置
        for (int i = 0; i < _numberOfColumns; i++) {
            self.maxYForColumn[@(i)] = @(self.startY);
        }
        
        
        //计算cell的布局
        //取出section有多少个row
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        //分别计算设置每个cell的布局对象
        for (NSInteger row = 0; row < rowsCount; row++) {
            NSIndexPath *cellIndePath =[NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndePath];
            
            //计算当前的cell加到哪一列（瀑布流是加载到最短的一列）
            CGFloat y = [self.maxYForColumn[@(0)] floatValue];
            NSInteger currentRow = 0;
            for (int i = 1; i < _numberOfColumns; i++) {
                if ([self.maxYForColumn[@(i)] floatValue] < y) {
                    y = [self.maxYForColumn[@(i)] floatValue];
                    currentRow = i;
                }
            }
            //计算x值
            CGFloat x = self.interitemSpace + (self.interitemSpace + itemWidth)*currentRow;
            //根据代理去当前cell的高度  因为当前是采用通过列数计算的宽度，高度根据图片的原始宽高比进行设置的
            CGFloat height = 0;
            // 通过协议回传高度值 - 当没实现代理 退化为普通的FlowLayout布局
            if (self.collectionView.delegate) {
                if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]) {
                    height = [((id<WaterfallFlowLayoutDelegate>)self.collectionView.delegate)
                              collectionView:self.collectionView
                              layout:self
                              heightForItemAtIndexPath:cellIndePath];
                }else {
                    height = kDefaultCollectionCellHeight;
                }
            }else {
                height = kDefaultCollectionCellHeight;
            }

            // [(id<WaterfallFlowLayoutDelegate>)self.delegate collectionView:self.collectionView layout:self heightOfItemAtIndexPath:cellIndePath itemWidth:itemWidth];
            
            //设置当前cell布局对象的frame
            attribute.frame = CGRectMake(x, y, itemWidth, height);
            //重新设置当前列的Y值
            y = y + self.interitemSpace + height;
            self.maxYForColumn[@(currentRow)] = @(y);
            //保留cell的布局对象
            self.cellLayoutInfo[cellIndePath] = attribute;
            
            //当是section的最后一个cell是，取出最后一排cell的底部Y值   设置startY 决定下个视图对象的起始Y值
            if (row == rowsCount -1) {
                CGFloat maxY = [self.maxYForColumn[@(0)] floatValue];
                for (int i = 1; i < _numberOfColumns; i++) {
                    if ([self.maxYForColumn[@(i)] floatValue] > maxY) {
                        NSLog(@"%f", [self.maxYForColumn[@(i)] floatValue]);
                        maxY = [self.maxYForColumn[@(i)] floatValue];
                    }
                }
                self.startY = maxY - self.interitemSpace + self.lineSpace;
            }
        }
        
        
        //存储footView属性
        //尾视图的高度不为0并且根据代理方法能取到对应的尾视图的时候，添加对应尾视图的布局对象
        if (_footViewHeight>0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView: viewForSupplementaryElementOfKind: atIndexPath:)]) {
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:XC_UICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
            
            attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, _footViewHeight);
            self.footLayoutInfo[supplementaryViewIndexPath] = attribute;
            self.startY = self.startY + _footViewHeight;
        }
        
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    //添加当前屏幕可见的cell的布局
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    //添加当前屏幕可见的头视图的布局
    [self.headLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    //添加当前屏幕可见的尾部的布局
    [self.footLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    return allAttributes;
}

//插入cell的时候系统会调用改方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([elementKind isEqualToString:XC_UICollectionElementKindSectionHeader]) {
        attribute = self.headLayoutInfo[indexPath];
    }else if ([elementKind isEqualToString:XC_UICollectionElementKindSectionFooter]){
        attribute = self.footLayoutInfo[indexPath];
    }
    return attribute;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                //                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                //                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    self.shouldanimationArr = indexPaths;
}

// 对应UICollectionViewUpdateItem 的indexPathBeforeUpdate 设置调用
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    
    if ([self.shouldanimationArr containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attr = self.cellLayoutInfo[itemIndexPath];
        
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        attr.alpha = 1;
        [self.shouldanimationArr removeObject:itemIndexPath];
        return attr;
    }
    return nil;
}

//对应UICollectionViewUpdateItem 的indexPathAfterUpdate 设置调用
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([self.shouldanimationArr containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attr = self.cellLayoutInfo[itemIndexPath];
        
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(2, 2), 0);
        //        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        attr.alpha = 0;
        [self.shouldanimationArr removeObject:itemIndexPath];
        return attr;
    }
    return nil;
}

- (void)finalizeCollectionViewUpdates
{
    self.shouldanimationArr = nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}


//移动相关
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition NS_AVAILABLE_IOS(9_0)
{
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
    
    if([self.delegate respondsToSelector:@selector(moveItemAtIndexPath: toIndexPath:)]){
        [self.delegate moveItemAtIndexPath:previousIndexPaths[0] toIndexPath:targetIndexPaths[0]];
    }
    return context;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled NS_AVAILABLE_IOS(9_0)
{
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
    
    if(!movementCancelled){
        
    }
    return context;
}


/*
#pragma mark - older
+ (instancetype)layoutWithColumns:(NSUInteger)columns mininterItemSpace:(CGFloat)mininterItemSpace {
    WaterfallFlowLayout *obj = [[self alloc] init];
    obj.columns = columns;
    obj.minimumInteritemSpacing = mininterItemSpace;
    obj.scrollDirection = UICollectionViewScrollDirectionVertical;
    return obj;
}

#pragma mark - Need override
- (void)prepareLayout {
    // 每行有多少个Item
    self.columns = 3;
    
    // Item间的间距
    self.minimumInteritemSpacing = 12.5;
    
    // 用于记录item的y轴
    self.lastYValueForColumn = [NSMutableDictionary dictionary];
    
    // 用于记录item的属性
    self.layoutInfo = [NSMutableDictionary dictionary];
    
    // 初始化当前Item为第0个Item
    CGFloat currentColumn = 0;
    
    // 计算Item的宽度
    CGFloat fullWidth = self.collectionView.frame.size.width;
    CGFloat availableSpaceExcludingPadding = fullWidth - (self.minimumInteritemSpacing * (self.columns + 1));
    CGFloat itemWidth = availableSpaceExcludingPadding / self.columns;
    
    NSIndexPath *indexPath = nil;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    // 遍历section
    for(NSInteger section = 0; section < numSections; section++)  {
        
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        // 遍历item
        for(NSInteger item = 0; item < numItems; item++){
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 计算x轴
            CGFloat x = self.minimumInteritemSpacing + (self.minimumInteritemSpacing + itemWidth) * currentColumn;
            // 计算y轴
            CGFloat y = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
            CGFloat height = 0;
            // 通过协议回传高度值 - 当没实现代理 退化为普通的FlowLayout布局
            if (self.collectionView.delegate) {
                if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]) {
                    height = [((id<WaterfallFlowLayoutDelegate>)self.collectionView.delegate)
                              collectionView:self.collectionView
                              layout:self
                              heightForItemAtIndexPath:indexPath];
                }else {
                    height = kDefaultCollectionCellHeight;
                }
            }else {
                height = kDefaultCollectionCellHeight;
            }
            
            
            itemAttributes.frame = CGRectMake(x, y, itemWidth, height);
            
            // 下一个item的y轴是当前y轴加上item高度，并且加上间距
            y += height;
            y += self.minimumInteritemSpacing;
            
            // 把下一个item的y轴记入到字典中
            self.lastYValueForColumn[@(currentColumn)] = @(y);
            
            currentColumn ++;
            if(currentColumn == self.columns) currentColumn = 0;
            
            // 将item的属性记录到字典中
            self.layoutInfo[indexPath] = itemAttributes;
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                         UICollectionViewLayoutAttributes *attributes,
                                                         BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}
- (CGSize)collectionViewContentSize {
    NSUInteger currentColumn = 0;
    CGFloat maxHeight = 0;
    do {
        //最大高度就是之前字典中的y轴
        CGFloat height = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
        if(height > maxHeight)
            maxHeight = height;
        currentColumn ++;
    } while (currentColumn < self.columns);
    
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);

}
 
 */

@end
