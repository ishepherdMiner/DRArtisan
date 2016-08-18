//
//  JXBaseCollectionViewFlowLayout.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXBaseCollectionViewFlowLayout.h"

@implementation JXBaseCollectionViewFlowLayout

+ (instancetype)layoutWithItemSize:(CGSize)itemSize
                    minMarginSize:(CGSize)marginSize
                     sectionInset:(UIEdgeInsets)sectionInset {
    JXBaseCollectionViewFlowLayout *obj = [[self alloc] init];
    obj.itemSize = itemSize;
    obj.minimumLineSpacing = marginSize.height;
    obj.minimumInteritemSpacing = marginSize.width;
    obj.sectionInset = sectionInset;
    return obj;
}

+ (instancetype)layoutWithItemSize:(CGSize)itemSize
                         lineSpace:(CGFloat)minLineSpace
                    interitemSpace:(CGFloat)minInteritemSpace
                      sectionInset:(UIEdgeInsets)sectionInset {
    
    JXBaseCollectionViewFlowLayout *obj = [[self alloc] init];
    obj.itemSize = itemSize;
    obj.minimumLineSpacing = minLineSpace;
    obj.minimumInteritemSpacing = minInteritemSpace;
    obj.sectionInset = sectionInset;
    return obj;
}

- (void)sizeWithHeader:(CGSize)hSize footer:(CGSize)fSize {
    self.headerReferenceSize = hSize;
    self.footerReferenceSize = fSize;
}

#pragma mark - sub class should override follow methods
- (void)prepareLayout {
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}
- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

@end
