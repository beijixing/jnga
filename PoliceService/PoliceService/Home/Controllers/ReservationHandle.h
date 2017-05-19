//
//  ReservationHandle.h
//  PoliceService
//
//  Created by WenJie on 2017/5/16.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^reservationBlock)(id ary, BOOL success);
@interface ReservationHandle : NSObject

/**类型*/
@property(nonatomic, strong) NSString *keyword;


/**业务大类*/
@property (nonatomic, strong) NSString *busiClassId;


/**业务子类*/
@property (nonatomic, strong) NSString *subBusiClassId;


/**办理分局*/
@property (nonatomic, strong) NSString *police;


/**派出所*/
@property (nonatomic, strong) NSString *station;


/**时间段*/
@property (nonatomic, strong) NSString *period;


- (void)getBusiClassAry:(reservationBlock)block;
- (void)getSubBusiClassAry:(reservationBlock)block;
- (void)getPoliceAry:(reservationBlock)block;
- (void)getStationAry:(reservationBlock)block;
- (void)getPeriodAry:(reservationBlock)block;









@end



