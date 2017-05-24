//
//  GlobalVariable.m
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "GlobalVariableManager.h"

@implementation GlobalVariableManager
+(instancetype)manager {
    static GlobalVariableManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GlobalVariableManager alloc] init];
        manager.mapViewShowBackBtn = NO;
    });
    return manager;
}


-(NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
-(void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"userId"];
}
-(NSString*)phone {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumber"];
}


-(void)setPhone:(NSString *)phone {
    [[NSUserDefaults standardUserDefaults]setObject:phone forKey:@"phoneNumber"];
}

-(NSString *)loginToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"loginToken"];
}

-(void)setLoginToken:(NSString *)loginToken {
    [[NSUserDefaults standardUserDefaults]setObject:loginToken forKey:@"loginToken"];
}

-(NSString *)pswd {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"pswd"];
}

-(void)setPswd:(NSString *)pswd {
    [[NSUserDefaults standardUserDefaults]setObject:pswd forKey:@"pswd"];
}
-(NSString *)codeId {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"codeId"];
}

-(void)setCodeId:(NSString *)codeId{
    [[NSUserDefaults standardUserDefaults]setObject:codeId forKey:@"codeId"];
}
@end
