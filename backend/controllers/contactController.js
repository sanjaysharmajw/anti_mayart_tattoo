const Contact = require('../models/Contact');

exports.createContact = async (req, res) => {
    try {
        const { fullName, email, phoneNumber, message } = req.body;
        const newContact = new Contact({ fullName, email, phoneNumber, message });
        await newContact.save();
        res.status(201).json({ message: 'Contact created successfully', data: newContact });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getContacts = async (req, res) => {
    try {
        const contacts = await Contact.find();
        res.status(200).json({ data: contacts });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteContact = async (req, res) => {
    try {
        const { id } = req.body;
        await Contact.findByIdAndDelete(id);
        res.status(200).json({ message: 'Contact deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
