import SwiftUI
import ToyWebView

struct ContentView: View {
    let html = """
        <body>
            <p>hello</p>
            <p class="inline">world</p>
            <p class="inline">:)</p>
            <div class="none"><p>this should not be shown</p></div>
            <style>
                .none {
                    display: none;
                }
                .inline {
                    display: inline;
                }
            </style>
        </body>
        """
    let css = """
        script, style {
            display: none;
        }
        p, div {
            display: block;
        }
        """

    var body: some View {
        ToyWebView(html: html, css: css)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
