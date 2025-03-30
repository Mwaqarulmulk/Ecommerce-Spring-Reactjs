package com.jianquanwang.ecommerce.service.impl;

import com.jianquanwang.ecommerce.exceptions.APIException;
import com.jianquanwang.ecommerce.exceptions.ResourceNotFoundException;
import com.jianquanwang.ecommerce.model.Cart;
import com.jianquanwang.ecommerce.model.CartItem;
import com.jianquanwang.ecommerce.model.Product;
import com.jianquanwang.ecommerce.model.User;
import com.jianquanwang.ecommerce.payload.CartDTO;
import com.jianquanwang.ecommerce.payload.ProductDTO;
import com.jianquanwang.ecommerce.repositories.CartItemRepository;
import com.jianquanwang.ecommerce.repositories.CartRepository;
import com.jianquanwang.ecommerce.repositories.ProductRepository;
import com.jianquanwang.ecommerce.service.CartService;
import com.jianquanwang.ecommerce.util.AuthUtil;
import jakarta.transaction.Transactional;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Stream;

@Service
public class CartServiceImpl implements CartService {
    @Autowired
    private ModelMapper modelMapper;
    @Autowired
    private CartRepository cartRepository;
    @Autowired
    private AuthUtil authUtil;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private CartItemRepository cartItemRepository;

