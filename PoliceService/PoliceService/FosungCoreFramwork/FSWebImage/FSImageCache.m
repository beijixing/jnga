//
//  FSImageCache.m
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSImageCache.h"
#import "SDImageCache.h"
@interface FSImageCache()
@property(nonatomic, strong) SDImageCache *imageCache;
@end
@implementation FSImageCache

+ (FSImageCache *)sharedImageCache {
    static FSImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[FSImageCache alloc] init];
    });
    return imageCache;
}

- (id)initWithNamespace:(NSString *)ns {
    if (self = [super init]) {
        self.imageCache = [[SDImageCache alloc] initWithNamespace:ns];
    }
    return self;
}

- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory {
    if (self = [super init]) {
        self.imageCache = [[SDImageCache alloc] initWithNamespace:ns diskCacheDirectory:directory];
    }
    return self;
}

-(NSString *)makeDiskCachePath:(NSString*)fullNamespace {
    return [self.imageCache makeDiskCachePath:fullNamespace];
}

- (void)addReadOnlyCachePath:(NSString *)path {
    [self.imageCache addReadOnlyCachePath:path];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [self.imageCache storeImage:image forKey:key];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk {
    [self.imageCache storeImage:image forKey:key toDisk:toDisk];
}

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk {
    [self.imageCache storeImage:image recalculateFromImage:recalculate imageData:imageData forKey:key toDisk:toDisk];
}

- (void)storeImageDataToDisk:(NSData *)imageData forKey:(NSString *)key {
    [self.imageCache storeImageDataToDisk:imageData forKey:key];
}

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(FSWebImageQueryCompletedBlock)doneBlock {
    return [self.imageCache queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
        if (doneBlock) {
            doneBlock(image, (FSImageCacheType)cacheType);
        }
    }];
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [self.imageCache imageFromMemoryCacheForKey:key];
}

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    return [self.imageCache imageFromDiskCacheForKey:key];
}

- (void)removeImageForKey:(NSString *)key {
    [self.imageCache removeImageForKey:key];
}

- (void)removeImageForKey:(NSString *)key withCompletion:(FSWebImageNoParamsBlock)completion {
    [self.imageCache removeImageForKey:key withCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk {
    [self.imageCache removeImageForKey:key fromDisk:fromDisk];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(FSWebImageNoParamsBlock)completion {
    [self.imageCache removeImageForKey:key fromDisk:fromDisk withCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)clearMemory {
    [self.imageCache clearMemory];
}

- (void)clearDiskOnCompletion:(FSWebImageNoParamsBlock)completion {
    [self.imageCache clearDiskOnCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)clearDisk {
    [self.imageCache clearDisk];
}

- (void)cleanDiskWithCompletionBlock:(FSWebImageNoParamsBlock)completionBlock {
    [self.imageCache cleanDiskWithCompletionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)cleanDisk {
    [self.imageCache cleanDisk];
}

- (NSUInteger)getSize {
    return [self.imageCache getSize];
}

- (NSUInteger)getDiskCount {
    return [self.imageCache getDiskCount];
}

- (void)calculateSizeWithCompletionBlock:(FSWebImageCalculateSizeBlock)completionBlock {
    [self.imageCache calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        if (completionBlock) {
            completionBlock(fileCount, totalSize);
        }
    }];
}

- (void)diskImageExistsWithKey:(NSString *)key completion:(FSWebImageCheckCacheCompletionBlock)completionBlock {
    [self.imageCache diskImageExistsWithKey:key completion:^(BOOL isInCache) {
        
    }];
}

- (BOOL)diskImageExistsWithKey:(NSString *)key {
    return [self.imageCache diskImageExistsWithKey:key];
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    return [self.imageCache cachePathForKey:key inPath:path];
}

- (NSString *)defaultCachePathForKey:(NSString *)key
{
    return [self.imageCache defaultCachePathForKey:key];
}


- (void)setShouldDecompressImages:(BOOL)shouldDecompressImages {
    self.imageCache.shouldDecompressImages = shouldDecompressImages;
}

- (void)setShouldDisableiCloud:(BOOL)shouldDisableiCloud {
    self.imageCache.shouldDisableiCloud = shouldDisableiCloud;
}

- (void)setShouldCacheImagesInMemory:(BOOL)shouldCacheImagesInMemory {
    self.imageCache.shouldCacheImagesInMemory = shouldCacheImagesInMemory;
}

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.imageCache.maxMemoryCost = maxMemoryCost;
}

- (void)setMaxMemoryCountLimit:(NSUInteger)maxMemoryCountLimit {
    self.imageCache.maxMemoryCountLimit = maxMemoryCountLimit;
}

- (void)setMaxCacheAge:(NSInteger)maxCacheAge {
    self.imageCache.maxCacheAge = maxCacheAge;
}

- (void)setMaxCacheSize:(NSUInteger)maxCacheSize {
    self.imageCache.maxCacheSize = maxCacheSize;
}

-(SDImageCache *)imageCache {
    if (_imageCache) {
        return _imageCache;
    }
    _imageCache = [SDImageCache sharedImageCache];
    return _imageCache;
}
@end
