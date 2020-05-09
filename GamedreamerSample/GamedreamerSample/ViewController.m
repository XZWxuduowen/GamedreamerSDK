//
//  ViewController.m
//  GamedreamerSample
//
//  Created by gd on 2019/2/18.
//  Copyright © 2019 efunfun. All rights reserved.
//

#import "ViewController.h"
#import "RoleViewController.h"
#import <Gamedreamer/GamedreamerManager.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *serverButotn;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation ViewController

//ui部分
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i8_7501334"]];
    iv.frame = self.view.frame;
    [self.view insertSubview:iv atIndex:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _servercode = [defaults objectForKey:@"servercode"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    _infoLabel.text = [NSString stringWithFormat:@"serverCode:%@\nuserID:%@",_servercode?:@"未选择伺服器",_userid?:@"未登录"];
    [_loginButton setTitle:_userid ? @"切换帐号" : @"登录" forState:UIControlStateNormal];
    if (_servercode && _servercode.length && _userid && _userid.length ){
        _gameButton.enabled = YES;
    }else if(_userid){
        _serverButotn.enabled = YES;
    }else if(_servercode){
        _serverButotn.enabled = YES;
    }else if(!_servercode && !_userid){
        _gameButton.enabled = NO;
        _serverButotn.enabled = NO;
    }
}

//登录部分
- (void)loginAciton{
    //登录接口--必须接入
    [[GamedreamerManager shareInstance] gamedreamerLoginWithSuperView:self.view andCompletion:^(NSDictionary *userInfo, NSError *error){
        if(error){
            //error處理
        }else{
            NSLog(@"返回接口的消息：%@",userInfo);
            self.userid = userInfo[@"userid"];
            [self reloadData];
        }
    }];
    
}
- (IBAction)changeAccountAction:(id)sender {
    [[GamedreamerManager shareInstance] gamedreamerLogout];
    [self loginAciton];
}



//伺服器部分
- (IBAction)changeServerAction:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"伺服器列表" message:@"请根据游戏需求选择伺服器页面" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"使用游戏选服页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gameServer];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"使用GDSDK选服页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self GDSDKServer];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)GDSDKServer{
    [[GamedreamerManager shareInstance] gamedreamerServerListWithSuperView:self.view andCompletion:^(NSDictionary *userInfo){
        if(userInfo){
            NSDictionary *serverInfo = userInfo[@"EfunfunServerInfo"];
            self.servercode = serverInfo[@"servercode"];
            [self reloadData];
        }
    }];
}

- (void)gameServer{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"游戏列表" message:@"请输入servercode，需要双方约定好，并且在SDK后台配置" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = self.servercode;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.servercode = alert.textFields.firstObject.text;
        [self reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



#warning 校验伺服器接口 务必每次进入游戏或切换服务器时调用，确保SDK记录的服务器与游戏实际服务器能够同步
- (IBAction)goGameAction:(id)sender {
    //进行进入游戏前最后验证 传入服务器id--必需接入
    if (_servercode) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_servercode forKey:@"servercode"];
        [defaults synchronize];
        [[GamedreamerManager shareInstance] gamedreamerCheckServerWithServerId:_servercode andCompletion:^(NSDictionary *userInfo, NSError *error){
            if(error){
                
            }else{
                //返回参数有可能和登录接口不一样，请以这个接口返回参数为准
                [self performSegueWithIdentifier:@"goGame" sender:nil];
            }
        }];
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     RoleViewController *rvc = [segue destinationViewController];
     rvc.servercode = _servercode;
     rvc.userid = _userid;
 // Pass the selected object to the new view controller.
 }


@end
