const mongoose = require('mongoose');

const tattooSchema = new mongoose.Schema({
    title: { type: String, required: true },
    image: { type: String, required: true }
}, { timestamps: true });

module.exports = mongoose.model('Tattoo', tattooSchema);
