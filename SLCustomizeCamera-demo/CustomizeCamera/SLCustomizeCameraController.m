//
//  SLCustomizeCameraController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLCustomizeCameraController.h"
#import "SLSingleViewController.h"

@interface SLCustomizeCameraController ()

@end

@implementation SLCustomizeCameraController

-(instancetype)init
{
    if (self = [super init])
    {
        SLSingleViewController *single = [[SLSingleViewController alloc]init];
        
        [self setViewControllers:@[single]];
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

@end
