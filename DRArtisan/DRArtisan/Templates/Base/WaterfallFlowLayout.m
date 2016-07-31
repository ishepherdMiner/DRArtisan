//
//  WaterfallFlowLayout.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "WaterfallFlowLayout.h"


@interface WaterfallFlowLayout ()

@property (nonatomic,assign) NSUInteger columns;

@property (nonatomic,strong) NSMutableDictionary *lastYValueForColumn;
@property (nonatomic,strong) NSMutableDictionary *layoutInfo;

@end

@implementation WaterfallFlowLayout

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

@end
