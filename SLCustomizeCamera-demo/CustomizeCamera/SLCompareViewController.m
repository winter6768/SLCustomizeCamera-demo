//
//  SLCompareViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLCompareViewController.h"
#import "SLSingleViewController.h"
#import "SLPSImageViewController.h"

@interface SLCompareViewController ()
{
    UIButton *btn_delete;
    
    UIButton *btn_sure;
    
    UIScrollView *sc_select;
    
    NSInteger imageCount;
}

@end

@implementation SLCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    imageCount = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    
    [self setupUI];
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
        UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(width / 2.0 * i, 50, width / 2.0, width)];
        sc.backgroundColor = [UIColor colorWithRed:63/255.0 green:60/255.0 blue:81/255.0 alpha:1];
        sc.tag = i + 1000;
        sc.layer.borderColor = [UIColor redColor].CGColor;
        [self.view addSubview:sc];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:sc.bounds];
        imageview.image = [UIImage imageNamed:@"cameraDefault"];
        imageview.contentMode = UIViewContentModeCenter;
        [sc addSubview:imageview];
        
        [sc addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
        sc.contentSize = sc.bounds.size;
        
        if (!i)
        {
            sc.layer.borderWidth = 2;
            sc_select = sc;
        }
    }
    
    //    对比图
    UIButton *btn_compare = [UIButton new];
    btn_compare.frame = CGRectMake(0, sc_select.frame.origin.y + sc_select.frame.size.height, 70, 50);
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
    
    UIImageView *image_photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
    image_photo.center = CGPointMake(self.view.frame.size.width / 4.0 * 3 + 20, btn_close.center.y);
    image_photo.backgroundColor = [UIColor lightGrayColor];
    [image_photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraAlbums:)]];
    [self.view addSubview:image_photo];
}

#pragma mark - 删除
-(void)cameraDelete:(UIButton *)button
{
    [[sc_select viewWithTag:777]removeFromSuperview];
    sc_select.contentSize = sc_select.bounds.size;
    btn_delete.enabled = NO;
    btn_delete.alpha = .5;
    
    imageCount -= 1;
    btn_sure.enabled = NO;
    btn_sure.alpha = .5;
}

#pragma mark - 图片点击
-(void)imageViewTap:(UITapGestureRecognizer *)tap
{
    UIView *view = [tap.view viewWithTag:777];
    
    btn_delete.enabled = view ? YES : NO;
    btn_delete.alpha = view ? 1 : .5;
    
    if (tap.view == sc_select)
    {
        if (view)
        {
            return;
        }
        
        SLSingleViewController *single = [[SLSingleViewController alloc]init];
        [single setCompareShootBlock:^(UIImage *image) {
            
            UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
            imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
            imageview.tag = 777;
            [sc_select addSubview:imageview];
            
            sc_select.contentSize = imageview.frame.size;
            btn_delete.enabled = YES;
            btn_delete.alpha = 1;
            
            imageCount += 1;
            
            btn_sure.enabled = imageCount > 1 ? YES : NO;
            btn_sure.alpha = imageCount > 1 ? 1 : .5;
            
        }];
        [self.navigationController pushViewController:single animated:YES];
    }
    else
    {
        sc_select.layer.borderWidth = 0;
        tap.view.layer.borderWidth = 2;
        sc_select = (UIScrollView *)tap.view;
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
    
}

#pragma mark - 确定
-(void)cameraSure:(UIButton *)button
{
    UIImage *image_left = nil;
    UIImage *image_right = nil;
    
    for (int i = 0; i < 2; i ++)
    {
        UIScrollView *sc = [self.view viewWithTag:1000 + i];
        UIImageView *imageView = [sc viewWithTag:777];
        
        CGImageRef takenCGImage = imageView.image.CGImage;
        size_t width = CGImageGetWidth(takenCGImage);
        size_t height = CGImageGetHeight(takenCGImage);
        
        CGFloat image_width = imageView.frame.size.width;
        CGFloat image_height = imageView.frame.size.height;
        CGRect cropRect = CGRectMake(sc.contentOffset.x / image_width * width,
                                     sc.contentOffset.y / image_height * height,
                                     sc.frame.size.width / image_width * width,
                                     sc.frame.size.height / image_height * height);
        
        CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
        UIImage *image = [UIImage imageWithCGImage:cropCGImage scale:imageView.image.scale orientation:imageView.image.imageOrientation];
        CGImageRelease(cropCGImage);
        
        if (i)
        {
            image_right = image;
        }
        else
        {
            image_left = image;
        }
    }
    
    
//  可以把图片绘制到指定大小 但是图片会有稍微模糊  使用图片原尺寸拼接则不会有变化
    CGSize size = CGSizeMake(image_left.size.height, image_left.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [image_left drawInRect:CGRectMake(0, 0, size.width/2.0, size.height)];
    [image_right drawInRect:CGRectMake(size.width/2.0, 0, size.width/2.0, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SLPSImageViewController *psImage = [[SLPSImageViewController alloc]init];
    psImage.image = newImage;
    [self.navigationController pushViewController:psImage animated:YES];
    
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
