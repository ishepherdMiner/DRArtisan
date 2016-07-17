//
//  SetMealTableView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SetMealTableView.h"

@interface SetMealTableView () <BasePickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIPickerView *picker_v;
@property (nonatomic,weak) UIToolbar *accessory_v;

@property (nonatomic,strong) NSArray <UIView *> *unit_v_list;

@property (nonatomic,weak) UIView *mask_v;

/// 当前cell的索引
@property (nonatomic,strong) NSIndexPath *cur_index;

@end

@implementation SetMealTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        UIView *mask_v = [[UIView alloc] initWithFrame:self.bounds];
        mask_v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6]; // HexRGB(0x000000);
        mask_v.alpha = 0.0;
//        mask_v.backgroundColor = [UIColor clearColor];
        // UIDeviceRGBColorSpace 0 0.478431 1 1
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskAction:)];
        [mask_v addGestureRecognizer:tap];
//        mask_v.alpha = 0;
        [self addSubview:_mask_v = mask_v];
        
        
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mask_v.alpha = 0.6;
    }];
    
#if 0
    // When this click index not equal to last index and _picker_v not equal to nil
    if (indexPath != _cur_index && _picker_v) {
        [[[UIApplication sharedApplication].delegate window] endEditing:true];
        [_picker_v removeFromSuperview];
        _picker_v = nil;
    }
#endif
    
    // recoard current  index
    _cur_index = indexPath;

    if(indexPath.section == kZero) {
        if (indexPath.row == kZero) {
            
            // 套餐周期
            
            // Wil log appear follow infomation in sometimes
            // http://blog.csdn.net/x567851326/article/details/51251655
            // _BSMachError: (os/kern) invalid capability (20)
            // _BSMachError: (os/kern) invalid name (15)
            
            NSArray *picker_option_list = @[@[@"每 1 月",@"每 2 月",@"每 3 月",@"每 4 月",@"每 5 月",@"每 6 月",@"每 7 月",@"每 8 月",@"每 9 月",@"每 10 月",@"每 11 月",@"每 12 月"]];
            
            [self pickerViewWithList:picker_option_list indexPath:indexPath];
            
        }else if(indexPath.row == kOne) {
            // 结算日期
            NSArray *picker_option_list = @[
                                            @"01  日",@"02  日",@"03  日",@"04  日",@"05  日",
                                            @"06  日",@"07  日",@"08  日",@"09  日",@"10  日",
                                            @"11  日",@"12  日",@"13  日",@"14  日",@"15  日",
                                            @"16  日",@"17  日",@"18  日",@"19  日",@"20  日",
                                            @"21  日",@"22  日",@"23  日",@"24  日",@"25  日",
                                            @"26  日",@"27  日",@"28  日",@"29  日",@"30  日",
                                            @"31  日"];
            
            [self pickerViewWithList:picker_option_list indexPath:indexPath];
            
        }else if(indexPath.row == kTwo) {
            // 套餐流量
            SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
            meal_cell_v.desc_field_v.userInteractionEnabled = true;
            meal_cell_v.desc_field_v.returnKeyType = UIReturnKeyDone;
            meal_cell_v.desc_field_v.delegate = self;
            meal_cell_v.desc_field_v.keyboardType = UIKeyboardTypeNumberPad;
//            meal_cell_v.desc_field_v.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            meal_cell_v.desc_field_v.inputAccessoryView = _accessory_v = [self accessory_v];
            [meal_cell_v.desc_field_v becomeFirstResponder];
            
        }
    }else if(indexPath.section == kOne) {
        if (indexPath.row == kZero) {
           // 调整流量
           SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
           meal_cell_v.desc_field_v.userInteractionEnabled = true;
           meal_cell_v.desc_field_v.delegate = self;
           meal_cell_v.desc_field_v.keyboardType = UIKeyboardTypeNumberPad;
           meal_cell_v.desc_field_v.inputAccessoryView = _accessory_v = [self accessory_v];
           [meal_cell_v.desc_field_v becomeFirstResponder];
        }
    }else if(indexPath.section == kTwo) {
        if (indexPath.row == kZero) {
            self.mask_v.alpha = 0;
            // 重置
            UIAlertController *alert_c = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定重置数据？" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *alert_action_submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JasLog(@"删除数据");
            }];
            
            UIAlertAction *alert_action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert_c addAction:alert_action_submit];
            [alert_c addAction:alert_action_cancel];
            
            self.alertBlock(alert_c);
            
        }
    }
}

