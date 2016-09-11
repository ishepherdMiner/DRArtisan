//
//  JXTagChooserView.h
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXTagChooserView,JXBaseCollectionView;

@protocol JXTagChooserViewDelegate <NSObject>

@optional
/// 子类继承后自定义CollectView提供方法
- (JXBaseCollectionView *)tagChooserView:(JXTagChooserView *)chooserView;

@end

@interface JXTagChooserView : UIView <JXTagChooserViewDelegate>

@property (nonatomic,weak,readonly) JXBaseCollectionView *collect_v;

@property (nonatomic,weak) id<JXTagChooserViewDelegate> delegate;

+ (instancetype)chooserViewWithFrame:(CGRect)frame
                        bottomHeight:(CGFloat)bHeight
                      maxSelectCount:(CGFloat)maxCount;

@end
