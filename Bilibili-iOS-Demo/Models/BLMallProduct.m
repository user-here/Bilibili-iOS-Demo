#import "BLMallProduct.h"

@implementation BLMallProduct

+ (instancetype)productWithTitle:(NSString *)title
                           price:(NSString *)price
                             tag:(NSString *)tag
                      cardHeight:(CGFloat)cardHeight {
    BLMallProduct *product = [[BLMallProduct alloc] init];
    product.title = title;
    product.price = price;
    product.tag = tag;
    product.cardHeight = cardHeight;
    return product;
}

@end
