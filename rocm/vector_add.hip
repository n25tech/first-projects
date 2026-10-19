#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cmath>

#define HIP_CHECK(call) do { \
    hipError_t err = (call); \
    if (err != hipSuccess) { \
        fprintf(stderr, "HIP error: %s\n", \
                hipGetErrorString(err)); \
        exit(EXIT_FAILURE); \
    } \
} while (0)

__global__ void vector_add(
    const float* a,
    const float* b,
    float* c,
    int n
) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    constexpr int N = 1024;
    constexpr size_t bytes = N * sizeof(float);

    float *a, *b, *c;
    float *d_a, *d_b, *d_c;

    a = (float*)malloc(bytes);
    b = (float*)malloc(bytes);
    c = (float*)malloc(bytes);

    for (int i = 0; i < N; i++) {
        a[i] = static_cast<float>(i);
        b[i] = static_cast<float>(i * 2);
    }

    HIP_CHECK(hipMalloc(&d_a, bytes));
    HIP_CHECK(hipMalloc(&d_b, bytes));
    HIP_CHECK(hipMalloc(&d_c, bytes));

    HIP_CHECK(hipMemcpy(d_a, a, bytes, hipMemcpyHostToDevice));
    HIP_CHECK(hipMemcpy(d_b, b, bytes, hipMemcpyHostToDevice));

    constexpr int threads = 256;
    int blocks = (N + threads - 1) / threads;

    hipLaunchKernelGGL(
        vector_add,
        dim3(blocks),
        dim3(threads),
        0, 0,
        d_a, d_b, d_c, N
    );

    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    HIP_CHECK(hipMemcpy(c, d_c, bytes, hipMemcpyDeviceToHost));

    for (int i = 0; i < N; i++) {
        if (fabsf(c[i] - (a[i] + b[i])) > 1e-5f) {
            fprintf(stderr, "Mismatch at %d\n", i);
            return EXIT_FAILURE;
        }
    }

    printf("Success: %d elements verified\n", N);

    HIP_CHECK(hipFree(d_a));
    HIP_CHECK(hipFree(d_b));
    HIP_CHECK(hipFree(d_c));

    free(a);
    free(b);
    free(c);

    return 0;
}

