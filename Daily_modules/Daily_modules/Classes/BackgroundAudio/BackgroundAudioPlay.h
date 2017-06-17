//
//  BackgroundAudioPlay.h
//  Market
//
//  Created by Jason on 4/4/16.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundAudioPlay : NSObject
/// [[BackgroundAudioPlay sharedBgAudioPlay] playSound];
+ (instancetype)sharedBgAudioPlay;
- (void)playSound;
@end
