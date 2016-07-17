//
//  DSNumberLabel.h
//  DataStream
//
//  Created by Jason on 4/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSNumberLabel : UILabel

- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(float)startNumber
                      toNumber:(float)endNumber;

- (void)jumpNumber;

@end
