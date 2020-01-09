//
//  LoginViewModel.h
//  验证码发送练习
//
//  Created by fanbaili on 2018/12/6.
//  Copyright © 2018年 fanbailiStudy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface LoginViewModel : NSObject

//处理登录按钮能否点击的信号
@property(nonatomic,strong)RACSignal *loginSignal;
//登录的命令
@property(nonatomic,strong)RACCommand   *loginCommand;

//账号
@property(nonatomic,strong)NSString *acount;
//密码
@property(nonatomic,strong)NSString *pwd;


@end
