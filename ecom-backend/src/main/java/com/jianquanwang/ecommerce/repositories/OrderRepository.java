package com.jianquanwang.ecommerce.repositories;

import com.jianquanwang.ecommerce.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {
}
