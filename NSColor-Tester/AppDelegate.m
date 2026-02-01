//
//  AppDelegate.m
//  NSColor-Tester
//
//  Created by Noah Nübling on 7/10/25.
//

#import "AppDelegate.h"
#import "MFObserver.h"
#import "MFTargetActionObserver.h"
#import "ColorDescriptionDisplay.h"

@implementation NSPopUpButton (Additions)

    - (BOOL)selectItemWithRepresentedObject:(id _Nonnull) representedObject {
        for (NSMenuItem *item in self.itemArray)
            if ([item.representedObject isEqual: representedObject]) {
                [self selectItem: item];
                return YES;
            }
        return NO;
    }

@end

@interface AppDelegate ()

    @property (strong) IBOutlet NSWindow *window;

    @property (weak) IBOutlet NSBox *box;
    @property (weak) IBOutlet NSTextField *text;

    @property (weak) IBOutlet NSPopUpButton *pbutton_borderColor;
    @property (weak) IBOutlet ColorDescriptionDisplay *colorDescriptionDisplay_borderColor;
    @property (weak) IBOutlet NSPopUpButton *pbbutton_fillColor;
    @property (weak) IBOutlet ColorDescriptionDisplay *colorDescriptionDisplay_fillColor;
    @property (weak) IBOutlet NSPopUpButton *pbutton_textColor;
    @property (weak) IBOutlet ColorDescriptionDisplay *colorDescriptionDisplay_textColor;
    @property (weak) IBOutlet NSTextField *display_borderWidth;
    @property (weak) IBOutlet NSSlider *slider_borderWidth;

@end

