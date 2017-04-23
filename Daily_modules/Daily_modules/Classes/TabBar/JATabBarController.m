//
//  RMTabBarViewController.m
//  RssMoney
//
//  Created by Jason on 11/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JATabBarController.h"

@interface JATabBarController ()

@property (nonatomic,strong) NSArray <UITabBarItem *> *items;

@end

@implementation JATabBarController

- (void)customizeTabBarWithControllers:(NSArray <UIViewController *> *) vcs {
    for (int i = 0; i < vcs.count; ++i) {
        [vcs[i] setTabBarItem:self.items[i]];
    }
    
    self.viewControllers = vcs;
}

- (void)customizeTabBarWithTitles:(NSArray *)titles
                           images:(NSArray <UIImage *> *)imgs
                   selectedImages:(NSArray <UIImage *> *)selectedImgs {
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (int i = 0; i < titles.count; ++i) {
        UIImage *img = [imgs objectAtIndex:i];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImg = [selectedImgs objectAtIndex:i];
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titles[i] image:img selectedImage:selectedImg];
        [items addObject:item];
    }
    
    self.items = [items copy];
    
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
