package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.ProductDetailImageDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductOptionDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingViewDto;

@Mapper
public interface IProductDao {
    // 조회
    public List<ShoppingListDto> ShoppingList(ShoppingListDto p_dto);
    public ShoppingViewDto ShoppingView(int p_no);
    public ShoppingViewDto ProductViewUpdate(@Param("p_no") int p_no, @Param("o_no") Integer o_no);
    public ProductDto getProductByTitle(String p_title);
    public List<ShoppingListDto> productSearchList(List<Integer> p_no);
    public List<ProductDto> p_list();
    
    // 등록
    public int ProductWrite(ProductDto p_dto);
    public int ProductOptionWrite(ProductOptionDto o_dto);
    public int ProductDetailImageWrite(ProductDetailImageDto img_dto);

    // 수정
    public int ProductUpdate(ProductDto p_dto);
    public int ProductOptionUpdate(ProductOptionDto o_dto);
    public int resetProductDefaultOption(int p_no);
    
    //  상세 이미지 부가 기능
    public int getMaxDetailSort(int p_no);
    public List<String> getImageUrlsByNos(List<Integer> imgNos);
    public void deleteImagesByNos(List<Integer> imgNos);
    public void reorderDetailImages(int p_no);

    // 5. 삭제 및 재고
    public int ProductDelete(int p_no);
    public int decreaseOptionStock(Long o_no, Integer o_quantity);
}