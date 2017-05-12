//
//  UIImageView+FSWebCache.m
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "UIImageView+FSWebCache.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (FSWebCache)
- (NSURL *)fs_imageURL {
    return [self sd_imageURL];
}

- (void)fs_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url];
}

- (void)fs_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)fs_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)options];
}


- (void)fs_setImageWithURL:(NSURL *)url completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}


- (void)fs_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(FSWebImageCompletionBlock)completedBlock {
    
}

- (void)fs_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}

- (void)fs_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options progress:(FSWebImageDownloaderProgressBlock)progressBlock completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
             progressBlock(receivedSize, expectedSize);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}

//- (void)fs_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options progress:(FSWebImageDownloaderProgressBlock)progressBlock completed:(FSWebImageCompletionBlock)completedBlock {
//    
//}

- (void)fs_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}

- (void)fs_cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

- (void)fs_cancelCurrentAnimationImagesLoad {
    [self sd_cancelCurrentAnimationImagesLoad];
}

- (void)fs_setShowActivityIndicatorView:(BOOL)show {
    [self setShowActivityIndicatorView:show];
}

- (void)fs_setIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    [self setIndicatorStyle:style];
}
@end
