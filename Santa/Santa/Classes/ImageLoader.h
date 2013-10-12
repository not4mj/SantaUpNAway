//
//  ImageLoader.h
//  Kangaroo
//
//  Created by Roman Semenov on 11/29/12.
//
//

#import <Foundation/Foundation.h>

@protocol ImageLoaderDelegate; // Предварительное объявление протокола, что бы не иметь проблем
// с объявлением свойства delegate

@interface ImageLoader : NSObject {
    id  delegate; // Свойство для задания делегата
    int index; // Свойство для упрощения обработки полученной картинки в делегате
    NSMutableData *activeDownloadData; // Буфер для данных
}

@property (nonatomic, assign) id  delegate;
@property (nonatomic) int index;

- (void)loadImage:(NSString *)imageURLString; // Метод, который грузит катринку.
// Принимает на вход URL на картинку

@end

@protocol ImageLoaderDelegate

- (void) appImageDidLoad:(UIImage *)image index:(int)index; // Метод делегата, вызываемый по получению файла

@end