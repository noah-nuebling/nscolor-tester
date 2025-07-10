//
//  AppDelegate.m
//  NSColor-Tester
//
//  Created by Noah Nübling on 7/10/25.
//

#import "AppDelegate.h"
#import "MFObserver.h"
#import "MFTargetActionObserver.h"

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
    @property (weak) IBOutlet NSPopUpButton *pbbutton_fillColor;
    @property (weak) IBOutlet NSPopUpButton *pbutton_textColor;
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

    const NSArray *colors = @[
        
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
        NSColor.labelColor,
        NSColor.secondaryLabelColor,
        NSColor.tertiaryLabelColor,
        NSColor.quaternaryLabelColor,
        NSColor.quinaryLabelColor,
        NSColor.linkColor,
        NSColor.placeholderTextColor,
        NSColor.windowFrameTextColor,
        NSColor.selectedMenuItemTextColor,
        NSColor.alternateSelectedControlTextColor,
        NSColor.headerTextColor,
        NSColor.separatorColor,
        NSColor.gridColor,
        NSNull.null,
        
        /// Background colors
        NSColor.windowBackgroundColor,
        NSColor.underPageBackgroundColor,
        NSColor.controlBackgroundColor,
        NSColor.selectedContentBackgroundColor,
        NSColor.unemphasizedSelectedContentBackgroundColor,
        NSColor.alternatingContentBackgroundColors[0],
        NSColor.alternatingContentBackgroundColors[1],
        NSColor.findHighlightColor,
        NSNull.null,
        
        /// Text colors
        NSColor.textColor,
        NSColor.textBackgroundColor,
        NSColor.textInsertionPointColor,
        NSColor.selectedTextColor,
        NSColor.selectedTextBackgroundColor,
        NSColor.unemphasizedSelectedTextBackgroundColor,
        NSColor.unemphasizedSelectedTextColor,
        NSNull.null,
        
        /// Control colors
        NSColor.controlColor,
        NSColor.controlTextColor,
        NSColor.selectedControlColor,
        NSColor.selectedControlTextColor,
        NSColor.disabledControlTextColor,
        NSColor.keyboardFocusIndicatorColor,
        NSColor.scrubberTexturedBackgroundColor,
        NSNull.null,

        /// System colors
        NSColor.systemRedColor,
        NSColor.systemGreenColor,
        NSColor.systemBlueColor,
        NSColor.systemOrangeColor,
        NSColor.systemYellowColor,
        NSColor.systemBrownColor,
        NSColor.systemPinkColor,
        NSColor.systemPurpleColor,
        NSColor.systemGrayColor,
        NSColor.systemTealColor,
        NSColor.systemIndigoColor,
        NSColor.systemMintColor,
        NSColor.systemCyanColor,
        NSNull.null,
        
        /// Fill colors for UI elements
        NSColor.systemFillColor,
        NSColor.secondarySystemFillColor,
        NSColor.tertiarySystemFillColor,
        NSColor.quaternarySystemFillColor,
        NSColor.quinarySystemFillColor,
        NSColor.controlAccentColor,
        //NSControlTint currentControlTint;
        //colorForControlTint:
        NSColor.highlightColor,
        NSColor.shadowColor,
        //[[NSColor alloc] highlightWithLevel: 0],
        //[[NSColor alloc] shadowWithLevel: 0],
        NSNull.null,
        
        /// Deprecated
        NSColor.controlHighlightColor,
        NSColor.controlLightHighlightColor,
        NSColor.controlShadowColor,
        NSColor.controlDarkShadowColor,

        NSColor.scrollBarColor,
        NSColor.knobColor,
        NSColor.selectedKnobColor,

        NSColor.windowFrameColor,
        NSColor.selectedMenuItemColor,
        NSColor.headerColor,

        NSColor.secondarySelectedControlColor,
        NSColor.alternateSelectedControlColor,
        NSColor.controlAlternatingRowBackgroundColors[0],
        NSColor.controlAlternatingRowBackgroundColors[1],
        NSNull.null,
    ];

    
    if ((1)) {
        
        [_pbbutton_fillColor removeAllItems];
        [_pbutton_borderColor removeAllItems];
        [_pbutton_textColor removeAllItems];
        
        for (int i = 0; i < colors.count; i++) {
            
            NSMenuItem *item = nil;
            if (colors[i] == NSNull.null) {
                item = NSMenuItem.separatorItem;
            }
            else {
                NSColor *color = colors[i];
                color = [color colorUsingType: NSColorTypeCatalog];
            
                item = [[NSMenuItem alloc] init];
                NSString *identifier = [NSString stringWithFormat: @"%@ (%@)", color.colorNameComponent, color.catalogNameComponent];
                item.title = identifier;
                item.identifier = identifier;
                
                item.representedObject = color;
            }
            
            [_pbbutton_fillColor.menu   addItem: item];
            [_pbutton_borderColor.menu  addItem: item.copy];
            [_pbutton_textColor.menu    addItem: item.copy];
        }
        
        
        #define linkcolor(object_, property_, pbutton_) \
            [(pbutton_) mf_observeUsingAction: mfkp((pbutton_), selectedItem.representedObject) block:^(id  _Nonnull newValue) { \
                object_.property_ = newValue; \
            }]; \
            [object_ mf_observe: mfkp(object_, property_) block:^(id  _Nonnull newValue) { \
                [(pbutton_) selectItemWithRepresentedObject: newValue]; \
            }] \
            
        linkcolor(self.box, fillColor, self.pbbutton_fillColor);
        linkcolor(self.box, borderColor, self.pbutton_borderColor);
        linkcolor(self.text, textColor, self.pbutton_textColor);
        
        #undef linkcolor
        
        double borderWidthMin = 0.1;
        double borderWidthMax = 10.0;
        
        [self.slider_borderWidth mf_observeUsingAction: mfkp(self.slider_borderWidth, doubleValue) block:^(id  _Nonnull newValue) {
            double newBorderWidth = mfscale([newValue doubleValue], (0, 1), (borderWidthMin, borderWidthMax));
            self.box.borderWidth = newBorderWidth;
            [self.display_borderWidth setStringValue: [NSString stringWithFormat: @"%.1f px", newBorderWidth]];
        }];
        [self.box mf_observe: mfkp(self.box, borderWidth) block:^(id  _Nonnull newValue) {
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
