#define ATSetupNavShare \
    NSMutableArray *leftBarBtns = [NSMutableArray array];  \
    for (NSUInteger i = 0; i < self.navigationItem.leftBarButtonItems.count; i++) {  \
        [leftBarBtns addObject:self.navigationItem.leftBarButtonItems[i]];  \
    }  \
    UIBarButtonItem *weixinBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"convenient_share_wx"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(weixinSharedClick)];  \
    UIBarButtonItem *pyquanBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"convenient_share_pyq"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pyqSharedClick)];  \
    UIBarButtonItem *otherBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"convenient_share_other"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick:)];  \
    [leftBarBtns addObject:weixinBtn];  \
    [leftBarBtns addObject:pyquanBtn];  \
    [leftBarBtns addObject:otherBtn];  \
    self.navigationItem.leftBarButtonItems = leftBarBtns; 