- (void)pickerViewWithList:(NSArray *)dataList indexPath:(NSIndexPath *)indexPath {
    // lazyload
    if (_picker_v == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BasePickerView *picker_v = [[BasePickerView alloc] initWithFrame:fRect(0, Screen_height - 200, Screen_width, 200)];
            picker_v.dataList = dataList;
            picker_v.pickerDelegate = self;
            SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
            meal_cell_v.desc_field_v.userInteractionEnabled = true;
            meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
            [meal_cell_v.desc_field_v becomeFirstResponder];
        });
    }
}

#pragma mark -Events
/// PickerView的代理方法
- (void)didSelectedPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component RowText:(NSString *)text {
    SetMealTableViewCell *cell = [self cellForRowAtIndexPath:_cur_index];
    cell.desc_field_v.text = text;
}

/// 点击遮罩视图,退下键盘,移除pickerview,隐藏遮罩层
- (void)maskAction:(UIGestureRecognizer *)tap {
    [self endEditing:true];
    [_picker_v removeFromSuperview];
    _picker_v = nil;
    [UIView animateWithDuration:0.5 animations:^{        
        _mask_v.alpha = 0.0;
    }];
}

- (void)unitClick:(UIButton *)sender {
    for (UIButton *unit_v in _unit_v_list) {
        if (unit_v == sender) {
            unit_v.selected = true;
        }else {
            unit_v.selected = false;
        }
    }
}

- (void)submitClick:(UIButton *)sender {
    UIButton *unit_v = (UIButton *)_unit_v_list.firstObject;
    SetMealTableViewCell *cell = [self cellForRowAtIndexPath:_cur_index];
    if(unit_v.selected) {
        cell.desc_field_v.text = [cell.desc_field_v.text stringByAppendingString:@" M"];
    }else {
        cell.desc_field_v.text = [cell.desc_field_v.text stringByAppendingString:@" G"];
    }
    // cell.desc_field_v.x -= [cell.desc_field_v.text singleLineWithFont:[UIFont systemFontOfSize:17]].width;
    // cell.desc_field_v.w = [cell.desc_field_v.text singleLineWithFont:[UIFont systemFontOfSize:17]].width;
    [self maskAction:nil];
    
}

#pragma mark - lazyload
- (UIToolbar *)accessory_v {
    if (_accessory_v == nil) {
        UIToolbar *accessory_v = [[UIToolbar alloc] initWithFrame:fRect(0, 0, Screen_width, 40)];
        
        UIButton *mb_unit_btn = [[UIButton alloc] initWithFrame:fRect(0, 0, accessory_v.w * 0.33, accessory_v.h)];
        mb_unit_btn.backgroundColor = HexRGB(0x888888);
        [mb_unit_btn setTitle:@"MB" forState:UIControlStateNormal];
        [mb_unit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mb_unit_btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [mb_unit_btn addTarget:self action:@selector(unitClick:) forControlEvents:UIControlEventTouchUpInside];
        mb_unit_btn.selected = true;
        
        UIButton *gb_unit_btn = [[UIButton alloc] initWithFrame:fRect(accessory_v.w * 0.33, 0, accessory_v.w * 0.33, accessory_v.h)];
        gb_unit_btn.backgroundColor = HexRGB(0x888888);
        [gb_unit_btn setTitle:@"GB" forState:UIControlStateNormal];
        [gb_unit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gb_unit_btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [gb_unit_btn addTarget:self action:@selector(unitClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 完成按钮
        UIButton *submit_btn = [[UIButton alloc] initWithFrame:fRect(accessory_v.w * 0.66, 0, accessory_v.w * 0.34, accessory_v.h)];
        submit_btn.backgroundColor = HexRGB(0x888888);
        [submit_btn setTitle:@"完成" forState:UIControlStateNormal];
        [submit_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submit_btn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [accessory_v addSubview:mb_unit_btn];
        [accessory_v addSubview:gb_unit_btn];
        [accessory_v addSubview:submit_btn];
        
        _unit_v_list = [NSArray arrayWithObjects:mb_unit_btn,gb_unit_btn, nil];
        return accessory_v;
    }
    return _accessory_v;
}

@end
