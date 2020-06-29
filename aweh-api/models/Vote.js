const mongoose = require("mongoose");

const VoteSchema = mongoose.Schema({
    voterId: String,
    upVote: Boolean,
});

const Vote = (module.exports = mongoose.model("Vote", VoteSchema));

module.exports = Vote;
