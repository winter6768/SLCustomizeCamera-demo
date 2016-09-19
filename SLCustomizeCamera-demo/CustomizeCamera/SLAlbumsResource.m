//
//  SLAlbumsResource.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/12.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLAlbumsResource.h"
#import "UIImage+Orientation.h"

@interface SLAlbumsResource ()

@property(nonatomic,strong)ALAssetsLibrary *library;

@end

@implementation SLAlbumsResource

+(instancetype)sharedInstance
{
    static SLAlbumsResource *resource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        resource = [[SLAlbumsResource alloc]init];
    });
    
    return resource;
}

-(void)getRecentPhotosGroupCompletion:(void (^)(SLAlbumsGroupModel *))completion
{
    if (![SLAlbumsResource requestAuthorization])
    {
        return;
    }
    
    _library = _library ?: [[ALAssetsLibrary alloc]init];
        
    [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            *stop = YES;
                        
            SLAlbumsGroupModel *model = [[SLAlbumsGroupModel alloc]init];
            
            //            相册封面
            model.posterImage = [UIImage imageWithCGImage:[group posterImage]];
            
            //            相册照片数量
            model.count = [group numberOfAssets];
            
            //            相册名称
            model.name = @"相机胶卷";
            
            //            相册对象
            model.group = group;
            
            model.photosArray = [NSMutableArray new];

            if (completion)
            {
                completion(model);
            }

        }
        
    } failureBlock:^(NSError *error) {

        NSLog(@"%@",error);
    }];
}



-(void)getAlbumsGroupCompletion:(void (^)(NSArray *))completion
{
    if (![SLAlbumsResource requestAuthorization])
    {
        return;
    }
    
    NSMutableArray *groupArray = [NSMutableArray new];
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            if (group.numberOfAssets > 0)
            {
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                
                if (![name isEqualToString:@"Camera Roll"])
                {
                    name = [name isEqualToString:@"My Photo Stream"] ? @"我的照片流" : name;
                    
                    SLAlbumsGroupModel *model = [[SLAlbumsGroupModel alloc]init];
                    
                    //            相册封面
                    model.posterImage = [UIImage imageWithCGImage:[group posterImage]];
                    
                    //            相册照片数量
                    model.count = [group numberOfAssets];
                    
                    //            相册名称
                    model.name = name;
                    
                    model.group = group;
                    
                    model.photosArray = [NSMutableArray new];
                    
                    [groupArray addObject:model];
                }
            }
        }
        else
        {
            if (completion)
            {
                completion(groupArray);
            }
        }
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];

}

-(void)getGroupPhotos:(ALAssetsGroup *)group photosCount:(NSInteger)count Completion:(void (^)(NSArray *))completion
{
    if (!group)
    {
        if (completion)
        {
            completion(@[]);
        }
        
        return;
    }
    
    if (group.numberOfAssets == count)
    {
        return;
    }
    
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    NSMutableArray *photosArray = [NSMutableArray new];
    
    NSInteger loc = group.numberOfAssets - count - 30;
    
    NSRange range = (loc > 0) ? NSMakeRange(loc, 30) : NSMakeRange(0, 30 + loc);

    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range] options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
//        NSLog(@"%lu",(unsigned long)index);
        
        if (result)
        {
//           缩略图  比较模糊，拉取速度快  size 75 75
//           UIImage *contentImage = [UIImage imageWithCGImage:result.thumbnail];
            
//           等比缩略图  相对清晰  拉取速度慢
            UIImage *contentImage = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
            
//           url
            NSURL *url = [result valueForProperty:ALAssetPropertyAssetURL];
            
            SLPhotoModel *model = [[SLPhotoModel alloc]init];
            
            model.Thumbnail = contentImage;
            model.url = url;
            
            [photosArray addObject:model];
        }
        else
        {
// result 为 nil，即遍历相片或视频完毕
            if (completion)
            {
                completion(photosArray);
            }
        }
    }];
}

-(void)getHDPhotos:(NSURL *)url Completion:(void (^)(UIImage *))completion
{
    [_library assetForURL:url resultBlock:^(ALAsset *asset) {
        
        if (asset)
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            
            UIImageOrientation orientation = [SLAlbumsResource imageOrientation:representation.orientation];
            
//            原图  通过系统相册编辑后的信息也不包含 缺点是拉取速度会比较慢
            UIImage *contentImage = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:orientation];
            
//            全屏图版本，缩略图，但图片的失真少，缺点是图片的尺寸是一个适应屏幕大小的版本
//            UIImage *contentImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
            contentImage = [contentImage fixOrientation];
            
            if (completion)
            {
                completion(contentImage);
            }
        }
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

+(UIImageOrientation)imageOrientation:(ALAssetOrientation)orientation
{
    switch (orientation)
    {
        case ALAssetOrientationUp:
            
            return UIImageOrientationUp;
            break;
            
        case ALAssetOrientationDown:
            
            return UIImageOrientationDown;
            break;
            
        case ALAssetOrientationLeft:
            
            return UIImageOrientationLeft;
            break;
            
        case ALAssetOrientationRight:
            
            return UIImageOrientationRight;
            break;
            
        case ALAssetOrientationUpMirrored:
            
            return UIImageOrientationUpMirrored;
            break;
            
        case ALAssetOrientationDownMirrored:
            
            return UIImageOrientationDownMirrored;
            break;
            
        case ALAssetOrientationLeftMirrored:
            
            return UIImageOrientationLeftMirrored;
            break;
            
        case ALAssetOrientationRightMirrored:
            
            return UIImageOrientationRightMirrored;
            break;
    }
}

#pragma mark - 请求授权状态
+(BOOL)requestAuthorization
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied)
    {
        [[[UIAlertView alloc]initWithTitle:@"请授权" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
        return NO;
    }

    return YES;
}

@end
