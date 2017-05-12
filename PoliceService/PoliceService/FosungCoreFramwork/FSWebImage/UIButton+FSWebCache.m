//
//  UIButton+FSWebCache.m
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "UIButton+FSWebCache.h"
#import "UIButton+WebCache.h"
@implementation UIButton (FSWebCache)

- (NSURL *)fs_currentImageURL {
    return [self sd_currentImageURL];
}

- (NSURL *)fs_imageURLForState:(UIControlState)state {
    return [self sd_imageURLForState:state];
}

- (void)fs_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setImageWithURL:url forState:state];
}

- (void)fs_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder];
}

- (void)fs_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:(SDWebImageOptions)options];
}


- (void)fs_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}


- (void)fs_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}


- (void)fs_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:(SDWebImageOptions)options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];

}

- (void)fs_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setBackgroundImageWithURL:url forState:state];
}


- (void)fs_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder];
}

- (void)fs_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:(SDWebImageOptions)options];
}

- (void)fs_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}


- (void)fs_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}

- (void)fs_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(FSWebImageOptions)options completed:(FSWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:(SDWebImageOptions)options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (FSImageCacheType)cacheType, imageURL);
        }
    }];
}


- (void)fs_cancelImageLoadForState:(UIControlState)state {
    [self sd_cancelImageLoadForState:state];
}

- (void)fs_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self sd_cancelBackgroundImageLoadForState:state];
}
@end
