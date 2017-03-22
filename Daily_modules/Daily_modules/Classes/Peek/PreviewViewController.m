//
//  PreviewViewController.m
//  Peekpop
//
//  Created by Jason on 18/03/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    [self.view addSubview:_webView];
}
    
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    
    // 赞
    UIPreviewAction *admire = [UIPreviewAction actionWithTitle:@"赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"点赞成功");
    }];
    
    // 举报
    UIPreviewAction *report = [UIPreviewAction actionWithTitle:@"举报" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"举报成功");
    }];
    
    // 收藏
    UIPreviewAction *collect = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"收藏成功");
    }];
    
    return @[admire,report,collect];
}

@end
