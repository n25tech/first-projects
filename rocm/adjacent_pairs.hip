#include <hip/hip_runtime.h>
#include <iostream>

inline void hip_check(hipError_t err)
{
	if (err != hipSuccess)
	{
		fprintf(stderr, "HIP error: %s\n", hipGetErrorString(err));
		exit(EXIT_FAILURE);
	}
}

__global__ void sum_adjacent_pairs_k(const float *a, float *b, const int n)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i < n - 1)
	{
		b[i] = a[i] + a[i + 1];
	}
}

std::vector<float> sum_adjacent_pairs(const float *a, const int N)
{
	std::vector<float> output(N - 1);
	float *k_a, *k_b;
	int a_bytes = N * sizeof(float);
	int b_bytes = (N - 1) * sizeof(float);
	hip_check(hipMalloc(&k_a, a_bytes));
	hip_check(hipMalloc(&k_b, b_bytes));
	hip_check(hipMemcpy(k_a, a, a_bytes, hipMemcpyHostToDevice));
	constexpr int threads = 256;
	int blocks = (N + threads - 1) / threads;
	hipLaunchKernelGGL(sum_adjacent_pairs_k, dim3(blocks), dim3(threads), 0, 0, k_a, k_b, N);
	hip_check(hipGetLastError());
	hip_check(hipDeviceSynchronize());
	hip_check(hipMemcpy(output.data(), k_b, b_bytes, hipMemcpyDeviceToHost));
	return output;
}

int main()
{
	constexpr int N = 10;
	float a[N] = {
		3.0f, 7.0f, 2.0f, 9.0f, 4.0f,
		6.0f, 1.0f, 8.0f, 5.0f, 10.0f};
	float expected[N - 1] = {
		10.0f, 9.0f, 11.0f, 13.0f, 10.0f,
		7.0f, 9.0f, 13.0f, 15.0f};

	std::vector<float> output = sum_adjacent_pairs(a, N);
	for (int i = 0; i < N - 1; i++)
	{
		std::cout << output[i] << std::endl;
		if (output[i] != expected[i])
		{
			std::cout << "Mismatch, expected: " << expected[i] << "  output: " << output[i] << std::endl;
		}
	}
	return 0;
}
