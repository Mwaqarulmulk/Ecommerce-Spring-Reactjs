package com.jianquanwang.ecommerce.service;

import com.jianquanwang.ecommerce.payload.OrderDTO;

public interface OrderService {

    OrderDTO placeOrder(String email, Long addressId, String paymentMethod, String pgName, Long pgPaymentId, String pgStatus, String pgResponseMessage);
}
