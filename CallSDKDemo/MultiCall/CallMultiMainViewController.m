//
//  CallMultiMainViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallMultiMainViewController.h"
#import "CallMultiMakeViewController.h"
#import "CallIncomingListener.h"


@interface CallMultiMainViewController () <UITextFieldDelegate>
@end

@implementation CallMultiMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.userLabel.text = [[ILiveLoginManager getInstance] getLoginId];
    [[TILCallManager sharedInstance] setIncomingCallListener:[[CallIncomingListener alloc] init]];
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
    CallMultiMakeViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"CallMultiMakeViewController"];
    NSArray *tempArray = [self.peerTextField.text componentsSeparatedByString:@" "];
    make.memberArray = tempArray;
    [self presentViewController:make animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
