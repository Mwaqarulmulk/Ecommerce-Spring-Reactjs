package com.jianquanwang.ecommerce.service.impl;

import com.jianquanwang.ecommerce.exceptions.APIException;
import com.jianquanwang.ecommerce.exceptions.ResourceNotFoundException;
import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.payload.CategoryDTO;
import com.jianquanwang.ecommerce.payload.CategoryResponse;
import com.jianquanwang.ecommerce.repositories.CategoryRepository;
import com.jianquanwang.ecommerce.service.CategoryService;
import jakarta.annotation.Resource;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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

    @Autowired
    private ModelMapper modelMapper;

    @Override
    public CategoryResponse getAllCategories(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Sort sortByAndOrder = sortOrder.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageDetails = PageRequest.of(pageNumber, pageSize, sortByAndOrder);
        Page<Category> categoryPage = categoryRepository.findAll(pageDetails);

        List<Category> categories = categoryPage.getContent();
        if (categories.isEmpty()) {
            throw new APIException("No category created till now");
        }
        List<CategoryDTO> categoryDTOS = categories.stream()
                .map(category -> modelMapper.map(category, CategoryDTO.class))
                .toList();

        CategoryResponse categoryResponse = new CategoryResponse();
        categoryResponse.setContent(categoryDTOS);
        categoryResponse.setPageNumber(categoryPage.getNumber());
        categoryResponse.setPageSize(categoryPage.getSize());
        categoryResponse.setTotalElements(categoryPage.getTotalElements());
        categoryResponse.setLastPage(categoryPage.isLast());
        categoryResponse.setTotalPages(categoryPage.getTotalPages());

        return categoryResponse;

    }

    @Override
    public CategoryDTO createCategory(CategoryDTO categoryDTO) {
        Category category = modelMapper.map(categoryDTO, Category.class);
        Category existingCategory = categoryRepository.findByCategoryName(category.getCategoryName());
        if(existingCategory != null) {
            throw new APIException("Category with the name" + category.getCategoryName() + " already exists!");
        }
        Category savedCategory = categoryRepository.save(category);
        CategoryDTO savedCategoryDTO = modelMapper.map(savedCategory, CategoryDTO.class);
        return savedCategoryDTO;
    }

    @Override
    public CategoryDTO deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(()->new ResourceNotFoundException("Category", "CategoryId", categoryId));

        categoryRepository.deleteById(categoryId);
        return modelMapper.map(category, CategoryDTO.class);
    }

    @Override
    public CategoryDTO updateCategory(CategoryDTO categoryDTO, Long categoryId) {
        Category category = modelMapper.map(categoryDTO, Category.class);
        Category existingCategory = categoryRepository.findById(categoryId)
                .orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND, "Resource is not found"));

        category.setCategoryId(categoryId);
        Category savedCategory = categoryRepository.save(category);
        return modelMapper.map(savedCategory, CategoryDTO.class);
    }
}
