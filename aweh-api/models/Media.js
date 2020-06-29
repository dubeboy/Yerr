const mongoose = require("mongoose");

const MediaSchema = mongoose.Schema({
    uuid: {
        type: String,
        require: true,
    },
    type: {
        type: String,
        require: true,
    },
    metaData: String,
});

const Media = (module.exports = mongoose.model("Media", MediaSchema));

module.exports = Media;
