const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const publicDir = path.join(rootDir, 'public');
const customerBuild = path.join(rootDir, 'client-customer', 'build');
const adminBuild = path.join(rootDir, 'client-admin', 'build');

console.log('Preparing production static assets...');

// Clean public directory
if (fs.existsSync(publicDir)) {
  fs.rmSync(publicDir, { recursive: true, force: true });
}
fs.mkdirSync(publicDir, { recursive: true });

// Copy customer build to public/
if (fs.existsSync(customerBuild)) {
  console.log(`Copying client-customer build -> ${publicDir}`);
  fs.cpSync(customerBuild, publicDir, { recursive: true });
} else {
  console.warn(`Warning: ${customerBuild} not found!`);
}

// Copy admin build to public/admin/
const publicAdminDir = path.join(publicDir, 'admin');
if (fs.existsSync(adminBuild)) {
  console.log(`Copying client-admin build -> ${publicAdminDir}`);
  fs.mkdirSync(publicAdminDir, { recursive: true });
  fs.cpSync(adminBuild, publicAdminDir, { recursive: true });
} else {
  console.warn(`Warning: ${adminBuild} not found!`);
}

console.log('Production assets prepared successfully in public/');