    @Override
    public CartDTO addProductToCart(Long productId, Integer quantity) {
        // Find existing cart or create one
        Cart cart = createCart();
        // Retrieve Product Details
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "productId", productId));
        Long cartId = cart.getCartId();
        CartItem cartItem = cartItemRepository.findCartItemByProductIdAndCartId(productId, cartId);
        // Perform Validations
        if (cartItem != null) {
            throw new APIException("Product " + product.getProductName() + " already exists in the cart");
        }

        if (product.getQuantity() == 0) {
            throw new APIException(product.getProductName() + " is not available");
        }

        if (product.getQuantity() < quantity) {
            throw new APIException("Please make an order of the " + product.getProductName() + " less than or equal to the quantity " + product.getQuantity() + ".");
        }
        // Create Cart Item
        CartItem newCartItem = new CartItem();
        newCartItem.setProduct(product);
        newCartItem.setProductPrice(product.getSpecialPrice());
        newCartItem.setCart(cart);
        newCartItem.setQuantity(quantity);
        newCartItem.setDiscount(product.getDiscount());
        // Save cart item
        cartItemRepository.save(newCartItem);
        cart.setTotalPrice(cart.getTotalPrice() + product.getSpecialPrice() * quantity);
        cartRepository.save(cart);
        CartDTO cartDTO = modelMapper.map(cart, CartDTO.class);
        List<CartItem> cartItems = cart.getCartItems();
        List<ProductDTO> productDTOs = cartItems.stream()
                .map(item -> modelMapper.map(item.getProduct(), ProductDTO.class)).toList();
        cartDTO.setProducts(productDTOs);
        // Return updated cart
        return cartDTO;
    }

    @Override
    public List<CartDTO> getAllCarts() {
        List<Cart> carts = cartRepository.findAll();
        if (carts.isEmpty()) {
            throw new APIException("No cart exists");
        }

        List<CartDTO> cartDTOs = carts.stream().map(cart -> {
            CartDTO cartDTO = modelMapper.map(cart, CartDTO.class);
            List<ProductDTO> productDTOS = cart.getCartItems().stream().map(
                    product -> modelMapper.map(product, ProductDTO.class)
            ).toList();
            cartDTO.setProducts(productDTOS);
            return cartDTO;
        }).toList();

        return cartDTOs;
    }

    @Override
    public CartDTO getUsersCart() {
        Cart cart = cartRepository.findCartByEmail(authUtil.loggedInEmail());
        if (cart == null) {
            throw new ResourceNotFoundException("Cart", "UserId", authUtil.loggedInUserId());
        }
        CartDTO cartDTO = modelMapper.map(cart, CartDTO.class);
        cart.getCartItems().forEach(c -> c.getProduct().setQuantity(c.getQuantity()));
        cartDTO.setProducts(cart.getCartItems().stream().map(cartItem -> modelMapper.map(cartItem.getProduct(), ProductDTO.class)).toList());
        return cartDTO;
    }

    @Transactional
    @Override
    public CartDTO updateProductQuantityInCart(Long productId, Integer operation) {
        Cart userCart = cartRepository.findCartByEmail(authUtil.loggedInEmail());
        if (userCart == null) {
            throw new ResourceNotFoundException("Cart", "UserId", authUtil.loggedInUserId());
        }
        Long cartId = userCart.getCartId();
        /*
        Cart cart = cartRepository.findById(cartId).orElseThrow(()-> new ResourceNotFoundException("Cart", "CartId", cartId));
         */
        Product product = productRepository.findById(productId).orElseThrow(() -> new ResourceNotFoundException("Product", "productId", productId));
        if (product.getQuantity() == 0) {
            throw new APIException(product.getProductName() + " is not available.");
        }

        CartItem cartItem = cartItemRepository.findCartItemByProductIdAndCartId(productId, cartId);
        if (cartItem == null) {
            throw new APIException(product.getProductName() + " is not available in cart.");
        }
        cartItem.setProductPrice(product.getSpecialPrice());
        cartItem.setQuantity(cartItem.getQuantity() + operation);

        if (cartItem.getQuantity() > product.getQuantity()) {
            throw new APIException("Cannot add more product of " + product.getProductName() + ".");
        }

        cartItem.setDiscount(product.getDiscount());
        userCart.setTotalPrice(userCart.getTotalPrice() + cartItem.getProductPrice() * operation);
        cartRepository.save(userCart);
        CartItem updatedItem = cartItemRepository.save(cartItem);
        CartDTO cartDTO;
        if (updatedItem.getQuantity() == 0) {
            cartDTO = deleteProductFromCart(productId);
        } else {
            cartDTO = modelMapper.map(userCart, CartDTO.class);
            List<CartItem> cartItems = userCart.getCartItems();
            List<ProductDTO> productDTOs =  cartItems.stream().map(item -> {
                ProductDTO productDTO = modelMapper.map(item.getProduct(), ProductDTO.class);
                productDTO.setQuantity(item.getQuantity());
                return productDTO;
            }).toList();
            cartDTO.setProducts(productDTOs);
        }
        return cartDTO;
    }

    @Transactional
    @Override
    public CartDTO deleteProductFromCart(Long productId) {
        Cart cart = cartRepository.findCartByEmail(authUtil.loggedInEmail());
        Long cartId = cart.getCartId();

        CartItem cartItem = cartItemRepository.findCartItemByProductIdAndCartId(productId, cartId);
        if (cartItem == null) {
            throw new ResourceNotFoundException("Product", "productId", productId);
        }
        Long cartItemId = cartItem.getCartItemId();
        cartItemRepository.deleteById(cartItemId);
        cart.getCartItems().remove(cartItem);
        cart.setTotalPrice(cart.getTotalPrice() - cartItem.getProductPrice() * cartItem.getQuantity());
        CartDTO cartDTO = modelMapper.map(cart, CartDTO.class);
        cartDTO.setProducts(cart.getCartItems().stream().map(item-> {
            if (!Objects.equals(item.getProduct().getProductId(), productId)) {
                ProductDTO productDTO = modelMapper.map(item.getProduct(), ProductDTO.class);
                productDTO.setQuantity(item.getQuantity());
                return productDTO;
            }
            else {
                return null;
            }
        }).toList());
        return cartDTO;
    }

    private Cart createCart() {
        Cart cart = cartRepository.findCartByEmail(authUtil.loggedInEmail());
        if (cart != null) {
            return cart;
        }
        cart = new Cart();
        cart.setUser(authUtil.loggedInUser());
        return cartRepository.save(cart);
    }
}
