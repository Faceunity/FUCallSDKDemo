//
//  CallMultiRecvViewController.h
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallMultiRecvViewController : UIViewController
@property (strong, nonatomic) TILCallInvitation *invite;

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)closeCamera:(id)sender;
- (IBAction)switchCamera:(id)sender;
- (IBAction)closeMic:(id)sender;
- (IBAction)switchReceiver:(id)sender;
- (IBAction)recvInvite:(id)sender;
- (IBAction)rejectInvite:(id)sender;
- (IBAction)hangUp:(id)sender;
- (IBAction)onBeautyChange:(id)sender;
- (IBAction)onWhiteChange:(id)sender;
- (IBAction)onInvite:(id)sender;
- (IBAction)cancelInvite:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;
@property (weak, nonatomic) IBOutlet UITextField *cancelTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *closeCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *closeMicButton;
@property (weak, nonatomic) IBOutlet UIButton *switchReceiverButton;
@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;
@property (weak, nonatomic) IBOutlet UIButton *recvInviteButton;
@end
