const mongoose = require("mongoose");
const Message = require("./Message");

const InboxSchema = mongoose.Schema({
    chat: [
        {
            id: Number,
            messages: [
                {
                    message: Message,
                },
            ],
            isArchived: Boolean,
            isDeleted: Boolean,
            isReported: Boolean,
        },
    ],
});

const Inbox = (module.exports = mongoose.model("Inbox", InboxSchema));

module.exports = Inbox;
