//
//  SLRotateImageViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/18.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLRotateImageViewController.h"
#import "SLPSImageViewController.h"
#import "SLImageViewerView.h"

#import "SLAlbumsResource.h"

@interface SLRotateImageViewController ()
{
    SLImageViewerView *image_show;

}
@end

@implementation SLRotateImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    self.view.clipsToBounds = YES;
    
    [self setupUI];
    
    if (self.imageUrl && [self.imageUrl isKindOfClass:[NSURL class]])
    {
        [[SLAlbumsResource sharedInstance]getHDPhotos:self.imageUrl Completion:^(UIImage *image) {
            
            NSLog(@"%@",image);
            image_show.contentImage = image;
        }];
    }
}

-(void)setupUI
{
    image_show = [[SLImageViewerView alloc]init];
    image_show.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width);
    image_show.clipsToBounds = NO;
    image_show.contentImage = self.image;
    [self.view addSubview:image_show];
    
    
    UIColor *color_shadow = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:.9];
    
//    提示文字
    UILabel *lab_tips = [UILabel new];
    lab_tips.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    lab_tips.textColor = [UIColor whiteColor];
    lab_tips.textAlignment = NSTextAlignmentCenter;
    lab_tips.text = @"滑动可选择图片显示区域";
    lab_tips.font = [UIFont systemFontOfSize:14];
    lab_tips.backgroundColor = color_shadow;
    [self.view addSubview:lab_tips];
    
//    阴影遮罩
    UIView *view_shadow = [UIView new];
    CGFloat y = image_show.frame.size.height + image_show.frame.origin.y;
    view_shadow.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - 50 - y);
    view_shadow.backgroundColor = color_shadow;
    [self.view addSubview:view_shadow];
    
//  底部view
    UIView *view_bottom = [UIView new];
    view_bottom.backgroundColor = self.view.backgroundColor;
    view_bottom.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    view_bottom.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    [self.view addSubview:view_bottom];
    
    //    返回
    UIButton *btn_back = [UIButton new];
    [btn_back setImage:[UIImage imageNamed:@"cameraBack"] forState:UIControlStateNormal];
    btn_back.frame = CGRectMake(0, 0, 50, 50);
    [btn_back addTarget:self action:@selector(rotateBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_back];
    
    //    完成
    UIButton *btn_finish = [UIButton new];
    [btn_finish setImage:[UIImage imageNamed:@"cameraFinish"] forState:UIControlStateNormal];
    btn_finish.frame = CGRectMake(view_bottom.frame.size.width - 50, 0, 50, 50);
    [btn_finish addTarget:self action:@selector(rotateFinish:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_finish];
    
//    旋转按钮
    UIButton *btn_rotate = [UIButton new];
    [btn_rotate setImage:[UIImage imageNamed:@"cameraRotate"] forState:UIControlStateNormal];
    [btn_rotate setBackgroundImage:[UIImage imageNamed:@"cameraBtnBg"] forState:UIControlStateNormal];
    btn_rotate.frame = CGRectMake(0, 0, 37, 37);
    btn_rotate.center = CGPointMake(view_bottom.frame.size.width / 2.0, view_bottom.frame.size.height / 2.0);
    [btn_rotate addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_rotate];
    
}

#pragma mark - 旋转
-(void)rotate:(UIButton *)button
{
    button.tag += 1;
    button.tag = button.tag % 4;
    image_show.directionType = button.tag;
}

#pragma mark - 完成旋转
-(void)rotateFinish:(UIButton *)button
{
    SLPSImageViewController *psImage = [[SLPSImageViewController alloc]init];
    psImage.image = image_show.editedImage;
    [self.navigationController pushViewController:psImage animated:YES];
}

#pragma mark - 返回
-(void)rotateBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
