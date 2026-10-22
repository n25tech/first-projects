#include <hip/hip_runtime.h>
#include <iostream>

void hip_check(hipError_t err)
{
    if (err != hipSuccess)
    {
        fprintf(stderr, "HIP error: %s\n", hipGetErrorString(err));
        exit(EXIT_FAILURE);
    }
}

__global__ void parallel_sum_reduction(const float input[], const int n, float *output) // output has to pointers always
{
    __shared__ float data[256];
    int tid = threadIdx.x;
    int i = blockIdx.x * blockDim.x + tid;
    if (i < n)
    {
        data[tid] = input[i];
    }
    else
    {
        data[tid] = 0.0f;
    }
    __syncthreads();
    for (int stride = blockDim.x / 2; stride > 0; stride /= 2)
    {
        if (tid < stride)
        {
            data[tid] += data[tid + stride];
        }
        __syncthreads();
        // print shared data:
        if (tid == 0)
        {
            printf("stride: %d\n", stride);
            for (int j = 0; j < 8; j++)
            {
                printf("%.0f ", data[j]);
            }
        }
        __syncthreads();
    }
    if (tid == 0)
    {
        output[blockIdx.x] = data[0];
        printf("\nsum=%.0f\n", *output);
    }
}

float sum_reduction(float input[], const int n)
{
    float output;
    float *k_input, *k_output;
    const int bytes = n * sizeof(float);
    hip_check(hipMalloc(&k_input, bytes));
    hip_check(hipMalloc(&k_output, sizeof(float)));
    hip_check(hipMemcpy(k_input, input, bytes, hipMemcpyHostToDevice));
    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    hipLaunchKernelGGL(parallel_sum_reduction, dim3(blocks), dim3(threads), 0, 0, k_input, n, k_output);
    hip_check(hipGetLastError());
    hip_check(hipDeviceSynchronize());
    hip_check(hipMemcpy(&output, k_output, sizeof(float), hipMemcpyDeviceToHost));
    return output;
}

int main()
{
    // tc1
    constexpr int tc1_N = 8;

    float tc1_input[tc1_N] = {
        3.0f, 7.0f, 2.0f, 9.0f,
        4.0f, 6.0f, 1.0f, 8.0f};

    float tc1_expected = 40.0f;
    // tc2
    constexpr int tc2_N = 256;

    float tc2_input[tc2_N];

    for (int i = 0; i < tc2_N; i++)
    {
        tc2_input[i] = static_cast<float>(i + 1);
    }

    float tc2_expected = 32896.0f;
    float tc1_result = sum_reduction(tc1_input, tc1_N);
    float tc2_result = sum_reduction(tc2_input, tc2_N);
    std::cout << "tc1_result: " << tc1_result << std::endl;
    std::cout << "tc2_result: " << tc2_result << std::endl;
    if (tc1_result != tc1_expected) {
        std::cout << "incorrect output for tc1" << tc1_result << std::endl;
    }
    if (tc2_result != tc2_expected) {
        std::cout << "incorrect output for tc2" << tc2_result << std::endl;
    }
}