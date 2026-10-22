#include <hip/hip_runtime.h>
#include <iostream>

inline void hip_check(hipError_t err) {
    if (err != hipSuccess) {
        fprintf(stderr, "HIP error: %s\n", hipGetErrorString(err));
        exit(EXIT_FAILURE);
    }
}

__global__ void sum_adjacent_pairs_k(const float *a, float *b, const int n) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
}

float[] sum_adjacent_pairs(const float *a, const int N) {
	float output[N];
	
	return output;
}

int main() {
	constexpr int N = 10;
	float a[N] = {
    3.0f, 7.0f, 2.0f, 9.0f, 4.0f,
    6.0f, 1.0f, 8.0f, 5.0f, 10.0f
};
	float expected[N - 1] = {
    10.0f, 9.0f, 11.0f, 13.0f, 10.0f,
    7.0f, 9.0f, 13.0f, 15.0f
};

	sum_adjacent_pairs() {}
	return 0;
}
