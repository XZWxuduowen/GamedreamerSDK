//
//  ViewController.h
//  GamedreamerSample
//
//  Created by gd on 2019/2/18.
//  Copyright © 2019 efunfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *servercode;
@property (strong, nonatomic) NSString *userid;

- (void)loginAciton;
@end

