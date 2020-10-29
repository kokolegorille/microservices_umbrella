// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// https://github.com/phoenixframework/phoenix_live_view/issues/104
const hooks = {
    base64_upload: {
        mounted() {
            this.el.addEventListener("change", e => {
                const file = this.el.files[0];
                
                // Set the name of the file
                var hidden_name = document.getElementById("video_live_form_upload_base64_filename")
                hidden_name.value = file.name;
                hidden_name.focus() // this is needed to register the new value with live view

                toBase64(file).then(base64 => {
                    var hidden = document.getElementById("video_live_form_upload_base64") // change this to the ID of your hidden input
                    hidden.value = base64;
                    hidden.focus() // this is needed to register the new value with live view
                });        
            })
        }
    }
}


let liveSocket = new LiveSocket("/live", Socket, {hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

const toBase64 = file => new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
});