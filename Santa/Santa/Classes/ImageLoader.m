//
//  ImageLoader.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/29/12.
//
//

#import "ImageLoader.h"

@implementation ImageLoader

@synthesize delegate, index;

- (void)loadImage:(NSString *)imageURLString {
    NSURL *imgURL = [NSURL URLWithString:imageURLString];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:imgURL];
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (newConnection) {
        activeDownloadData = [[NSMutableData data] retain]; // Важный момент - сделать retain
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [activeDownloadData setLength:0]; //Если есть отклик от сервера, ставим буфер в 0
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [activeDownloadData appendData:data]; // Собираем данные файла
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
    [activeDownloadData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [UIImage imageWithData:activeDownloadData]; // Создаем из данных каритнку
    if (delegate != nil) {
        [delegate appImageDidLoad:image index:index]; // Вызываем метод делегата
    }
    else {
        activeDownloadData = nil;
        NSLog(@"Can't find delegate for ImageLoader");
    }
    [activeDownloadData release];
    [connection release];
}


- (void)dealloc {
    [super dealloc];
}

@end