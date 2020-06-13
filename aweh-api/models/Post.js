const mongoose = require("mongoose");

//Schema
const PostSchema = mongoose.Schema({
    body: String,
    timestamp: Date,
    author: {
        username: String,
        profilePicUUID: String,
    },
    media: {
        uuid: String,
        type: String,
        metaData: String,
    },
    comments: [],
    isEmergency: Boolean,
    isFlagged: Boolean,
    isHidden: Boolean,
    timeLimit: Number,
});

const Post = (module.exports = mongoose.model("Post", PostSchema));

module.exports = Post;
