//
//  ViewController.m
//  TestHTMLtoWebView
//
//  Created by active on 2021/04/22.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKNavigationDelegate>//이거 안하면 도루묵구이

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_WebviewOutlet setNavigationDelegate:self];//이거 절대 중요하니까 무조건!

    //NSString 형태로 할꺼면 "를 \"로 바꿔야 한다
    //구랭 뭐 테스트 해보는 것도 나쁘진 않겠지
    NSString *htmlfile = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlfile encoding:NSUTF8StringEncoding error:nil];
    
    NSString *headerString = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>";
    //처음에 로딩되었을때 글자 확대용 meta 추가
    [_WebviewOutlet loadHTMLString:[headerString stringByAppendingString:htmlString] baseURL:[[NSBundle mainBundle] bundleURL]];//설정을 집어넣은 코드 넣기

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//여기서 html 을 변경해야 적용이된다.
    [_WebviewOutlet evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(NSString* result,NSError* error){
        NSLog(@"지금 적용된 html : %@",result);
    }];
    [_WebviewOutlet evaluateJavaScript:@"document.body.setAttribute('contentEditable','true')" completionHandler:nil];//편집 가능 기능 부여 위치 주목
   
}

- (IBAction)getTexttoHtml:(id)sender {
    [self SetTextHtml];//뽑아 누르면 작동하는 애
}
-(void)SetTextHtml{
    [_WebviewOutlet evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(NSString* result,NSError* error){
        NSLog(@"지금 적용된 html : %@",result);//여기 result 에 html 나옴
        result = [result stringByReplacingOccurrencesOfString:@"contenteditable=\"true\"" withString:@""];//편집 가능 여부 코드 삭제
        result = [result stringByReplacingOccurrencesOfString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">" withString:@""];//컨텐츠 확대 코드 삭제
        
        [self->_textviewOutlet setText:result];//내가 변경한거 빼고 출력
    }];
 
    [_WebviewOutlet evaluateJavaScript:@"document.documentElement.outerText.toString()" completionHandler:^(NSString* result,NSError* error){
        NSLog(@"html 내용 뽑기 : %@",result);
        [self->_showOnlyContentLayout setText:result];
    }];//->이게 그 검색할때 쓰면 될듯?
    
}
//-(void)BasicHtmlSetting{//하다 망한거
//    //뭔가 생각처럼 되지 않는다
//    NSString *jScript = @"document.head.meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no');";
//
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//    [wkUController addUserScript:wkUScript];
//
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//    wkWebConfig.userContentController = wkUController;
//
//    _WebviewOutlet = [[WKWebView alloc] initWithFrame:_WebviewOutlet.frame configuration:wkWebConfig];
//}

