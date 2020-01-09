//
//  LoginViewModel.m
//  验证码发送练习
//
//  Created by fanbaili on 2018/12/6.
//  Copyright © 2018年 fanbailiStudy. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
-(instancetype)init{
    if (self == [super init]) {
        //初始化
        [self setUP];
    }
    return self;
}

-(void)setUP{
    //处理登陆点击的信号
   //组合
   //reduce参数：根据组合的信号关联的 必须一一对应
    _loginSignal = [RACSignal combineLatest:@[RACObserve(self, acount),RACObserve(self, pwd)] reduce:^id _Nonnull(NSString*acount,NSString *pwd){
        return @(acount.length && pwd.length);
    }] ;
    
    //处理登录的命令
    //创建命令
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"拿到%@",input);
        //密码加密
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送请求&&获取登录结果
            [subscriber sendNext:@"请求登陆的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //获取命令中的信号源
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
        //监听命令的执行过程
        [[_loginCommand.executing skip:1]subscribeNext:^(NSNumber * _Nullable x) {
            if ([x boolValue]) {
                NSLog(@"加载");
            }else{
                NSLog(@"停止加载");
            }
        }];
    
    
}
@end