#define UNPACK(x...) x
#define mfkp(obj, keypath) ({ (void)obj.keypath; @#keypath; })
double _mfscale(double x, double from_0, double from_1, double to_0, double to_1) {
    double unit = (x - from_0) / (from_1 - from_0);
    double result = unit * (to_1 - to_0) + to_0;
    return result;
}
#define mfscale(x, from, to) _mfscale(x, UNPACK from, UNPACK to)

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    #define xxx(color) \
        @{ @"name": [@#color substringFromIndex: @"NSColor.".length], @"value": color }

    const NSArray <NSDictionary <NSString *, id> *> *colors = @[
        
        /// "Standard" colors
//        NSColor.blackColor,
//        NSColor.darkGrayColor,
//        NSColor.lightGrayColor,
//        NSColor.whiteColor,
//        NSColor.grayColor,
//        NSColor.redColor,
//        NSColor.greenColor,
//        NSColor.blueColor,
//        NSColor.cyanColor,
//        NSColor.yellowColor,
//        NSColor.magentaColor,
//        NSColor.orangeColor,
//        NSColor.purpleColor,
//        NSColor.brownColor,
//        NSColor.clearColor,
        
        
        /// Foreground colors
        xxx(NSColor.labelColor),
        xxx(NSColor.secondaryLabelColor),
        xxx(NSColor.tertiaryLabelColor),
        xxx(NSColor.quaternaryLabelColor),
        xxx(NSColor.quinaryLabelColor),
        xxx(NSColor.linkColor),
        xxx(NSColor.placeholderTextColor),
        xxx(NSColor.windowFrameTextColor),
        xxx(NSColor.selectedMenuItemTextColor),
        xxx(NSColor.alternateSelectedControlTextColor),
        xxx(NSColor.headerTextColor),
        xxx(NSColor.separatorColor),
        xxx(NSColor.gridColor),
        xxx(NSNull.null),
        
        /// Background colors
        xxx(NSColor.windowBackgroundColor),
        xxx(NSColor.underPageBackgroundColor),
        xxx(NSColor.controlBackgroundColor),
        xxx(NSColor.selectedContentBackgroundColor),
        xxx(NSColor.unemphasizedSelectedContentBackgroundColor),
        xxx(NSColor.alternatingContentBackgroundColors[0]),
        xxx(NSColor.alternatingContentBackgroundColors[1]),
        xxx(NSColor.findHighlightColor),
        xxx(NSNull.null),
        
        /// Text colors
        xxx(NSColor.textColor),
        xxx(NSColor.textBackgroundColor),
        xxx(NSColor.textInsertionPointColor),
        xxx(NSColor.selectedTextColor),
        xxx(NSColor.selectedTextBackgroundColor),
        xxx(NSColor.unemphasizedSelectedTextBackgroundColor),
        xxx(NSColor.unemphasizedSelectedTextColor),
        xxx(NSNull.null),
        
        /// Control colors
        xxx(NSColor.controlColor),
        xxx(NSColor.controlTextColor),
        xxx(NSColor.selectedControlColor),
        xxx(NSColor.selectedControlTextColor),
        xxx(NSColor.disabledControlTextColor),
        xxx(NSColor.keyboardFocusIndicatorColor),
        xxx(NSColor.scrubberTexturedBackgroundColor),
        xxx(NSNull.null),

        /// System colors
        xxx(NSColor.systemRedColor),
        xxx(NSColor.systemGreenColor),
        xxx(NSColor.systemBlueColor),
        xxx(NSColor.systemOrangeColor),
        xxx(NSColor.systemYellowColor),
        xxx(NSColor.systemBrownColor),
        xxx(NSColor.systemPinkColor),
        xxx(NSColor.systemPurpleColor),
        xxx(NSColor.systemGrayColor),
        xxx(NSColor.systemTealColor),
        xxx(NSColor.systemIndigoColor),
        xxx(NSColor.systemMintColor),
        xxx(NSColor.systemCyanColor),
        xxx(NSNull.null),
        
        /// Fill colors for UI elements
        xxx(NSColor.systemFillColor),
        xxx(NSColor.secondarySystemFillColor),
        xxx(NSColor.tertiarySystemFillColor),
        xxx(NSColor.quaternarySystemFillColor),
        xxx(NSColor.quinarySystemFillColor),
        xxx(NSColor.controlAccentColor),
        //NSControlTint currentControlTint;
        //colorForControlTint:
        xxx(NSColor.highlightColor),
        xxx(NSColor.shadowColor),
        //[[NSColor alloc] highlightWithLevel: 0],
        //[[NSColor alloc] shadowWithLevel: 0],
        xxx(NSNull.null),
        
        /// Deprecated
        xxx(NSColor.controlHighlightColor),
        xxx(NSColor.controlLightHighlightColor),
        xxx(NSColor.controlShadowColor),
        xxx(NSColor.controlDarkShadowColor),

        xxx(NSColor.scrollBarColor),
        xxx(NSColor.knobColor),
        xxx(NSColor.selectedKnobColor),

        xxx(NSColor.windowFrameColor),
        xxx(NSColor.selectedMenuItemColor),
        xxx(NSColor.headerColor),

        xxx(NSColor.secondarySelectedControlColor),
        xxx(NSColor.alternateSelectedControlColor),
        xxx(NSColor.controlAlternatingRowBackgroundColors[0]),
        xxx(NSColor.controlAlternatingRowBackgroundColors[1]),
        xxx(NSNull.null),
    ];

    
    if ((1)) {
        
        [_pbbutton_fillColor removeAllItems];
        [_pbutton_borderColor removeAllItems];
        [_pbutton_textColor removeAllItems];
        
        for (int i = 0; i < colors.count; i++) {
            
            NSMenuItem *item = nil;
            if (colors[i][@"value"] == NSNull.null) {
                item = NSMenuItem.separatorItem;
            }
            else {
                NSColor *color = colors[i][@"value"];
                color = [color colorUsingType: NSColorTypeCatalog];
            
                item = [[NSMenuItem alloc] init];
                NSString *identifier = colors[i][@"name"];
                item.title = identifier;
                item.identifier = identifier;
                
                item.representedObject = colors[i];
            }
            
            [_pbbutton_fillColor.menu   addItem: item];
            [_pbutton_borderColor.menu  addItem: item.copy];
            [_pbutton_textColor.menu    addItem: item.copy];
        }
        
        
        #define linkcolor(object_, property_, pbutton_) \
            [(pbutton_) mf_observeUsingAction: mfkp((pbutton_), selectedItem.representedObject) block:^(id  _Nonnull newValue) { \
                object_.property_ = newValue[@"value"]; \
            }]; \
        
        linkcolor(self.box,  fillColor,   self.pbbutton_fillColor);
        linkcolor(self.box,  borderColor, self.pbutton_borderColor);
        linkcolor(self.text, textColor,   self.pbutton_textColor);
        
        linkcolor(self.colorDescriptionDisplay_fillColor,    color,   self.pbbutton_fillColor);
        linkcolor(self.colorDescriptionDisplay_borderColor,  color,   self.pbutton_borderColor);
        linkcolor(self.colorDescriptionDisplay_textColor,    color,   self.pbutton_textColor);
        
        #undef linkcolor
        
        double borderWidthMin = 0.1;
        double borderWidthMax = 10.0;
        
        [self.slider_borderWidth mf_observeUsingAction: mfkp(self.slider_borderWidth, doubleValue) block:^(id  _Nonnull newValue) {
            double newBorderWidth = mfscale([newValue doubleValue], (0, 1), (borderWidthMin, borderWidthMax));
            self.box.borderWidth = newBorderWidth;
            [self.display_borderWidth setStringValue: [NSString stringWithFormat: @"%.1f px", newBorderWidth]];
        }];
        [self.box mf_observe: mfkp(self.box,borderWidth) block: ^(id  _Nonnull newValue) {
            [self.slider_borderWidth setDoubleValue: mfscale([newValue doubleValue], (borderWidthMin, borderWidthMax), (0, 1))];
        }];
        
        
    if ((0)) {
        
        #define defaultBindingOptions /** These options are selected by default in IB */\
            NSRaisesForNotApplicableKeysBindingOption: @YES, \
            NSAllowsEditingMultipleValuesSelectionBindingOption: @YES, \
            NSRaisesForNotApplicableKeysBindingOption: @YES \
    
        [self.pbutton_borderColor bind: NSSelectedValueBinding toObject: self.box withKeyPath: mfkp(_box, borderColor) options: @{ defaultBindingOptions }];
        [self.pbbutton_fillColor bind: NSSelectedValueBinding toObject: self.box withKeyPath: mfkp(_box, fillColor) options: @{ defaultBindingOptions }];
    }
        
    }
}

@end
