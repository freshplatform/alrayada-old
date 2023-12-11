package com.ahmedhnewa.data.post

interface PostDataSource {
    suspend fun getAllPost(): List<Post>
}