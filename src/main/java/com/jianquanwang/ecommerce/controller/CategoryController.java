package com.jianquanwang.ecommerce.controller;

import com.jianquanwang.ecommerce.config.AppConstants;
import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.payload.CategoryDTO;
import com.jianquanwang.ecommerce.payload.CategoryResponse;
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
    public ResponseEntity<CategoryResponse> getAllCategories(
            @RequestParam(name="pageNumber", defaultValue = AppConstants.PAGE_NUMBER, required = false) Integer pageNumber,
            @RequestParam(name="pageSize", defaultValue = AppConstants.PAGE_SIZE, required = false) Integer pageSize,
            @RequestParam(name="sortBy", defaultValue = AppConstants.SORT_CATEGORIES_BY, required = false) String sortBy,
            @RequestParam(name="sortOrder", defaultValue = AppConstants.SORT_DIR, required = false) String sortOrder) {
        CategoryResponse categoryResponse = categoryService.getAllCategories(pageNumber, pageSize, sortBy, sortOrder);
        return new ResponseEntity<>(categoryResponse, HttpStatus.OK);
    }

    @PostMapping("")
    public ResponseEntity<String> createCategory(@Valid @RequestBody CategoryDTO categoryDTO) {
        CategoryDTO savedCategoryDTO = categoryService.createCategory(categoryDTO);
        return new ResponseEntity<>("Category added successfully", HttpStatus.CREATED);
    }

    @DeleteMapping("{categoryId}")
    public ResponseEntity<CategoryDTO> deleteCategory(@PathVariable  Long categoryId) {
        CategoryDTO categoryDTO = this.categoryService.deleteCategory(categoryId);
        return ResponseEntity.ok(categoryDTO);
    }
    @PutMapping("{categoryId}")
    public ResponseEntity<CategoryDTO> updateCategory(@Valid @RequestBody CategoryDTO categoryDTO, @PathVariable Long categoryId) {
        CategoryDTO savedCategoryDTO = categoryService.updateCategory(categoryDTO, categoryId);
        return new ResponseEntity<>(savedCategoryDTO, HttpStatus.OK);
    }
}
