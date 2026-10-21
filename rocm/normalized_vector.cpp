/*
 *import math
... 
... def normalize_vector(vector):
...     length = math.sqrt(sum(comp ** 2 for comp in vector))
...     if length == 0:
...         raise ValueError("Cannot normalize a zero vector.")
...     return [comp / length for comp in vector]
... 
... # Example usage
... vector = [3, 4, 0]
... normalized_vector = normalize_vector(vector)
... print("Normalized Vector:", normalized_vector)
... 
Normalized Vector: [0.6, 0.8, 0.0]
 */

//#include <hip/hip_runtime.h>
#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>

/* version 1
 * On the CPU only
 * calling function allocates the return array
 * return array is a vector
 */
std::vector<float> normalize_vector_v1(const float* data, const size_t n) {
	std::vector<float> output(n);
	// calculate length
	float sum = 0;
	for (int i = 0; i < n; i++) {
		sum += pow(data[i], 2.0);
	}
	float length = sqrt(sum);
	if (length == 0) {
		return output;
	}
	// get values for output
	for (int i = 0; i < n; i++) {
		output[i] = data[i] / length;
	}
	return output;
}

/* version 2
 * On the CPU only
 * caller allocates both input and out arrays
 */

/* version 3
 * On the GPU with transfer between CPU and GPU
 */

/* version 4
 * On the GPU limiting transfer between CPU and GPU
 */

void display_array(float* data, const size_t n, const char* s) {
	std::cout << s 
	  << "["
          << data[0] << ", "
          << data[1] << ", "
          << data[2] << "]" << std::endl;
}


int main() {
	const int n = 3;
	// get input data for test cases
	float tc1_input[n] = {3.0f, 4.0f, 0.0f};
	constexpr size_t tc2_input_bytes = n * sizeof(float);
	float* tc2_input = (float*)malloc(tc2_input_bytes);
	tc2_input[0] = 6.0f;
	tc2_input[1] = 8.0f;
	tc2_input[2] = 0.0f;

	std::chrono::steady_clock::time_point start, end;
	double time_taken;
	std::vector tmp_result = normalize_vector_v1(tc1_input, n);

	// VERSION 1
	display_array(tc1_input, n, "test case 1:\n  input: ");
    	start = std::chrono::steady_clock::now();
	std::vector tc1_result = normalize_vector_v1(tc1_input, n);
	end = std::chrono::steady_clock::now();
	display_array(tc1_result.data(), tc1_result.size(), "  output: ");
	time_taken = std::chrono::duration<double, std::milli>(end - start).count();
	std::cout << "  time taken: " << time_taken << std::endl;
	
	std::cout << "testcase 2: large array" << std::endl;
    	start = std::chrono::steady_clock::now();
	std::vector tc2_result = normalize_vector_v1(tc2_input, n);
	end = std::chrono::steady_clock::now();
	time_taken = std::chrono::duration<double, std::milli>(end - start).count();
	std::cout << "  time taken: " << time_taken << std::endl;
	free(tc2_input);
	
	
	// VERSION 2
}

