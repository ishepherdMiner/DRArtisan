//
//  JXMealPersistent.m
//  Flow
//
//  Created by Jason on 8/20/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXMealPersistent.h"

#define kFlowFile [NSString stringWithFormat:@"%@/%@",kDir_Doc,@"JXFlow.plist"]

NSString *kOlder = @"older";
NSString *kCurrentMonth = @"current_month";
NSString *kRegTimestamp = @"reg_timestamp";
NSString *kRunningTime = @"running_time";
NSString *kChangeStatus = @"change_status";
NSString *kCalTotalFlow = @"cal_total_flow";
NSString *kCalTotalFlowUnit = @"cal_total_flow_unit";
NSString *kCalUsedFlow = @"cal_used_flow";
NSString *kCalUsedFlowUnit = @"cal_used_flow_unit";
NSString *kCalLeftFlow = @"cal_left_flow";
NSString *kCalLeftFlowUnit = @"cal_left_flow_unit";
NSString *kCalSettleDate = @"cal_settle_date";
NSString *kCalMealCycle = @"cal_meal_cycle";
NSString *kCalBootFlow = @"cal_boot_flow";
NSString *kCalNotClearFlow = @"cal_not_clear_flow";
NSString *kMinBootFlow = @"min_running_time";
NSString *kLeftFlowMonthDic = @"left_flow_month_dic";


@implementation JXMealPersistent

+ (void)storeModel:(id)persistent{
    [NSKeyedArchiver archiveRootObject:persistent toFile:kFlowFile];
}

+ (instancetype)accessModel {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kFlowFile];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    _reg_timestamp = [aDecoder decodeDoubleForKey:kRegTimestamp];
    _init_running_time = [aDecoder decodeDoubleForKey:kRunningTime];
    _older = [aDecoder decodeBoolForKey:kOlder];
    _current_month = [aDecoder decodeIntegerForKey:kCurrentMonth];
    _change_status = [aDecoder decodeObjectForKey:kChangeStatus];
    _cal_boot_flow = [aDecoder decodeDoubleForKey:kCalBootFlow];
    _cal_total_flow = [aDecoder decodeDoubleForKey:kCalTotalFlow];
    _cal_total_flow_unit = [aDecoder decodeObjectForKey:kCalTotalFlowUnit];
    _cal_used_flow = [aDecoder decodeDoubleForKey:kCalUsedFlow];
    _cal_used_flow_unit = [aDecoder decodeObjectForKey:kCalUsedFlowUnit];
    _cal_left_flow = [aDecoder decodeDoubleForKey:kCalLeftFlow];
    _cal_left_flow_unit = [aDecoder decodeObjectForKey:kCalLeftFlowUnit];
    _cal_settle_date = [aDecoder decodeIntegerForKey:kCalSettleDate];
    _cal_meal_cycle = [aDecoder decodeIntegerForKey:kCalMealCycle];
    _cal_not_clear_flow = [aDecoder decodeIntegerForKey:kCalNotClearFlow];
    _min_running_time = [aDecoder decodeDoubleForKey:kMinBootFlow];
    _left_flow_month_dic = [aDecoder decodeObjectForKey:kLeftFlowMonthDic];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_reg_timestamp forKey:kRegTimestamp];
    [aCoder encodeDouble:_init_running_time forKey:kRunningTime];
    [aCoder encodeBool:_older forKey:kOlder];
    [aCoder encodeInteger:_current_month forKey:kCurrentMonth];
    [aCoder encodeObject:_change_status forKey:kChangeStatus];
    [aCoder encodeDouble:_cal_boot_flow forKey:kCalBootFlow];
    [aCoder encodeDouble:_cal_total_flow forKey:kCalTotalFlow];
    [aCoder encodeObject:_cal_total_flow_unit forKey:kCalTotalFlowUnit];
    [aCoder encodeDouble:_cal_used_flow forKey:kCalUsedFlow];
    [aCoder encodeObject:_cal_used_flow_unit forKey:kCalUsedFlowUnit];
    [aCoder encodeDouble:_cal_left_flow forKey:kCalLeftFlow];
    [aCoder encodeObject:_cal_left_flow_unit forKey:kCalLeftFlowUnit];
    [aCoder encodeInteger:_cal_settle_date forKey:kCalSettleDate];
    [aCoder encodeInteger:_cal_meal_cycle forKey:kCalMealCycle];
    [aCoder encodeInteger:_cal_not_clear_flow forKey:kCalNotClearFlow];
    [aCoder encodeDouble:_min_running_time forKey:kMinBootFlow];
    [aCoder encodeObject:_left_flow_month_dic forKey:kLeftFlowMonthDic];
}


#pragma mark - computer property
- (NSString *)total_flow {
    if (self.cal_total_flow == 0) {
        return @"";
    }
    
    if (self.cal_total_flow_unit) {
       return [[NSString stringWithFormat:@"%.1f",self.cal_total_flow] stringByAppendingString:self.cal_total_flow_unit];
    }
    return @"";
}

- (NSString *)used_flow {
    if (self.cal_used_flow == 0) {
        return @"";
    }
    if (self.cal_used_flow_unit) {
        return [[NSString stringWithFormat:@"%.1f",self.cal_used_flow] stringByAppendingString:self.cal_used_flow_unit];
    }
    return @"";
}

- (NSString *)left_flow {
    if (self.cal_left_flow == 0) {
        return @"";
    }
    if (self.cal_left_flow_unit) {
        return [[NSString stringWithFormat:@"%.1f",self.cal_left_flow] stringByAppendingString:self.cal_left_flow_unit];
    }
    return @"";
}

- (NSString *)settle_date {
    if (self.cal_settle_date == 0) {
        return @"01 日";
    }
    
    if (self.cal_settle_date) {
        // 一位数
        if (@(self.cal_settle_date).stringValue.length == kOne) {
            return [[@"0" stringByAppendingString:@(self.cal_settle_date).stringValue] stringByAppendingString:@" 日"];
        }else if(@(self.cal_settle_date).stringValue.length == kTwo) {
            return [@(self.cal_settle_date).stringValue stringByAppendingString:@" 日"];
        }
    }
    
    return @"01 日";
}

- (NSString *)meal_cycle {
    if (self.cal_meal_cycle == 0) {
        return @"每 1 月";
    }
    
    if (self.cal_meal_cycle) {
        return [[@"每" stringByAppendingString:@(self.cal_meal_cycle).stringValue] stringByAppendingString:@" 月"];

//        if (@(self.cal_meal_cycle).stringValue.length == kOne) {
//            return [[@"每" stringByAppendingString:@(self.cal_meal_cycle).stringValue] stringByAppendingString:@" 月"];
//        }
    }
    return @"每 1 月";
}

- (NSString *)not_clear_flow {
    if (self.cal_not_clear_flow == 0) {
        return @"每 2 月";
    }
    
    if (self.cal_not_clear_flow) {
        if (@(self.cal_not_clear_flow).stringValue.length == kOne) {
            return [[@"每 " stringByAppendingString:@(self.cal_not_clear_flow).stringValue] stringByAppendingString:@" 月"];
        }

    }
    return @"每 2 月";
}

@end
