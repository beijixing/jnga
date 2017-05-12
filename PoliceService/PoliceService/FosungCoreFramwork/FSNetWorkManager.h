//
//  FSNetWorkManager.h
//  FosungCore
//
//  Created by horse on 2017/1/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface FSNetWorkManager : NSObject
/*
    设置请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) NSURL *baseUrl;

@property (nonatomic, strong) NSURLSessionConfiguration *urlConfig;
/*
    创建并返回FSNetWorkManager 实例
 */
+ (instancetype)manager;

/**
    创建get请求，将获得的数据用 resultBlock 返回给调用的地方进行处理。
 @param url 请求的url地址 如：http://xxx.xxx.com/get。
 @param parameter 请求参数 参数类型为id ，可能的参数类型为Nsstring、NSArray、NSDictionary等。
 @param resultBlock 服务端返回结果的回调block，如果请求成功 resultBlock 的success参数为true，否则为false，object参数中包含返回的数据。
*/
- (void)getDataWithHostUrl:(NSString *)url
                parameters:(id)parameter
                result:(void(^)(BOOL success, id object))resultBlock;


/**
    创建post请求，将获得的数据用 resultBlock 返回给调用的地方进行处理。
 @param url 请求的url地址 如：http://xxx.xxx.com/post。
 @param parameter 请求参数 参数类型为id ，可能的参数类型为Nsstring、NSArray、NSDictionary等。
 @param resultBlock 服务端返回结果的回调block，如果请求成功 resultBlock 的success参数为true，
 否则为false，object参数中包含返回的数据。
*/
- (void)postDataWithHostUrl:(NSString *)url
                parameters:(id)parameter
                result:(void(^)(BOOL success, id object))resultBlock;

/**
    上传图片到服务器，将结果用 resultBlock 返回给调用的地方进行处理。
 @param url 请求的url地址 如：http://xxx.xxx.com/upload。
 @param parameter 请求参数 参数类型为id ，可能的参数类型为Nsstring、NSArray、NSDictionary等。
 @param imagePath 上传图片的本地路径。
 @param suffix   图片的后缀名 如：png/jpeg。
 @param uploadProgress 上传进度的回调block， 如果不需要显示进度，参数可以设置为nil；
 如果要在uploadProgress block中处理UI更新，请切换到主线程处理。
 @param resultBlock 服务端返回结果的回调block，如果请求成功 resultBlock 的success参数为true，
 否则为false，object参数中包含返回的数据。
 */
- (void)uploadImageWithUrl:(NSString *)url
                parameters:(id)parameter
                imagePath:(NSString *)imagePath
                suffix:(NSString *)suffix
                progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                result:(void(^)(BOOL success, id object))resultBlock;
/**
    上传文件到服务器，将结果用 resultBlock 返回给调用的地方进行处理。
 @param url 请求的url地址 如：http://xxx.xxx.com/upload。
 @param filePath 上传文件的本地路径。
 @param uploadProgress 上传进度的回调block， 如果不需要显示进度，参数可以设置为nil；
 如果要在uploadProgress block中处理UI更新，请切换到主线程处理。
 @param resultBlock 服务端返回结果的回调block，如果请求成功 resultBlock 的success参数为true，
 否则为false，object参数中包含返回的数据。
 */
- (void)uploadFileWithUrl:(NSString *)url
                    filePath:(NSString *)filePath
                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                    result:(void(^)(BOOL success, id object))resultBlock;

/**
 下载文件，将结果用 resultBlock 返回给调用的地方进行处理。
 @param url 请求的url地址 如：http://xxx.xxx.com/download/file。
 @param destFilePath 下载文件的本地存储路径。
 @param downloadProgress 下载进度的回调block， 如果不需要显示进度，参数可以设置为nil；
 如果要在downloadProgress block中处理UI更新，请切换到主线程处理。
 @param resultBlock 服务端返回结果的回调block，如果请求成功 resultBlock 的success参数为true，
 否则为false，object参数中包含返回的数据。
 */
- (void)downLoadFileWithUrl:(NSString *)url
                destFilePath:(NSString *)destFilePath
                progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                result:(void(^)(BOOL success, id object))resultBlock;

