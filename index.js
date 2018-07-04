const sharp = require('sharp');

sharp('test.pdf', { density: 150 }).png({ compressionLevel: 9 }).toFile('test.png');
