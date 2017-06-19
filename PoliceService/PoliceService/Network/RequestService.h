//
//  RequestService.h
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSNetWorkManager.h"
@interface RequestService : NSObject


+(void)registerWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getVerifyCodeWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)autoLoginWithResultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)loginWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)changePhoneWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)changePasswordWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getPoliceServiceMapDataWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getArchBusicClassWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+ (void)getArchSubBusiClassWithParamDic:(NSDictionary *)paramDict resultBlock:(void (^)(BOOL success, id object))resultBlock;
+ (void)getArchPeriodWithResultBlock:(void (^)(BOOL success, id object))resultBlock;
+ (void)getArchPoliceWithResultBlock:(void (^)(BOOL success, id object))resultBlock;
+ (void)getArchStationWithParamDict:(NSDictionary *)paramDict resultBlock:(void (^)(BOOL success, id object))resultBlock;

+(void)getNameNumWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getStrayManListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getLostItemListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getReservationOnlineListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getWrapBookingPageDataWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)saveBookingInfoWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getUserBookingListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)cancelBookingWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getGuideListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getNewsListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getTopListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getSearchResultWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getNoticeListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getNoticeDetailWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)postPeopleappealMostWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)postAppListByPhoneZtWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)getAppVersionInfoWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)postPeopleappealOneWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getAppDataDictWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getBusinessNotesWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)getStrangeWordWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)checkDriverLicenseWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)queryAwardWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)cashAwardWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;
+(void)consultOnlineWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock;

+(void)reportCrimeWithMediaArray:(NSMutableArray *)array  withParamDict:(NSDictionary *)paramDict progress:(nullable void (^)(NSProgress * _Nonnull))progress resultBlock:(void(^_Nullable)(BOOL success,id _Nullable object))resultBlock;

+(void)queryBusinessPlaceWithresultBlock:(void(^_Nullable)(BOOL success,id _Nullable object))resultBlock;
+(void)queryCityWithParamDict:(NSDictionary *_Nullable)paramDict resultBlock:(void(^_Nullable)(BOOL success,id _Nullable object))resultBlock;
+(void)moveCarWithParamDict:(NSDictionary *_Nullable)paramDict image:(UIImage *_Nullable)image resultBlock:(void(^_Nullable)(BOOL success,id _Nullable object))resultBlock;
+(void)checkHightWayStatusWithParamDict:(NSDictionary *_Nullable)paramDict resultBlock:(void(^_Nullable)(BOOL success,id _Nullable object))resultBlock;

@end
