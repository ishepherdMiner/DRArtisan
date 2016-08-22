//
//  JXMealPersistent.m
//  Flow
//
//  Created by Jason on 8/20/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXMealPersistent.h"

#define kFlowFile [NSString stringWithFormat:@"%@/%@",kDir_Doc,@"JXFlow.plist"]

NSString *kMealCycle = @"meal_cycle";
NSString *kSettleDate = @"settle_date";
NSString *kTotalFlow = @"total_flow";
NSString *kUsedFlow = @"used_flow";
// NSString *kLeftFlow = @"left_flow";
NSString *kCurrentMonth = @"current_month";
NSString *KOlder = @"older";

@implementation JXMealPersistent

+ (void)storeModel:(id)persistent{
    // JXLog(@"%@",[NSString stringWithFormat:@"%@/%@",kDir_Doc,kFlowFile]);
    [NSKeyedArchiver archiveRootObject:persistent toFile:kFlowFile];
}

+ (instancetype)accessModel {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kFlowFile];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    _meal_cycle = [aDecoder decodeObjectForKey:kMealCycle];
    _settle_date = [aDecoder decodeObjectForKey:kSettleDate];
    _total_flow = [aDecoder decodeObjectForKey:kTotalFlow];
    _used_flow = [aDecoder decodeObjectForKey:kUsedFlow];
//    _left_flow = [aDecoder decodeObjectForKey:kLeftFlow];
    _reg_timestamp = [aDecoder decodeDoubleForKey:@"reg_timestamp"];
    _running_time = [aDecoder decodeDoubleForKey:@"running_time"];
    _older = [aDecoder decodeBoolForKey:KOlder];
    _current_month = [aDecoder decodeIntegerForKey:kCurrentMonth];
    _change_status = [aDecoder decodeObjectForKey:@"change_status"];
    
    _cal_boot_flow = [aDecoder decodeDoubleForKey:@"cal_boot_flow"];
    _cal_used_flow = [aDecoder decodeDoubleForKey:@"cal_used_flow"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {    
    [aCoder encodeObject:_meal_cycle forKey:kMealCycle];
    [aCoder encodeObject:_settle_date forKey:kSettleDate];
    [aCoder encodeObject:_total_flow forKey:kTotalFlow];
    [aCoder encodeObject:_used_flow forKey:kUsedFlow];
//    [aCoder encodeObject:_left_flow forKey:kLeftFlow];
    [aCoder encodeDouble:_reg_timestamp forKey:@"reg_timestamp"];
    [aCoder encodeDouble:_running_time forKey:@"running_time"];
    [aCoder encodeBool:_older forKey:KOlder];
    [aCoder encodeInteger:_current_month forKey:kCurrentMonth];
    [aCoder encodeObject:_change_status forKey:@"change_status"];
    
    [aCoder encodeDouble:_cal_boot_flow forKey:@"cal_boot_flow"];
    [aCoder encodeDouble:_cal_used_flow forKey:@"cal_used_flow"];
}
@end
