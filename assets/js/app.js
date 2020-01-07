/* -*- mode: web -*- */
// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import "bootstrap"
// import flatpickr from "flatpickr";

// Import local files

// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let Hooks = {}
Hooks.has_feather = {
    mounted() {
        feather.replace()
    },
    updated() {
        feather.replace()
    }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks})

// import LiveSocket from "phoenix_live_view"

// let liveSocket = new LiveSocket("/live")
liveSocket.connect()

