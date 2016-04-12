//
//  BaseTableViewCell.h
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

@interface BaseTableViewCell : UITableViewCell

/**
 *  cell 的数据对象
 */
@property (nonatomic, strong) id cellData;

/**
 *  刷新数据的方法
 */
- (void)reloadData;

/**
 *  返回当前 cell 的 identifier，默认为类名
 *
 *  @return 当前 cell 的 identifier
 */
+ (NSString *)cellIdentifier;

/**
 *  返回 tableview 中可复用的cell，identifier 取当前 cell 类名
 *
 *  @param tableView tableview
 *
 *  @return 
 */
+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView;

/**
 *  获得cell高度
 */
+ (CGFloat)heightForCell:(id)cellData;

@end
