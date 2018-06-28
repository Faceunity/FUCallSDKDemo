//
//  CallMultiRecvViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallMultiRecvViewController.h"

@interface CallMultiRecvViewController () <TILCallNotificationListener, TILCallMemberEventListener, UITextFieldDelegate>
@property (nonatomic, strong) TILMultiCall *call;
@property (nonatomic, strong) NSMutableArray *indexArray;
@end

@implementation CallMultiRecvViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _indexArray = [[NSMutableArray alloc] init];
    [self setText:[NSString stringWithFormat:@"收到%@的通话邀请",_invite.sponsorId]];
    [self setText:[NSString stringWithFormat:@"参与通话的成员有:%@",
                   [_invite.memberArray componentsJoinedByString:@";"]]];
    [self setButtonEnable:NO];
    [self initCall];
}

#pragma mark - 通话接口相关
- (void)initCall{
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = NO;
    baseConfig.memberArray = _invite.memberArray;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    listener.memberEventListener = self;
    listener.notifListener = self;
    config.callListener = listener;
    
    TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
    responderConfig.callInvitation = _invite;
    responderConfig.controlRole = @"interactTest";
    config.responderConfig = responderConfig;
    _call = [[TILMultiCall alloc] initWithConfig:config];
}

- (IBAction)recvInvite:(id)sender {
    __weak typeof(self) ws = self;
    [_call createRenderViewIn:self.view];
    [_call accept:^(TILCallError *err) {
        if(err){
            [ws setText:[NSString stringWithFormat:@"接受失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [ws selfDismiss];
        }
        else{
            [ws setButtonEnable:YES];
            [ws setText:@"接受成功"];
        }
    }];
}

- (IBAction)rejectInvite:(id)sender {
    __weak typeof(self) ws = self;
    [_call refuse:^(TILCallError *err) {
        if(err){
            [ws setText:[NSString stringWithFormat:@"拒绝失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
        }
        else{
            [ws setText:@"拒绝成功"];
            [ws selfDismiss];
        }
    }];
}

- (IBAction)hangUp:(id)sender {
    __weak typeof(self) ws = self;
    [_call hangup:^(TILCallError *err) {
        if(err){
        [ws setText:[NSString stringWithFormat:@"挂断失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
        }
        else{
            [ws setText:@"挂断成功"];
            [ws selfDismiss];
        }
    }];
}

- (IBAction)onInvite:(id)sender {
    NSArray *members = [_inviteTextField.text componentsSeparatedByString:@" "];
    if(members.count == 0){
        return;
    }
    
    __weak typeof(self) ws = self;
    [_call inviteCall:members callTip:nil custom:nil result:^(TILCallError *err) {
        if(err){
            [ws setText:[NSString stringWithFormat:@"邀请%@失败:%@-%d-%@",
                         [members componentsJoinedByString:@","],err.domain,err.code,err.errMsg]];
        }
        else{
            [ws setText:
             [NSString stringWithFormat:@"邀请%@成功",
              [members componentsJoinedByString:@","]]];
        }
        ws.inviteTextField.text = @"";
    }];
}

- (IBAction)cancelInvite:(id)sender {
    NSArray *members = nil;
    __weak typeof(self) ws = self;
    if(_cancelTextField.text.length > 0){
        members = [_cancelTextField.text componentsSeparatedByString:@" "];
        [_call cancelCall:members result:^(TILCallError *err) {
            if(err){
                [ws setText:[NSString stringWithFormat:@"取消%@的通话邀请失败:%@-%d-%@",
                             [members componentsJoinedByString:@","],err.domain,err.code,err.errMsg]];
            }
            else{
                [ws setText:
                 [NSString stringWithFormat:@"取消%@的通话邀请成功",
                  [members componentsJoinedByString:@","]]];
            }
            ws.cancelTextField.text = @"";
        }];
    }
    else{
        [_call cancelAllCall:^(TILCallError *err) {
            if(err){
                [ws setText:[NSString stringWithFormat:@"取消所有的通话邀请失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            }
            else{
                [ws setText:@"取消所有的通话邀请成功"];
            }
            ws.cancelTextField.text = @"";
            [ws selfDismiss];
        }];
    }
}


#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    //注意：此处的处理逻辑请按各自业务修改
    NSString *myId = [[ILiveLoginManager getInstance] getLoginId];
    if(isOn){
        for (TILCallMember *member in members) {
            NSString *identifier = member.identifier;
            if([identifier isEqualToString:myId]){
                [_call addRenderFor:myId atFrame:self.view.bounds];
                [_call sendRenderViewToBack:myId];
            }
            else{
                NSInteger count = _indexArray.count;
                CGRect frame = [self getRenderFrame:count];
                [_call addRenderFor:identifier atFrame:frame];
                [_indexArray addObject:identifier];
            }
        }
    }
    else{
        for (TILCallMember *member in members) {
            NSString *identifier = member.identifier;
            [_call removeRenderFor:identifier];
            [_indexArray removeObject:identifier];
        }
    }
}

#pragma mark - 通知回调
- (void)onRecvNotification:(TILCallNotification *)notify
{
    //    TILCALL_NOTIF_ACCEPTED      = 0x82,
    //    TILCALL_NOTIF_CANCEL,
    //    TILCALL_NOTIF_TIMEOUT,
    //    TILCALL_NOTIF_REFUSE,
    //    TILCALL_NOTIF_HANGUP,
    //    TILCALL_NOTIF_LINEBUSY,
    //    TILCALL_NOTIF_HEARTBEAT     = 0x88,
    //    TILCALL_NOTIF_INVITE        = 0x89,
    //    TILCALL_NOTIF_DISCONNECT    = 0x8A,
    
    NSInteger notifId = notify.notifId;
    NSString *sender = notify.sender;
    NSString *target = [notify.targets componentsJoinedByString:@";"];
    NSString *myId = [[ILiveLoginManager getInstance] getLoginId];
    switch (notifId) {
        case TILCALL_NOTIF_INVITE:
            [self setText:[NSString stringWithFormat:@"%@邀请%@通话",sender,target]];
            break;
        case TILCALL_NOTIF_ACCEPTED:
            [self setText:[NSString stringWithFormat:@"%@接受了%@的邀请",sender,target]];
            break;
        case TILCALL_NOTIF_CANCEL:
        {
            [self setText:[NSString stringWithFormat:@"%@取消了对%@的邀请",sender,target]];
            if([notify.targets containsObject:myId]){
                [self selfDismiss];
            }
        }
            break;
        case TILCALL_NOTIF_TIMEOUT:
        {
            if([sender isEqualToString:myId]){
                [self setText:[NSString stringWithFormat:@"%@等待超时",sender]];
            }
            else if([sender isEqualToString:_invite.sponsorId]){
                [self setText:[NSString stringWithFormat:@"%@呼叫超时",sender]];
                [self selfDismiss];
            }
            else{
                [self setText:[NSString stringWithFormat:@"%@手机可能不在身边",sender]];
            }
        }
            break;
        case TILCALL_NOTIF_REFUSE:
            [self setText:[NSString stringWithFormat:@"%@拒绝了%@的邀请",sender,target]];
            break;
        case TILCALL_NOTIF_HANGUP:
            [self setText:[NSString stringWithFormat:@"%@挂断了%@邀请的通话",sender,target]];
            break;
        case TILCALL_NOTIF_LINEBUSY:
            [self setText:[NSString stringWithFormat:@"%@占线，无法接受%@的邀请",sender,target]];
            break;
        case TILCALL_NOTIF_HEARTBEAT:
            [self setText:[NSString stringWithFormat:@"%@发来心跳",sender]];
            break;
        case TILCALL_NOTIF_DISCONNECT:
        {
            [self setText:[NSString stringWithFormat:@"%@失去连接",sender]];
            if([sender isEqualToString:myId]){
                [self selfDismiss];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 设备操作（使用ILiveRoomManager接口）
- (IBAction)closeCamera:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurCameraState];
    cameraPos pos = [manager getCurCameraPos];
    __weak typeof(self) ws = self;
    [manager enableCamera:pos enable:!isOn succ:^{
        NSString *text = !isOn?@"打开摄像头成功":@"关闭摄像头成功";
        [ws setText:text];
        [ws.closeCameraButton setTitle:(!isOn?@"关闭摄像头":@"打开摄像头") forState:UIControlStateNormal];
    }failed:^(NSString *moudle, int errId, NSString *errMsg) {
        NSString *text = !isOn?@"打开摄像头失败":@"关闭摄像头失败";
        [ws setText:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg]];
    }];
}

- (IBAction)switchCamera:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    [manager switchCamera:^{
        [ws setText:@"切换摄像头成功"];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws setText:[NSString stringWithFormat:@"切换摄像头失败:%@-%d-%@",moudle,errId,errMsg]];
    }];
}

- (IBAction)closeMic:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    __weak typeof(self) ws = self;
    [manager enableMic:!isOn succ:^{
        NSString *text = !isOn?@"打开麦克风成功":@"关闭麦克风成功";
        [ws setText:text];
        [ws.closeMicButton setTitle:(!isOn?@"关闭麦克风":@"打开麦克风") forState:UIControlStateNormal];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        NSString *text = !isOn?@"打开麦克风失败":@"关闭麦克风失败";
        [ws setText:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg]];
    }];
}

- (IBAction)switchReceiver:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    QAVOutputMode mode = [manager getCurAudioMode];
    [ws setText:(mode == QAVOUTPUTMODE_EARPHONE?@"切换扬声器成功":@"切换到听筒成功")];
    [ws.switchReceiverButton setTitle:(mode == QAVOUTPUTMODE_EARPHONE?@"切换到听筒":@"切换扬声器") forState:UIControlStateNormal];
    if(mode == QAVOUTPUTMODE_EARPHONE){
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
    }
    else{
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
    }
}

- (IBAction)onBeautyChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [[ILiveRoomManager getInstance] setBeauty:slider.value];
}

- (IBAction)onWhiteChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [[ILiveRoomManager getInstance] setWhite:slider.value];
}


#pragma mark - 界面管理

- (CGRect)getRenderFrame:(NSInteger)count{
    if(count == 3){
        return CGRectZero;
    }
    CGFloat height = (self.view.frame.size.height - 2*20 - 3 * 10)/3;
    CGFloat width = height*3/4;//宽高比3:4
    CGFloat y = 20 + (count * (height + 10));
    CGFloat x = 20;
    return CGRectMake(x, y, width, height);
}

- (void)setButtonEnable:(BOOL)isAccept{
    _closeCameraButton.enabled = isAccept;
    _switchCameraButton.enabled = isAccept;
    _closeMicButton.enabled = isAccept;
    _switchReceiverButton.enabled = isAccept;
    _hangUpButton.enabled = isAccept;
    _recvInviteButton.enabled = !isAccept;
    _rejectButton.enabled = !isAccept;
    _inviteButton.enabled = isAccept;
}

- (void)setText:(NSString *)text
{
    NSString *tempText = _textView.text;
    tempText = [tempText stringByAppendingString:@"\n"];
    tempText = [tempText stringByAppendingString:text];
    _textView.text = tempText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)selfDismiss
{
    //为了看到关闭打印的信息，demo延迟1秒关闭
    __weak typeof(self) ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws dismissViewControllerAnimated:YES completion:nil];
    });
}
@end
