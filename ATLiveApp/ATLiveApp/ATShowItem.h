//
//  ATShowItem.h
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/3.
//  Copyright © 2020 张伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATShowItem : NSObject
@property (nonatomic, copy) NSString *flv;

@property (nonatomic, assign) NSUInteger lianMaiStatus;

@property (nonatomic, assign) NSUInteger sex;

@property (nonatomic, assign) NSUInteger roomid;

@property (nonatomic, assign) NSUInteger serverid;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, assign) NSUInteger anchorLevel;

@property (nonatomic, assign) NSUInteger starlevel;

@property (nonatomic, assign) NSUInteger phonetype;

@property (nonatomic, assign) NSUInteger new;

@property (nonatomic, assign) NSUInteger isOnline;

@property (nonatomic, assign) NSUInteger useridx;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *familyName;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, assign) NSUInteger allnum;
@end

NS_ASSUME_NONNULL_END
