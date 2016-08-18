//
//  CODJXBaseNavigationController.m
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXBaseNavigationController.h"

@interface JXBaseNavigationController ()

@end

@implementation JXBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    // The navigation bar's shadowImage is set to a transparent image.  In
    // conjunction with providing a custom background image, this removes
    // the grey hairline at the bottom of the navigation bar.
    [self.navigationBar setShadowImage:[UIImage new]];
    
    // [self.navigationBar setBarTintColor:Jas_HexRGB(0xff0000)];
    // Translucency of the navigation bar is disabled so that it matches with
    // the non-translucent background of the extension view.
    // [self.navigationController.navigationBar setTranslucent:false];
    
    // 设置导航栏的字体的颜色,字体大小等
    NSDictionary *navigationBarStyle = @{
                                         NSForegroundColorAttributeName:HexRGB(0xffffff),
                                         NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
                                       };
    
    [self.navigationBar setTitleTextAttributes:navigationBarStyle];
}
#pragma mark - Custom NavBar
- (void)customRightViewWithType:(NavRightType)rightType content:(id)content {
    switch (rightType) {
        case NavRightTypeTitle:{
            NSAssert([content isKindOfClass:[NSString class]], @"When type is equal to NavRightTypeTitle, content class should be NSString");
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:content
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(rightViewClick:)];
            self.navigationItem.rightBarButtonItem = addButton;

        }
            
            break;
        case NavRightTypeImage: {
            NSAssert([content isKindOfClass:[NSString class]], @"When type is equal to NavRightTypeImage, content class should be NSString");
            // add our custom image button as the nav bar's custom right view
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:content]
                                                                          style:UIBarButtonItemStyleBordered target:self action:@selector(rightViewClick:)];
            self.navigationItem.rightBarButtonItem = addButton;

        }
            break;
            
        case NavRightTypeSeg:{
            NSAssert([content isKindOfClass:[NSArray class]], @"When type is equal to NavRightTypeSeg,content class should be NSArray");
            
            // "Segmented" control to the right
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:content];
            
            [segmentedControl addTarget:self action:@selector(rightViewClick:) forControlEvents:UIControlEventValueChanged];
            segmentedControl.frame = CGRectMake(0, 0, 90, 30.0);
            segmentedControl.momentary = YES;
            
            UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
            
            self.navigationItem.rightBarButtonItem = segmentBarItem;

        }
            break;
    }
}

- (void)customTitleView:(UISegmentedControl *)segmentedControl {
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = CGRectMake(0, 0, 400.0f, 30.0f);
    [segmentedControl addTarget:self action:@selector(titleViewClick:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;

}

- (void)customPromptTitle:(NSString *)promptTitle{
    // There is a bug in iOS 7.x (fixed in iOS 8) which causes the
    // topLayoutGuide to not be properly resized if the prompt is set before
    // -viewDidAppear: is called. This may result in the navigation bar
    // improperly overlapping your content.  For this reason, you should avoid
    // configuring the prompt in your storyboard and instead configure it
    // programmatically in -viewDidAppear:.
    self.navigationItem.prompt = promptTitle;

}

#pragma mark - Events
- (void)rightViewClick:(UIBarButtonItem *)barBtn {
    
}

- (void)titleViewClick:(UISegmentedControl *)seg {
    
}

#pragma mark - Style
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//| ----------------------------------------------------------------------------
//  Defer returning the supported interface orientations to the navigation
//  controller's top-most view controller.
//
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

#pragma mark - Debug
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
