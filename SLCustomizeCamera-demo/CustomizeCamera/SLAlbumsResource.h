//
//  SLAlbumsResource.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/12.
//  Copyright © 2016年 winter. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SLAlbumsGroupModel.h"

@interface SLAlbumsResource : NSObject

+(instancetype)sharedInstance;

/** 获取最近照片相册信息 */
-(void)getRecentPhotosGroupCompletion:(void (^)(SLAlbumsGroupModel *))completion;


/** 获取所有相册分组信息 */
-(void)getAlbumsGroupCompletion:(void (^)(NSArray *))completion;

/** 分段加载获取相册内所有照片  默认一次加载30张 */
-(void)getGroupPhotos:(ALAssetsGroup *)group photosCount:(NSInteger)count Completion:(void (^)(NSArray *))completion;

/** 根据图片url获取高清照片 */
-(void)getHDPhotos:(NSURL *)url Completion:(void (^)(UIImage *))completion;

@end
