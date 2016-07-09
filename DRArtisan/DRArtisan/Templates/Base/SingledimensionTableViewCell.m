//
//  SingledimensionTableViewCell.m
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SingledimensionTableViewCell.h"

@implementation SingledimensionTableViewCell

- (void)setModel:(id)model {
    _model = model;
    self.textLabel.text = (NSString *)model;
    
    //
    ////  NSDictionary *modelDic = (NSDictionary *)model;
    ////  self.textLabel.text = [modelDic valueForKey:@"title"];
    ////  self.detailTextLabel.text = [modelDic valueForKey:@"desc"];
}

@end
