//
//  JXSwitch.h
//  DRArtisan
//
//  Created by Jason on 9/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#ifndef JXSwitch_h
#define JXSwitch_h

/**
 *  Setting switch service
 *
 *  @author  WangDL
 *  @version 1.1
 *  @date    20160712
 */
#if DEBUG
    #define JXLog(fmt,...)    NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt),\
                                __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__); \
                                fprintf(stderr,"\n\n");

    #define JXBaseURL  @""
    #define JXError    JXLog(@"\n\tclass => %@ \n\tfunction => %s",self,__func__)
    #define JXFrame    JXLog(@"\n\tframe => %@",NSStringFromClass([self class]))
#else
    #define JXLog(...) {}
    #define JXBaseURL  @""
    #define JXError    {}
    #define JXFrame    {}
#endif

#endif /* JXSwitch_h */
