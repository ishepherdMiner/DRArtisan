//
//  SetMealTableView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SetMealTableView.h"
#import "JasFlowAnalytical.h"

@interface SetMealTableView () <BasePickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIPickerView *picker_v;
@property (nonatomic,weak) UIToolbar *accessory_v;

@property (nonatomic,strong) NSArray <UIView *> *unit_v_list;

@property (nonatomic,weak) UIView *mask_v;

/// 当前cell的索引
@property (nonatomic,strong) NSIndexPath *cur_index;

@end

@implementation SetMealTableView

#pragma mark - Lifecycle
/// in order to kvo,so override parent method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Why not set kvo in cell
    // It won't work because the cells are being reused. So when the cell goes off the screen it's not deallocated, it goes to reuse pool.
    // You shouldn't register notifications and KVO in cell. You should do it in table view controller instead and when the model changes you should update model and reload visible cells.
    // http://stackoverflow.com/questions/25056942/instance-was-deallocated-while-key-value-observers-were-still-registered-with-it
    SetMealTableViewCell *cell = (SetMealTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    for (UIView *sub_v in cell.contentView.subviews) {
        if ([sub_v isKindOfClass:[UITextField class]]) {
            [cell.desc_field_v addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    return cell;

}

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Events

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mask_v.alpha = 0.6;
    }];
    
#if 0
    // When this click index not equal to last index and _picker_v not equal to nil
    if (indexPath != self.cur_index && _picker_v) {
        [[[UIApplication sharedApplication].delegate window] endEditing:true];
        [_picker_v removeFromSuperview];
        _picker_v = nil;
    }
#endif
    
    // recoard current  index
    self.cur_index = indexPath;

    if(indexPath.section == kZero) {
        if (indexPath.row == kZero) {
            // 套餐周期
            // Will log appear follow infomation in sometimes
            // http://blog.csdn.net/x567851326/article/details/51251655
            // _BSMachError: (os/kern) invalid capability (20)
            // _BSMachError: (os/kern) invalid name (15)
            NSArray *picker_option_list = kMealCycleMonths;
            
            [self pickerViewWithList:picker_option_list indexPath:indexPath];
            
        }else if(indexPath.row == kOne) {
            // 结算日期
            NSArray *picker_option_list = kSettleDates;
            
            [self pickerViewWithList:picker_option_list indexPath:indexPath];
            
        }else if(indexPath.row == kTwo) {
            // 套餐流量
            [self fieldViewWithIndexPath:indexPath];
        }
    }else if(indexPath.section == kOne) {
        if (indexPath.row == kZero) {
           // 调整流量
            [self fieldViewWithIndexPath:indexPath];
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

- (void)fieldViewWithIndexPath:(NSIndexPath *)indexPath {
    SetMealTableViewCell *meal_cell_v = [self cellForRowAtIndexPath:indexPath];
    meal_cell_v.desc_field_v.userInteractionEnabled = true;
    meal_cell_v.desc_field_v.returnKeyType = UIReturnKeyDone;
    meal_cell_v.desc_field_v.delegate = self;
    meal_cell_v.desc_field_v.keyboardType = UIKeyboardTypeDecimalPad;
    meal_cell_v.desc_field_v.inputAccessoryView = _accessory_v = [self accessory_v];
    [meal_cell_v.desc_field_v becomeFirstResponder];
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

/// PickerView的代理方法
- (void)didSelectedPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component RowText:(NSString *)text {
    SetMealTableViewCell *cell = [self cellForRowAtIndexPath:self.cur_index];
    cell.desc_field_v.text = text;
}

/// 点击遮罩视图,退下键盘,移除pickerview,隐藏遮罩层
- (void)maskClick:(UIGestureRecognizer *)tap {
    [self endEditing:true];
    [_picker_v removeFromSuperview];
    _picker_v = nil;
    [UIView animateWithDuration:0.5 animations:^{
        _mask_v.alpha = 0.0;
    }];
    
    // reset _cur_index
    _cur_index = [NSIndexPath indexPathForRow:0 inSection:0];
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
    SetMealTableViewCell *cell = [self cellForRowAtIndexPath:self.cur_index];
    // 需要把流量单位也保存到用户配置中
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    
    // 调整使用量
    if(_cur_index.section == kOne) {
        if(unit_v.selected) {
            cell.desc_field_v.text = [cell.desc_field_v.text stringByAppendingString:@" M"];
            [userDefaults setObject:@" M" forKey:kUsedFlowUnit];
        }else {
            cell.desc_field_v.text = [cell.desc_field_v.text stringByAppendingString:@" G"];
            [userDefaults setObject:@" G" forKey:kUsedFlowUnit];
        }
    }else {
        if(unit_v.selected) {
            cell.desc_field_v.text = [cell.desc_field_v.text stringByAppendingString:@" M/月"];
            [userDefaults setObject:@" M/月" forKey:kFlowUnit];
        }else {
            cell.desc_field_v.text = [cell.desc_field_v.text stringByAppendingString:@" G/月"];
            [userDefaults setObject:@" G/月" forKey:kFlowUnit];
        }
    }
    
    
    
    // cell.desc_field_v.x -= [cell.desc_field_v.text singleLineWithFont:[UIFont systemFontOfSize:17]].width;
    // cell.desc_field_v.w = [cell.desc_field_v.text singleLineWithFont:[UIFont systemFontOfSize:17]].width;
    
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    JasLog(@"change => %@",change);
    //
    NSMutableDictionary *desc_dicM = nil;
    if(self.desc_dic){
        desc_dicM = [self.desc_dic mutableCopy];
    }else {
        desc_dicM = [NSMutableDictionary dictionaryWithCapacity:kTotalCellNums];
        [desc_dicM setObject:@"false" forKey:@"change"];
    }
    
    // - mark 功能点:从文件中读取当前的这一次,如果最终没有变化,不需要弹窗提示,对_desc_dic的change值重新赋值
    
    
    if ([[desc_dicM objectForKey:@"change"] isEqualToString:@"false"]) {
        [desc_dicM setObject:@"true" forKey:@"change"];
    }
    
    // 找到具体是哪个cell的UITextField的值改变了
    NSUInteger nums = [self numberOfRowsInSection:kZero]; // 第一组的rows的数量
    
    // 如果数量越界
    BOOL transboundary = self.cur_index.row + self.cur_index.section * nums > kTotalCellNums;
    [desc_dicM setObject:change[@"new"] forKey:transboundary ? kNewDescValues[kTotalCellNums - 1]:
                                                               kNewDescValues[self.cur_index.row + self.cur_index.section * nums]];
    
    self.desc_dic = [desc_dicM copy];
}

#pragma mark - lazyload
- (UIToolbar *)accessory_v {
    if (_accessory_v == nil) {
        UIToolbar *accessory_v = [[UIToolbar alloc] initWithFrame:fRect(0, 0, Screen_width, 40)];
        
        // 单位:MB
        UIButton *mb_unit_btn = [[UIButton alloc] initWithFrame:fRect(0, 0, accessory_v.w * 0.33, accessory_v.h)];
        mb_unit_btn.backgroundColor = HexRGB(0x888888);
        [mb_unit_btn setTitle:@"MB" forState:UIControlStateNormal];
        [mb_unit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mb_unit_btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [mb_unit_btn addTarget:self action:@selector(unitClick:) forControlEvents:UIControlEventTouchUpInside];
        mb_unit_btn.selected = true;
        
        // 单位:GB
        UIButton *gb_unit_btn = [[UIButton alloc] initWithFrame:fRect(accessory_v.w * 0.33, 0, accessory_v.w * 0.33, accessory_v.h)];
        gb_unit_btn.backgroundColor = HexRGB(0x888888);
        [gb_unit_btn setTitle:@"GB" forState:UIControlStateNormal];
        [gb_unit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gb_unit_btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [gb_unit_btn addTarget:self action:@selector(unitClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 完成按钮
        UIButton *submit_btn = [[UIButton alloc] initWithFrame:fRect(accessory_v.w * 0.66, 0, accessory_v.w * 0.34, accessory_v.h)];
        submit_btn.backgroundColor = HexRGB(0x888888);
        submit_btn.titleLabel.font = [UIFont systemFontOfSize:13];
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
