//
//  PostTextCell.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseTableViewCell.h"
#import <YYText/YYText.h>

@interface PostTextCell : BaseTableViewCell

+ (NSMutableAttributedString *)builtContentAttributedString:(NSString *)content;

+ (YYTextLayout *)builtTextLayout:(NSMutableAttributedString *)attributedString withMaxRow:(NSInteger)maxRow;

@end
