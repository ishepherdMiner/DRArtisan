//
//  JXSetMealTableView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXSetMealTableView.h"
#import "JXFlowAnalytical.h"
#import "JXMealPersistent.h"

@interface JXSetMealTableView () <JXBasePickerViewDelegate,UITextFieldDelegate>

/// 视图 - 选择器
@property (nonatomic,weak) UIPickerView *picker_v;

/// 视图 - 工具条
@property (nonatomic,weak) UIToolbar *accessory_v;

/// 视图 - 遮罩层
@property (nonatomic,weak) UIView *mask_v;

/// 视图 - 预览
@property (nonatomic,weak) UILabel *preview_label;

@property (nonatomic,weak) UIButton *preview_submit;

@end

@implementation JXSetMealTableView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        UIView *mask_v = [[UIView alloc] initWithFrame:self.bounds];
        mask_v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6]; // HexRGB(0x000000);
        mask_v.alpha = 0.0;
        // mask_v.backgroundColor = [UIColor clearColor];
        // UIDeviceRGBColorSpace 0 0.478431 1 1
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskClick:)];
        [mask_v addGestureRecognizer:tap];
        [self addSubview:_mask_v = mask_v];
    }
    return self;
}

#pragma mark - Events

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mask_v.alpha = 0.6;
    }];
    
    NSArray *picker_option_list = nil;
    switch (indexPath.section) {
        case kZero:{
            switch (indexPath.row) {
                case kZero:{
                    // 套餐周期
                    // Will log appear follow infomation in sometimes
                    // http://blog.csdn.net/x567851326/article/details/51251655
                    // _BSMachError: (os/kern) invalid capability (20)
                    // _BSMachError: (os/kern) invalid name (15)
                    picker_option_list = MealCycleMonths;
                    [self pickerViewWithList:picker_option_list indexPath:indexPath];
                }
                    break;
                case kOne:{
                    // 结算日期
                    picker_option_list = SettleDates;
                    [self pickerViewWithList:picker_option_list indexPath:indexPath];
                }
                    break;
                case kTwo:{
                    // 套餐流量
                    picker_option_list = MealFlows;
                    [self pickerViewWithList:picker_option_list indexPath:indexPath];
                }
                    break;
            }
        }
            break;
        case kOne:{
            switch (indexPath.row) {
                case kZero: {
                    // 已使用流量
                    picker_option_list = UsedFlows;
                    [self pickerViewWithList:picker_option_list indexPath:indexPath];
                }
                    break;
                case kOne: {
                    // 剩余流量
                    picker_option_list = LeftFlows;
                    [self pickerViewWithList:picker_option_list indexPath:indexPath];
                }
                    break;
                case kTwo:{
                    // 流量不清零周期
                    picker_option_list = FlowNotClear;
                    [self pickerViewWithList:picker_option_list indexPath:indexPath];
                }
                    break;
            }
        }
            
            break;
        case kTwo:{
            switch (indexPath.row) {
                case kZero:{
                    self.mask_v.alpha = 0;
                    // 重置
                    UIAlertController *alert_c = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定重置数据？" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *alert_action_submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        JXLog(@"删除数据");
                        [JXFlowAnalytical resetAll];
                    }];
                    
                    UIAlertAction *alert_action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        JXLog(@"取消修改数据");
                    }];
                    
                    [alert_c addAction:alert_action_submit];
                    [alert_c addAction:alert_action_cancel];
                    
                    self.alertBlock(alert_c);
                }
                    break;
            }
        }
            break;
    }
}

- (void)pickerViewWithList:(NSArray *)dataList indexPath:(NSIndexPath *)indexPath {
    // lazyload
    if (_picker_v == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JXBasePickerView *picker_v = [[JXBasePickerView alloc] initWithFrame:fRect(0, Screen_height - 200, Screen_width, 200)];
            picker_v.dataList = dataList;
            picker_v.pickerDelegate = self;
            JXSetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
            meal_cell_v.desc_field_v.userInteractionEnabled = true;
            meal_cell_v.desc_field_v.delegate = self;
            meal_cell_v.desc_field_v.inputView = _picker_v = picker_v;
            meal_cell_v.desc_field_v.inputAccessoryView = _accessory_v = [self accessory_v];
            [meal_cell_v.desc_field_v becomeFirstResponder];
        });
    }
}

