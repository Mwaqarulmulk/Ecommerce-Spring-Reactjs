package com.jianquanwang.ecommerce.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="role_id")
    private Integer roleId;
    @Column(name="role_name", length=20)
    @ToString.Exclude
    private AppRole roleName;

    public Role(AppRole roleName){
        this.roleName = roleName;
    }

}
