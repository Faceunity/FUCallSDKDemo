//
//  CallTableViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallTableViewController.h"
#import "CallIncomingListener.h"

#define kDemoName @"DemoName"
#define kDemoSegue @"DemoSegue"
#define kCellReuseId @"CellReuseId"

@interface CallTableViewController ()
@property (nonatomic, strong) NSMutableArray *demoArray;
@end
@implementation CallTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupData];
}

- (void)setupData{
    _demoArray = [[NSMutableArray alloc] init];
    //双人通话
    NSDictionary *c2cDic = [NSDictionary dictionaryWithObjectsAndKeys:@"双人通话",kDemoName,@"toC2C",kDemoSegue,nil];
    [self.demoArray addObject:c2cDic];
    //多人通话
    NSDictionary *multiDic = [NSDictionary dictionaryWithObjectsAndKeys:@"多人通话",kDemoName,@"toMulti",kDemoSegue,nil];
    [_demoArray addObject:multiDic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _demoArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseId];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseId];
    }
    cell.textLabel.text = [_demoArray[indexPath.row] objectForKey:kDemoName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *segue = [_demoArray[indexPath.row] objectForKey:kDemoSegue];
    [self performSegueWithIdentifier:segue sender:nil];
}

@end
