const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Controllers
const aboutController = require('../controllers/aboutController');
const portfolioController = require('../controllers/portfolioController');
const tattooController = require('../controllers/tattooController');
const contactController = require('../controllers/contactController');

// Multer Setup
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        const dir = path.join(__dirname, '..', 'uploads');
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir);
        }
        cb(null, dir);
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});
const upload = multer({ storage: storage });

// About API
router.post('/createAbout', aboutController.createAbout);
router.post('/getAbout', aboutController.getAbout);
router.post('/updateAbout', aboutController.updateAbout);
router.post('/deleteAbout', aboutController.deleteAbout);

// Portfolio API
router.post('/createPortfolio', upload.single('image'), portfolioController.createPortfolio);
router.post('/getPortfolio', portfolioController.getPortfolio);
router.post('/updatePortfolio', upload.single('image'), portfolioController.updatePortfolio);
router.post('/deletePortfolio', portfolioController.deletePortfolio);

// Latest Tattoos API
router.post('/createTattoo', upload.single('image'), tattooController.createTattoo);
router.post('/getTattoo', tattooController.getTattoo);
router.post('/updateTattoo', upload.single('image'), tattooController.updateTattoo);
router.post('/deleteTattoo', tattooController.deleteTattoo);

// Contact Us API
router.post('/createContact', contactController.createContact);
router.post('/getContacts', contactController.getContacts);
router.post('/deleteContact', contactController.deleteContact);

module.exports = router;
