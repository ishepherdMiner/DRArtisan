//
//  JXMealPersistent.m
//  Flow
//
//  Created by Jason on 8/20/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXMealPersistent.h"
#import "JXGlobal.h"

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
NSString *kRefreshSource = @"refresh_source";


@implementation JXMealPersistent

+ (NSUserDefaults *)flowDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.coderFlow"];
}

+ (void)storeModel:(JXMealPersistent *)pst{
    NSUserDefaults *flowDic = [self flowDefaults];
    [flowDic setObject:@(pst.reg_timestamp) forKey:kRegTimestamp];
    [flowDic setObject:@(pst.init_running_time) forKey:kRunningTime];
    [flowDic setObject:@(pst.older) forKey:kOlder];
    [flowDic setObject:@(pst.current_month) forKey:kCurrentMonth];
    [flowDic setObject:pst.change_status forKey:kChangeStatus];
    [flowDic setObject:@(pst.cal_boot_flow) forKey:kCalBootFlow];
    [flowDic setObject:@(pst.cal_total_flow) forKey:kCalTotalFlow];
    [flowDic setObject:pst.cal_total_flow_unit forKey:kCalTotalFlowUnit];
    [flowDic setObject:@(pst.cal_used_flow) forKey:kCalUsedFlow];
    [flowDic setObject:pst.cal_used_flow_unit forKey:kCalUsedFlowUnit];
    [flowDic setObject:@(pst.cal_left_flow) forKey:kCalLeftFlow];
    [flowDic setObject:pst.cal_left_flow_unit forKey:kCalLeftFlowUnit];
    [flowDic setObject:@(pst.cal_settle_date) forKey:kCalSettleDate];
    [flowDic setObject:@(pst.cal_meal_cycle) forKey:kCalMealCycle];
    [flowDic setObject:@(pst.cal_not_clear_flow) forKey:kCalNotClearFlow];
    [flowDic setObject:@(pst.min_running_time) forKey:kMinBootFlow];
    [flowDic setObject:[NSKeyedArchiver archivedDataWithRootObject:pst.left_flow_month_dic] forKey:kLeftFlowMonthDic];
    [flowDic setObject:@(pst.source) forKey:kRefreshSource];
    [flowDic synchronize];
//  [NSKeyedArchiver archiveRootObject:persistent toFile:kFlowFile];
}

+ (instancetype)accessModel {
    NSUserDefaults *flowDic = [self flowDefaults];
    JXMealPersistent *pst = [[JXMealPersistent alloc] init];
    pst.reg_timestamp = [[flowDic objectForKey:kRegTimestamp] doubleValue];
    pst.init_running_time = [[flowDic objectForKey:kRunningTime] doubleValue];
    pst.older = [[flowDic objectForKey:kOlder] boolValue];
    pst.current_month = [[flowDic objectForKey:kCurrentMonth] integerValue];
    pst.change_status = [flowDic objectForKey:kChangeStatus];
    pst.cal_boot_flow = [[flowDic objectForKey:kCalBootFlow] doubleValue];
    pst.cal_total_flow = [[flowDic objectForKey:kCalTotalFlow] doubleValue];
    pst.cal_total_flow_unit = [flowDic objectForKey:kCalTotalFlowUnit];
    pst.cal_used_flow = [[flowDic objectForKey:kCalUsedFlow] doubleValue];
    pst.cal_used_flow_unit = [flowDic objectForKey:kCalUsedFlowUnit];
    pst.cal_left_flow = [[flowDic objectForKey:kCalLeftFlow] doubleValue];
    pst.cal_left_flow_unit = [flowDic objectForKey:kCalLeftFlowUnit];
    pst.cal_settle_date = [[flowDic objectForKey:kCalSettleDate] integerValue];
    pst.cal_meal_cycle = [[flowDic objectForKey:kCalMealCycle] integerValue];
    pst.cal_not_clear_flow = [[flowDic objectForKey:kMinBootFlow] doubleValue];
    pst.left_flow_month_dic = [NSKeyedUnarchiver unarchiveObjectWithData:[flowDic objectForKey:kLeftFlowMonthDic]];
    pst.source = [[flowDic objectForKey:kRefreshSource] integerValue];
    // return [NSKeyedUnarchiver unarchiveObjectWithFile:kFlowFile];
    return pst;
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
        if (@(self.cal_settle_date).stringValue.length == 1) {
            return [[@"0" stringByAppendingString:@(self.cal_settle_date).stringValue] stringByAppendingString:@" 日"];
        }else if(@(self.cal_settle_date).stringValue.length == 2) {
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
