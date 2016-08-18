//
//  SetMealTableViewCell.m
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SetMealTableViewCell.h"

@interface SetMealTableViewCell ()

@property (nonatomic,weak) UILabel *title_v;

@property (nonatomic,weak) UITextField *desc_field_v;

@property (nonatomic,strong) SetMealCellModel *model;
@end

@implementation SetMealTableViewCell

- (void)injectedModel:(id)model {
    _model = model;
    
    self.title_v.text = _model.meal_question;
    self.desc_field_v.text = _model.meal_answer;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.indexPath.section == kTwo){
        self.cell_type = MealCellTypeCenter;
        self.title_v.textColor = DEFAULT_COLOR;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.desc_field_v removeFromSuperview];
    }
    
    // _model.cell_h = 50;    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title_v = [[UILabel alloc] init];
        title_v.textColor = DEFAULT_FONT_COLOR;
        self.cell_type = MealCellTypeLeft;
        
        UITextField *desc_field_v = [[UITextField alloc] init];
        desc_field_v.font = [UIFont systemFontOfSize:17];
        desc_field_v.textAlignment = NSTextAlignmentRight;
        desc_field_v.userInteractionEnabled = false;
        
        [self.contentView addSubview:_desc_field_v = desc_field_v];
        [self.contentView addSubview:_title_v = title_v];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize title_s = [_title_v.text singleLineWithFont:[UIFont systemFontOfSize:17]];
    if (self.cell_type == MealCellTypeLeft) {
        _title_v.x = 10;
    }else if(self.cell_type == MealCellTypeCenter){
        _title_v.x = self.contentView.centerX - title_s.width * 0.5;
    }
    _title_v.frame = fRect(_title_v.x, self.contentView.centerY - title_s.height * 0.5, title_s.width, title_s.height);
    
    CGSize desc_field_s = [_desc_field_v.text singleLineWithFont:[UIFont systemFontOfSize:17]];
    _desc_field_v.frame = fRect(Screen_width - 200 - 40, self.contentView.centerY - desc_field_s.height * 0.5, 200 + 10, desc_field_s.height);
    
    UIView *mask_v = [[UIView alloc] initWithFrame:_desc_field_v.frame];
    mask_v.userInteractionEnabled = false;
    mask_v.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:mask_v];
}

@end
