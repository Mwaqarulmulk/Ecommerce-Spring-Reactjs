import api from '../../api/api'
export const fetchProducts = () => async (dispatch) => {
    try {
        const { data } = await api.get(`/products`);
        dispatch({
            type: "FETCH PRODUCTS",
            payload: data.content,
            pageNumber: data.pageNumber,
            pageSize: data.pageSize,
            totalElements: data.totalElements,
            totalPages: data.totalPages,
            lastPage: data.lastPage,
        })
    } catch (error) {
        console.log(error);
    }
};