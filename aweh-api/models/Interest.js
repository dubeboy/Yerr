const mongoose = require("mongoose");

const InterestSchema = mongoose.Schema({
    title: String,
    description: String,
});

const Interest = (module.exports = mongoose.model("Interest", InterestSchema));

module.exports = Interest;
