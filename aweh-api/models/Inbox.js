const mongoose = require('mongoose');

const InboxSchema = mongoose.Schema({

});

const Inbox = module.exports = mongoose.model('Inbox', InboxSchema);

module.exports = Inbox;