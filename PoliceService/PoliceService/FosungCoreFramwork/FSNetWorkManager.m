//
//  FSNetWorkManager.m
//  FosungCore
//
//  Created by horse on 2017/1/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSNetWorkManager.h"
#import "AFNetworking.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAsset.h>
#import "ALAsset+lExport.h"
static FSNetWorkManager *manager = nil;

@interface FSNetWorkManager()
@end

@implementation FSNetWorkManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)uploadFileWithMediaData:(NSMutableArray *)mediaDatas progress:(nullable void (^)(NSProgress * _Nonnull))progress url:(NSString *)url params:(id)params  result:(void(^)(BOOL success, id object))resultBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (mediaDatas.count > 0) {
            
            
            for (int i=0; i<mediaDatas.count; i++) {
                NSObject *firstObj = [mediaDatas objectAtIndex:i];
                if ([firstObj isKindOfClass:[UIImage class]]) {
                    // 图片
                    UIImage *eachImg = [mediaDatas objectAtIndex:i];
                    //NSData *eachImgData = UIImagePNGRepresentation(eachImg);
                    NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
                    [formData appendPartWithFileData:eachImgData name:@"picfile" fileName:[NSString stringWithFormat:@"img%d.png", i+1] mimeType:@"image/png"];
                    
                }else if([firstObj isKindOfClass:[ALAsset class]]){
                    // 视频
                    ALAsset *asset = [mediaDatas objectAtIndex:i];
                    if (asset != nil) {
                        NSArray *documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *docuPath = [documentPaths objectAtIndex:0];
                        
                        NSString *videoPath= [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4", 0]];    // 这里直接强制写一个即可，之前计划是用i++来区分不明视频
                        NSURL *url = [NSURL fileURLWithPath:videoPath];
                        NSError *theErro = nil;
                        BOOL exportResult = [asset exportDataToURL:url error:&theErro];
                        NSLog(@"exportResult=%@", exportResult?@"YES":@"NO");
                        
                        NSData *videoData = [NSData dataWithContentsOfURL:url];
                        [formData appendPartWithFileData:videoData name:@"videosfile" fileName:@"video1.mp4" mimeType:@"video/mp4"];//name服务器字段名
                    }
                }
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        resultBlock(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"服务器的错误原因:%@",str);
        resultBlock(NO, error);
    }];

    
}

- (void)getDataWithHostUrl:(NSString *)url
                        parameters:(id)parameter
                        result:(void(^)(BOOL success, id object))resultBlock{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseUrl sessionConfiguration:self.urlConfig];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    self.urlConfig.HTTPAdditionalHeaders = [];
    NSString *fullUrl;
    fullUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = self.timeoutInterval != 0 ? self.timeoutInterval : 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", nil];
    [manager GET:url parameters:parameter progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            resultBlock(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            resultBlock(NO, error);
    }];
}

- (void)postDataWithHostUrl:(NSString *)url
                        parameters:(id)parameter
                        result:(void(^)(BOOL success, id object))resultBlock {
     AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseUrl sessionConfiguration:self.urlConfig];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    [manager POST:url parameters:parameter progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        resultBlock(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultBlock(NO, error);
    }];
}

- (void)uploadImageWithUrl:(NSString *)url
                parameters:(id)parameter
                imagePath:(NSString *)imagePath
                suffix:(NSString *)suffix
                progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                result:(void(^)(BOOL success, id object))resultBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseUrl sessionConfiguration:self.urlConfig];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/jpeg", @"image/png",nil];
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *imageSuffix = suffix!=nil ? [suffix lowercaseString] : @"png";
        if ([imageSuffix isEqualToString:@"png"]) {
            [formData appendPartWithFormData:UIImagePNGRepresentation([UIImage imageWithContentsOfFile:imagePath]) name:@"imagePath"];
        }else if([imageSuffix isEqualToString:@"jpeg"]) {
             [formData appendPartWithFileData: UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:imagePath], 1.0) name:@"FileData" fileName:imagePath mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull progress) {
        if (uploadProgress) {
            uploadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         resultBlock(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         resultBlock(NO, error);
    }];
}

- (void)uploadFileWithUrl:(NSString *)url
                 filePath:(NSString *)filePath
                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                 result:(void(^)(BOOL success, id object))resultBlock {
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseUrl sessionConfiguration:self.urlConfig];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:fileUrl progress:^(NSProgress * _Nonnull progress) {
        if (uploadProgress) {
            uploadProgress(progress);
        }
        } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            resultBlock(NO, error);
        } else {
            resultBlock(YES, responseObject);
        }
    }];
    [uploadTask resume];
}

