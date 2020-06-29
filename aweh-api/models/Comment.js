const mongoose = require("mongoose");
const Vote = require("./Vote");

const CommentSchema = mongoose.Schema({
    body: {
        type: String,
        require: true,
    },
    authorName: {
        type: String,
        require: true,
    },
    authorProfilePicUUID: String,
    timestamp: Date,
    votes: [Vote.schema],
    isFlagged: Boolean,
    isDeleted: Boolean,
    isEdited: Boolean,
});

const Comment = (module.exports = mongoose.model("Comment", CommentSchema));

module.exports = Comment;
