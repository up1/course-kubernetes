// Switch to the products database
db = db.getSiblingDB('products_db');

// Create a collection for products
db.createCollection('products');

// Insert initial product data
db.products.insertMany([
  {
    id: 1,
    name: "Laptop",
    price: 999.99
  },
  {
    id: 2,
    name: "Smartphone",
    price: 699.99
  },
  {
    id: 3,
    name: "Tablet",
    price: 299.99
  },
  {
    id: 4,
    name: "Headphones",
    price: 199.99
  },
  {
    id: 5,
    name: "Keyboard",
    price: 79.99
  },
  {
    id: 6,
    name: "Mouse",
    price: 49.99
  },
  {
    id: 7,
    name: "Monitor",
    price: 249.99
  },
  {
    id: 8,
    name: "Webcam",
    price: 89.99
  },
  {
    id: 9,
    name: "Speakers",
    price: 129.99
  },
  {
    id: 10,
    name: "Printer",
    price: 159.99
  }
]);

// Create an index on the id field for better performance
db.products.createIndex({ "id": 1 }, { unique: true });

// Print confirmation
print("Database initialized with product data");
print("Total products inserted:", db.products.countDocuments());
