package com.jianquanwang.ecommerce.controller;

import com.jianquanwang.ecommerce.payload.OrderDTO;
import com.jianquanwang.ecommerce.payload.OrderRequest;
import com.jianquanwang.ecommerce.service.OrderService;
import com.jianquanwang.ecommerce.util.AuthUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @Autowired
    private AuthUtil authUtil;

    @PostMapping("/order/users/payments/{paymentMethod}")
    public ResponseEntity<OrderDTO> orderProducts(@PathVariable String paymentMethod, @Valid @RequestBody OrderRequest orderRequest){
        String email = authUtil.loggedInEmail();
        OrderDTO order = orderService.placeOrder(email,
                orderRequest.getAddressId(),
                paymentMethod,
                orderRequest.getPgName(),
                orderRequest.getPgPaymentId(),
                orderRequest.getPgStatus(),
                orderRequest.getPgResponseMessage()
        );
        return new ResponseEntity<>(order, HttpStatus.CREATED);
    }

}
