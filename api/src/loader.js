require('nocamel');
const express = require('express');
const expressWs = require('express-ws');
const globals = require('./globals');
const config = require('./config');
const path = require('path');
const fs = require('fs/promises');
const fss = require('fs');
const body_parser = require('body-parser');
const runtime = require('./runtime');
const logger = require('logplease').create('loader');

const package_dir = path.join(config.data_directory, globals.data_directories.packages);

logger.info('Scanning for pre-installed packages...');

// Use fss.existsSync
if (!fss.existsSync(package_dir)) {
    logger.info('No packages directory found, skipping scan.');
    return;
}

// Use fss.readdirSync
const languages = fss.readdirSync(package_dir);

for (const lang of languages) {
    const lang_path = path.join(package_dir, lang);
    // Use fss.statSync
    if (!fss.statSync(lang_path).isDirectory()) continue;

    const versions = fss.readdirSync(lang_path);

    for (const version of versions) {
        const version_path = path.join(lang_path, version);
        if (!fss.statSync(version_path).isDirectory()) continue;

        const pkg_info_path = path.join(version_path, 'pkg-info.json');

        if (fss.existsSync(pkg_info_path)) {
            try {
                logger.info(`Found pre-installed package: ${lang}-${version}`);
                runtime.load_package(version_path);
            } catch (e) {
                logger.error(`Failed to load package ${lang}-${version}:`, e.message);
            }
        }
    }
}

