const mongoose = require("mongoose");

//Schema
const NotificationSchema = mongoose.Schema({
    message: {
        token: String,
        notification: {
            body: String,
            timestamp: Date,
            type: String,
            to: {
                _id: String,
                profilePicUUID: String,
            },
            from: {
                _id: String,
                profilePicUUID: String,
            },
            isRead: Boolean,
            isMuted: Boolean,
        },
    },
});

const Notification = (module.exports = mongoose.model(
    "Notification",
    NotificationSchema
));

module.exports = Notification;
