package com.jianquanwang.ecommerce.repositories;

import com.jianquanwang.ecommerce.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
}
