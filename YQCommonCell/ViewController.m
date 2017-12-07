//
//  ViewController.m
//  YQCommonCell
//
//  Created by easylink on 2017/12/6.
//  Copyright © 2017年 YuQi. All rights reserved.
//

#import "ViewController.h"
#import "YQCommonCell.h"
#import "YQCommonGroup.h"
#import "YQCommonItem.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 150;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YQCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQCommonCell *cell = [YQCommonCell cellWithTableView:tableView];
    YQCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQCommonGroup *group = self.groups[indexPath.section];
    YQCommonItem *item = group.items[indexPath.row];
    
    if (item.destVcClass) {
        [self presentViewController:[[item.destVcClass alloc] init] animated:YES completion:nil];
    }
    
    if (item.operation) {
        item.operation();
    }
}


- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
        
        YQCommonGroup *group = [[YQCommonGroup alloc] init];
        
        // 无法点击
        YQCommonItem *item1 = [YQCommonItem itemWithTitle:@"第一行" icon:@"0" arrow:YES screenSeparator:YES];
        item1.selectAbility = NO;
        item1.operation = ^{
            NSLog(@"第一行");
        };
        
        
        YQCommonItem *item2 = [YQCommonItem itemWithTitle:@"第二行第二行" icon:@"1" arrow:NO screenSeparator:YES];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor clearColor];
        v.frame = CGRectMake(0, 0, 140, 40);
        v.layer.cornerRadius = 4;
        
        UILabel *l = [[UILabel alloc] init];
        l.frame = CGRectMake(0, 0, 100, 40);
        l.text = @"自定义视图";
        [v addSubview:l];
        
        UIImageView *iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:@"3"];
        iv.frame = CGRectMake(100, 0, 40, 40);
        [v addSubview:iv];
        
        item2.assistCustomView = v;
        item2.assistCustomViewLayout = YQAssistCustomViewLayoutRightBottom;
        item2.operation = ^{
            
        };
        
        YQCommonItem *item3 = [YQCommonItem itemWithTitle:@"第三行第三行第三行" icon:@"2" arrow:YES screenSeparator:YES];
        UISwitch *s = [[UISwitch alloc] init];
        s.frame = CGRectMake(0, 0, 100, 40);
        item3.assistCustomView = s;
        item3.assistCustomViewLayout = YQAssistCustomViewLayoutRightTop;
        item3.selectHighlight = NO;
        item3.operation = ^{
            
        };
        
        YQCommonItem *item4 = [YQCommonItem itemWithTitle:@"第四行" icon:@"3" arrow:YES screenSeparator:YES];
        item4.assistImageURLStr = @"https://ss0.baidu.com/73F1bjeh1BF3odCf/it/u=2953611372,3247682668&fm=85&s=DCE02CC4015325CA441C3C3903001040";
        item4.destVcClass = [ViewController class];
        
        YQCommonItem *item5 = [YQCommonItem itemWithTitle:@"第五行" icon:@"2" arrow:NO screenSeparator:YES];
        item5.operation = ^{
            NSLog(@"--");
        };
        
        YQCommonItem *item6 = [YQCommonItem itemWithTitle:@"第六行" icon:@"2" arrow:NO screenSeparator:YES];
        UIView *v2 = [[UIView alloc] init];
        v2.backgroundColor = [UIColor clearColor];
        v2.frame = CGRectMake(0, 0, 140, 40);
        v2.layer.cornerRadius = 4;
        
        UILabel *l2 = [[UILabel alloc] init];
        l2.frame = CGRectMake(0, 0, 100, 40);
        l2.text = @"自定义视图";
        [v2 addSubview:l2];
        
        UIImageView *iv2 = [[UIImageView alloc] init];
        iv2.image = [UIImage imageNamed:@"3"];
        iv2.frame = CGRectMake(100, 0, 40, 40);
        [v2 addSubview:iv2];
        
        item6.assistCustomView = v2;
        item6.assistCustomViewLayout = YQAssistCustomViewLayoutBottom;
        item6.operation = ^{
            
        };
        
        
        YQCommonItem *item7 = [YQCommonItem itemWithTitle:@"第七行" icon:@"1" arrow:NO screenSeparator:YES];
        UIView *v3 = [[UIView alloc] init];
        v3.backgroundColor = [UIColor blueColor];
        v3.frame = CGRectMake(0, 0, 30, 30);
        v3.layer.cornerRadius = 4;
        
        item7.assistCustomView = v3;
        item7.assistCustomViewLayout = YQAssistCustomViewLayoutLeft;
        item7.operation = ^{
            
        };
        
        
        YQCommonItem *item8 = [YQCommonItem itemWithTitle:@"第八行" icon:@"1" arrow:NO screenSeparator:YES];
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(10, 10, 80, 30);
        item8.assistCustomView = slider;
        item8.assistCustomViewLayout = YQAssistCustomViewLayoutLeftBottom;
        item8.operation = ^{
            
        };
        
        
        YQCommonItem *item9 = [YQCommonItem itemWithTitle:@"第九行第九行" icon:@"1" arrow:NO screenSeparator:YES];
        UISwitch *s2 = [[UISwitch alloc] init];
        s2.frame = CGRectMake(0, 0, 100, 40);
        item9.assistCustomView = s2;
        item9.assistCustomViewLayout = YQAssistCustomViewLayoutCenter;
        item9.operation = ^{
            
        };
        group.items = @[item1, item2, item3, item4, item5, item6,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item1, item2, item3, item4, item5,
                        item6, item7, item8, item9];
        
        [_groups addObject:group];
    }
    return _groups;
}


@end