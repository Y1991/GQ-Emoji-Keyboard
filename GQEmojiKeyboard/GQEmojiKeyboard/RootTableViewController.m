
//
//  RootTableViewController.m
//  CALayer的使用
//
//  Created by Guangquan Yu on 2017/8/23.
//  Copyright © 2017年 Guangquan Yu. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    

    [self addCell:@"【1】简单使用" class:@"ViewController"];
    [self addCell:@"【2】简单表视图使用" class:@"TableViewController"];
    
    [self.tableView reloadData];

}



- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
