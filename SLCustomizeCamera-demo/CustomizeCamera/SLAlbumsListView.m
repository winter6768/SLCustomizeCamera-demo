//
//  SLAlbumsListView.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/9.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLAlbumsListView.h"

@interface SLAlbumsListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SLAlbumsListView

-(instancetype)initWithDataArray:(NSArray *)dataArray
                          origin:(CGPoint)origin
                           width:(CGFloat)width
                          height:(CGFloat)height
                 backgroundColor:(UIColor *)color
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        height = (height > 0) ? height : 44;
        
        //背景色为clearColor
        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.dataArray = dataArray;
        
        CGFloat _KHeight = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
        UIView *view_bg = [[UIView alloc]initWithFrame:CGRectMake(origin.x, origin.y, width, _KHeight - origin.y)];
        view_bg.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        [self addSubview:view_bg];
        
        CGFloat tHeight = height * dataArray.count;
        
        tHeight = MIN(tHeight, _KHeight / 2.0);
        tHeight = (tHeight + origin.y > _KHeight) ? (_KHeight - origin.y) : tHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, tHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [self addSubview:self.tableView];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(origin.x, origin.y, width, .5)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:.2];
        [self addSubview:line];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SLAlbumsGroupModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",model.name,(int)model.count];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    
    cell.imageView.image = model.posterImage;
    cell.imageView.frame = CGRectMake(15, (cell.frame.size.height - 69) / 2.0, 69, 69);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedBlock)
    {
        self.didSelectedBlock(self.dataArray[indexPath.row]);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
}


- (void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0;
    CGRect frame = self.tableView.frame;
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 1;
        self.tableView.frame = frame;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, self.width, 0);
    } completion:^(BOOL finished)
     {
         if (finished)
         {
             if (self.didSelectedBlock)
             {
                 self.didSelectedBlock(nil);
             }
             
             [self removeFromSuperview];
         }
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView])
    {
        [self dismiss];
    }
}


@end
