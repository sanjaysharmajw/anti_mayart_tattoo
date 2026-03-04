const Tattoo = require('../models/Tattoo');
const path = require('path');
const fs = require('fs');

exports.createTattoo = async (req, res) => {
    try {
        const { title } = req.body;
        const image = req.file ? `/uploads/${req.file.filename}` : null;
        if (!image) return res.status(400).json({ error: 'Image is required' });

        const newTattoo = new Tattoo({ title, image });
        await newTattoo.save();
        res.status(201).json({ message: 'Tattoo created successfully', data: newTattoo });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getTattoo = async (req, res) => {
    try {
        const tattoos = await Tattoo.find();
        res.status(200).json({ data: tattoos });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updateTattoo = async (req, res) => {
    try {
        const { id, title } = req.body;
        const tattoo = await Tattoo.findById(id);
        if (!tattoo) return res.status(404).json({ error: 'Tattoo not found' });

        tattoo.title = title || tattoo.title;
        if (req.file) {
            const oldImagePath = path.join(__dirname, '..', tattoo.image);
            if (fs.existsSync(oldImagePath)) {
                fs.unlinkSync(oldImagePath);
            }
            tattoo.image = `/uploads/${req.file.filename}`;
        }

        await tattoo.save();
        res.status(200).json({ message: 'Tattoo updated successfully', data: tattoo });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteTattoo = async (req, res) => {
    try {
        const { id } = req.body;
        const tattoo = await Tattoo.findById(id);
        if (!tattoo) return res.status(404).json({ error: 'Tattoo not found' });

        const imagePath = path.join(__dirname, '..', tattoo.image);
        if (fs.existsSync(imagePath)) {
            fs.unlinkSync(imagePath);
        }

        await Tattoo.findByIdAndDelete(id);
        res.status(200).json({ message: 'Tattoo deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
