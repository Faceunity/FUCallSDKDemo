//
//  CallC2CMakeViewController.h
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallC2CMakeViewController : UIViewController
@property (strong, nonatomic) NSString *peerId;
- (IBAction)closeCamera:(id)sender;
- (IBAction)switchCamera:(id)sender;
- (IBAction)closeMic:(id)sender;
- (IBAction)switchReceiver:(id)sender;
- (IBAction)hangUp:(id)sender;
- (IBAction)cancelInvite:(id)sender;
- (IBAction)onBeautyChange:(id)sender;
- (IBAction)onWhiteChange:(id)sender;
- (IBAction)switchRenderView:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *switchRenderButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *hungUpButton;
@property (weak, nonatomic) IBOutlet UIButton *closeCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *swichCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *closeMicButton;
@property (weak, nonatomic) IBOutlet UIButton *switchReceiverButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelInviteButton;
@end
