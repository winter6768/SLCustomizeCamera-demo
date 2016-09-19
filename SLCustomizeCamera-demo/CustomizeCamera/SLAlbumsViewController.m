//
//  SLAlbumsViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLAlbumsViewController.h"
#import "SLButton.h"
#import "SLAlbumsListView.h"
#import "SLAlbumsCell.h"
#import "SLRotateImageViewController.h"

@interface SLAlbumsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *myCollectionView;
    
    NSMutableArray *groupArr;
    
    SLAlbumsGroupModel *currentModel;
}

@end

@implementation SLAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];

    groupArr = [NSMutableArray new];

    [self setupUI];
    
    currentModel = self.recentPhotosModel;
    
    if (self.recentPhotosModel)
    {
        [groupArr addObject:self.recentPhotosModel];
    }
    
    [[SLAlbumsResource sharedInstance] getAlbumsGroupCompletion:^(NSArray *arr) {
        
        [groupArr addObjectsFromArray:arr];
    }];
    
    [self loadPhotos];
}

#pragma mark - UI
-(void)setupUI
{
    UIView *view_top = [UIView new];
    view_top.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [self.view addSubview:view_top];
    
    //    返回
    UIButton *btn_back = [UIButton new];
    [btn_back setImage:[UIImage imageNamed:@"cameraBack"] forState:UIControlStateNormal];
    btn_back.frame = CGRectMake(0, 0, 50, 50);
    [btn_back addTarget:self action:@selector(abBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_top addSubview:btn_back];
    
//    标题
    SLButton *btn_title = [SLButton new];
    btn_title.frame = CGRectMake((view_top.frame.size.width - 150) / 2.0, 0, 150, view_top.frame.size.height);
    btn_title.imageAligment = SLButtonImageAlignmentRight;
    btn_title.spacing = 7;
    btn_title.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_title setTitle:@"最近照片" forState:UIControlStateNormal];
    [btn_title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_title setImage:[UIImage imageNamed:@"albumListOpen"] forState:UIControlStateNormal];
    [btn_title addTarget:self action:@selector(albumListTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_title];
    
    
    CGFloat itemWidth = (self.view.frame.size.width - 5 * 4) / 3.0;
    
    UICollectionViewFlowLayout * viewLayout = [[UICollectionViewFlowLayout alloc]init];
    viewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    viewLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    viewLayout.minimumLineSpacing = 5;
    viewLayout.minimumInteritemSpacing = 5;
    viewLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    CGRect frame = CGRectMake(0, view_top.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - view_top.frame.size.height);
    myCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:viewLayout];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.showsVerticalScrollIndicator = NO;
    myCollectionView.backgroundColor = self.view.backgroundColor;
    [myCollectionView registerClass:[SLAlbumsCell class] forCellWithReuseIdentifier:@"albumItemsCell"];
    [self.view addSubview:myCollectionView];
}

static bool loading = NO;
-(void)loadPhotos
{
    if (loading)
    {
        return;
    }
    
    loading = YES;
    NSLog(@"loading");
    
    __weak __typeof(self) weakSelf = self;

    [[SLAlbumsResource sharedInstance]getGroupPhotos:currentModel.group photosCount:currentModel.photosArray.count Completion:^(NSArray * arr) {
        
        [weakSelf addNewCells:arr];
    }];
}

-(void)addNewCells:(NSArray *)arr
{
    if (currentModel.photosArray.count == 0)
    {
        [currentModel.photosArray addObjectsFromArray:arr];
        
        //  无cell时 必须使用这个方法  不然会崩溃   连续刷新使用这个方法会出现cell丢失现象
        [myCollectionView reloadData];
    }
    else
    {
        NSMutableArray *indexArr = [NSMutableArray new];
        
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            
            [indexArr addObject:[NSIndexPath indexPathForItem:currentModel.photosArray.count + idx inSection:0]];
        }];
        
        [currentModel.photosArray addObjectsFromArray:arr];
        [myCollectionView insertItemsAtIndexPaths:indexArr];
    }

    loading = NO;
}

#pragma mark - collectionDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 5);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return currentModel.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLAlbumsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumItemsCell" forIndexPath:indexPath];
    SLPhotoModel *model = currentModel.photosArray[indexPath.row];
    cell.contentImage = model.Thumbnail;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLPhotoModel *model = currentModel.photosArray[indexPath.row];
    
    SLRotateImageViewController *rotateImage = [[SLRotateImageViewController alloc]init];
    rotateImage.image = model.Thumbnail;
    rotateImage.imageUrl = model.url;
    [self.navigationController pushViewController:rotateImage animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item > currentModel.photosArray.count - 6)
    {
        [self loadPhotos];
    }
}

#pragma mark - 选择相册
-(void)albumListTap:(UIButton *)button
{
    if (groupArr && groupArr.count)
    {
        [button setImage:[UIImage imageNamed:@"albumListClose"] forState:UIControlStateNormal];
        
        SLAlbumsListView *list = [[SLAlbumsListView alloc]initWithDataArray:groupArr origin:CGPointMake(0, 50) width:self.view.frame.size.width height:99 backgroundColor:self.view.backgroundColor];
        
        [list setDidSelectedBlock:^(SLAlbumsGroupModel *model) {
            
            loading = NO;
            
            currentModel = model ?: currentModel;

            if (currentModel.photosArray.count)
            {
                [myCollectionView reloadData];
            }
            else
            {
                [self loadPhotos];
            }
            
            [button setTitle:model ? model.name : button.currentTitle forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"albumListOpen"] forState:UIControlStateNormal];
        }];
        
        [list show];
    }
}

#pragma mark - 返回按钮
-(void)abBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
