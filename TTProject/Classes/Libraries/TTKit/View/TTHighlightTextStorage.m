//
//  TTHighlightTextStorage.m
//  TTProject
//
//  Created by Ivan on 16/4/15.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTHighlightTextStorage.h"

@interface TTHighlightTextStorage ()

@property (nonatomic, strong) NSMutableAttributedString *storeString;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) NSString *highlightPattern;

@end

@implementation TTHighlightTextStorage

#pragma mark - Override Methods

- (instancetype)initWithHighlightColor:(UIColor *)color pattern:(NSString *)pattern
{
    self = [super init];
    
    if (self) {
        self.normalColor = Color_Black;
        self.highlightColor = color;
        self.highlightPattern = pattern;
        self.storeString = [[NSMutableAttributedString alloc] init];
    }
    
    return self;
}

- (NSString *)string
{
    return self.storeString.string;
}

- (NSDictionary<NSString *,id> *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [self.storeString attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self.storeString replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
}

- (void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range
{
    [self.storeString setAttributes:attrs range:range];
    
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:0];
}

- (void)processEditing
{
    [super processEditing];
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:self.highlightPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange paragraphRange = [self.string paragraphRangeForRange:self.editedRange];
    
    [self cleanAttributeInRange:paragraphRange];
    
    [regularExpression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragraphRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        if ( result ) {
            [self addHighlightInRange:result.range];
        }        
    }];
    
}

- (void)cleanAttributeInRange:(NSRange)range
{
    [self removeAttribute:NSForegroundColorAttributeName range:range];
//    [self removeAttribute:NSFontAttributeName range:range];
    [self addAttribute:NSForegroundColorAttributeName value:self.normalColor range:range];
//    [self addAttribute:NSFontAttributeName value:FONT(self.fontSize) range:range];
}

- (void)addHighlightInRange:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:self.highlightColor range:range];
//    [self addAttribute:NSFontAttributeName value:BOLD_FONT(self.fontSize) range:range];
}

@end
