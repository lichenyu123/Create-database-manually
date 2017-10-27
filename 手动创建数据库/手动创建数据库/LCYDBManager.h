//
//  LCYDBManager.h
//  手动创建数据库
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface LCYDBManager : NSObject
{
    FMDatabase *_database;
}

+(instancetype)shareManager;

-(void)insertdataarray:(NSMutableArray *)array;
-(void)updatedata:(NSString *)namestr;
-(void)deletedata:(NSString *)string;
-(void)selecteddata;
-(void)dropTable;
@end