/*
지금 당장 안쓰는 코드 정리 (제발 정리 좀 해!)
 
 [_WebviewOutlet evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(NSString* result,NSError* error){
     NSLog(@"노래 조아 : %@",result);
 }];
 [_WebviewOutlet evaluateJavaScript:@"document.documentElement.outerText.toString()" completionHandler:^(NSString* result,NSError* error){
     NSLog(@"안 조아 : %@",result);
 }];//->이게 그 검색할때 쓰면 될듯?
 ->애네 둘은 좀 중요하니 주의
 
 //[self.webView loadHTMLString:[headerString stringByAppendingString:yourHTMLString] baseURL:nil];//원래 쓰던 녀석
//    [_WebviewOutlet loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
 //[_WebviewOutlet evaluateJavaScript:@"document.body.setAttribute('contentEditable','true')" completionHandler:nil];//편집 가능 기능 부여- 이건 건들지 마라
 
 
 NSString * sample =@"<html><h1>Is it Text?</h1><h6>Lorem ipsum dolor sit amet, laborum.</h6></body></html>";
//    sample = @"<html><body contenteditable=\"true\"><title>Test</title><p>테스트임</p><p><font size=\"4\">크기큼</font></p><p><font size=\"1\">작음</font></p><p><font color=\"#ffff00\">노란색색넣음</font></p><p><font style=\"BACKGROUND-COLOR: #ff0000\">배경빨간색넣음</font></p><p><strong>볼드</strong></p><p><em>이탤릭</em></p><p><u>밑줄</u></p><p>&nbsp;</p></body></html>";
 
//    sample = @"<html><body><title>Test</title><p>테스트임</p><p><font size=\"4\">크기큼</font></p><p><font size=\"1\">작음</font></p><p><font color=\"#ffff00\">노란색색넣음</font></p><p><font style=\"BACKGROUND-COLOR: #ff0000\">배경빨간색넣음</font></p><p><strong>볼드</strong></p><p><em>이탤릭</em></p><p><img src=\"https://www.w3schools.com/images/lamp.jpg\" alt=\"Lamp\" width=\"32\" height=\"32\"></p><p>&nbsp;</p></body></html>";
//
 
 sample = @"<html><head><title></title><meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\" /><style type=\"text/css\">P {    MARGIN: 3px}IMG {    BORDER-TOP: 0px; BORDER-RIGHT: 0px; BORDER-BOTTOM: 0px; BORDER-LEFT: 0px}BODY {    BORDER-TOP-STYLE: none; FONT-SIZE: 10pt; BORDER-LEFT-STYLE: none; FONT-FAMILY: 굴림; BORDER-BOTTOM-STYLE: none; COLOR: ; BORDER-RIGHT-STYLE: none; MARGIN: 0.1em}</style></head><body style=\"OVERFLOW: auto\" background=\"/BACK@IMG/activepost배너-1.png\" scroll=\"auto\"><p>테스트임</p><p><font size=\"4\">크기큼</font></p><p><font size=\"1\">작음</font></p><p><font color=\"#ffff00\">노란색색넣음</font></p></body></html>";

 
 //    [_WebviewOutlet loadHTMLString:sample baseURL:[[NSBundle mainBundle] resourceURL]];//이게 지금 넣는거
     
     
     //<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head> 이거 넣으면 크게 나온다
     
     
 //    NSAttributedString *attr = [[NSAttributedString alloc]
 //                                initWithData:[sample dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];//애가 제일 이상해;;;;;
 //////    _textviewOutlet.attributedText = attr;
 
 //???????아까 분명 됬는데 이번에는 안된다 뭐지 이 양아치는 ?
//  [_WebviewOutlet evaluateJavaScript:@"document.getElementsByTagName(\"body\")[0].setAttribute('contentEditable','true')" completionHandler:nil];//뭐 이론이랑 실제가 같은수는 없으니까...

// [self BasicHtmlSetting];
// [_WebviewOutlet evaluateJavaScript:@"document.createElement('meta'))" completionHandler:nil];//뭐 이론이랑 실제가 같은수는 없으니까...
 
// [_WebviewOutlet evaluateJavaScript:@"document.meta.setAttribute('user-scalable','no')" completionHandler:nil];//뭐 이론이랑 실제가 같은수는 없으니까...
 
// [_WebviewOutlet evaluateJavaScript:@"document.getElementsByTagName(\"meta\")[0].setAttribute('user-scalable','no')" completionHandler:nil];//뭐 이론이랑 실제가 같은수는 없으니까...

// [_WebviewOutlet evaluateJavaScript:@"document.getElementsByTagName(\"meta\")[0].setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no');" completionHandler:nil];//편집 가능 기능 부여
//    [_WebviewOutlet evaluateJavaScript:@"document.head.setAttribute('initial-scale','1.0');" completionHandler:nil];//편집 가능 기능 부여
//    [_WebviewOutlet evaluateJavaScript:@"document.head.setAttribute('initial-scale','1.0');" completionHandler:nil];//편집 가능 기능 부여
 
 
//    [_WebviewOutlet evaluateJavaScript:@"document.head.setAttribute('id','subtext')" completionHandler:nil];//편집 가능 기능 부여
 
 
 애는 버튼애 있던 코드
 //    NSString *html = @"";
 //
 //    NSDictionary *documentAttributed = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
 //    NSData *htmlData = [_textviewOutlet.attributedText dataFromRange:NSMakeRange(0, _textviewOutlet.attributedText.length) documentAttributes:documentAttributed error:nil];
 //
 //    html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
 //
 //
 //    NSLog(@"왕 : %@",html);
 //
 //   // [_WebviewOutlet loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
 //    [_labelOutlet setText:html];
 //
    // [_WebviewOutlet evaluateJavaScript:@"document.body.setAttribute('contentEditable','true')" completionHandler:nil];
 
 
 */

@end
