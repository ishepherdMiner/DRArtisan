//
//  AbstractBaseCollectionView.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceCollectionViewDelegate <NSObject>

@optional

@end

@protocol BaseCollectionViewDelegate <UICollectionViewDataSource,UICollectionViewDelegate>

@optional

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


@end
