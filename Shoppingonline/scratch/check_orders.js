require('../server/utils/MongooseUtil');
const { Order } = require('../server/models/Models');

async function checkOrders() {
  try {
    const orders = await Order.find({}).exec();
    console.log('Total orders in DB:', orders.length);
    orders.forEach((ord, i) => {
      console.log(`Order #${i+1} ID: ${ord._id}, status: ${ord.status}, customer: ${JSON.stringify(ord.customer)}`);
    });
    process.exit(0);
  } catch (err) {
    console.error('Error fetching orders:', err);
    process.exit(1);
  }
}

checkOrders();
