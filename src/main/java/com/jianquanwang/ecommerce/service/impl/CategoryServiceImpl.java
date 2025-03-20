package com.jianquanwang.ecommerce.service.impl;

import com.jianquanwang.ecommerce.exceptions.APIException;
import com.jianquanwang.ecommerce.exceptions.ResourceNotFoundException;
import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.repositories.CategoryRepository;
import com.jianquanwang.ecommerce.service.CategoryService;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    @Override
    public List<Category> getAllCategories() {
        List<Category> categories = categoryRepository.findAll();
        if (categories.isEmpty()) {
            throw new APIException("No category created till now");
        }
        return categories;
    }

    @Override
    public void createCategory(Category category) {
        Category existingCategory = categoryRepository.findByCategoryName(category.getCategoryName());
        if(existingCategory != null) {
            throw new APIException("Category with the name" + category.getCategoryName() + " already exists!");
        }
        categoryRepository.save(category);
    }

    @Override
    public String deleteCategory(Long categoryId) {
        categoryRepository.findById(categoryId)
                .orElseThrow(()->new ResourceNotFoundException("Category", "CategoryId", categoryId));

        categoryRepository.deleteById(categoryId);
        return "category with categoryID:" + categoryId + " is removed successfully";
    }

    @Override
    public Category updateCategory(Category category, Long categoryId) {
        Category savedCategory = categoryRepository.findById(categoryId)
                .orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND, "Resource is not found"));

        category.setCategoryId(categoryId);
        return categoryRepository.save(category);

    }
}
