package com.jianquanwang.ecommerce.service;

import com.jianquanwang.ecommerce.payload.CartDTO;
import jakarta.transaction.Transactional;

import java.util.List;

public interface CartService {
    CartDTO addProductToCart(Long productId, Integer quantity);

    List<CartDTO> getAllCarts();

    CartDTO getUsersCart();

    @Transactional
    CartDTO updateProductQuantityInCart(Long productId, Integer operation);

    @Transactional
    CartDTO deleteProductFromCart(Long productId);
}
