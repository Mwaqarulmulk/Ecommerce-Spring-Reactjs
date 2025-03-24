package com.jianquanwang.ecommerce.controller;

import com.jianquanwang.ecommerce.payload.CartDTO;
import com.jianquanwang.ecommerce.payload.CartResponse;
import com.jianquanwang.ecommerce.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping("/user/cart/products/{productId}/quantity/{quantity}")
    public ResponseEntity<CartDTO> addProductToCart(@PathVariable Long productId, @PathVariable Integer quantity){
        CartDTO cartDTO = cartService.addProductToCart(productId, quantity);
        return new ResponseEntity<>(cartDTO, HttpStatus.CREATED);
    }

    @GetMapping("/carts")
    public ResponseEntity<CartResponse> getAllCarts() {
        List<CartDTO> cartDTOs = cartService.getAllCarts();
        CartResponse response = new CartResponse(cartDTOs);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/user/cart")
    public ResponseEntity<CartDTO> getUsersCart() {
        CartDTO cartDTO = cartService.getUsersCart();
        return new ResponseEntity<>(cartDTO, HttpStatus.OK);
    }

    @PutMapping("/user/cart/products/{productId}/quantity/{operation}")
    public ResponseEntity<CartDTO> updateProductQuantityInCart(@PathVariable Long productId, @PathVariable String operation) {
        CartDTO cartDTO = cartService.updateProductQuantityInCart(productId, operation.equalsIgnoreCase("delete") ? -1 : 1);
        return new ResponseEntity<>(cartDTO, HttpStatus.OK);
    }

    @DeleteMapping("/user/cart/products/{productId}")
    public ResponseEntity<CartDTO> deleteProductFromCart(@PathVariable Long productId) {
        CartDTO cartDTO = cartService.deleteProductFromCart(productId);
        return new ResponseEntity<>(cartDTO, HttpStatus.OK);
    }
}
