//
//  TableViewController.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/12.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property(nonatomic, strong)NSMutableArray * dataArr;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[].mutableCopy;
    for (int i=0; i<100; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%d", i+1]];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    GQEKBModel * model = [[GQEKBModel alloc]init];
    model.relativeView = cell ;
    model.scrollView = self.tableView;
    
    __weak typeof(self) weakSelf = self;
    model.scrollInsetBlock = ^(UIEdgeInsets insets) {
        weakSelf.tableView.contentInset = insets;
    };
    model.scrollOffsetBlock = ^(CGPoint point) {
        weakSelf.tableView.contentOffset = point;
    };
    
    model.kbType = GQKeyboardTypeText;
    model.placeHolder = @"您可以发送信息了";
    model.messageBlock = ^(NSString *message, NSString *placeHolder) {
        NSLog(@"发送消息 ===> %@   %@", placeHolder, message);
    };
    model.barHeightChangeBlock = ^(CGFloat barHeight, CGFloat kbHeight) {
        NSLog(@"高度改变 ===> %f   %f", barHeight, kbHeight);
    };
    
    [GQEmojiKBManager share].model = model;
    [[GQEmojiKBManager share] startEdit];

}



@end
