package com.jianquanwang.ecommerce.service;

import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.repositories.CategoryRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Unit tests for Category-related service operations
 */
@ExtendWith(MockitoExtension.class)
class CategoryServiceTest {

    @Mock
    private CategoryRepository categoryRepository;

    private Category testCategory;

    @BeforeEach
    void setUp() {
        testCategory = new Category();
        testCategory.setCategoryId(1L);
        testCategory.setCategoryName("Electronics");
    }

    @Test
    void testFindCategoryById() {
        // Given
        when(categoryRepository.findById(1L)).thenReturn(Optional.of(testCategory));

        // When
        Optional<Category> result = categoryRepository.findById(1L);

        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getCategoryName()).isEqualTo("Electronics");
        verify(categoryRepository, times(1)).findById(1L);
    }

    @Test
    void testSaveCategory() {
        // Given
        when(categoryRepository.save(any(Category.class))).thenReturn(testCategory);

        // When
        Category savedCategory = categoryRepository.save(testCategory);

        // Then
        assertThat(savedCategory).isNotNull();
        assertThat(savedCategory.getCategoryId()).isEqualTo(1L);
        verify(categoryRepository, times(1)).save(testCategory);
    }

    @Test
    void testDeleteCategory() {
        // Given
        doNothing().when(categoryRepository).delete(testCategory);

        // When
        categoryRepository.delete(testCategory);

        // Then
        verify(categoryRepository, times(1)).delete(testCategory);
    }

    @Test
    void testCategoryNotFound() {
        // Given
        when(categoryRepository.findById(999L)).thenReturn(Optional.empty());

        // When
        Optional<Category> result = categoryRepository.findById(999L);

        // Then
        assertThat(result).isEmpty();
    }
}
