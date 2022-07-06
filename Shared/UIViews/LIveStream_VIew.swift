//
//  LIveStream_VIew.swift
//  28
//
//  Created by Hamna on 2021/11/23.
//

import SwiftUI
import WebKit


class StreamSettings: ObservableObject {
    @Published var streaming = false
    @Published var username: String = "000-000-000"
    @Published var pwd: String = "3030"
}

//struct Streaming_View: View {    use when required login
//    @StateObject var settings = StreamSettings()
//    @ViewBuilder
//    var body: some View {
//        if settings.streaming{
//            LiveStream_View().environmentObject(settings)
//
//        }
//        else {
//            DeviceIdentification_View().environmentObject(settings)
//
//        }
//    }
//}

struct Streaming_View: View {
    @StateObject var settings = StreamSettings()
    @ViewBuilder
    var body: some View {
        LiveStream_View().environmentObject(settings)
    }
}



struct DeviceIdentification_View: View{
    @EnvironmentObject var settings: StreamSettings
    var body: some View{
        VStack{
            TextField("Device ID" , text: $settings.username)
                .padding()
                .background(Color("gray1"))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password" , text: $settings.pwd)
                .padding()
                .background(Color("gray1"))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {print("Button tapped")
                settings.streaming.toggle()
            }) {
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
                        }
            
        }
        .padding()
    }

}



struct LiveStream_View: View {
    @EnvironmentObject var settings: StreamSettings
    let webView = WKWebView()
    var body: some View {
        WebView(settings: settings)
            .onDisappear{
                
            }
    }
}


struct WebView: UIViewRepresentable {
    var settings: StreamSettings
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
            webConfiguration.allowsInlineMediaPlayback = true
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //let url_concat = "http://mlv.co.kr/ict/showid.php?devid='"+settings.username+"'&key='"+settings.pwd+"'"
        let url1 = #"http://mlv.co.kr/ict/showvid.php?devid='\#(String(settings.username))'&key='\#(String(settings.pwd))'"#
        print(url1)
        if let url = URL(string: url1)  {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {

    }
}

struct LiveStream_View_Previews: PreviewProvider {
    static var previews: some View {
        LiveStream_View()
    }
}
