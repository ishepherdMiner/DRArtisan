//
//  DemoHorCollectionViewController.m
//  DRArtisan
//
//  Created by Jason on 9/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "DemoHorCollectionViewController.h"
#import "JXArtisan.h"

@interface DemoHorCollectionViewController ()

@end

@implementation DemoHorCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JXBaseCollectionViewFlowLayout *flowLayout = [JXBaseCollectionViewFlowLayout layoutWithItemSize:fSize(80, 120) lineSpace:10 interitemSpace:10 sectionInset:UIEdgeInsetsZero];
    
    JXBaseCollectionView *collectionView = [JXBaseCollectionView collectionViewWithFrame:fRect(0, kNav_bar_height, Screen_width, Screen_height - kNav_bar_height) layout:flowLayout classType:JXCollectionViewClassTypeBase clickItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
        
        
    }];
    
    collectionView.backgroundColor = HexRGB(0xffffff);
    [collectionView registerCellClass:[JXHorCollectionViewCell class]];
    [self.view addSubview:collectionView = collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
