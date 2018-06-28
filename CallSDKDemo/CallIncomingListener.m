//
//  CallIncomingListener.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/3.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallIncomingListener.h"
#import "CallMultiRecvViewController.h"
#import "CallC2CRecvViewController.h"
#import "AppDelegate.h"

@implementation CallIncomingListener
- (void)onC2CCallInvitation:(TILCallInvitation *)invitation
{
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    CallC2CRecvViewController *call = [nav.storyboard instantiateViewControllerWithIdentifier:@"CallC2CRecvViewController"];
    call.invite = invitation;
    [nav presentViewController:call animated:YES completion:nil];
}

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation
{
//回复忙时
//    TILCallConfig * config = [[TILCallConfig alloc] init];
//    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
//    baseConfig.peerId = invitation.sponsorId;
//    baseConfig.callType = invitation.callType;
//    baseConfig.isSponsor = NO;
//    config.baseConfig = baseConfig;
//    
//    TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
//    responderConfig.callInvitation = invitation;
//    config.responderConfig = responderConfig;
//    TILMultiCall *call = [[TILMultiCall alloc] initWithConfig:config];
//    [call responseLineBusy:nil];
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    CallMultiRecvViewController *call = [nav.storyboard instantiateViewControllerWithIdentifier:@"CallMultiRecvViewController"];
    call.invite = invitation;
    [nav presentViewController:call animated:YES completion:nil];
}

@end
