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
@end