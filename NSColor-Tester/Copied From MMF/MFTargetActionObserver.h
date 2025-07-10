//
//  MFTargetActionObserver.h
//  swiftui-test-tahoe-beta
//
//  Created by Noah Nübling on 23.06.25.
//

#import "MFObserver.h"
#import "AppKit/AppKit.h"

typedef void (^MFTargetActionObserver_Callback) (id _Nullable sender);

@interface NSControl (MFTargetActionObserver)

- (void) mf_observeUsingAction: (NSString *_Nonnull)keypath block: (MFObserver_CallbackBlock_New _Nonnull)block;
- (void) mf_observeAction: (MFTargetActionObserver_Callback _Nonnull)callbackBlock;

@end
