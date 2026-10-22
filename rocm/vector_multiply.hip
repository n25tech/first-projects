#include <hip/hip_runtime.h>
#include <iostream>

#define HIP_CHECK(call) do { \
    hipError_t err = (call); \
    if (err != hipSuccess) { \
        fprintf(stderr, "HIP error: %s\n", \
                hipGetErrorString(err)); \
        exit(EXIT_FAILURE); \
    } \
} while (0)

__global__ void vector_multiply_k(const float a[], const float b[], float c[], int n) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i < n) {
		c[i] = a[i] * b[i];
	}
}

void vector_multiply(const float a[], const float b[], const int n) {
	float *k_a, *k_b, *k_c; 
	size_t bytes = n * sizeof(float);
	HIP_CHECK(hipMalloc(&k_a, bytes));
	HIP_CHECK(hipMalloc(&k_b, bytes));
	HIP_CHECK(hipMalloc(&k_c, bytes));
	HIP_CHECK(hipMemcpy(k_a, a, bytes, hipMemcpyHostToDevice));
	HIP_CHECK(hipMemcpy(k_b, b, bytes, hipMemcpyHostToDevice));

	constexpr int threads = 256;
	int blocks = (n + threads -1)/ threads;

	hipLaunchKernelGGL(vector_multiply_k, dim3(blocks), dim3(threads), 0, 0, k_a, k_b, k_c, n);

	HIP_CHECK(hipGetLastError());
	HIP_CHECK(hipDeviceSynchronize());

	float c[n];
	HIP_CHECK(hipMemcpy(c, k_c, bytes, hipMemcpyDeviceToHost));

	for (int i=0; i< n; i++) {
		std::cout << c[i] << std::endl;
	}
}

int main() {
	constexpr int n = 4;
	float a[n] = {1.0f, 2.0f, 3.0f, 4.0f};
	float b[n] = {2.0f, 3.0f, 4.0f, 5.0f};
	vector_multiply(a, b, n);
	return 0;
}
