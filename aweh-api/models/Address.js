const mongoose = require("mongoose");

const AddressSchema = mongoose.Schema({
    street: String,
    city: String,
    state: String,
    postCode: String,
    country: String,
});

const Address = (module.exports = mongoose.model("Address", AddressSchema));

module.exports = Address;
