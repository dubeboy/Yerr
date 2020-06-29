const mongoose = require("mongoose");
const Comment = require("./Comment");
const Media = require("./Media");
const Interest = require("./Interest");

const PostSchema = mongoose.Schema({
    body: {
        type: String,
        require: true,
    },
    timestamp: Date,
    authorName: {
        type: String,
        require: true,
    },
    interest: Interest.schema,
    authorProfilePicUUID: String,
    media: Media.schema,
    comments: [Comment.schema],
    isEmergency: Boolean,
    isFlagged: Boolean,
    isDeleted: Boolean,
    timeLimit: Number,
});

const Post = (module.exports = mongoose.model("Post", PostSchema));

module.exports = Post;
