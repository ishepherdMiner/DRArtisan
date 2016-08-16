//
//  FlexibleWidthCollectionViewController.m
//  DRArtisan
//
//  Created by Jason on 8/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleWidthCollectionViewController.h"
#import "XCTagChooserView.h"

@interface FlexibleWidthCollectionViewController ()

@property (nonatomic,weak)  XCTagChooserView *tagChooserView;

@end

@implementation FlexibleWidthCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XCTagChooserView *tagChooserView = [XCTagChooserView chooserViewWithFrame:fRect(0, 200, Screen_width, 300) bottomHeight:300 maxSelectCount:5];
    
    [self.view addSubview:_tagChooserView = tagChooserView];
}

@end