- (void)downLoadFileWithUrl:(NSString *)url
                            destFilePath:(NSString *)destFilePath
                            progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                            result:(void(^)(BOOL success, id object))resultBlock{
    
    NSURL *URL = [NSURL URLWithString:url];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseUrl sessionConfiguration:self.urlConfig];    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull progress) {
        if (downloadProgress) {
            downloadProgress(progress);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:destFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            resultBlock(NO, response);
        }else {
            resultBlock(YES, filePath);
        }
    }];
    [downLoadTask resume];
}
@end


#pragma mark Reachability
static char reachabilityManagerKey;
@implementation FSNetWorkManager(Reachability)
- (AFNetworkReachabilityManager *)networkReachabilityManager:(NSString *)domain {
    AFNetworkReachabilityManager *reachabilityManager = objc_getAssociatedObject(self, &reachabilityManagerKey);
    if (reachabilityManager) {
        return reachabilityManager;
    }
    reachabilityManager = [AFNetworkReachabilityManager managerForDomain:domain];
    objc_setAssociatedObject(self, &reachabilityManagerKey, reachabilityManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return reachabilityManager;
}

- (void)setDomain:(NSString *)domain {
    objc_setAssociatedObject(self, &reachabilityManagerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self networkReachabilityManager:domain];
}

- (NSString *)domain {
    return @"";
}

- (FSNetworkReachabilityStatus)networkReachabilityStatus {
    return (FSNetworkReachabilityStatus)[self networkReachabilityManager:nil].networkReachabilityStatus;
}

- (BOOL)isReachable {
    return [self networkReachabilityManager:nil].reachable;
}

- (BOOL)isReachableViaWWAN {
    return [self networkReachabilityManager:nil].isReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return [self networkReachabilityManager:nil].isReachableViaWiFi;
}

- (void)startMonitoring {
    [[self networkReachabilityManager:nil] startMonitoring];
}

- (void)stopMonitoring {
    [self stopMonitoring];
}

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(FSNetworkReachabilityStatus status))block {
    [[self networkReachabilityManager:nil] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block((FSNetworkReachabilityStatus)status);
    }];
}
@end

@implementation FSNetWorkManager(SecurityPolicy)

- (FSSSLPinningMode)SSLPinningMode {
    return (FSSSLPinningMode)[AFHTTPSessionManager manager].securityPolicy.SSLPinningMode;
}

- (void)setPinnedCertificates:(NSSet<NSData *> *)pinnedCertificates {
    [[AFHTTPSessionManager manager].securityPolicy setPinnedCertificates:pinnedCertificates];
}

- (NSSet<NSData *> *)pinnedCertificates {
    return [AFHTTPSessionManager manager].securityPolicy.pinnedCertificates;
}

-(void)setAllowInvalidCertificates:(BOOL)allowInvalidCertificates {
    [AFHTTPSessionManager manager].securityPolicy.allowInvalidCertificates = allowInvalidCertificates;
}

- (BOOL)allowInvalidCertificates {
    return [AFHTTPSessionManager manager].securityPolicy.allowInvalidCertificates;
}


- (void)setValidatesDomainName:(BOOL)validatesDomainName {
    [AFHTTPSessionManager manager].securityPolicy.validatesDomainName = validatesDomainName;
}

- (BOOL)validatesDomainName {
    return [AFHTTPSessionManager manager].securityPolicy.validatesDomainName;
}

- (NSSet <NSData *> *)getCertificatesInBundle:(NSBundle *)bundle {
    return  [AFSecurityPolicy certificatesInBundle:bundle];
}


- (void)policyWithPinningMode:(FSSSLPinningMode)pinningMode {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningMode)pinningMode];
    securityPolicy.allowInvalidCertificates = [AFHTTPSessionManager manager].securityPolicy.allowInvalidCertificates;
    securityPolicy.pinnedCertificates = [AFHTTPSessionManager manager].securityPolicy.pinnedCertificates;
    securityPolicy.validatesDomainName = [AFHTTPSessionManager manager].securityPolicy.validatesDomainName;
    [AFHTTPSessionManager manager].securityPolicy = securityPolicy;
}


- (void)setPolicyPinningMode:(FSSSLPinningMode)pinningMode andPinnedCertificates:(NSSet <NSData *> *)pinnedCertificates {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningMode)pinningMode withPinnedCertificates:pinnedCertificates];
    securityPolicy.allowInvalidCertificates = [AFHTTPSessionManager manager].securityPolicy.allowInvalidCertificates;
    securityPolicy.validatesDomainName = [AFHTTPSessionManager manager].securityPolicy.validatesDomainName;
     [AFHTTPSessionManager manager].securityPolicy = securityPolicy;
}


- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(nullable NSString *)domain {
    return [[AFHTTPSessionManager manager].securityPolicy evaluateServerTrust:serverTrust forDomain:domain];
}

@end

