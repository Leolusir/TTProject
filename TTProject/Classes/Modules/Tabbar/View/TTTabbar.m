//
//  TTTabbar.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTTabbar.h"

@interface TTTabbar ()

@property(nonatomic,retain) NSMutableArray *items;
@property(nonatomic,assign) NSUInteger selectedIndex;
@property(nonatomic,retain) UIView *barPanel;

@end

@implementation TTTabbar

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items delegate:(id<TTTabbarDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.items = [items copy];
        [self loadContent];
    }
    return self;
}

- (void)loadContent
{
    self.barPanel = [[UIView alloc]initWithFrame:self.bounds];
    self.barPanel.backgroundColor = Color_White;
    [self addSubview:self.barPanel];
    
    //描边
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LINE_WIDTH)];
    topLine.backgroundColor = Color_Green1;
    [self addSubview:topLine];
    [self bringSubviewToFront:topLine];
    
    
    self.selectedIndex = 0;
    
    [self addItems];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.barPanel.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void)selectItemAtIndex:(NSInteger)index
{
    if (index < self.items.count) {
        [self tabBarItemdidSelected:self.items[index]];
    }
}

#pragma -mark
#pragma -mark reload data
- (void)addItems
{
    NSUInteger barNum = self.items.count;
    CGFloat width = (self.width) / barNum;
    CGFloat xOffset = 0.0f;
    
    for (int i = 0; i < barNum; i++) {
        
        TTTabbarItem *item = self.items[i];
        item.width = width;
        item.height = self.height;
        item.left = xOffset;
        item.delegate = self;
        if (i == self.selectedIndex) {
            item.selected = YES;
        }
        item.tag = -i;
        xOffset += width;
        
        [self.barPanel addSubview:item];
        
    }
}

#pragma -mark
#pragma -mark tabbar item delegate
- (void)tabBarItemdidSelected:(TTTabbarItem *)item{
    
    NSUInteger index = -item.tag;
    
    if (index >= [self.items count]) {
        return;
    }
    
    if (self.selectedIndex != index) {
        
        BOOL shouldSelect = YES;
        if ([self.delegate respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
            shouldSelect = [self.delegate tabBar:self shouldSelectItemAtIndex:index];
        }
        
        if (!shouldSelect) {
            return;
        }
        
        TTTabbarItem *old = [self.items objectAtIndex:self.selectedIndex];
        if (old) {
            old.selected = NO;
        }
        
    }
    
    self.selectedIndex = index;
    item.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        [self.delegate tabBar:self didSelectItemAtIndex:index];
    }
}

@end
