//
//  ATShowViewController.m
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/3.
//  Copyright © 2020 张伟. All rights reserved.
//

#import "ATShowViewController.h"
#import "LFLiveKit.h"

@interface ATShowViewController () <LFLiveSessionDelegate>
@property (nonatomic, strong) LFLiveSession *session;
@end

@implementation ATShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self setTitle:@"直播"];
    UIButton *beautyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 80, 120)];
    [beautyBtn setTitle:@"取消美颜" forState:UIControlStateNormal];
    [beautyBtn setTitle:@"美颜" forState:UIControlStateSelected];
    [beautyBtn addTarget:self action:@selector(beautyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beautyBtn];

}

- (void)beautyBtnClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    self.session.beautyFace = !self.session.beautyFace;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestAccessForAudio];
    [self requestAccessForVideo];
    [self startLive];
}

-(void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
    case AVAuthorizationStatusNotDetermined:
        {
            //许可对话没有出现 则设置请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_self.session setRunning:YES];
                });
                }
            }];
            
            break;
        }
    case AVAuthorizationStatusAuthorized:
        {
           dispatch_async(dispatch_get_main_queue(), ^{
               [_self.session setRunning:YES];
           });
            break;
        }
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
            //用户获取失败
            break;
    default:
            break;
    }
    
}
-(void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
  case AVAuthorizationStatusNotDetermined:{
      
      [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
          
      }];
  }
            break;
            
        case AVAuthorizationStatusAuthorized:
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            break;
  default:
            break;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopLive];
}

- (LFLiveSession*)session {
    if (!_session) {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.preView = self.view;
        _session.delegate = self;
    }
    return _session;
}

- (void)startLive {
    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    streamInfo.url = @"rtmp://192.168.0.193:1935/rtmplive/room";
    [self.session startLive:streamInfo];
}

- (void)stopLive {
    [self.session stopLive];
}

//MARK: - CallBack:
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange: (LFLiveState)state {
    NSLog(@"%ld",state);
}
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo {
    
}
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode {
    
}

@end
