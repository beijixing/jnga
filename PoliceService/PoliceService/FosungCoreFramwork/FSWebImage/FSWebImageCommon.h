//
//  FSWebImageCommon.h
//  FosungCore
//
//  Created by horse on 2017/1/19.
//  Copyright © 2017年 zgl. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef FSWebImageCommon_h
#define FSWebImageCommon_h

typedef NS_ENUM(NSInteger, FSImageCacheType) {
    /**
     * The image wasn't available the FSWebImage caches, but was downloaded from the web.
     */
    FSImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    FSImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    FSImageCacheTypeMemory
};

typedef void(^FSWebImageQueryCompletedBlock)(UIImage *image, FSImageCacheType cacheType);

typedef void(^FSWebImageCheckCacheCompletionBlock)(BOOL isInCache);

typedef void(^FSWebImageCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

typedef NS_OPTIONS(NSUInteger, FSWebImageOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    FSWebImageRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    FSWebImageLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching
     */
    FSWebImageCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    FSWebImageProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of FSWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embedded cache busting parameter.
     */
    FSWebImageRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    FSWebImageContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    FSWebImageHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     */
    FSWebImageAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, images are loaded in the order in which they were queued. This flag moves them to
     * the front of the queue.
     */
    FSWebImageHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     */
    FSWebImageDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    FSWebImageTransformAnimatedImage = 1 << 10,
    
    /**
     * By default, image is added to the imageView after download. But in some cases, we want to
     * have the hand before setting the image (apply a filter or add it with cross-fade animation for instance)
     * Use this flag if you want to manually set the image in the completion when success
     */
    FSWebImageAvoidAutoSetImage = 1 << 11
};

typedef void(^FSWebImageCompletionBlock)(UIImage *image, NSError *error, FSImageCacheType cacheType, NSURL *imageURL);

typedef void(^FSWebImageCompletionWithFinishedBlock)(UIImage *image, NSError *error, FSImageCacheType cacheType, BOOL finished, NSURL *imageURL);

typedef NSString *(^FSWebImageCacheKeyFilterBlock)(NSURL *url);

typedef NS_OPTIONS(NSUInteger, FSWebImageDownloaderOptions) {
    FSWebImageDownloaderLowPriority = 1 << 0,
    FSWebImageDownloaderProgressiveDownload = 1 << 1,
    
    /**
     * By default, request prevent the use of NSURLCache. With this flag, NSURLCache
     * is used with default policies.
     */
    FSWebImageDownloaderUseNSURLCache = 1 << 2,
    
    /**
     * Call completion block with nil image/imageData if the image was read from NSURLCache
     * (to be combined with `FSWebImageDownloaderUseNSURLCache`).
     */
    
    FSWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    
    FSWebImageDownloaderContinueInBackground = 1 << 4,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    FSWebImageDownloaderHandleCookies = 1 << 5,
    
    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     */
    FSWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,
    
    /**
     * Put the image in the high priority queue.
     */
    FSWebImageDownloaderHighPriority = 1 << 7,
};

typedef NS_ENUM(NSInteger, FSWebImageDownloaderExecutionOrder) {
    /**
     * Default value. All download operations will execute in queue style (first-in-first-out).
     */
    FSWebImageDownloaderFIFOExecutionOrder,
    
    /**
     * All download operations will execute in stack style (last-in-first-out).
     */
    FSWebImageDownloaderLIFOExecutionOrder
};

extern NSString *const FSWebImageDownloadStartNotification;
extern NSString *const FSWebImageDownloadStopNotification;

typedef void(^FSWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^FSWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

typedef NSDictionary *(^FSWebImageDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

typedef void(^FSWebImageNoParamsBlock)();

#endif /* FSWebImageCommon_h */
