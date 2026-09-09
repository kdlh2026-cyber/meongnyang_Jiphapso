package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.CartDTO;

@Mapper
public interface ICartDAO {

    // 장바구니 담기
    int insertCart(CartDTO dto);

    // 수량 변경
    int updateCartQuantity(CartDTO dto);

    // 쇼핑백 추가 여부/수량 변경
    int updateCartBag(CartDTO dto);

    // 단건 삭제
    int deleteCart(@Param("caNo") Long caNo);

    // 선택 삭제
    int deleteCartList(@Param("caNoList") List<Long> caNoList);

    // 회원 장바구니 전체 삭제
    int deleteCartAllByMember(@Param("mNo") Long mNo);

    // 장바구니 1건 조회
    CartDTO selectCartOne(@Param("caNo") Long caNo);

    // 회원 장바구니 목록
    List<CartDTO> selectCartListByMember(@Param("mNo") Long mNo);

    // 비회원 장바구니 목록
    List<CartDTO> selectCartListByToken(@Param("caToken") String caToken);

    // 관리자 전체 장바구니 목록
    List<CartDTO> selectCartListAll();

    // 회원 장바구니 개수
    int countCartByMember(@Param("mNo") Long mNo);

    // 비회원 장바구니 개수 (추가)
    int countCartByToken(@Param("caToken") String caToken);

    // 옵션 선택 없이 담을 때(상품목록 페이지) 사용할 대표(기본) 옵션 번호 조회
    Long selectDefaultOptionNo(@Param("pNo") Long pNo);

    // 장바구니 - 옵션 변경 모달용 : 특정 상품(p_no)의 전체 옵션 목록(색상/사이즈/가격/재고) 조회
    List<Map<String, Object>> selectOptionListByProduct(@Param("pNo") Long pNo);

    // 장바구니 - 옵션 변경 (o_no, 수량 동시 변경)
    int updateCartOption(@Param("caNo") Long caNo, @Param("oNo") Long oNo, @Param("quantity") Integer quantity);
}
