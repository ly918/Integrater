//
//  GNRButton.m
//  Integrater
//
//  Created by LvYuan on 2017/3/31.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRButton.h"

@implementation GNRButton

- (void)setTitleColor:(NSColor *)titleColor{
    _titleColor = titleColor;
    [self setButtonAlternateTitleColor:titleColor fontSize:self.fontSize];
}

- (void)setFontSize:(NSInteger)fontSize{
    _fontSize = fontSize;
    [self setButtonAlternateTitleColor:self.titleColor fontSize:fontSize];
}

- (void)setButtonAlternateTitleColor:(NSColor *)color fontSize:(NSInteger)fontSize{
    if (color == nil) {
        color = [NSColor whiteColor];
    }
    if (!fontSize) {
        fontSize = [NSFont systemFontSize];
    }
    NSFont *font = [NSFont systemFontOfSize:fontSize];
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:font,
                            NSFontAttributeName,
                            color,
                            NSForegroundColorAttributeName,
                            nil];
    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:[self alternateTitle] attributes:attrs];
    [self setAttributedAlternateTitle:attributedString];
    
}

@end
