//
//  JXBasePickerView.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXBasePickerViewDelegate <NSObject>

@optional
- (void)didSelectedPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component RowText:(NSString *)text;

@end

@interface JXBasePickerView : UIPickerView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,weak) id<JXBasePickerViewDelegate> pickerDelegate;

@property (nonatomic,strong) NSArray *dataList;

- (void)hide;
- (void)show:(UIView *)view;

@end
