
//
//  Macros.h
//  swiftui-test-tahoe-beta
//
//  Created by Noah Nübling on 23.06.25.
//

/// Definitions to make the files copied from MMF work inside swiftui-test-tahoe (without pulling in half the project)

#ifndef Macros_h
#define Macros_h

#define loopc(varname, count) for (typeof(count+0) varname = 0; varname < (count); varname++) /// [Jun 2025] +0 removes `const` from the type

#endif /* Macros_h */
