//
//  RequestService.m
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "RequestService.h"
#import "Constant.h"
#import "UDIDManager.h"
#import "APISign.h"
#import "GlobalVariableManager.h"
@implementation RequestService

+(void)registerWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_PhoneReg];
    
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}
//@{@"phone":phone}

+(void)getVerifyCodeWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_ValidateCode];
    
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];

}

+(void)autoLoginWithResultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_IsPhoneLogin];
    NSDictionary *paramDict = @{@"token": [GlobalVariableManager manager].loginToken ?: @"null"};
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)loginWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_PhoneLogin];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)changePhoneWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_ChangePhone];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)changePasswordWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_ChangePassword];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getPoliceServiceMapDataWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_PoliceMapList];
    
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getArchBusicClassWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_BusicClass];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:paramDict functionName:Interface_BusicClass]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];

}

+ (void)getArchSubBusiClassWithParamDic:(NSDictionary *)paramDict resultBlock:(void (^)(BOOL success, id object))resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_SubBusicClass];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:paramDict functionName:Interface_BusicClass]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getArchPeriodWithResultBlock:(void (^)(BOOL, id))resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_ArchPeriod];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:@{} functionName:Interface_BusicClass]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}
+ (void)getArchPoliceWithResultBlock:(void (^)(BOOL success, id object))resultBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_ArchPolice];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:@{} functionName:Interface_BusicClass]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}
+(void)getArchStationWithParamDict:(NSDictionary *)paramDict resultBlock:(void (^)(BOOL, id))resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_ArchStation];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:paramDict functionName:Interface_BusicClass]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getNameNumWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_NameNum];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:paramDict functionName:Interface_NameNum]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];

}
+(void)getStrangeWordWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppJNGAURL, Interface_StrangeWord];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:[APISign paramSignedWithPagram:paramDict functionName:Interface_StrangeWord]  result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
    
}
+(void)getStrayManListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_StrayManList];
    
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getLostItemListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_LostItemList];
    
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getReservationOnlineListWithParamDict:(NSDictionary *)paramDict resultBlock:(void (^)(BOOL, id))resultBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_WrapBusinessList];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getWrapBookingPageDataWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_WrapBookingPageData];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)saveBookingInfoWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_WrapsaveBookingInfo];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getUserBookingListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_WrapMyBookingList];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)cancelBookingWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_CancelBooking];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getGuideListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_GuideList];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getNewsListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_NewsList];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}
+(void)getTopListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_GetTopList];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getSearchResultWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_Search];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getNoticeListWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_NoticeList];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getNoticeDetailWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_GetNotice];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:paramDict result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(NSDictionary *)addAddtionalParamWith:(NSDictionary *)paramDict {
    NSMutableDictionary *tmParamDict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [tmParamDict setObject:[UDIDManager getUDID] forKey:@"device_id"];
    if ([GlobalVariableManager manager].userId != nil) {
        //登录
      [tmParamDict setObject:[GlobalVariableManager manager].loginToken forKey:@"token"];
    }
    return tmParamDict;
}

+(void)postPeopleappealMostWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_PeopleappealMost];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)postAppListByPhoneZtWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_appListByPhoneZt];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}
+(void)getAppVersionInfoWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_CheckVersion];
    [[FSNetWorkManager manager] getDataWithHostUrl:urlStr parameters:paramDict result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)postPeopleappealOneWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_PeopleappealMost];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getAppDataDictWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_AppGetDataDict];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:[self addAddtionalParamWith:paramDict] result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

+(void)getBusinessNotesWithParamDict:(NSDictionary *)paramDict resultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", AppURL, Interface_BusinessNotesTJn];
    [[FSNetWorkManager manager] postDataWithHostUrl:urlStr parameters:paramDict result:^(BOOL success, id  _Nonnull object) {
        resultBlock(success, object);
    }];
}

@end
