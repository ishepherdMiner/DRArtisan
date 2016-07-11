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

@end

@implementation SetMealTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kZero) {
        if (indexPath.row == kZero) {
            // Lazyload
            if (_picker_v == nil) {
                // Wil log appear follow infomation in sometines
                // http://blog.csdn.net/x567851326/article/details/51251655
                // _BSMachError: (os/kern) invalid capability (20)
                // _BSMachError: (os/kern) invalid name (15)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    BasePickerView *picker_v = [[BasePickerView alloc] initWithFrame:fRect(0, Screen_height - 200, Screen_width, 200)];
                    picker_v.dataList = @[@[@"每 1",@"每 2",@"每 3",@"每 4",@"每 5",@"每1",@"每2",@"每 7",@"每 8",@"每 9",@"每 10",@"每 11",@"每 12"],@[@"日",@"周",@"月",@"年"]];
                    SetMealTableViewCell *meal_cell_v = [tableView cellForRowAtIndexPath:indexPath];
                    meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
                    [meal_cell_v.desc_field_v becomeFirstResponder];
                });
            }
        }
    }else if(indexPath.section == kOne) {
        if (indexPath.row == kOne) {
            
        }
    }else if(indexPath.section == kTwo) {
        if (indexPath.row == kTwo) {
            
        }
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
