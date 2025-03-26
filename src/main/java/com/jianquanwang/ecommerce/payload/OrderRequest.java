package com.jianquanwang.ecommerce.payload;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderRequest {
    private Long addressId;
    private String pgName;
    private Long pgPaymentId;
    private String pgStatus;
    private String pgResponseMessage;
}
