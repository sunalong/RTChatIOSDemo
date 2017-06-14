//
//  LoginViewController.m
//  RTChat
//
//  Created by raymon_wang on 16/10/12.
//  Copyright © 2016年 RTChatTeam. All rights reserved.
//

#import "LoginViewController.h"
#import "RTChatHelper.hpp"

@interface LoginViewController () {
    NSString*   choosedPlatfromAddr;
    NSString*   appID;
    NSString*   appKey;
}

@property IBOutlet UITextField* userInputField;
@property IBOutlet UITextField* platformAddr1;
@property IBOutlet UITextField* platformAddr2;
@property IBOutlet UITextField* platformAddr3;
@property IBOutlet UITextField* platformAddr4;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userInputField.text = [LoginViewController getRandomName];
    
    choosedPlatfromAddr = _platformAddr1.text;
    appID = @"1fcfaa5cdc01502e";
    appKey = @"7324e82e18d9d16ca4783aa5f872adf54d17a0175f48fa7c1af0d80211dfff82";
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
    RTChatHelper::instance().init([_userInputField.text UTF8String], [appID UTF8String], [appKey UTF8String], [choosedPlatfromAddr UTF8String]);
}

-(IBAction)WangxinLogin
{
    RTChatHelper::instance().init("wangxin", [appID UTF8String], [appKey UTF8String], [choosedPlatfromAddr UTF8String]);
}

-(IBAction)LuluLogin
{
    RTChatHelper::instance().init("lulu", [appID UTF8String], [appKey UTF8String], [choosedPlatfromAddr UTF8String]);
}

-(IBAction)platfromAddrChoosed:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        choosedPlatfromAddr = _platformAddr1.text;
        appID = @"1fcfaa5cdc01502e";
        appKey = @"7324e82e18d9d16ca4783aa5f872adf54d17a0175f48fa7c1af0d80211dfff82";
    }
    else if (sender.selectedSegmentIndex == 1) {
        choosedPlatfromAddr = _platformAddr2.text;
        appID = @"1fcfaa5cdc01502e";
        appKey = @"7324e82e18d9d16ca4783aa5f872adf54d17a0175f48fa7c1af0d80211dfff82";
    }
    else if (sender.selectedSegmentIndex == 2) {
        choosedPlatfromAddr = _platformAddr3.text;
        appID = @"3768c59536565afb";
        appKey = @"df191ec457951c35b8796697c204382d0e12d4e8cb56f54df6a54394be74c5fe";
    }
    else if (sender.selectedSegmentIndex == 3) {
        choosedPlatfromAddr = _platformAddr4.text;
        appID = @"3768c59536565afb";
        appKey = @"df191ec457951c35b8796697c204382d0e12d4e8cb56f54df6a54394be74c5fe";
    }
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
