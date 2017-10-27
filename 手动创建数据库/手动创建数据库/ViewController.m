//
//  ViewController.m
//  手动创建数据库
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import "ViewController.h"
#import "LCYDBManager.h"
@interface ViewController ()

{
    NSMutableArray *totalArr;
}

@property (nonatomic,strong)NSMutableArray *totalModelArr;

@end

@implementation ViewController

-(NSMutableArray *)totalModelArr
{
    if (!_totalModelArr)
    {
        _totalModelArr = [[NSMutableArray alloc]init];
    }
    
    return _totalModelArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    
    NSString *string = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"test.db"];
    NSLog(@"%@",string);
    
    NSDictionary *dict1 = @{@"name":@"侯亮平",@"age":@"43",@"score":@"100",@"sex":@"0"};
    
    NSDictionary *dict2 = @{@"name":@"林华华",@"age":@"33",@"score":@"80",@"sex":@"1"};
    
    NSDictionary *dict3 = @{@"name":@"李达康",@"age":@"53",@"score":@"90",@"sex":@"0"};
    
    NSDictionary *dict4 = @{@"name":@"高育良",@"age":@"63",@"score":@"90",@"sex":@"0"};
    
    NSDictionary *dict5 = @{@"name":@"小金子",@"age":@"60",@"score":@"100",@"sex":@"0"};
    
    totalArr = [NSMutableArray array];
    
    [totalArr addObject:dict1];
    
    [totalArr addObject:dict2];
    
    [totalArr addObject:dict3];
    
    [totalArr addObject:dict4];
    
    [totalArr addObject:dict5];
    
    NSLog(@"totalArr = %@",totalArr);
    
    //    [[LCYDBManager shareInshance] dbName];
    
//    self.totalModelArr = [[LCYDBManager shareManager] selectedTestData:@""];
    
    NSLog(@"self.totalModelArr = %@ -- count = %lu",self.totalModelArr,self.totalModelArr.count);

    UIButton *insertbutton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    insertbutton.tag = 10;
    [insertbutton setTitle:@"插入数据" forState:0];
    [insertbutton setBackgroundColor:[UIColor redColor]];
    [insertbutton addTarget:self action:@selector(insertIntoTestModel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insertbutton];
    
    
    UIButton *deletebutton = [[UIButton alloc]initWithFrame:CGRectMake(100, 160, 80, 40)];
    deletebutton.tag = 20;
    [deletebutton setTitle:@"删除数据" forState:0];
    [deletebutton setBackgroundColor:[UIColor redColor]];
    [deletebutton addTarget:self action:@selector(insertIntoTestModel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deletebutton];
    
    UIButton *updatebutton = [[UIButton alloc]initWithFrame:CGRectMake(100, 220, 80, 40)];
    updatebutton.tag = 30;
    [updatebutton setTitle:@"修改数据" forState:0];
    [updatebutton setBackgroundColor:[UIColor redColor]];
    [updatebutton addTarget:self action:@selector(insertIntoTestModel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updatebutton];
    
    UIButton *selectbutton = [[UIButton alloc]initWithFrame:CGRectMake(100, 280, 80, 40)];
    selectbutton.tag = 40;
    [selectbutton setTitle:@"选取数据" forState:0];
    [selectbutton setBackgroundColor:[UIColor redColor]];
    [selectbutton addTarget:self action:@selector(insertIntoTestModel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectbutton];
    
    UIButton *dropbutton = [[UIButton alloc]initWithFrame:CGRectMake(100, 340, 80, 40)];
    dropbutton.tag = 50;
    [dropbutton setTitle:@"删除表" forState:0];
    [dropbutton setBackgroundColor:[UIColor redColor]];
    [dropbutton addTarget:self action:@selector(insertIntoTestModel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dropbutton];
    

}

- (void)insertIntoTestModel:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10:
            [[LCYDBManager shareManager] insertdataarray:totalArr];
            break;
            //先修改再删除
        case 20:
            [[LCYDBManager shareManager] deletedata:@"沙瑞金"];
            break;
        case 30:
            [[LCYDBManager shareManager] updatedata:@"沙瑞金"];
            break;
        case 40:
            [[LCYDBManager shareManager] selecteddata];
            break;
        case 50:
            [[LCYDBManager shareManager] dropTable];
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
