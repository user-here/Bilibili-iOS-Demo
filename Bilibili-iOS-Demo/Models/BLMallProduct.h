#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMallProduct : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) CGFloat cardHeight;

+ (instancetype)productWithTitle:(NSString *)title
                           price:(NSString *)price
                             tag:(NSString *)tag
                      cardHeight:(CGFloat)cardHeight;

@end

NS_ASSUME_NONNULL_END
