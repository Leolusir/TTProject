//
//  TTTopicParser.m
//  TTProject
//
//  Created by Ivan on 16/4/24.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SKTopicParser.h"

@implementation SKTopicParser

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    
    if (text.length == 0) {
        return NO;
    }
    
    NSRange paragraphRange = NSMakeRange(0, text.length);
    
    [text yy_removeAttributesInRange:paragraphRange];
    [text addAttributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:Color_Gray2} range:paragraphRange];
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"#[^#]+?#" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange matchRange = [regularExpression rangeOfFirstMatchInString:text.string options:0 range:paragraphRange];
    
    if ( matchRange.location == 0 ) {
        [text addAttributes:@{NSFontAttributeName:BOLD_FONT(14), NSForegroundColorAttributeName:Color_Green1} range:matchRange];
    }
    
    return YES;
}

@end
