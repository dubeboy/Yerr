const mongoose = require("mongoose");

//Schema
const CommentSchema = mongoose.Schema({
    body: String,
    timestamp: Date,
    upVote: Number,
    downVote: Number,
    isFlagged: Boolean,
    author: {
        username: String,
        profilePicUUID: String,
    },
    isDeleted: Boolean,
    isEdited: Boolean,
});

const Comment = (module.exports = mongoose.model("Comment", CommentSchema));

module.exports = Comment;