@end

typedef NS_ENUM(NSInteger, FSNetworkReachabilityStatus) {
    FSNetworkReachabilityStatusUnknown          = -1,
    FSNetworkReachabilityStatusNotReachable     = 0,
    FSNetworkReachabilityStatusReachableViaWWAN = 1,
    FSNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface FSNetWorkManager(Reachability)
/*
    domain 要检测的是否可以访问的网络地址，一般为App接口的BaseUrl 如：http://123.321.234.12/App
 */
@property (nonatomic, strong) NSString *domain;
/*
    网络可访问状态
*/
@property(readonly, nonatomic, assign) FSNetworkReachabilityStatus networkReachabilityStatus;

/**
    当前网络是否可访问
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
/**
    当前访问网络是否是WWAN
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
    当前访问网络是否是WiFi
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/**
    开始监测网络状态变化
 */
- (void)startMonitoring;

/**
    停止监测网络状态
 */
- (void)stopMonitoring;

/**
 设置回调block ，当网络连接状态发生变化时调用。
 @param block 当网络连接状态发生变化时调用block， block的 status 参数表示当前的网络连接状态。
 */
- (void)setReachabilityStatusChangeBlock:(nullable void (^)(FSNetworkReachabilityStatus status))block;

@end

typedef NS_ENUM(NSUInteger, FSSSLPinningMode) {
    FSSSLPinningModeNone,
    FSSSLPinningModePublicKey,
    FSSSLPinningModeCertificate,
};

@interface FSNetWorkManager(SecurityPolicy)

@property (readonly, nonatomic, assign) FSSSLPinningMode SSLPinningMode;

/**
 The certificates used to evaluate server trust according to the SSL pinning mode.
 
 By default, this property is set to any (`.cer`) certificates included in the target compiling AFNetworking. Note that if you are using AFNetworking as embedded framework, no certificates will be pinned by default. Use `certificatesInBundle` to load certificates from your target, and then create a new policy by calling `policyWithPinningMode:withPinnedCertificates`.
 
 Note that if pinning is enabled, `evaluateServerTrust:forDomain:` will return true if any pinned certificate matches.
 */
@property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;

/**
 Whether or not to trust servers with an invalid or expired SSL certificates. Defaults to `NO`.
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 Whether or not to validate the domain name in the certificate's CN field. Defaults to `YES`.
 */
@property (nonatomic, assign) BOOL validatesDomainName;

///-----------------------------------------
/// @name Getting Certificates from the Bundle
///-----------------------------------------

/**
 Returns any certificates included in the bundle. If you are using AFNetworking as an embedded framework, you must use this method to find the certificates you have included in your app bundle, and use them when creating your security policy by calling `policyWithPinningMode:withPinnedCertificates`.
 
 @return The certificates included in the given bundle.
 */
- (NSSet <NSData *> *)getCertificatesInBundle:(NSBundle *)bundle;

///-----------------------------------------
/// @name Getting Specific Security Policies
///-----------------------------------------


///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns a security policy with the specified pinning mode.
 
 @param pinningMode The SSL pinning mode.
 
 */
- (void)policyWithPinningMode:(FSSSLPinningMode)pinningMode;

/**
 Creates and returns a security policy with the specified pinning mode.
 
 @param pinningMode The SSL pinning mode.
 @param pinnedCertificates The certificates to pin against.
 
 */
- (void)setPolicyPinningMode:(FSSSLPinningMode)pinningMode andPinnedCertificates:(NSSet <NSData *> *)pinnedCertificates;

///------------------------------
/// @name Evaluating Server Trust
///------------------------------

/**
 Whether or not the specified server trust should be accepted, based on the security policy.
 
 This method should be used when responding to an authentication challenge from a server.
 
 @param serverTrust The X.509 certificate trust of the server.
 @param domain The domain of serverTrust. If `nil`, the domain will not be validated.
 
 @return Whether or not to trust the server.
 */
- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(nullable NSString *)domain;
@end

NS_ASSUME_NONNULL_END
