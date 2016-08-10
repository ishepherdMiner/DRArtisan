//
//  AbstractBaseCollectionView.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;

@protocol ServiceCollectionViewDelegate <NSObject>

@optional
/// collectionView service delegate declare
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol BaseCollectionViewDelegate <UICollectionViewDataSource,UICollectionViewDelegate>

@optional

/**
 *  Packing a foundation class to a JASBaseCellModel object,just for UITableViewCell at present
 *
 *  @param obj founcation class
 *
 *  @return a JASBaseCellModel object
 */
- (id)packFoundationClass:(id)obj;

/**
 *  The collectionView cell height
 *
 *  @param collectionView which collectionView object
 *  @param layout         which collectionView layout
 *  @param indexPath      which collecitonView indexPath
 *
 *  @return the height for assign conditons
 */
- (CGFloat)collectionView:(UICollectionView*)collectionView
                   layout:(WaterFlowLayout *) layout
 heightForItemAtIndexPath:(NSIndexPath*)indexPath
                itemWidth:(NSUInteger)itemWidth;

/**
 *  The collectionView movable
 *
 *  @param sourceIndexPath      source IndexPath
 *  @param destinationIndexPath destination IndexPath
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
                toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface AbstractBaseCollectionView : UICollectionView <BaseCollectionViewDelegate> {
    NSArray *_dataList;
}

/**
 *  UICollectionView cell class
 */
@property (nonatomic,weak,readonly) Class cellClass;

/**
 *  reuse flag
 */
@property (nonatomic,copy,readonly) NSString *identifier;

/**
 *  the dataList of collectionView
 */
@property (nonatomic,strong) NSArray *dataList;

/**
 *  只关注点击cell触发动作的代理,因为点击触发的操作与具体的业务有关
 */
@property (nonatomic,weak) id<ServiceCollectionViewDelegate> sdelegate;

/**
 *  If you like use vc to become tableview delegate object,set it.
 */
@property (nonatomic,weak) id<BaseCollectionViewDelegate> cdelegate;


/**
 *  If need custom setter method
 */
@property (nonatomic,assign) BOOL customSetter;

/**
 *  It's a shortcut property to show system UITableViewCell type
 */
@property (nonatomic,assign) UITableViewCellStyle cellStyle;

/**
 *  the tableview cell reuse times;
 */
@property (nonatomic,assign) NSUInteger reuseCount;

/**
 *  register tableview cell class and set a reuse id which equal to classname
 *
 *  @param cellClass which class is tableview cell
 */
- (void)registerClass:(Class)cellClass;

@end
