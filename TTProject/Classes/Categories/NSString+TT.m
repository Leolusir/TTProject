//
//  NSString+TT.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "NSString+TT.h"
#import <CommonCrypto/CommonDigest.h>
#include <ctype.h>

@implementation NSString (TT)

- (NSString *)urldecode
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlencode
{
    static NSString * const kCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    static NSString * const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, (__bridge CFStringRef)kCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kCharactersToBeEscapedInQueryString, kCFStringEncodingUTF8);
}

- (NSString *)md5
{
    if(self == nil || [self length] == 0)
        return nil;
    
	const char* str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, (CC_LONG)strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x",result[i]];
	}   
	return ret;
}

- (NSString *)trim
{
    if( self == nil || [self isKindOfClass:[NSNull class]] ) {
        return nil;
    }
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGSize)sizeWithUIFont:(UIFont *)font forWidth:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [self sizeWithUIAttributes:attribute forWidth:width];
    return size;
}

- (CGSize)sizeWithUIFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing forWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [self sizeWithUIAttributes:attribute forWidth:width];
    return size;
}

- (CGSize)sizeWithUIAttributes:(NSDictionary *)attributes forWidth:(CGFloat)width
{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return size;
}

@end
