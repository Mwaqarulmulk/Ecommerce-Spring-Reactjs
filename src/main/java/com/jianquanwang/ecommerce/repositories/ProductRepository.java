package com.jianquanwang.ecommerce.repositories;

import com.jianquanwang.ecommerce.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    Page<Product> findByCategoryOrderByPriceAsc(Long categoryId, Pageable pageDetails);

    Page<Product> findByProductNameLikeIgnoreCase(String keyword, Pageable pageDetails);
}