/// PickerView的代理方法
- (void)didSelectedPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component RowText:(NSString *)text {
    if (_preview_submit) {
        _preview_submit.userInteractionEnabled = false;
        // [_preview_submit setTitle:@"adf" forState:UIControlStateNormal];
        [_preview_submit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    NSIndexPath *indexPath = self.indexPathForSelectedRow;
    switch (indexPath.section) {
        case kZero:{
            switch (indexPath.row) {
                case kZero:
                case kOne:{
                    _preview_label.text = text;
                }
                    break;
                case kTwo:{
                    // 百位
                    NSString *hDigits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(0, 1)] : @"0";
                    // 十位
                    NSString *tDigits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(1, 1)] : @"0";
                    
                    // 个位
                    NSString *digits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(2, 1)] : @"0";
                    
                    // 单位
                    NSString *unit = _preview_label.text ? [_preview_label.text substringWithRange:fRange(3, 2)] : @"MB";
                    
                    NSMutableArray *preview_labels = [NSMutableArray arrayWithArray:@[hDigits,tDigits,digits,unit]] ;
                    
                    preview_labels[component] = text;
                    
                    NSMutableString *preview_stringM = [NSMutableString string];
                    NSMutableString *marks_String0 = [NSMutableString string];
                    
                    for (int i = 0; i < [MealFlows count]; ++i) {
                        [preview_stringM appendString:preview_labels[i]];
                        
                        // 排除单位的字段
                        if (i < [MealFlows count] - 1) {
                            [marks_String0 appendString:preview_labels[i]];
                        }else {
                            _mark_String0_unit = preview_labels[i];
                        }
                    }
                    
                    // 总流量
                    _mark_String0 = [marks_String0 copy];
                    _preview_label.text = preview_stringM;
                }
                    break;
            }
        }
            
            break;
        case kOne:{
            switch (indexPath.row) {
                case kZero:{
                    // 百位
                    NSString *hDigits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(0, 1)] : @"0";
                    // 十位
                    NSString *tDigits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(1, 1)] : @"0";
                    
                    // 个位
                    NSString *digits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(2, 2)] : @"0.";
 
                    // 十分位
                    NSString *decile = _preview_label.text ? [_preview_label.text substringWithRange:fRange(4, 1)] : @"0";
                    // 单位
                    NSString *unit = _preview_label.text ? [_preview_label.text substringWithRange:fRange(5, 2)] : @"MB";
                    
                    NSMutableArray *preview_labels = [NSMutableArray arrayWithArray:@[hDigits,tDigits,digits,decile,unit]] ;
                    
                    preview_labels[component] = text;
                    
                    NSMutableString *preview_stringM = [NSMutableString string];
                    NSMutableString *marks_String1 = [NSMutableString string];
                    
                    for (int i = 0; i < [UsedFlows count]; ++i) {
                        [preview_stringM appendString:preview_labels[i]];
                        
                        if (i < [UsedFlows count] - 1) {
                            [marks_String1 appendString:preview_labels[i]];
                        }else {
                            // - 单位
                            _mark_String1_unit = preview_labels[i];
                        }
                    }
                    
                    //  - 值
                    // 已使用流量
                    _mark_String1 = [marks_String1 copy];
                    _preview_label.text = preview_stringM;
                    
                }
                    break;
                case kOne:{
                    // 百位
                    NSString *hDigits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(0, 1)] : @"0";
                    // 十位
                    NSString *tDigits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(1, 1)] : @"0";
                    
                    // 个位
                    NSString *digits = _preview_label.text ? [_preview_label.text substringWithRange:fRange(2, 2)] : @"0.";
                    
                    // 十分位
                    NSString *decile = _preview_label.text ? [_preview_label.text substringWithRange:fRange(4, 1)] : @"0";
                    // 单位
                    NSString *unit = _preview_label.text ? [_preview_label.text substringWithRange:fRange(5, 2)] : @"MB";
                    
                    NSMutableArray *preview_labels = [NSMutableArray arrayWithArray:@[hDigits,tDigits,digits,decile,unit]] ;
                    
                    preview_labels[component] = text;
                    
                    NSMutableString *preview_stringM = [NSMutableString string];
                    NSMutableString *marks_String2 = [NSMutableString string];
                    
                    for (int i = 0; i < [LeftFlows count]; ++i) {
                        [preview_stringM appendString:preview_labels[i]];
                        
                        if (i < [LeftFlows count] - 1) {
                            [marks_String2 appendString:preview_labels[i]];
                        }else {
                            _mark_String2_unit = preview_labels[i];
                        }
                    }
                    
                    // 剩余流量
                    _mark_String2 = [marks_String2 copy];
                    _preview_label.text = preview_stringM;
                }
                    break;
                case kTwo:{
                    _preview_label.text = text;
                }
                    break;
            }
        }
            break;
    }
    
    if (_preview_submit) {
        _preview_submit.userInteractionEnabled = true;
        [_preview_submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

/// 点击遮罩视图,退下键盘,移除pickerview,隐藏遮罩层
- (void)maskClick:(UIGestureRecognizer *)tap {
    [self endEditing:true];
    
    [_picker_v removeFromSuperview];
    
    _picker_v = nil;
    _accessory_v = nil;
    _preview_label = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        _mask_v.alpha = 0.0;
//        [_mask_v removeFromSuperview];
//        _mask_v = nil;
    }];
}

