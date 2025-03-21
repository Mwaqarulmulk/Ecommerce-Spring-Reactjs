package com.jianquanwang.ecommerce.service;

import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.payload.CategoryDTO;
import com.jianquanwang.ecommerce.payload.CategoryResponse;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface CategoryService {
    CategoryResponse getAllCategories(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder);
    CategoryDTO createCategory(CategoryDTO categoryDTO);

    CategoryDTO deleteCategory(Long categoryId);

    CategoryDTO updateCategory(CategoryDTO categoryDTO, Long categoryId);
}
