package com.jianquanwang.ecommerce.repositories;

import com.jianquanwang.ecommerce.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}
