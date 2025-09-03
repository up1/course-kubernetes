package products

import (
	"context"
	"net/http"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"

	"github.com/gin-gonic/gin"
)

type Product struct {
	ID    string `bson:"_id"`
	Name  string `bson:"name"`
	Price int    `bson:"price"`
}

type ProductResource struct {
	Client *mongo.Client
}

func (p *ProductResource) GetProducts(c *gin.Context) {
	// Find products
	cursor, err := p.Client.Database("products_db").Collection("products").Find(context.TODO(), bson.D{{}})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	// Map results
	var products []bson.M
	if err = cursor.All(context.TODO(), &products); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	// Return products
	c.JSON(http.StatusOK, products)
}
