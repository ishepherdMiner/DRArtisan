//
//  SetMealTableView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SetMealTableView.h"

@interface SetMealTableView ()
@property (nonatomic,weak) UIPickerView *picker_v;
@end

@implementation SetMealTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kZero) {
        if (indexPath.row == kZero) {
            // Lazyload
            if (_picker_v == nil) {
                UIPickerView *picker_v = [[UIPickerView alloc] init];
                picker_v.dataSource = self;
                picker_v.delegate = self;
                SetMealTableViewCell *meal_cell_v = [tableView cellForRowAtIndexPath:indexPath];
                meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
                [meal_cell_v.desc_field_v becomeFirstResponder];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return kTwo;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kFive;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"test";
}

@end
