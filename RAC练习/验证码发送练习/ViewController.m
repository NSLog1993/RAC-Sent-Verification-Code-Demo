//
//  ViewController.m
//  验证码发送练习
//
//  Created by fanbaili on 2018/12/5.
//  Copyright © 2018年 fanbailiStudy. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "LoginViewModel.h"


@interface ViewController ()

//VM
@property(nonatomic,strong)LoginViewModel *loginVM;


@property (weak, nonatomic) IBOutlet UIButton *reSendBtn;
@property(nonatomic,assign) int time;
@property(nonatomic,strong)RACDisposable *disposable;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textFlie;

@property (weak, nonatomic) IBOutlet UITextField *acontFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController
-(LoginViewModel *)loginVM{
    if(!_loginVM){
        _loginVM = [[LoginViewModel alloc]init];
    }
        return _loginVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginDemo];
    
}

-(void)loginDemo{
    
    //给视图模型绑定信号
    RAC(self.loginVM,acount) = _acontFiled.rac_textSignal;
    RAC(self.loginVM,pwd) = _pwdFiled.rac_textSignal;
    
    //    //组合
    //    //reduce参数：根据组合的信号关联的 必须一一对应
    //    RACSignal *signal = [RACSignal combineLatest:@[_acontFiled.rac_textSignal,_pwdFiled.rac_textSignal] reduce:^id _Nonnull(NSString* acount,NSString* pwd){
    //
    ////        NSLog(@"acount===%@,pwd===%@",acount,pwd);
    //
    //        return @(acount.length && pwd.length);
    //    }];
    
    
    //设置按钮
    //    //订阅
    //    [signal subscribeNext:^(id  _Nullable x) {
    //        _loginBtn.enabled = [x boolValue];
    //    }];
    //    RAC(_loginBtn,enabled) = signal;
    RAC(_loginBtn,enabled) = self.loginVM.loginSignal;
    
    
    //    //创建命令
    //    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    //        NSLog(@"拿到%@",input);
    //        //密码加密
    //
    //        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //
    //            //发送请求&&获取登录结果
    //            [subscriber sendNext:@"请求登陆的数据"];
    //            [subscriber sendCompleted];
    //            return nil;
    //        }];
    //    }];
    //
    //    //获取命令中的信号源
    //    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    
    //    //监听命令的执行过程
    //    [[command.executing skip:1]subscribeNext:^(NSNumber * _Nullable x) {
    //        if ([x boolValue]) {
    //            NSLog(@"加载");
    //        }else{
    //            NSLog(@"停止加载");
    //        }
    //    }];
    
    //监听按钮的点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        //        [command execute:@"账号密码"];
        [self.loginVM.loginCommand execute:@"账号密码"];
        
    }];
    
}

-(void)skipDemo{
    RACSubject *signal = [RACSubject subject];
    
    //skip :忽略前几个信号
    [[signal skip:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signal sendNext:@"1"];
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];

}


-(void)distinctUntilChangedDemo{
    //忽略重复数据
    RACSubject *signal = [RACSubject subject];
    
    [[signal distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
        
    [signal sendNext:@"1"];
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];
    [signal sendNext:@"3"];
    
}


-(void)takeDemo{
    RACSubject *signal =[RACSubject subject];
    
    //take:指定拿前面几条数据(从前往后)
    //takeLast:指定拿前面几条数据(从后往前)一定要结束：[signal sendCompleted];
    [[signal take:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];
    //    [signal sendCompleted];
}


-(void)ignoreDemo{
    //ignore：忽略某个信号
    RACSubject *signal  = [RACSubject subject];
    
    
    //忽略一些值
    RACSignal *ignoreSignal =  [signal ignore:@"sbb"];
    
    //    //忽略所有值
    //    RACSignal *ignoreSignal =  [signal ignoreValues];
    
    [ignoreSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [signal sendNext:@"sbb"];
    
    
    
}

-(void)filterDemo{
    //过滤掉不需要的信号
    [[_textFlie.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return [value length]>5;
    }]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}




-(void)zipwithDemo{
    //zipwith:两个信号压缩，只有当两个信号同时发出信号内容，并且内容合并成为一个元祖给你
    RACSubject *singnalA = [RACSubject subject];
    RACSubject *singnalB = [RACSubject subject];
    
    //压缩
    RACSignal *zipSignal =  [singnalA zipWith:singnalB];
    
    
    //接收数据 和压缩顺序有关
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        
    }];
    
    [singnalA sendNext:@"A"];
    [singnalB sendNext:@"B"];
    [singnalA sendNext:@"A1"];
    [singnalB sendNext:@"B1"];
    [singnalA sendNext:@"A2"];
    [singnalB sendNext:@"B2"];
}

-(void)mergeDeemo{
    //创建信号
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    //组合信号
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    
    //订阅信号-->根据发送的顺序
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    //发送数据
    [signalA sendNext:@"数据A"];
    [signalB sendNext:@"数据B"];
}

-(void)thenDemo{
    //创建信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求A");
        
        //发送数据
        [subscriber sendNext:@"数据A"];
        
        //A结束才会到B
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建信号
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求B");
        
        //发送数据
        [subscriber sendNext:@"数据B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //then:忽略掉第一个信号的所有的值
    RACSignal *thenSignal = [signalA then:^RACSignal * _Nonnull{
        return signalB;
    }];
    
    //订阅信号
    [thenSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

-(void)concatDemo{
    
    //concat
    //组合！！！要求请求到的数据按某个顺序显示
    
    //创建信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求A");
        
        //发送数据
        [subscriber sendNext:@"数据A"];
        
        //A结束才会到B
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建信号
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求B");
        
        //发送数据
        [subscriber sendNext:@"数据B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //    concat :按顺序组合
    //创建组合信号
    RACSignal *concatSingna = [signalA concat:signalB];
    
    //订阅组合信号
    [concatSingna subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
}

-(void)监听textfile{
    //监听文本框内容
    [_textFlie.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        _label.text = x;
    }];
}

-(void)RACObserve宏{
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
     RAC(_label,text) = _textFlie.rac_textSignal;
}

-(void)RAC宏{
    //给某个对象的某个属性绑定信号。一旦信号产生数据就将内容赋值给属性
    RAC(_label,text) = _textFlie.rac_textSignal;
}


//按钮点击
- (IBAction)reSendBtnClick:(id)sender {
    //改变按钮状态
    self.reSendBtn.enabled = NO;
    
    //设置倒计时
    self.time = 11;
    
    //每一秒进来一次
   self.disposable =  [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]]subscribeNext:^(NSDate * _Nullable x) {
        _time--;
                //设置文字
        NSString * btnText = _time >0 ? [NSString stringWithFormat:@"请等待%d秒",_time] :@"重新发送";
        [ _reSendBtn setTitle:btnText forState:_time>0 ? UIControlStateDisabled : UIControlStateNormal];
        
        //设置为0 时 返回
        if (_time  >0) {
            _reSendBtn.enabled = NO;
        }else{
            _reSendBtn.enabled = YES;
            
            //取消订阅
            [self.disposable dispose];
            
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
