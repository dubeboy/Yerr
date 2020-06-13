const mongoose = require('mongoose');

//Schema
const MessageSchema = mongoose.Schema({
    body: String,
    timestamp: Date,
    sender: {
        username: String,
        profilePicUUID: String,
    },
    recipient: {
        username: String,
        profilePicUUID: String,
    },
    isSent: Boolean,
    isRead: Boolean,
    isDeleted: Boolean
});

const Message = module.exports = mongoose.model('Message', MessageSchema);

module.exports = Message;