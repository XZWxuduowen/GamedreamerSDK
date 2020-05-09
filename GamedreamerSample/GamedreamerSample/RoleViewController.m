//
//  RoleViewController.m
//  GamedreamerSample
//
//  Created by gd on 2019/2/19.
//  Copyright © 2019 efunfun. All rights reserved.
//

#import "RoleViewController.h"
#import "GameViewController.h"
#import <Gamedreamer/GamedreamerManager.h>

@interface RoleViewController ()
@property(nonatomic, strong)NSString *roldName;
@property(nonatomic, strong)NSString *roldId;
@property(nonatomic, strong)NSString *roldLevel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation RoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i8_7501334"]];
    iv.frame = self.view.frame;
    [self.view insertSubview:iv atIndex:0];
    _infoLabel.text = [NSString stringWithFormat:@"serverCode:%@\nuserID:%@",_servercode?:@"未选择伺服器",_userid?:@"未登录"];
    _roldId = @"100000";
    _roldLevel = @"10";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//新建角色时 调用新建角色接口
- (IBAction)newRoleAction:(id)sender {
    
    _roldName = _textField.text;
    //如果新建角色--可选
    if (_roldName) {
        [[GamedreamerManager shareInstance] gamedreamerNewRoleName:_roldName andRoleId:_roldId];
        [self goGameAction];
    }
}

//使用已有角色登录 调用保存角色接口
- (IBAction)oldRoleAction:(id)sender {
    //保存角色名和角色id--必需接入
    _roldName = @"Demo";
     [[GamedreamerManager shareInstance] gamedreamerSaveRoleName:_roldName andRoleId:_roldId andRoleLevel:_roldLevel];
    [self goGameAction];
}

- (void)goGameAction{
    [self performSegueWithIdentifier:@"beginGame" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameViewController *gvc = [segue destinationViewController];
    gvc.servercode = _servercode;
    gvc.userid = _userid;
    gvc.roleName = _roldName;
    
    // Pass the selected object to the new view controller.
}

@end
