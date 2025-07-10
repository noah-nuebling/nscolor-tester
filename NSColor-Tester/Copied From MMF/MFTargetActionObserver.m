//
//  MFTargetActionObserver.m
//  swiftui-test-tahoe-beta
//
//  Created by Noah Nübling on 23.06.25.
//

///
/// [Jun 23 2025] This is a sloppy block-based wrapper around TargetAction, similar to how MFObserver is a block-based wrapper around KVO.
///     However, this is not well tested or thought through like MFObserver is – don't use this in production before reviewing!
///
/// Thread safety:
///     [Jun 2025] Since this will only be used on UI elements which should only be interacted with from the main thread anyways, I don't think we have to synchronize (which we do in MFObserver)
///
/// Motivation:
///     [Jun 2025] NSPopUpButton doesn't seem to support KVO, so we made this to get a block-based interface for observing NSPopUpButton's selected item
///

#import "MFTargetActionObserver.h"
#import "objc/runtime.h"

#define auto __auto_type

@interface MFTargetActionObserver : NSObject @end
@implementation MFTargetActionObserver
    {
        @public
        NSMutableSet<MFTargetActionObserver_Callback> *__strong callbacks;
    }
    - (void) handleAction: (id _Nullable)sender {
        for (MFTargetActionObserver_Callback callback in self->callbacks) callback(sender);
    }
@end


@implementation NSControl (MFTargetActionObserver)

- (void) mf_observeUsingAction: (NSString *_Nonnull)keypath block: (MFObserver_CallbackBlock_New _Nonnull)block {
    /// Observe a keypath on an object but detect changes via TargetAction instead of KVO
    ///     [Jun 2025] This is necessary to observe the selected item on NSPopUpButton – it doesn't support KVO
    
    block([self valueForKeyPath: keypath]);
    [self mf_observeAction: ^void (id _Nullable sender) {
        block([self valueForKeyPath: keypath]);
    }];
};

- (void) mf_observeAction: (MFTargetActionObserver_Callback _Nonnull)callbackBlock {
    
    MFTargetActionObserver *observer;
    ({
        static const char *key = "MFTargetActionObserver";
        observer = objc_getAssociatedObject(self, key);
        if (!observer) {
            observer = [MFTargetActionObserver alloc];
            [self setTarget: observer];
            [self setAction: @selector(handleAction:)];
            objc_setAssociatedObject(self, key, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    });
    
    if (!observer->callbacks) {
        observer->callbacks = [NSMutableSet set];
    }
    
    [observer->callbacks addObject: callbackBlock];
}

@end
