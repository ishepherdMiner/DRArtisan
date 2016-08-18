//
//  JXBasePickerView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXBasePickerView.h"

#define kDefaultRowHeight 40

@implementation JXBasePickerView

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
    if ([_dataList.firstObject isKindOfClass:[NSArray class]]) {
        return [_dataList count];
    }
    return kOne;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_dataList.firstObject isKindOfClass:[NSArray class]]) {
        return [_dataList[component] count];
    }
    return [_dataList count];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([_dataList.firstObject isKindOfClass:[NSArray class]]) {
        return [_dataList[component] objectAtIndex:row];
    }
    return _dataList[row];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([_dataList.firstObject isKindOfClass:[NSArray class]]) {
        return self.frame.size.width/[self.dataList count];
    }
    return self.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kDefaultRowHeight;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.pickerDelegate respondsToSelector:@selector(didSelectedPickerView:didSelectRow:inComponent:RowText:)]) {
        
        BOOL isMulti = [_dataList.firstObject isKindOfClass:[NSArray class]];
        [self.pickerDelegate didSelectedPickerView:self didSelectRow:row inComponent:isMulti ? component:0 RowText:isMulti ? _dataList[component][row]:_dataList[row]];
    }
}

- (void)hide{
    [self removeFromSuperview];
}

-(void)show:(UIView *)view{
    [view addSubview:self];
}

@end
