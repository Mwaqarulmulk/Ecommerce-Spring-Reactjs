const initialState = {
    isLoading: false,
    errorMessage: null,
};

export const errorReducer = (state = initialState, action) =>{
    switch(action.type) {
        case "IS FETCHING":
            return {
                ...state,
                isLoading: true,
                errorMessage: null,
            }
        case "IS ERROR":
            return {
                ...state,
                isLoading: false,
                errorMessage: action.payload,
            }
        case "IS SUCCESS":
            return {
                ...state,
                isLoading: false,
                errorMessage: null,
            }
        default:
            return state;
    }
};