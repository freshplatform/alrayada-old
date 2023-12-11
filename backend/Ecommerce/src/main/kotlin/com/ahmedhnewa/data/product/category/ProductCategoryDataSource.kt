package com.ahmedhnewa.data.product.category

import com.ahmedhnewa.data.CrudRepository

interface ProductCategoryDataSource: CrudRepository<ProductCategory, String> {
    suspend fun getAllChildrenOf(id: String): List<ProductCategory>
    suspend fun getByName(name: String): ProductCategory?
}