//
//  ColorDescriptionDisplay.m
//  NSColor-Tester
//
//  Created by Noah Nübling on 01.02.26.
//

#import "ColorDescriptionDisplay.h"

@implementation ColorDescriptionDisplay
    
    - (instancetype)initWithCoder:(NSCoder *)coder {
        if (self = [super initWithCoder:coder]) {
            self.editable = NO;
            self.font = [NSFont monospacedSystemFontOfSize: 0 weight: 0];
        }
        return self;
    }
    
    - (void)setColor:(NSColor *)color {
        
        self->_color = color;
        __auto_type desc = [NSMutableString new];
        {
            color = [color colorUsingColorSpace: [NSColorSpace deviceRGBColorSpace]];
            CGFloat r, g, b, a;
            [color getRed: &r green: &g blue: &b alpha: &a];
            [desc appendFormat:
                //@"%02X %02X %02X %02X",
                @"%3d %3d %3d %3d"
                ,(int)(100*r)
                ,(int)(100*g)
                ,(int)(100*b)
                ,(int)(100*a)
            ];
        }
        self.stringValue = desc;
        
    }
    
@end
