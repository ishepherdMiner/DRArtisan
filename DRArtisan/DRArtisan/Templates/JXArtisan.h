//
//  JXArtisan.h
//  DRArtisan
//
//  Created by Jason on 8/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#ifndef JXArtisan_h
#define JXArtisan_h

/// Cabability Switch
// if you define it, you should manual link libz.x.x.x.tbd framework at present
// #define Add_Data_Zip_Capability

#import "NSObject+Coder.h"
#import "NSString+Coder.h"
#import "NSArray+Coder.h"
#import "NSDictionary+Coder.h"
#import "NSDate+Coder.h"
#import "NSURL+Coder.h"
#import "NSNumber+Coder.h"

#ifdef Add_Data_Zip_Capability
    #import <zlib.h>
#endif

#import "NSData+Coder.h"
#import "UIDevice+Coder.h"
#import "UIView+Coder.h"
#import "UIImage+Coder.h"
#import "UIViewController+Coder.h"

// - Abstract layer
#import "JXAbstractBaseTableView.h"
#import "JXAbstractBaseCollectionView.h"

#import "JXBaseObject.h"

// Cell Model
#import "JXDefaultCellModel.h"
#import "JXValue1CellModel.h"
#import "JXValue2CellModel.h"
#import "JXSubtitleCellModel.h"
#import "JXSetMealCellModel.h"

// ViewController
#import "JXBaseViewController.h"
#import "JXBaseNavigationController.h"

// TableView
#import "JXBaseTableView.h"
#import "JXFlexibleHeightTableView.h"
#import "JXSupplementaryTitleTableView.h"
#import "JXSupplementaryViewTableView.h"
#import "JXSupplementaryHeaderTitleMix.h"
#import "JXSupplementaryHeaderViewMix.h"

// TableViewCell
#import "JXBaseTableViewCell.h"
#import "JXDefaultCell.h"
#import "JXValue1Cell.h"
#import "JXValue2Cell.h"
#import "JXSubtitleCell.h"

// CollectionView
#import "JXBaseCollectionView.h"
#import "JXFlexibleHeightCollectionView.h"
#import "JXFlexibleWidthCollectionView.h"
#import "JXBaseCollectionViewFlowLayout.h"
#import "JXWaterFlowVerLayout.h"
#import "JXWaterFlowHorLayout.h"
#import "WaterfallFlowLayout.h"

#import "Capable.h"

// CollectionViewCell
#import "JXBaseCollectionViewCell.h"

// PickerView
#import "JXBasePickerView.h"

#import "JASTableViewController.h"

// From flow project
#import "JXSetMealTableViewCell.h"

#endif /* JXArtisan_h */
