package com.jianquanwang.ecommerce.controller;

import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.service.CategoryService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/public/categories")
public class CategoryController {

    private CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("")
    public ResponseEntity<List<Category>> getAllCategories() {
        List<Category> categories = categoryService.getAllCategories();
        return new ResponseEntity<>(categories, HttpStatus.OK);
    }

    @PostMapping("")
    public ResponseEntity<String> createCategory(@Valid @RequestBody Category category) {
        this.categoryService.createCategory(category);
        return new ResponseEntity<>("Category added successfully", HttpStatus.CREATED);
    }

    @DeleteMapping("{categoryId}")
    public ResponseEntity<String> deleteCategory(@PathVariable  Long categoryId) {
        String status = this.categoryService.deleteCategory(categoryId);
        return ResponseEntity.ok(status);
    }
    @PutMapping("{categoryId}")
    public ResponseEntity<String> updateCategory(@Valid @RequestBody Category category, @PathVariable Long categoryId) {
        categoryService.updateCategory(category, categoryId);
        return new ResponseEntity<>("Category: " + categoryId + " update successfully", HttpStatus.OK);
    }
}
