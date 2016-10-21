
#define ATShare  \
 \
static CGFloat const AT_HUDVIEW_TAG = 110; \
static CGFloat const AT_SHARECONTENTVIEW_TAG = 120; \
static CGFloat const AT_SHARECOUNT = 5; \
- (void)hudTap:(UIView *)hudView { \
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:AT_HUDVIEW_TAG] removeFromSuperview]; \
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:AT_SHARECONTENTVIEW_TAG] removeFromSuperview]; \
} \
- (void)weixinSharedClick { \
    OSMessage *msg = [[OSMessage alloc]init]; \
    msg.title = @"下厨房"; \
    msg.link = [NSString stringWithFormat:@"http://www.xiachufang.com"]; \
    msg.image = [UIImage imageNamed:@"tabCSelected"]; \
    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) { \
        ATLog(@"微信分享到会话成功：\n%@",message); \
    } Fail:^(OSMessage *message, NSError *error) { \
        ATLog(@"微信分享到会话失败：\n%@\n%@",error,message); \
    }]; \
} \
- (void)pyqSharedClick { \
    OSMessage *msg = [[OSMessage alloc]init]; \
    msg.title = @"下厨房"; \
    msg.link = [NSString stringWithFormat:@"http://www.xiachufang.com"]; \
    msg.image = [UIImage imageNamed:@"tabCSelected"]; \
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) { \
        ATLog(@"微信分享到朋友圈成功：\n%@",message); \
    } Fail:^(OSMessage *message, NSError *error) { \
        ATLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message); \
    }]; \
} \
- (void)shareBtnClick:(UIButton *)btn { \
    ATLog(@"分享按钮"); \
     \
    UIView *hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds]; \
    hudView.tag = AT_HUDVIEW_TAG; \
    hudView.backgroundColor = [UIColor blackColor]; \
    hudView.alpha = 0.45; \
    UITapGestureRecognizer *hudViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudTap:)]; \
    [hudView addGestureRecognizer:hudViewTap]; \
    [[[UIApplication sharedApplication] keyWindow] addSubview:hudView]; \
     \
    CGFloat shareContentViewHeigth = 220; \
    UIView *shareContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, shareContentViewHeigth)]; \
    shareContentView.tag = AT_SHARECONTENTVIEW_TAG; \
    shareContentView.backgroundColor = [UIColor whiteColor]; \
    shareContentView.alpha = 1; \
    [[[UIApplication sharedApplication] keyWindow] addSubview:shareContentView]; \
     \
    CGFloat btnWidthHeight = 80; \
    for (int i = 0; i < AT_SHARECOUNT; i++) { \
        CGFloat btnMargin = (screenWidth - 3 * btnWidthHeight) / 4; \
        CGFloat rowMargin = 20; \
        ATButton *btn = [[ATButton alloc] initWithFrame:CGRectMake(btnMargin + (i % 3 * (btnWidthHeight + btnMargin)), rowMargin + (i / 3) * (btnWidthHeight + rowMargin), btnWidthHeight, btnWidthHeight)]; \
        btn.buttonStyle = ATButtonStyleUpImageDownTitle; \
        btn.padding = 10; \
        btn.tag = i + 10; \
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shared%d",i]]]; \
        [btn setTitleColor:[UIColor blackColor]]; \
        NSArray *sharesArray = @[@"QQ好友",@"QQ空间",@"微信好友",@"朋友圈",@"新浪微博"]; \
        [btn setTitle:sharesArray[i]]; \
        [btn setTitleColor:[UIColor blackColor]]; \
         \
        __weak typeof(self) weakSelf = self; \
        btn.tap = ^{ \
            [weakSelf hudTap:nil]; \
             \
            OSMessage *msg = [[OSMessage alloc]init]; \
            msg.title = @"下厨房"; \
            msg.link = [NSString stringWithFormat:@"http://www.xiachufang.com"]; \
            msg.image = [UIImage imageNamed:@"tabCSelected"]; \
            if (btn.tag == 13) { \
                [weakSelf pyqSharedClick]; \
            } else if (btn.tag == 14) { \
                [OpenShare shareToWeibo:msg Success:^(OSMessage *message) { \
                    ATLog(@"分享到sina微博成功:\%@",message); \
                } Fail:^(OSMessage *message, NSError *error) { \
                    ATLog(@"分享到sina微博失败:\%@\n%@",message,error); \
                }]; \
            } else if (btn.tag == 12) { \
                [weakSelf weixinSharedClick]; \
            } else if (btn.tag == 11) { \
                msg.desc = @""; \
                msg.multimediaType=OSMultimediaTypeNews; \
                [OpenShare shareToQQZone:msg Success:^(OSMessage *message) { \
                    ATLog(@"分享到QQ空间成功:%@",msg); \
                } Fail:^(OSMessage *message, NSError *error) { \
                    ATLog(@"分享到QQ空间失败:%@\n%@",msg,error); \
                }]; \
            } else if (btn.tag == 10) { \
                msg.desc = @""; \
                msg.multimediaType=OSMultimediaTypeNews; \
                [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) { \
                    ATLog(@"分享到QQ好友成功:%@",msg); \
                } Fail:^(OSMessage *message, NSError *error) { \
                    ATLog(@"分享到QQ好友失败:%@\n%@",msg,error); \
                }]; \
            } \
        }; \
        [shareContentView addSubview:btn]; \
    } \
}
