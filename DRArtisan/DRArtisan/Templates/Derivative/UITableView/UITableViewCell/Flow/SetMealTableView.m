//
//  SetMealTableView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SetMealTableView.h"

@interface SetMealTableView () <BasePickerViewDelegate>

@property (nonatomic,weak) UIPickerView *picker_v;

/// 当前cell的索引
@property (nonatomic,strong) NSIndexPath *last_index;

@end

@implementation SetMealTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // When this click index not equal to last index and _picker_v not equal to nil
    if (indexPath != _last_index && _picker_v) {
        [[[UIApplication sharedApplication].delegate window] endEditing:true];
        [_picker_v removeFromSuperview];
        _picker_v = nil;
    }
    
    // recoard last index
    _last_index = indexPath;
    
    if(indexPath.section == kZero) {
        if (indexPath.row == kZero) {
            // 套餐周期
            
            // Wil log appear follow infomation in sometines
            // http://blog.csdn.net/x567851326/article/details/51251655
            // _BSMachError: (os/kern) invalid capability (20)
            // _BSMachError: (os/kern) invalid name (15)
            
            NSArray *picker_option_list = @[@[@"每 1 月",@"每 2 月",@"每 3 月",@"每 4 月",@"每 5 月",@"每 6 月",@"每 7 月",@"每 8 月",@"每 9 月",@"每 10 月",@"每 11 月",@"每 12 月"]];
            
            [self pickerViewWithList:picker_option_list indexPath:indexPath];

        }else if(indexPath.row == kOne) {
            // 结算日期
            NSArray *picker_option_list = @[
                                            @"01 日",@"02 日",@"03 日",@"04 日",@"05 日",
                                            @"06 日",@"07 日",@"08 日",@"09 日",@"10 日",
                                            @"11 日",@"12 日",@"13 日",@"14 日",@"15 日",
                                            @"16 日",@"17 日",@"18 日",@"19 日",@"20 日",
                                            @"21 日",@"22 日",@"23 日",@"24 日",@"25 日",
                                            @"26 日",@"27 日",@"28 日",@"29 日",@"30 日",
                                            @"31 日"];
            
            [self pickerViewWithList:picker_option_list indexPath:indexPath];
            
        }else if(indexPath.row == kTwo) {
            // 套餐流量
            SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
            [meal_cell_v.desc_field_v becomeFirstResponder];
            
        }
    }else if(indexPath.section == kOne) {
        if (indexPath.row == kZero) {
           // 调整流量
           SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
           [meal_cell_v.desc_field_v becomeFirstResponder];
        }
    }else if(indexPath.section == kTwo) {
        if (indexPath.row == kZero) {
            // 重置
        }
    }
}

- (void)pickerViewWithList:(NSArray *)dataList indexPath:(NSIndexPath *)indexPath {
    // lazyload
    if (_picker_v == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BasePickerView *picker_v = [[BasePickerView alloc] initWithFrame:fRect(0, Screen_height - 200, Screen_width, 200)];
            picker_v.dataList = dataList;
            SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
            meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
            [meal_cell_v.desc_field_v becomeFirstResponder];
        });
    }
}

- (void)didSelectedPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component RowText:(NSString *)text {
    
}

#pragma mark - Deprecated
// pickerView 列数
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return [_dataList count];
//}
//
//// pickerView 每列个数
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return [_dataList[component] count];
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return @"title";
//}

//                BasePickerView *picker_v = [[BasePickerView alloc] initWithFrame:fRect(0, Screen_height - 200, Screen_width, 200)];
//                picker_v.dataList = @[@[@"每 1",@"每 2",@"每 3",@"每 4",@"每 5",@"每1",@"每2",@"每 7",@"每 8",@"每 9",@"每 10",@"每 11",@"每 12"],@[@"日",@"周",@"月",@"年"]];
//                SetMealTableViewCell *meal_cell_v = [tableView cellForRowAtIndexPath:indexPath];
//                meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
//                [meal_cell_v.desc_field_v becomeFirstResponder];

//                UIPickerView *picker_v = [[UIPickerView alloc] init];
//                picker_v.delegate = self;
//                picker_v.dataSource = self;
//                SetMealTableViewCell *meal_cell_v = [tableView cellForRowAtIndexPath:indexPath];
//                meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
//                [meal_cell_v.desc_field_v becomeFirstResponder];

@end
