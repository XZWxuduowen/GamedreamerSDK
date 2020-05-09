//
//  AppDelegate.m
//  GamedreamerSample
//
//  Created by gd on 2019/2/18.
//  Copyright © 2019 efunfun. All rights reserved.
//

#import "AppDelegate.h"
#import <Gamedreamer/GamedreamerManager.h>
#import "ViewController.h"

@interface AppDelegate () <GamedreamerDelegate>
{
    UINavigationController *navController;
}
@property(nonatomic, weak)ViewController *rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storybord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self.window makeKeyAndVisible];
    _rootViewController = [storybord instantiateInitialViewController];
    self.window.rootViewController = _rootViewController;
    
    
#pragma mark SDK初始化与委托
    [[GamedreamerManager shareInstance] gamedreamerStartWithSuperView:nil andCompletion:^(NSDictionary *result, NSError *error){
        //务必在初始化接口回调后才开始游戏流程活调用登录接口，不然会导致部分参数没有获取到
        [self.rootViewController loginAciton];
    }];
    
    //应用委托实现--必需加入
    [[GamedreamerManager shareInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //SDK委托实现--必需加入处理
    [GamedreamerManager shareInstance].delegate = self;
    
    return YES;
}


#pragma mark SDK登出回调
//SDK委托实现--必需加入
- (void)gamedreamerNeedRelogin{
    NSLog(@"登出");
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UIViewController *vc = _rootViewController;
    _rootViewController.userid = nil;
    _rootViewController.servercode = nil;
    while (vc) {
        [arr insertObject:vc atIndex:0];
        vc = vc.presentedViewController;
    }
    for (UIViewController *vc in arr) {
        if (vc != _rootViewController){
            [vc dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //应用委托实现--必需加入
    [[GamedreamerManager shareInstance] applicationWillResignActive:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //应用委托实现--必需加入
    [[GamedreamerManager shareInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //应用委托实现--必需加入
    [[GamedreamerManager shareInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //应用委托实现--必需加入
    [[GamedreamerManager shareInstance] applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark SDK 推送Token记录
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    [[GamedreamerManager shareInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}


#pragma mark SDK OpenUrl处理
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
 //应用委托实现，处理Facebook等第三方的跳转回调--必需加入
    return [[GamedreamerManager shareInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

//说明 本方法是ios9.0后出的替代application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation接口，9.0后的系统如果调用本接口后上面的方法会不生效
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
     [[GamedreamerManager shareInstance] application:app openURL:url options:options];
     return YES;
}

@end
