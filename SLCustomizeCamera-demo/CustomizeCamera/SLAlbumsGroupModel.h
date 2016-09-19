//
//  SLAlbumsGroupModel.h
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/12.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SLPhotoModel : NSObject

/** 图片URL */
@property(nonatomic,strong)NSURL *url;

/** 缩略图 */
@property(nonatomic,strong)UIImage *Thumbnail;

/** 高清图 */
@property(nonatomic,strong)UIImage *HDImage;

@end

@interface SLAlbumsGroupModel : NSObject

/** 相册对象 */
@property(nonatomic,strong)ALAssetsGroup *group;

/** 相册照片数量 */
@property(nonatomic,assign)NSInteger count;

/** 相册名称 */
@property(nonatomic,strong)NSString *name;

/** 相册封面 */
@property(nonatomic,strong)UIImage *posterImage;

/** 相册照片数组 */
@property(nonatomic,strong)NSMutableArray *photosArray;

@end
