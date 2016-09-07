//
//  ViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "ViewController.h"
#import "SLCustomizeCameraController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton new];
    [button setBackgroundColor: [UIColor darkGrayColor]];
    [button setTitle:@"点击获取图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    button.frame = CGRectMake(0, 0, 300, 300);
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonTap:(UIButton *)button
{
    SLCustomizeCameraController *camera = [[SLCustomizeCameraController alloc]init];
    
    [camera setCompletionBlock:^(UIImage *image) {
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    [self presentViewController:camera animated:YES completion:nil];
}


@end
