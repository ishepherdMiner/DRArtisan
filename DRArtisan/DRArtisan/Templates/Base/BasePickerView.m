//
//  BasePickerView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Selection box
        self.frame = frame;
        // 显示选中框
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [_dataList count];
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataList[component] count];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_dataList[component] objectAtIndex:row];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.frame.size.width/[self.dataList count];
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.pickerDelegate respondsToSelector:@selector(didSelectedPickerView:didSelectRow:inComponent:RowText:)]) {
        [self.pickerDelegate didSelectedPickerView:self didSelectRow:row inComponent:component RowText:_dataList[component][row]];
    }
}

- (void)hide{
    [self removeFromSuperview];
}

-(void)show:(UIView *)view{
    [view addSubview:self];
}

@end
