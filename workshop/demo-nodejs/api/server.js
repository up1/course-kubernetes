const express = require("express");
const mysql = require("mysql2/promise");
const Redis = require("ioredis");
const client = require("prom-client");

const app = express();
app.use(express.json());

// ====== Prometheus Metrics ======
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

const httpRequestCounter = new client.Counter({
  name: "http_requests_total",
  help: "Total number of HTTP requests",
  labelNames: ["method", "endpoint"]
});

// ====== Environment Variables ======
const PORT = process.env.APP_PORT || 3000;
const DATABASE_URL = process.env.DATABASE_URL || "mysql://user:password@localhost:3306/mydatabase";
const REDIS_HOST = process.env.REDIS_HOST || "localhost";
const REDIS_PORT = process.env.REDIS_PORT || 6379;

// ====== MySQL Connection ======
const pool = mysql.createPool({
  uri: DATABASE_URL,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// ====== Redis Connection ======
const redis = new Redis({ host: REDIS_HOST, port: REDIS_PORT });

// ====== Routes ======

// Health check
app.get("/", (req, res) => {
  httpRequestCounter.inc({ method: "GET", endpoint: "/" });
  // Get id of container hostname
  const os = require('os');
  const hostname = os.hostname();
  res.send(`Node.js App running in Kubernetes 🚀 - Host: ${hostname}`);
});

// Get data with caching
app.get("/api/users", async (req, res) => {
  httpRequestCounter.inc({ method: "GET", endpoint: "/api/users" });

  const cacheKey = "users:data";
  const cachedData = await redis.get(cacheKey);

  if (cachedData) {
    return res.json({ source: "cache", data: JSON.parse(cachedData) });
  }

  try {
    const [rows] = await pool.execute("SELECT * FROM users LIMIT 5");
    await redis.set(cacheKey, JSON.stringify(rows), "EX", 30); // cache for 30s
    res.json({ source: "database", data: rows });
  } catch (err) {
    console.error("Database error:", err);
    res.status(500).send("Database query failed");
  }
});

// Create new user
app.post("/api/users", async (req, res) => {
  httpRequestCounter.inc({ method: "POST", endpoint: "/api/users" });

  const { name, email } = req.body;
  try {
    const [result] = await pool.execute(
      "INSERT INTO users(name, email) VALUES(?, ?)",
      [name, email]
    );
    // Get the inserted user
    const [insertedUser] = await pool.execute(
      "SELECT * FROM users WHERE id = ?",
      [result.insertId]
    );
    await redis.del("users:data"); // clear cache
    res.status(201).json(insertedUser[0]);
  } catch (err) {
    console.error("Insert error:", err);
    res.status(500).send("Failed to insert user");
  }
});

// Prometheus endpoint
app.get("/metrics", async (req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
