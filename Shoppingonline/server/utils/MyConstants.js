require('dotenv').config();

const MyConstants = {
  DB_SERVER: process.env.DB_SERVER || 'cluster0.bjtzrj2.mongodb.net',
  DB_USER: process.env.DB_USER || 'duyhoang030199_db_user',
  DB_PASS: process.env.DB_PASS || 'Ron@ldo9',
  DB_DATABASE: process.env.DB_DATABASE || 'shoppingonline',
  EMAIL_USER: process.env.EMAIL_USER || 'never.again0121@gmail.com', // Gmail service
  EMAIL_PASS: process.env.EMAIL_PASS || 'pooobrqbdnkxetpz',
  JWT_SECRET: process.env.JWT_SECRET || 'kipalog',
  JWT_EXPIRES: process.env.JWT_EXPIRES || '36000000', // in milliseconds
};
module.exports = MyConstants;
