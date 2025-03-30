package com.jianquanwang.ecommerce.repositories;

import com.jianquanwang.ecommerce.model.AppRole;
import com.jianquanwang.ecommerce.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Integer> {
    Optional<Role> findByRoleName(AppRole role);
}
