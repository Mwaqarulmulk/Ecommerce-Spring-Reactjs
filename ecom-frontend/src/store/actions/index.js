import api from '../../api/api'
export const fetchProducts = () => async (dispatch) => {
    try {
        dispatch({ type: "IS FETCHING" });
        const { data } = await api.get(`/products`);
        dispatch({
            type: "FETCH PRODUCTS",
            payload: data.content,
            pageNumber: data.pageNumber,
            pageSize: data.pageSize,
            totalElements: data.totalElements,
            totalPages: data.totalPages,
            lastPage: data.lastPage,
        });
        dispatch({ type: "IS SUCCESS" });
    } catch (error) {
        console.log(error);
        dispatch({ type: "IS ERROR",
            payload: error?.response?.data?.message || "Failed to fetch products",
        });
    }
};