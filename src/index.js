const config = require("./config.json");
const { Elm } = require("./Main");

Elm.Main.init({ flags: config });
