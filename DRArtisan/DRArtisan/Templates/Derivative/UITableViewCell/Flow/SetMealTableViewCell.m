//
//  SetMealTableViewCell.m
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SetMealTableViewCell.h"

#define kMeal_Section_Num   3

@interface SetMealTableViewCell ()

@property (nonatomic,weak) UILabel *title_v;

@property (nonatomic,weak) UITextField *desc_field_v;

@end

@implementation SetMealTableViewCell

- (void)setModel:(JASBaseCellModel *)model {
    _model = model;
    
    self.title_v.text = model.b_string;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([[self.owned_table_v locWithModel:model] section] == kMeal_Section_Num - 1) {
        self.cell_type = MealCellTypeCenter;
        self.title_v.textColor = DEFAULT_COLOR;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    CGFloat title_h = [_title_v.text singleLineWithFont:[UIFont systemFontOfSize:17]].height;
    model.cell_h = 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *title_v = [[UILabel alloc] init];
        title_v.textColor = DEFAULT_FONT_COLOR;
        self.cell_type = MealCellTypeLeft;
        
        UITextField *desc_field_v = [[UITextField alloc] init];
        
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
    
    CGSize desc_field_s = [_desc_field_v.text singleLineWithFont:[UIFont systemFontOfSize:15]];
    _desc_field_v.frame = fRect(Jas_Screen_width - 50, self.contentView.centerY - desc_field_s.height * 0.5, desc_field_s.width, desc_field_s.height);
    
}

@end
