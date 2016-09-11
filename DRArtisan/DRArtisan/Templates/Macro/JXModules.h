//
//  JXModules.h
//  DRArtisan
//
//  Created by Jason on 9/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#ifndef JXModules_h
#define JXModules_h

/// Cabability Switch
// if you define it, you should manual link libz.x.x.x.tbd framework at present
// #define Add_Data_Zip_Capability

#ifdef Add_Data_Zip_Capability
    #import <zlib.h>
#endif

#endif /* JXModules_h */
