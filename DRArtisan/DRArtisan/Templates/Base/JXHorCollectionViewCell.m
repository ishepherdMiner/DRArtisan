//
//  JXHorCollectionViewCell.m
//  DRArtisan
//
//  Created by Jason on 9/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXHorCollectionViewCell.h"
#import "JXHorCellModel.h"
#import "JXGlobal.h"
#import "JXCategory.h"

@interface JXHorCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic,strong) JXHorCellModel *model;

@end

@implementation JXHorCollectionViewCell

- (void)injectedModel:(id)models {
    CGFloat xbase = 10;
    CGFloat width = 100;
    if (![models isKindOfClass:[NSArray class]]) {
        return;
    }
    for (JXHorCellModel *model in models) {
        // 模拟单个cell,其实所有的都只是一个cell
        UIView *singleCell = [self createSingleCellWithModel:model];
        [self.scroll addSubview:singleCell];
        singleCell.frame = fRect(xbase, 7, width, 150);
        xbase += 10 + width;
    }
    
    self.scroll.contentSize = fSize(xbase, self.scroll.h);
    self.scroll.delegate = self;
}

// If you extends you should override
- (UIView *)createSingleCellWithModel:(JXHorCellModel *)model {
    UIView *singleCell = [[UIView alloc] initWithFrame:fRect(0, 0, 100, 150)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:fRect(0, 0, 100, 110)];
    CGSize titleSize = [model.title singleLineWithFont:[UIFont systemFontOfSize:13]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:fRect(100 - titleSize.width, 120, titleSize.width, titleSize.height)];
    imageView.image = [UIImage imageNamed:model.image];
    titleLabel.text = model.title;
    singleCell.backgroundColor = HexRGB(0xffffff);
    [singleCell addSubview:imageView];
    [singleCell addSubview:titleLabel];
    //    UITapGestureRecognizer *singleFingerTap =
    //    [[UITapGestureRecognizer alloc] initWithTarget:self
    //                                            action:@selector(handleSingleTap:)];
    //    [custom addGestureRecognizer:singleFingerTap];
    return singleCell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self containingScrollViewDidEndDragging:scrollView];
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView{
    
    NSLog(@"%.2f",containingScrollView.contentOffset.x);
    
    NSLog(@"%.2f",self.scroll.contentSize.width);
    
    if (containingScrollView.contentOffset.x <= -50){
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-50 , 7, 100, 150)];
        UIActivityIndicatorView *acc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        acc.hidesWhenStopped = YES;
        [view addSubview:acc];
        [acc setFrame:CGRectMake(view.center.x - 25, view.center.y - 25, 50, 50)];
        [view setBackgroundColor:[UIColor clearColor]];
        [self.scroll addSubview:view];
        [acc startAnimating];
        [UIView animateWithDuration: 0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [containingScrollView setContentInset:UIEdgeInsetsMake(0, 100, 0, 0)];
                         }
                         completion:nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Do whatever you want.
                
                NSLog(@"Refreshing");
                
                [NSThread sleepForTimeInterval:3.0];
                
                NSLog(@"refresh end");
                
                [UIView animateWithDuration: 0.3
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     [containingScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                     
                                 }
                                 completion:nil];
            });
        });
        
    }
}

// The event handling method
//- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//    if([_cellDelegate respondsToSelector:@selector(cellSelected:)]){
//        [_cellDelegate cellSelected:self];
//    }
//}


@end
