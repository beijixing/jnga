//
//  ReservationHandle.m
//  PoliceService
//
//  Created by WenJie on 2017/5/16.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ReservationHandle.h"
#import "RequestService.h"
@interface ReservationHandle()
/**业务大类数组*/
@property (nonatomic, strong) NSArray *busiClass_array;
/**业务子类*/
@property (nonatomic, strong) NSArray *subBusiClass_array;
/**办理分局*/
@property (nonatomic, strong) NSArray *police_array;
/**派出所*/
@property (nonatomic, strong) NSArray *station_array;
/**时间段*/
@property (nonatomic, strong) NSArray *period_array;
/**公告*/
@property (nonatomic, strong) NSString *notice;
@end

@implementation ReservationHandle

#pragma mark Notice
-(void)getNotice:(reservationBlock)block
{
    typeof(self) __weak wself = self;
    
    if (_notice) {
        block(wself.notice,YES);
    }else{
        [RequestService getBusinessNotesWithParamDict:@{@"keyword" : self.keyword} resultBlock:^(BOOL success, id object) {
            if (success) {
                if ([[object objectForKey:@"error_code"] integerValue] == 0) {
                    NSArray *dataArr = [object objectForKey: @"data"];
                    if (dataArr.count>0) {
                        NSDictionary *dataDict = dataArr[0];
                        wself.notice = dataDict[@"businesscontent"];
                    }
                    block(wself.notice,YES);
                }else{
                    block(@"",NO);
                }
            }else{
                block(object,NO);
            }
        }];
    }
}

#pragma mark 业务大类
-(void)getBusiClassAry:(reservationBlock)block
{
    typeof(self) __weak wself = self;

    if (_busiClass_array) {
        block(wself.busiClass_array,YES);
    }else{
        [RequestService getArchBusicClassWithParamDict:@{} resultBlock:^(BOOL success, id object) {
            if (success) {
                if ([[object objectForKey:@"error_code"] integerValue] == 0) {
                    NSArray *ary = [object objectForKey: @"data"];
                    wself.busiClass_array = ary;
                    block(wself.busiClass_array,YES);
                }else{
                    block(@"",NO);
                }
            }else{
                block(object,NO);
            }
        }];
    }
}

-(void)setBusiClassId:(NSString *)busiClassId
{
    _busiClassId = busiClassId;
    _subBusiClassId = nil;
    _subBusiClass_array = nil;
}


#pragma mark 业务子类
-(void)getSubBusiClassAry:(reservationBlock)block
{
    typeof(self) __weak wself = self;

    if ([self.keyword isEqualToString:@"hzhyy"]) {
        if (_busiClassId) {
            
            if (_subBusiClass_array) {
                block(wself.subBusiClass_array,YES);
            }else{
                [RequestService getArchSubBusiClassWithParamDic:@{@"id":self.busiClassId} resultBlock:^(BOOL success, id object) {
                    if (success) {
                        if ([[object objectForKey:@"error_code"] integerValue] == 0) {
                            NSArray *ary = [object objectForKey: @"data"];
                            wself.subBusiClass_array = ary;
                            block(wself.subBusiClass_array,YES);
                        }else{
                            block(@"",NO);
                        }
                    }else{
                        block(object,NO);
                    }
                }];
            }
        }else{
            block(@"请先选择业务大类",NO);
        }
    }else{
        
        if (_subBusiClass_array) {
            block(wself.subBusiClass_array,YES);
        }else{
            [RequestService getAppDataDictWithParamDict:@{@"type":self.keyword} resultBlock:^(BOOL success, id object) {
                if (success) {
                    if ([[object objectForKey:@"code"] integerValue] == 1) {
                        NSArray *ary = [object objectForKey: @"data"];
                        wself.subBusiClass_array = ary;
                        block(wself.subBusiClass_array,YES);
                    }else{
                        block(@"",NO);
                    }
                }else{
                    block(object,NO);
                }
            }];
        }

    }
   
}

#pragma mark 时间段
-(void)getPeriodAry:(reservationBlock)block
{
    typeof(self) __weak wself = self;
    
    if (_period_array) {
        block(wself.period_array,YES);
    }else{
        [RequestService getArchPeriodWithResultBlock:^(BOOL success, id object) {
            if (success) {
                if ([[object objectForKey:@"error_code"] integerValue] == 0) {
                    NSArray *ary = [object objectForKey: @"data"];
                    wself.period_array = ary;
                    block(wself.period_array,YES);
                }else{
                    block(@"",NO);
                }
            }else{
                block(object,NO);
            }
        }];
    }
}

#pragma mark 公安局
-(void)getPoliceAry:(reservationBlock)block
{
    typeof(self) __weak wself = self;
    
    if (_police_array) {
        block(wself.police_array,YES);
    }else{
        [RequestService getArchPoliceWithResultBlock:^(BOOL success, id object) {
            if (success) {
                if ([[object objectForKey:@"error_code"] integerValue] == 0) {
                    NSArray *ary = [object objectForKey: @"data"];
                    wself.police_array = ary;
                    block(wself.police_array,YES);
                }else{
                    block(@"",NO);
                }
            }else{
                block(object,NO);
            }
        }];
    }
}
-(void)setPolice:(NSString *)police
{
    _police = police;
    _station = nil;
    _station_array = nil;
}

#pragma mark 派出所
-(void)getStationAry:(reservationBlock)block
{
    if (_police) {
        typeof(self) __weak wself = self;
        
        if (_station_array) {
            block(wself.station_array,YES);
        }else{
            [RequestService getArchStationWithParamDict:@{@"id":_police} resultBlock:^(BOOL success, id object) {
                if (success) {
                    if ([[object objectForKey:@"error_code"] integerValue] == 0) {
                        NSArray *ary = [object objectForKey: @"data"];
                        wself.station_array = ary;
                        block(wself.station_array,YES);
                    }else{
                        block(@"",NO);
                    }
                }else{
                    block(object,NO);
                }
            }];
        }
    }else{
        block(@"请先选择办理分局",NO);
    }
}
@end
