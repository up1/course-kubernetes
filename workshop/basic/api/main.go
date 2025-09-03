package main

import (
	// Add required Go packages
	"api/products"
	"context"
	"log"
	"os"

	"github.com/gin-gonic/gin"

	// Add the MongoDB driver packages
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// A global variable that will hold a reference to the MongoDB client
var mongoClient *mongo.Client

func main() {

	// Get uri of MongoDB from environment variable
	uri := os.Getenv("MONGODB_URI")
	if uri == "" {
		log.Fatal("MONGODB_URI environment variable is not set")
	}

	mongoClient, err := connect_to_mongodb(uri)
	if err != nil {
		log.Fatal("Could not connect to MongoDB")
	}
	productResource := &products.ProductResource{
		Client: mongoClient,
	}

	r := gin.Default()
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "OK",
		})
	})

	// Add product routes
	r.GET("/products", productResource.GetProducts)

	r.Run()
}

// Our implementation logic for connecting to MongoDB
func connect_to_mongodb(uri string) (*mongo.Client, error) {
	serverAPI := options.ServerAPI(options.ServerAPIVersion1)
	opts := options.Client().ApplyURI(uri).SetServerAPIOptions(serverAPI)

	client, err := mongo.Connect(context.TODO(), opts)
	if err != nil {
		panic(err)
	}
	err = client.Ping(context.TODO(), nil)
	mongoClient = client
	return client, err
}
