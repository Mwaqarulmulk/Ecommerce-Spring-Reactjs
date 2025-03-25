package com.jianquanwang.ecommerce.repositories;

import com.jianquanwang.ecommerce.model.Address;
import com.jianquanwang.ecommerce.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface AddressRepository extends JpaRepository<Address, Long> {
}
