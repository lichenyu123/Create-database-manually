//
//  LCYDBManager.m
//  手动创建数据库
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import "LCYDBManager.h"
#import "testModel.h"

@implementation LCYDBManager

+(instancetype)shareManager
{
    static LCYDBManager *manager = nil;
    static dispatch_once_t once ;
    
    dispatch_once(&once, ^{
       
        if (!manager)
        {
            manager = [[[self class] alloc] init];
        }
        
    });
    return manager;
}

-(FMDatabase *)testDataDB
{
    if (!_database)
    {
        [self copybundledbToDocument];
        
        NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DB"];
        
        NSString *dbpath = [documentPath stringByAppendingPathComponent:@"test.db"];
        
        FMDatabaseQueue *dbqueue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        
        [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            _database = db;
            if (![_database open])
            {
                NSLog(@"Could not open database!");
            }
            
            [_database setLogsErrors:YES];
            
            /*
             *版本迭代需要增加表中的字段，可以在这里加。
             */
            
//            NSString *createSql=[self createSqlForTable:@"student"];
//            NSRange range= [createSql rangeOfString:@"需要增加的字段"];
//            if (range.length == 0)
//            {
//                NSString *sql = [NSString stringWithFormat:@"ALTER TABLE circledraft ADD %@ TEXT DEFAULT 0",
//                                 @"需要增加的字段"];
//                [[self testDataDB] executeUpdate:sql,nil];
//            }
        }];
    }
    return _database;
}

-(NSString *)createSqlForTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE name = '%@' and type = 'table'",tableName];
    FMResultSet  *rs = [[self testDataDB] executeQuery:sql,nil];
    
    NSString  *str = nil;
    while ([rs next])
    {
        str = [rs stringForColumn:@"sql"];
        
    }
    return str;
}

//创建一个bundle路径
-(NSString *)bundlePath
{
    NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"test.db"];
    
    return bundlePath;
}

//移动bundle下的数据库到沙盒路径下
-(void)copybundledbToDocument
{
    NSString * bundlePath = [self bundlePath];
    
    NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DB"];
    
    NSString *dbpath = [documentPath stringByAppendingPathComponent:@"test.db"];
    
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    if (![filemanager fileExistsAtPath:documentPath])
    {
        [filemanager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![filemanager fileExistsAtPath:dbpath])
    {
       BOOL ret = [filemanager copyItemAtPath:bundlePath toPath:dbpath error:nil];
        if (ret)
        {
            NSLog(@"搬成功了");
        }
        else
        {
            NSLog(@"失败了");
        }
    }
}

-(void)insertdataarray:(NSMutableArray *)array
{
    [[self testDataDB] beginTransaction];
    //刚一启动应用，需要从服务端拉数据，需要先删除表中的内容，然后在重新插入表数据。
//    NSString *deleteSql = [NSString stringWithFormat:@"delete from student"];
    
//    [[self testDataDB] executeUpdate:deleteSql,nil];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into student (%@,%@,%@,%@,%@) values (?,?,?,?,?)",@"id",@"name",@"score",@"age",@"sex"];
    for (NSDictionary *dict in array)
    {
        [[self testDataDB] executeUpdate:insertSql,[self ret32bitString],dict[@"name"],dict[@"score"],dict[@"age"],dict[@"sex"],nil];
    }

    [[self testDataDB] commit];
}

- (NSString *)ret32bitString
{
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

-(void)updatedata:(NSString *)namestr
{
    NSString *updateSql = [NSString stringWithFormat:@"update student set name = '%@' where name = '小金子'",namestr];
    [[self testDataDB] executeUpdate:updateSql,nil];
}

-(void)deletedata:(NSString *)string
{
    NSString *updateSql = [NSString stringWithFormat:@"delete from student where name = '%@'",string];
    [[self testDataDB] executeUpdate:updateSql,nil];
}

-(void)selecteddata
{
    NSString *selectSql = [NSString stringWithFormat:@"select * from student "];
    [[self testDataDB] executeUpdate:selectSql,nil];
}

-(void)dropTable
{
    NSString *dropSql = [NSString stringWithFormat:@"drop table student"];
    [[self testDataDB] executeUpdate:dropSql,nil];
}

//有兴趣你们可以自己加
-(NSMutableArray *)searchDatalistFrom:(NSInteger)from limit:(NSInteger)limit
{
    NSMutableArray *listArr = [[NSMutableArray alloc]init];
    
    NSString *selectsql = [NSString stringWithFormat:@"select * from student order by age desc limit %ld,%ld",(long)from,(long)limit];
    FMResultSet *rs = [[self testDataDB] executeQuery:selectsql,nil];
    
    while ([rs next])
    {
        testModel *model = [[testModel alloc]init];
        
        model.name = [rs stringForColumn:@"name"];
        
        model.age = [rs stringForColumn:@"age"];
        
        model.score = [rs stringForColumn:@"score"];
        
        model.sex = [rs stringForColumn:@"sex"];
        
        [listArr addObject:model];
    }
    return listArr;
}
@end
