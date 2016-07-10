//
//  BaseObject.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

- (NSString *)description {
    NSMutableString *descM = [NSMutableString stringWithFormat:@"<%@ %p>\n",self,self];
    for (NSString *property in [[self class] jas_propertyList]) {
        [descM appendString:[NSString stringWithFormat:@"%@ => %@",property,[self valueForKey:property]]];
    }
    return descM;
}
@end