/// 完成修改按钮点击触发额事件
- (void)submitClick:(UIButton *)sender {
    NSIndexPath *indexPath = self.indexPathForSelectedRow;
    JXSetMealTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    if (_persistent == nil) {
        _persistent = [[JXMealPersistent alloc] init];
    }


    switch (indexPath.section) {
        case kZero:{
            switch (indexPath.row) {
                case kZero:{
                    // JXLog(@"%zd",[[_preview_label.text filterDigital:JXRegularDigitalTypeDefault] integerValue]);
                    _persistent.cal_meal_cycle = [[_preview_label.text filterDigital:JXRegularDigitalTypeDefault] integerValue];
                }
                    break;
                case kOne:{
                    _persistent.cal_settle_date = [[_preview_label.text filterDigital:JXRegularDigitalTypeDefault] integerValue];
                }
                    break;
                case kTwo:{
                    _persistent.cal_total_flow = [_mark_String0 doubleValue];
                    _persistent.cal_total_flow_unit = _mark_String0_unit;
                }
                    break;
            }
            _persistent.change_status = @"true";
        }
            break;
        case kOne:{
            switch (indexPath.row) {
                case kZero:{
                    _persistent.cal_used_flow = [_mark_String1 doubleValue];
                    _persistent.cal_used_flow_unit = _mark_String1_unit;
                }
                    break;
                case kOne:{
                    _persistent.cal_left_flow = [_mark_String2 doubleValue];
                    _persistent.cal_left_flow_unit = _mark_String2_unit;
                    
                }
                    break;
                case kTwo:{
                    _persistent.cal_not_clear_flow = [[_preview_label.text filterDigital:JXRegularDigitalTypeDefault] integerValue];
                }
                    break;
            }
            _persistent.change_status = @"true";
        }
            break;
    }
    cell.desc_field_v.text = _preview_label.text;
    [self maskClick:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(_mask_v.alpha < 0.6){
        [UIView animateWithDuration:0.5 animations:^{
            _mask_v.alpha = 0.6;
        }];
    }
    return true;
}


#pragma mark - lazyload
- (UIToolbar *)accessory_v {
    if (_accessory_v == nil) {
        UIToolbar *accessory_v = [[UIToolbar alloc] initWithFrame:fRect(0, 0, Screen_width, 40)];
        
        // 完成按钮
        UIButton *submit_btn = [[UIButton alloc] initWithFrame:fRect(accessory_v.w * 0.66 + 5, 5, accessory_v.w * 0.34 - 10, accessory_v.h - 10)];
        submit_btn.backgroundColor = HexRGB(0xffffff);
        // [UIColor colorWithWhite:0 alpha:0.6];
        submit_btn.titleLabel.font = kCommonFonts_1(17);
        // JXLog(@"%@",[UIFont familyNames]);
        [submit_btn setTitle:@"完成" forState:UIControlStateNormal];
        [submit_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submit_btn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _preview_submit = submit_btn;
        
        // 预览结果
        UILabel *preview_label = [[UILabel alloc] initWithFrame:fRect(5, 5, accessory_v.w - submit_btn.w - 15, accessory_v.h - 10)];
        preview_label.backgroundColor = HexRGB(0xffffff);
        preview_label.font = kCommonFonts_1(17);
        preview_label.textAlignment = NSTextAlignmentCenter;
        _preview_label = preview_label;
        
        [accessory_v addSubview:preview_label];
        [accessory_v addSubview:submit_btn];
        return accessory_v;
    }
    return _accessory_v;
}

@end
