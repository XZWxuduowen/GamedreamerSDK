//
//  GameViewController.m
//  GamedreamerSample
//
//  Created by gd on 2019/2/19.
//  Copyright © 2019 efunfun. All rights reserved.
//

#import "GameViewController.h"
#import <Gamedreamer/Gamedreamer.h>

@interface GameViewController ()
@property(nonatomic, strong)NSString* proItemId;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i8_7501334"]];
    iv.frame = self.view.frame;
    [self.view insertSubview:iv atIndex:0];
    
    _infoLabel.text = [NSString stringWithFormat:@"serverCode:%@\nuserID:%@\nroleName:%@",_servercode?:@"未选择伺服器",_userid?:@"未登录",_roleName];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SDK 支付储值
- (IBAction)GDSDKPay:(id)sender {
    //跳转SDK品项列表界面购买储值--可选
    [[GamedreamerManager shareInstance] gamedreamerStoreWithSuperView:self.view andCompletion:^(NSDictionary *result, NSError *error) {
        if(error){
            
        }else{
            NSLog(@"%@",result);
            if([[result objectForKey:@"code"] intValue] == 1000){
                //儲值成功
            }
        }
    }];
}
- (IBAction)gamePay:(id)sender {
    UIAlertController *storeAlert;
    storeAlert = [UIAlertController alertControllerWithTitle:nil message:@"请输入proItemid" preferredStyle:UIAlertControllerStyleAlert];
    [storeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.proItemId;
    }];
    [storeAlert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    [storeAlert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                       self.proItemId = storeAlert.textFields.firstObject.text;
                                                       [self proStoreWithProitemid:self.proItemId];
                                                   }]];
    [self presentViewController:storeAlert animated:YES completion:nil];
}

- (void)proStoreWithProitemid:(NSString *)proitemid{
    //单独品项购买--可选
    //proitemid 由我方后台生成
    [[GamedreamerManager shareInstance] gamedreamerStoreWithProItemid:proitemid andCompletion:^(NSDictionary *result, NSError *error) {
        if(error){
            
        }else{
            NSLog(@"%@",result);
            if([[result objectForKey:@"code"] intValue] == 1000){
                //儲值成功
            }
        }
    }];
}

#pragma mark - SDK 功能

- (IBAction)memberCenter:(id)sender {
    //会员中心--必需接入
    [[GamedreamerManager shareInstance] gamedreamerMemberCenterWithSuperView:self.view];
}
- (IBAction)cs:(id)sender {
    //客服页面--选接
    [[GamedreamerManager shareInstance] gamedreamerCsWithSuperView:self.view];
}
- (IBAction)appScore:(id)sender {
    //商店评分--选接
    [[GamedreamerManager shareInstance] gamedreamerAPPScore];
    
    UIAlertController *storeAlert = [UIAlertController alertControllerWithTitle:nil message:@"评分接口已经调用，弹窗是否显示由后台控制" preferredStyle:UIAlertControllerStyleAlert];
    [storeAlert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                   style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:storeAlert animated:YES completion:nil];
}

- (IBAction)LogEventSample:(id)sender {
    //事件记录--选接
    //部分事件名SDK有預定義好的宏，但是部分針對此遊戲的事件沒有定義宏，直接傳入字符串
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"选择触发事件" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"打開儲值頁面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打開儲值頁面
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:EventEnterPayment parameters:nil];
    }]];

    [alertC addAction:[UIAlertAction actionWithTitle:@"開始下載游戲資源" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //開始下載游戲資源
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:EvenStartDownloadSRC parameters:nil];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"資源下載完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //資源下載完成
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:EvenFinishDownloadSRC parameters:nil];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"完成新手任務" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //完成新手任務
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:EventTutorial_completion parameters:nil];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"角色等級達成10级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //角色等級達成10级。根據角色等級EventParamLevel值傳入對應等級數
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:EventLevelAchieved parameters:@{EventParamLevel:@"10"}];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"通關普通1-1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //關卡 通關普通1-1
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:@"clearance level" parameters:@{@"af_key":@"11"}];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"活躍天數2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //活躍天數。EventParamDay參數的值根據當前活躍天數傳入，活躍天數2
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:EventActiveDays parameters:@{EventParamDay:@"2"}];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"總儲值金額>50台幣" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //總儲值大於，根據玩家當前儲值金額處理，總儲值金額>50台幣
        [[GamedreamerManager shareInstance] gamedreamerLogEventWithName:@"stored_value" parameters:@{@"af_key":@"50"}];
    }]];

    [self presentViewController:alertC animated:YES completion:nil];
}



#pragma mark - 分享
- (IBAction)shareAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"FB连接分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //FB连接分享
        [[GDFacebookShare shareInstance] gamedreamerNewFacebookShareFrom:self
                                                                    Link:@"http://h.hiphotos.baidu.com/zhidao/pic/item/6d81800a19d8bc3ed69473cb848ba61ea8d34516.jpg"
                                                                complete:^(GDShareType shareResult) {
                                                                    switch (shareResult) {
                                                                        case GDShareTypeFail:
                                                                            NSLog(@"========分享失败");
                                                                            break;
                                                                        case GDShareTypeSuccess:
                                                                            NSLog(@"========分享成功");
                                                                            break;
                                                                        case GDShareTypeCancel:
                                                                            NSLog(@"========取消分享");
                                                                            break;
                                                                        case GDShareTypeNoapp:
                                                                            NSLog(@"========没有客户端");
                                                                            break;
                                                                            
                                                                        default:
                                                                            break;
                                                                    }
                                                                }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"FB图片分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //FB图片分享
        [[GDFacebookShare shareInstance] gamedreamerNewFacebookShare:self LocalImage:[UIImage imageNamed:@"i8_7501334"] completion:^(GDShareType shareResult) {
            switch (shareResult) {
                case GDShareTypeFail:
                    NSLog(@"========分享失败");
                    break;
                case GDShareTypeSuccess:
                    NSLog(@"========分享成功");
                    break;
                case GDShareTypeCancel:
                    NSLog(@"========取消分享");
                    break;
                case GDShareTypeNoapp:
                    NSLog(@"========没有客户端");
                    break;
                    
                default:
                    break;
            }
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Line分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Line分享
        [GDLineShare LineShareWithContentMessage:@"分享测试"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    if (alert.popoverPresentationController){
        alert.popoverPresentationController.sourceView = sender;
        alert.popoverPresentationController.sourceRect = sender.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end
