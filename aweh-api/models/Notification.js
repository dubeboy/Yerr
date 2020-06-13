const mongoose = require('mongoose');

//Schema
const NotificationSchema = mongoose.Schema({
    body: String,
    timestamp: Date,
    type: String,
    recipient: {
        username: String,
        profilePicUUID: String,
    },
    isRead: Boolean,
});

const Notification = module.exports = mongoose.model('Notification', NotificationSchema);

module.exports = Notification;