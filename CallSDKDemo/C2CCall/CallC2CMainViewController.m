//
//  CallC2CMainViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallC2CMainViewController.h"
#import "CallC2CMakeViewController.h"
#import "CallIncomingListener.h"


@interface CallC2CMainViewController () <UITextFieldDelegate>
@end

@implementation CallC2CMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.userLabel.text = [[ILiveLoginManager getInstance] getLoginId];
}

//登出
- (IBAction)logout:(id)sender {
    __weak typeof(self) ws = self;
    [[ILiveLoginManager getInstance] tlsLogout:^{
        [ws.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

//发起呼叫
- (IBAction)makeCall:(id)sender {
    NSString *peerId = self.peerTextField.text;
    if(peerId.length <= 0){
        return;
    }
    CallC2CMakeViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"CallC2CMakeViewController"];
    make.peerId = peerId;
    [self presentViewController:make animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
