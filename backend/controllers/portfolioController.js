const Portfolio = require('../models/Portfolio');
const path = require('path');
const fs = require('fs');

exports.createPortfolio = async (req, res) => {
    try {
        const { title } = req.body;
        const image = req.file ? `/uploads/${req.file.filename}` : null;
        if (!image) return res.status(400).json({ error: 'Image is required' });

        const newPortfolio = new Portfolio({ title, image });
        await newPortfolio.save();
        res.status(201).json({ message: 'Portfolio created successfully', data: newPortfolio });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getPortfolio = async (req, res) => {
    try {
        const portfolios = await Portfolio.find();
        res.status(200).json({ data: portfolios });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updatePortfolio = async (req, res) => {
    try {
        const { id, title } = req.body;
        const portfolio = await Portfolio.findById(id);
        if (!portfolio) return res.status(404).json({ error: 'Portfolio not found' });

        portfolio.title = title || portfolio.title;
        if (req.file) {
            // Delete old image
            const oldImagePath = path.join(__dirname, '..', portfolio.image);
            if (fs.existsSync(oldImagePath)) {
                fs.unlinkSync(oldImagePath);
            }
            portfolio.image = `/uploads/${req.file.filename}`;
        }

        await portfolio.save();
        res.status(200).json({ message: 'Portfolio updated successfully', data: portfolio });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deletePortfolio = async (req, res) => {
    try {
        const { id } = req.body;
        const portfolio = await Portfolio.findById(id);
        if (!portfolio) return res.status(404).json({ error: 'Portfolio not found' });

        const imagePath = path.join(__dirname, '..', portfolio.image);
        if (fs.existsSync(imagePath)) {
            fs.unlinkSync(imagePath);
        }

        await Portfolio.findByIdAndDelete(id);
        res.status(200).json({ message: 'Portfolio deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
