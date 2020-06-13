const mongoose = require("mongoose");

const LevelSchema = mongoose.Schema({});

const Level = (module.exports = mongoose.model("Level", LevelSchema));

module.exports = Level;
