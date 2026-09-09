package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.meongnyang_Jiphapso.dao.ICartDAO;
import com.springboot.meongnyang_Jiphapso.dto.CartDTO;

@Service
public class CartService {

    private final ICartDAO cartDAO;

    @Autowired
    public CartService(ICartDAO cartDAO) {
        this.cartDAO = cartDAO;
    }

    /** 요청자가 이 장바구니 항목의 소유자(회원 or 게스트 토큰)인지 검증 */
    private void checkOwner(CartDTO cart, Long mNo, String guestToken) {
        boolean isMemberOwner = (mNo != null && mNo.equals(cart.getMNo()));
        boolean isGuestOwner = (guestToken != null && guestToken.equals(cart.getCaToken()));
        if (!isMemberOwner && !isGuestOwner) {
            throw new IllegalStateException("본인 장바구니만 접근할 수 있습니다");
        }
    }

    /** 장바구니 담기 - 이미 담긴 상품(같은 옵션)이면 수량만 합산 */
    @Transactional
    public CartDTO addCart(Long mNo, String guestToken, Long pNo, Long oNo, int quantity) {
        // 상품목록 페이지처럼 옵션 선택 UI 없이 담는 경우 oNo가 null로 들어옴.
        // o_price/o_main_img가 dc_product_option에만 있어서 o_no가 null이면
        // 조회 시 LEFT JOIN이 매칭 안 돼 가격/이미지가 비어버리므로, 대표(default) 옵션으로 채워줌.
        if (oNo == null) {
            oNo = cartDAO.selectDefaultOptionNo(pNo);
            if (oNo == null) {
                throw new IllegalStateException("담을 수 있는 옵션이 없는 상품입니다");
            }
        }

        List<CartDTO> existingList = (mNo != null)
                ? cartDAO.selectCartListByMember(mNo)
                : cartDAO.selectCartListByToken(guestToken);

        Long finalONo = oNo;
        CartDTO existing = existingList.stream()
                .filter(c -> c.getPNo().equals(pNo) && Objects.equals(c.getONo(), finalONo))
                .findFirst()
                .orElse(null);

        if (existing != null) {
            // 이미 담긴 상품 - 수량만 합산
            CartDTO updateDto = new CartDTO();
            updateDto.setCaNo(existing.getCaNo());
            updateDto.setCaQuantity(existing.getCaQuantity() + quantity);
            cartDAO.updateCartQuantity(updateDto);
            return cartDAO.selectCartOne(existing.getCaNo());
        }

        // 신규 담기
        CartDTO dto = new CartDTO();
        dto.setMNo(mNo);
        dto.setCaToken(mNo == null ? guestToken : null);
        dto.setPNo(pNo);
        dto.setONo(oNo);
        dto.setCaQuantity(quantity);
        dto.setCaYn("N"); // 쇼핑백 추가구매 기본값
        dto.setCaQty(0);
        cartDAO.insertCart(dto);
        return cartDAO.selectCartOne(dto.getCaNo());
    }

    /** 수량 변경 - 소유자 검증 후 */
    @Transactional
    public void updateQuantity(Long caNo, int quantity, Long mNo, String guestToken) {
        CartDTO cart = cartDAO.selectCartOne(caNo);
        checkOwner(cart, mNo, guestToken);

        CartDTO dto = new CartDTO();
        dto.setCaNo(caNo);
        dto.setCaQuantity(quantity);
        cartDAO.updateCartQuantity(dto);
    }

    /** 쇼핑백 옵션 변경 - 소유자 검증 후 */
    @Transactional
    public void updateBag(Long caNo, String bagYn, int bagQty, Long mNo, String guestToken) {
        CartDTO cart = cartDAO.selectCartOne(caNo);
        checkOwner(cart, mNo, guestToken);

        CartDTO dto = new CartDTO();
        dto.setCaNo(caNo);
        dto.setCaYn(bagYn);
        dto.setCaQty(bagQty);
        cartDAO.updateCartBag(dto);
    }

    /** 옵션 변경 모달용 - 해당 상품(pNo)의 옵션 전체 목록 (색상/사이즈/가격/재고) */
    public List<Map<String, Object>> getOptionListByProduct(Long pNo) {
        return cartDAO.selectOptionListByProduct(pNo);
    }

    /** 장바구니 옵션 변경 - 소유자 검증 후 (연필 아이콘 -> 옵션 변경 모달에서 "변경") */
    @Transactional
    public CartDTO changeOption(Long caNo, Long oNo, int quantity, Long mNo, String guestToken) {
        CartDTO cart = cartDAO.selectCartOne(caNo);
        checkOwner(cart, mNo, guestToken);

        cartDAO.updateCartOption(caNo, oNo, quantity);
        return cartDAO.selectCartOne(caNo);
    }

    /** 관리자용 - 소유자 검증 없이 강제 삭제 */
    @Transactional
    public void deleteCart(Long caNo) {
        cartDAO.deleteCart(caNo);
    }

    /** 사용자용 - 소유자 검증 후 삭제 */
    @Transactional
    public void deleteCart(Long caNo, Long mNo, String guestToken) {
        CartDTO cart = cartDAO.selectCartOne(caNo);
        checkOwner(cart, mNo, guestToken);
        cartDAO.deleteCart(caNo);
    }

    /** 관리자용 - 소유자 검증 없이 일괄 삭제 */
    @Transactional
    public void deleteCartList(List<Long> caNoList) {
        if (caNoList == null || caNoList.isEmpty()) return;
        cartDAO.deleteCartList(caNoList);
    }

    /** 사용자용 - 소유자 검증 후 일괄 삭제 */
    @Transactional
    public void deleteCartList(List<Long> caNoList, Long mNo, String guestToken) {
        if (caNoList == null || caNoList.isEmpty()) return;
        for (Long caNo : caNoList) {
            CartDTO cart = cartDAO.selectCartOne(caNo);
            checkOwner(cart, mNo, guestToken);
        }
        cartDAO.deleteCartList(caNoList);
    }

    /** 회원 장바구니 전체 삭제 (주문완료 후 등에 사용) */
    @Transactional
    public void deleteCartAllByMember(Long mNo) {
        cartDAO.deleteCartAllByMember(mNo);
    }

    public List<CartDTO> getCartListByMember(Long mNo) {
        return cartDAO.selectCartListByMember(mNo);
    }

    public List<CartDTO> getCartListByToken(String guestToken) {
        return cartDAO.selectCartListByToken(guestToken);
    }

    public int countCart(Long mNo) {
        return cartDAO.countCartByMember(mNo);
    }

    public int countCartByToken(String guestToken) {
        return cartDAO.countCartByToken(guestToken);
    }

    /** 관리자 - 전체 목록 */
    public List<CartDTO> getCartListAll() {
        return cartDAO.selectCartListAll();
    }
}
