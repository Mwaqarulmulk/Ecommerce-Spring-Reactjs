package com.jianquanwang.ecommerce.integration;

import com.jianquanwang.ecommerce.model.Category;
import com.jianquanwang.ecommerce.repositories.CategoryRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Integration tests for database connectivity and operations
 * This test verifies that the application can properly connect to PostgreSQL
 * and perform basic CRUD operations.
 */
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@ActiveProfiles("test")
class DatabaseIntegrationTest {

    @Autowired
    private CategoryRepository categoryRepository;

    @Test
    void testDatabaseConnection() {
        // Given: Database is available
        // When: We query the database
        long count = categoryRepository.count();
        
        // Then: Connection is successful (no exception thrown)
        assertThat(count).isGreaterThanOrEqualTo(0);
    }

    @Test
    void testCreateAndRetrieveCategory() {
        // Given: A new category
        Category category = new Category();
        category.setCategoryName("Test Category");
        
        // When: Saving the category
        Category savedCategory = categoryRepository.save(category);
        
        // Then: Category is persisted with an ID
        assertThat(savedCategory.getCategoryId()).isNotNull();
        assertThat(savedCategory.getCategoryName()).isEqualTo("Test Category");
        
        // And: Can be retrieved from database
        Category retrievedCategory = categoryRepository.findById(savedCategory.getCategoryId()).orElse(null);
        assertThat(retrievedCategory).isNotNull();
        assertThat(retrievedCategory.getCategoryName()).isEqualTo("Test Category");
    }

    @Test
    void testUpdateCategory() {
        // Given: An existing category
        Category category = new Category();
        category.setCategoryName("Original Name");
        Category savedCategory = categoryRepository.save(category);
        
        // When: Updating the category
        savedCategory.setCategoryName("Updated Name");
        categoryRepository.save(savedCategory);
        
        // Then: Changes are persisted
        Category updatedCategory = categoryRepository.findById(savedCategory.getCategoryId()).orElse(null);
        assertThat(updatedCategory).isNotNull();
        assertThat(updatedCategory.getCategoryName()).isEqualTo("Updated Name");
    }

    @Test
    void testDeleteCategory() {
        // Given: An existing category
        Category category = new Category();
        category.setCategoryName("To Be Deleted");
        Category savedCategory = categoryRepository.save(category);
        Long categoryId = savedCategory.getCategoryId();
        
        // When: Deleting the category
        categoryRepository.delete(savedCategory);
        
        // Then: Category is removed from database
        boolean exists = categoryRepository.existsById(categoryId);
        assertThat(exists).isFalse();
    }

    @Test
    void testTransactionRollback() {
        // Given: Initial count
        long initialCount = categoryRepository.count();
        
        // When: An exception occurs (simulated by not flushing)
        try {
            Category category = new Category();
            category.setCategoryName(null); // This might cause validation error
            categoryRepository.save(category);
        } catch (Exception e) {
            // Exception expected
        }
        
        // Then: Transaction is rolled back (count unchanged)
        long finalCount = categoryRepository.count();
        assertThat(finalCount).isEqualTo(initialCount);
    }
}
