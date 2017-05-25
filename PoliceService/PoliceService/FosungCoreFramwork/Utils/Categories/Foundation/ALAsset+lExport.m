//
//  ALAsset+lExport.m
//  PoliceService
//
//  Created by fosung on 2017/5/25.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ALAsset+lExport.h"
#define BufferSize 10000
@implementation ALAsset (lExport)
- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error
{
    [[NSFileManager defaultManager] createFileAtPath:[fileURL path] contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:fileURL error:error];
    if (!handle) {
        return NO;
    }
    
    ALAssetRepresentation *rep = [self defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:error];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    
    free(buffer);
    return YES;
}
@end
