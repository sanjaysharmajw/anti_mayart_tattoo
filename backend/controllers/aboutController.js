const About = require('../models/About');

exports.createAbout = async (req, res) => {
    try {
        const { title, description } = req.body;
        const newAbout = new About({ title, description });
        await newAbout.save();
        res.status(201).json({ message: 'About created successfully', data: newAbout });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getAbout = async (req, res) => {
    try {
        const abouts = await About.find();
        res.status(200).json({ data: abouts });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updateAbout = async (req, res) => {
    try {
        const { id, title, description } = req.body;
        const updatedAbout = await About.findByIdAndUpdate(id, { title, description }, { new: true });
        res.status(200).json({ message: 'About updated successfully', data: updatedAbout });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteAbout = async (req, res) => {
    try {
        const { id } = req.body;
        await About.findByIdAndDelete(id);
        res.status(200).json({ message: 'About deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
