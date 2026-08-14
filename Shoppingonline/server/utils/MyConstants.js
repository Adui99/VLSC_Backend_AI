const MyConstants = {
  DB_SERVER: 'cluster0.bjtzrj2.mongodb.net',
  DB_USER: 'duyhoang030199_db_user',
  DB_PASS: 'Ron@ldo9',
  DB_DATABASE: 'shoppingonline',
  EMAIL_USER: process.env.EMAIL_USER || 'never.again0121@gmail.com', // Gmail service
  EMAIL_PASS: process.env.EMAIL_PASS || 'pooobrqbdnkxetpz',
  JWT_SECRET: 'kipalog',
  JWT_EXPIRES: '36000000', // in milliseconds
};
module.exports = MyConstants;
