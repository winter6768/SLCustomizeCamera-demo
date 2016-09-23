//
//  SLPSImageViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLPSImageViewController.h"
#import "UIImage+SLFilterEffect.h"
#import "SLPSImageCell.h"
#import "SLPSTitleView.h"

#import "SLCustomizeCameraController.h"

@interface SLPSImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIImageView *image_show;
    
    SLPSTitleView *view_sticker;
    
    UICollectionView *myCollectionView;
    NSMutableArray *arr_filter;
    NSMutableArray *arr_sticker;
    
    UIButton *btn_select;
}
@end

@implementation SLPSImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    arr_filter = [NSMutableArray new];
    arr_sticker = [NSMutableArray new];
    
    for (int i = 0; i < 8; i ++)
    {
        SLPSImageModel *model = [[SLPSImageModel alloc]init];
//        model.image = nil;
//        model.title = nil;
        [arr_sticker addObject:model];
    }
    
    [self setupUI];
    
    [self setupFilterUI];
}

-(void)setupUI
{
    image_show = [[UIImageView alloc]initWithImage:self.image];
    image_show.contentMode = UIViewContentModeScaleAspectFit;
    image_show.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:image_show];
    
    //    底部操作栏
    UIView *view_bottom = [UIView new];
    view_bottom.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    view_bottom.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];
    [self.view addSubview:view_bottom];
    
    [self setupBottomView:view_bottom];
    
    CGFloat frame_y = image_show.frame.origin.y + image_show.frame.size.height;

//    滤镜
    UILabel *lab_filter = [[UILabel alloc]initWithFrame:CGRectMake(15, frame_y, 100, 50)];
    lab_filter.textColor = [UIColor whiteColor];
    lab_filter.font = [UIFont systemFontOfSize:14];
    lab_filter.text = @"滤镜";
    [self.view addSubview:lab_filter];
    
//    贴纸
    view_sticker = [[SLPSTitleView alloc]initWithFrame:CGRectMake(0, frame_y, self.view.frame.size.width, 50)];
    view_sticker.backgroundColor = self.view.backgroundColor;
    view_sticker.titleArray = @[@"SLine",@"健康",@"饮食",@"鼓励",@"挑战"];
    view_sticker.selectedIndex = 0;
    [self.view addSubview:view_sticker];
    
    frame_y += view_sticker.frame.size.height;
    
//    分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame_y, self.view.frame.size.width, .5)];
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:.2];
    [self.view addSubview:line];
    
    frame_y += line.frame.size.height + 25;
    
    CGFloat height = self.view.frame.size.height - frame_y - 50;
//    UICollectionView
    UICollectionViewFlowLayout * viewLayout = [[UICollectionViewFlowLayout alloc]init];
    viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    viewLayout.itemSize = CGSizeMake(110, height);
    viewLayout.minimumLineSpacing = 5;
    viewLayout.minimumInteritemSpacing = 5;
    viewLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    CGRect frame = CGRectMake(0, frame_y, self.view.frame.size.width, height);
    myCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:viewLayout];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.showsHorizontalScrollIndicator = NO;
    myCollectionView.backgroundColor = self.view.backgroundColor;
    [myCollectionView registerClass:[SLPSImageCell class] forCellWithReuseIdentifier:@"SLPSImageCell"];
    [self.view addSubview:myCollectionView];
}

-(void)setupBottomView:(UIView *)view_bottom
{
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
    
    //    贴纸   滤镜
    NSArray *arr_image = @[@"cameraSticker",@"cameraFilter"];
    for (int i = 0; i < arr_image.count; i ++)
    {
        point_x += space_middle / 3.0;
        
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:arr_image[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"cameraBtnBg"] forState:UIControlStateSelected];
        button.frame = CGRectMake(0, 0, 37, 37);
        button.center = CGPointMake(point_x, view_bottom.frame.size.height / 2.0);
        [button addTarget:self action:@selector(psButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [view_bottom addSubview:button];
        
        button.tag = i;
        
        if (i == 0)
        {
            button.selected = YES;
            btn_select = button;
        }
    }
}

#pragma mark - collectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = btn_select.tag ? arr_filter : arr_sticker;

    return arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = btn_select.tag ? arr_filter : arr_sticker;
    
    SLPSImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLPSImageCell" forIndexPath:indexPath];
    cell.model = arr[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = btn_select.tag ? arr_filter : arr_sticker;

    SLPSImageModel *model = arr[indexPath.item];
    image_show.image = model.image;
}


-(void)setupFilterUI
{
    //    滤镜渲染 会造成内存突增，引起页面卡顿 所以需要放到其他线程渲染
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *arr = [SLFilterEffect allFilter];
        
        [arr enumerateObjectsUsingBlock:^(SLFilterEffect *filter, NSUInteger idx, BOOL * stop) {
            
            UIImage *showImage = [self.image SLFilterEffect:filter];
            SLPSImageModel *model = [[SLPSImageModel alloc]init];
            model.image = showImage;
            model.title = filter.title;
            [arr_filter addObject:model];
        }];
    });
}

#pragma mark - 贴纸  滤镜 旋转
-(void)psButtonTouch:(UIButton *)button
{
    if (button == btn_select)
    {
        return;
    }
    
    view_sticker.hidden = button.tag;
    btn_select.selected = NO;
    button.selected = YES;
    btn_select = button;
    
    [myCollectionView reloadData];
    [myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    
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
