//
//  Capable.h
//  DRArtisan
//
//  Created by Jason on 8/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JXBaseCollectionView;

@interface Capable : NSObject

// - instance methods
+ (instancetype)capableWithCollectionView:(JXBaseCollectionView *)collectionView;


- (void)mobility;

@end
