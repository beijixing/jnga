//
//  ALAsset+lExport.h
//  PoliceService
//
//  Created by fosung on 2017/5/25.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (lExport)
- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error;
@end
