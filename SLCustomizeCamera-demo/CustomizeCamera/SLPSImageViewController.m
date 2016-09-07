//
//  SLPSImageViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLPSImageViewController.h"
#import "UIImage+SLFilterEffect.h"
#import "SLPSImageView.h"

#import "SLCustomizeCameraController.h"

@interface SLPSImageViewController ()
{
    UIImageView *image_show;
    UIView *view_middle;
    
    UIButton *btn_select;
    SLPSImageView *image_filterSelect;
}
@end

@implementation SLPSImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    
    [self setupUI];
    [self setupFilterUI];
}

-(void)setupUI
{
    image_show = [[UIImageView alloc]initWithImage:self.image];
    image_show.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:image_show];
    
    CGFloat frame_y = image_show.frame.origin.y + image_show.frame.size.height;
    
    view_middle = [[UIView alloc]initWithFrame:CGRectMake(0, frame_y, self.view.frame.size.width, self.view.frame.size.height - frame_y - 50)];
    [self.view addSubview:view_middle];
    
    UIView *view_bottom = [UIView new];
    view_bottom.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    view_bottom.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    [self.view addSubview:view_bottom];
    
    //    返回
    UIButton *btn_back = [UIButton new];
    [btn_back setImage:[UIImage imageNamed:@"cameraBack"] forState:UIControlStateNormal];
    btn_back.frame = CGRectMake(0, 0, 50, 50);
    [btn_back addTarget:self action:@selector(psBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_back];
    
    //    完成
    UIButton *btn_finish = [UIButton new];
    [btn_finish setImage:[UIImage imageNamed:@"cameraFinish"] forState:UIControlStateNormal];
    btn_finish.frame = CGRectMake(view_bottom.frame.size.width - 50, 0, 50, 50);
    [btn_finish addTarget:self action:@selector(psFinish:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_finish];
    
    CGFloat space_middle = view_bottom.frame.size.width - btn_back.frame.size.width - btn_finish.frame.size.width;
    CGFloat point_x = btn_back.frame.origin.x + btn_back.frame.size.width;
    
    //    贴纸   滤镜  旋转
    NSArray *arr_image = @[@"cameraSticker",@"cameraFilter",@"cameraRotate"];
    for (int i = 0; i < arr_image.count; i ++)
    {
        point_x += space_middle / 4.0;
        
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:arr_image[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"cameraBtnBg"] forState:UIControlStateSelected];
        button.frame = CGRectMake(0, 0, 37, 37);
        button.center = CGPointMake(point_x, view_bottom.frame.size.height / 2.0);
        [button addTarget:self action:@selector(psButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [view_bottom addSubview:button];
        
        button.tag = i;
        
        if (i == 1)
        {
            button.selected = YES;
            btn_select = button;
        }
    }
}

-(void)setupFilterUI
{
    UIScrollView *sc_filter = [UIScrollView new];
    sc_filter.frame = CGRectMake(0, 20, view_middle.frame.size.width, 150);
    [view_middle addSubview:sc_filter];
    
    NSArray *arr_filter = [SLFilterEffect allFilter];
    sc_filter.contentSize = CGSizeMake(arr_filter.count * 115 + 5, sc_filter.frame.size.height);
    
    [arr_filter enumerateObjectsUsingBlock:^(SLFilterEffect *filter, NSUInteger idx, BOOL * stop) {
        
        UIImage *showImage = [self.image SLFilterEffect:filter];
        
        SLPSImageView *image = [SLPSImageView new];
        image.frame = CGRectMake(5 + idx * 115, 0, 110, sc_filter.frame.size.height);
        image.psImage = showImage;
        image.psTitle = filter.title;
        [sc_filter addSubview:image];
        
        if (!idx)
        {
            image.psSelected = YES;
            image_filterSelect = image;
        }
        
        image.tag = idx;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterImageTap:)]];
        
    }];
    
}

#pragma mark - 滤镜效果图片点击
-(void)filterImageTap:(UITapGestureRecognizer *)tap
{
    SLPSImageView *image = (SLPSImageView *)tap.view;
    image.psSelected = YES;
    image_filterSelect.psSelected = NO;
    image_filterSelect = image;
    
    image_show.image = image_filterSelect.psImage;
}

#pragma mark - 贴纸  滤镜 旋转
-(void)psButtonTouch:(UIButton *)button
{
    btn_select.selected = NO;
    button.selected = YES;
    btn_select = button;
    
    
}

#pragma mark - 完成ps
-(void)psFinish:(UIButton *)button
{
    SLCustomizeCameraController *camera = nil;
    
    if ([self.navigationController isKindOfClass:[SLCustomizeCameraController class]])
    {
        camera = (SLCustomizeCameraController *)self.navigationController;
    }
    
    if (camera && camera.completionBlock)
    {
        camera.completionBlock(image_show.image);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    UIImageWriteToSavedPhotosAlbum(image_show.image, nil, nil, nil);
//    
//    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                imageDataSampleBuffer,
//                                                                kCMAttachmentMode_ShouldPropagate);
//    
//    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
//    {
//        //无权限
//        return ;
//    }
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//        
//    }];
    
}

#pragma mark - 返回
-(void)psBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
