//
//  SLCompareViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLCompareViewController.h"
#import "SLSingleViewController.h"
#import "SLRotateImageViewController.h"

#import "SLAlbumsViewController.h"
#import "SLAlbumsResource.h"
#import "SLImageViewerView.h"

@interface SLCompareViewController ()
{
    UIButton *btn_delete;
    
    UIButton *btn_sure;
    
    UIImageView *image_photo;
    
    SLAlbumsGroupModel *groupModel;
    
    SLImageViewerView *image_left;
    SLImageViewerView *image_right;
}

@end

@implementation SLCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    
    [self setupUI];
    

    [[SLAlbumsResource sharedInstance]getRecentPhotosGroupCompletion:^(SLAlbumsGroupModel *model) {
        
        groupModel = model;
        image_photo.image = model.posterImage;
    }];
}

#pragma mark - 初始化
-(void)setupUI
{
    //    删除
    btn_delete = [UIButton new];
    btn_delete.frame = CGRectMake(0, 0, 50, 50);
    btn_delete.enabled = NO;
    btn_delete.alpha = .5;
    [btn_delete setImage:[UIImage imageNamed:@"cameraDelete"] forState:UIControlStateNormal];
    [btn_delete addTarget:self action:@selector(cameraDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_delete];
    
    //    确定按钮
    btn_sure = [UIButton new];
    btn_sure.frame = CGRectMake(self.view.frame.size.width - 55, 0, 50, 50);
    btn_sure.enabled = NO;
    btn_sure.alpha = .5;
    btn_sure.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(cameraSure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_sure];
    
    
    CGFloat width = self.view.frame.size.width;
    
    for (int i = 0; i < 2; i ++)
    {
        SLImageViewerView *sc = [[SLImageViewerView alloc]initWithFrame:CGRectMake(width / 2.0 * i, 50, width / 2.0, width)];
        sc.backgroundColor = [UIColor colorWithRed:63/255.0 green:60/255.0 blue:81/255.0 alpha:1];
        [self.view addSubview:sc];
        
        sc.placeholderImage = [UIImage imageNamed:@"cameraDefault"];
        [sc addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
        
        if (i)
        {
            image_right = sc;
        }
        else
        {
            image_left = sc;
            image_left.selected = YES;
        }
    }
    
    //    对比图
    UIButton *btn_compare = [UIButton new];
    btn_compare.frame = CGRectMake(0, image_left.frame.origin.y + image_left.frame.size.height, 70, 50);
    btn_compare.center = CGPointMake(self.view.center.x, btn_compare.center.y);
    [btn_compare setTitle:@"对比图" forState:UIControlStateNormal];
    [btn_compare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_compare.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn_compare];
    
    //    单图
    UIButton *btn_single = [UIButton new];
    btn_single.frame = CGRectMake(btn_compare.frame.origin.x - 50, btn_compare.frame.origin.y, 50, 50);
    [btn_single setTitle:@"单图" forState:UIControlStateNormal];
    [btn_single setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_single addTarget:self action:@selector(cameraSingle:) forControlEvents:UIControlEventTouchUpInside];
    btn_single.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn_single];
    
    CGFloat bottomSpaceHeight = self.view.frame.size.height - btn_single.frame.origin.y - btn_single.frame.size.height;
    
    //    关闭
    UIButton *btn_close = [UIButton new];
    btn_close.frame = CGRectMake(0, 0, 50, 50);
    btn_close.center = CGPointMake(self.view.frame.size.width / 4.0 - 20, self.view.frame.size.height - bottomSpaceHeight / 2.0);
    [btn_close setImage:[UIImage imageNamed:@"cameraClose"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(cameraClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_close];
    
    //    相册
    image_photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
    image_photo.center = CGPointMake(self.view.frame.size.width / 4.0 * 3 + 20, btn_close.center.y);
    image_photo.userInteractionEnabled = YES;
    [image_photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraAlbums:)]];
    [self.view addSubview:image_photo];
    
}

#pragma mark - 删除
-(void)cameraDelete:(UIButton *)button
{
    if (image_left.selected)
    {
        image_left.contentImage = nil;
    }
    else
    {
        image_right.contentImage = nil;
    }
    
    btn_delete.enabled = NO;
    btn_delete.alpha = .5;
    
    btn_sure.enabled = NO;
    btn_sure.alpha = .5;
}

#pragma mark - 图片点击
-(void)imageViewTap:(UITapGestureRecognizer *)tap
{
    SLImageViewerView *view = (SLImageViewerView *)tap.view;
    
    btn_delete.enabled = view.contentImage ? YES : NO;
    btn_delete.alpha = view.contentImage ? 1 : .5;
    
    if (view.selected)
    {
        if (view.contentImage)
        {
            return;
        }
        
        SLSingleViewController *single = [[SLSingleViewController alloc]init];
        [single setCompareShootBlock:^(UIImage *image) {
            
            view.contentImage = image;
            btn_delete.enabled = YES;
            btn_delete.alpha = 1;
            
            BOOL finish = (image_left.contentImage && image_right.contentImage);
            btn_sure.enabled = finish ? YES : NO;
            btn_sure.alpha = finish ? 1 : .5;
            
        }];
        [self.navigationController pushViewController:single animated:YES];
    }
    else
    {
        image_left.selected = (view == image_left) ? YES : NO;
        image_right.selected = (view == image_left) ? NO : YES;
    }
}

#pragma mark - 单图拍照
-(void)cameraSingle:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 相册
-(void)cameraAlbums:(UITapGestureRecognizer *)tap
{
    SLAlbumsViewController *cus = [[SLAlbumsViewController alloc]init];
    cus.recentPhotosModel = groupModel;
    [cus setCompareDidSelectBlock:^(UIImage * image) {
        
        SLImageViewerView *view = image_left.selected ? image_left : image_right;
        view.contentImage = image;
        btn_delete.enabled = YES;
        btn_delete.alpha = 1;
        
        BOOL finish = (image_left.contentImage && image_right.contentImage);
        btn_sure.enabled = finish ? YES : NO;
        btn_sure.alpha = finish ? 1 : .5;
    }];
    [self.navigationController pushViewController:cus animated:YES];
}

#pragma mark - 确定
-(void)cameraSure:(UIButton *)button
{
    UIImage *left  = image_left.editedImage;
    UIImage *right = image_right.editedImage;
    
//    以最大尺寸为准可以保证尺寸大图片的清晰度，小的不会有影响
    CGFloat height = MAX(left.size.height, right.size.height);
    
//  可以把图片绘制到指定大小 但是图片会有稍微模糊  使用图片原尺寸拼接则不会有变化
    CGSize size = CGSizeMake(height, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [left drawInRect:CGRectMake(0, 0, size.width/2.0, size.height)];
    [right drawInRect:CGRectMake(size.width/2.0, 0, size.width/2.0, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SLRotateImageViewController *rotateImage = [[SLRotateImageViewController alloc]init];
    rotateImage.image = newImage;
    [self.navigationController pushViewController:rotateImage animated:YES];
    
}

#pragma mark - 关闭
-(void)cameraClose:(UIButton *)button
{
    NSArray *arr = self.navigationController.childViewControllers;
    
    if (arr.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
