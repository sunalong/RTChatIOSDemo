//
//  LoginViewController.m
//  RTChat
//
//  Created by raymon_wang on 16/10/12.
//  Copyright © 2016年 RTChatTeam. All rights reserved.
//

#import "LoginViewController.h"
#import "RTChatHelper.hpp"

@interface LoginViewController ()

@property IBOutlet UITextField* userInputField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userInputField.text = [LoginViewController getRandomName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSString*) getRandomName
{
    return [[[NSUUID UUID] UUIDString] substringWithRange:NSMakeRange(0, 8)];
}

-(IBAction)randomLogin
{
    RTChatHelper::instance().init([_userInputField.text UTF8String]);
}

-(IBAction)WangxinLogin
{
    RTChatHelper::instance().init("wangxin");
}

-(IBAction)LuluLogin
{
    RTChatHelper::instance().init("lulu");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
