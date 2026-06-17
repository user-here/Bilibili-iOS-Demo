#import <UIKit/UIKit.h>

#ifndef BLTheme_h
#define BLTheme_h

static inline UIColor *BLPinkColor(void) {
    return [UIColor colorWithRed:0.93 green:0.29 blue:0.53 alpha:1.0];
}

static inline UIColor *BLTextPrimaryColor(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

static inline UIColor *BLTextSecondaryColor(void) {
    return [UIColor colorWithWhite:0.5 alpha:1.0];
}

static inline UIColor *BLTextTertiaryColor(void) {
    return [UIColor colorWithWhite:0.36 alpha:1.0];
}

static inline UIColor *BLSeparatorColor(void) {
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

static inline UIColor *BLBackgroundColor(void) {
    return [UIColor whiteColor];
}

static inline UIColor *BLDarkBackgroundColor(void) {
    return [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1.0];
}

#endif
