const mongoose = require("mongoose");

const LevelSchema = mongoose.Schema({
    name: String,
    description: String,
});

const Level = (module.exports = mongoose.model("Level", LevelSchema));

module.exports = Level;
