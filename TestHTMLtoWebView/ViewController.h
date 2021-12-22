//
//  ViewController.h
//  TestHTMLtoWebView
//
//  Created by active on 2021/04/22.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet WKWebView *WebviewOutlet;

@property (weak, nonatomic) IBOutlet UITextView *textviewOutlet;
- (IBAction)getTexttoHtml:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *showOnlyContentLayout;


@end

