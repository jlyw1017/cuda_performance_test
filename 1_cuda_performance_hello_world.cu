#include <stdio.h>

__global__ void kernelfunction(int*a,int*b,int*c){
    *c=*a+*b;
}

int main(void){
    printf("Cuda_Performance Hello World\n");
    int a,b,c;
    int *d_a,*d_b,*d_c;
    int size =sizeof(int);
// take the address of d_a,and cast into void**
// 取d_a的地址（一个二级指针），然后类型转换成void**
// Allocate space for device

// Create Status for error check
    cudaError_t cudastatus;

    cudastatus=cudaMalloc((void **)&d_a, size);
    cudastatus=cudaMalloc((void **)&d_b, size);
    cudastatus=cudaMalloc((void **)&d_c, size);
    
    a = 1;
    b = 2;

    cudaEvent_t start, stop;
    float timeall;
    cudastatus=cudaEventCreate(&start);
    cudastatus=cudaEventCreate(&stop);
    cudastatus=cudaEventRecord( start, 0 );

    cudastatus=cudaMemcpy(d_a,&a,size,cudaMemcpyHostToDevice);
    cudastatus=cudaMemcpy(d_b,&b,size,cudaMemcpyHostToDevice);
    kernelfunction<<<1,1>>>(d_a,d_b,d_c);
    cudastatus=cudaMemcpy(&c,d_c,size,cudaMemcpyDeviceToHost);

    cudastatus=cudaEventRecord( stop, 0 );
    cudastatus=cudaEventSynchronize( stop );
    cudastatus=cudaEventElapsedTime( &timeall, start, stop );
    cudastatus=cudaEventDestroy( start );
    cudastatus=cudaEventDestroy( stop );

    printf("c:%i \n",c);
    printf("time:%f \n",timeall);
    cudastatus=cudaFree(d_a);
    cudastatus=cudaFree(d_b);
    cudastatus=cudaFree(d_c);

    if (cudastatus != cudaSuccess) {
         fprintf(stderr, "Failed %s\n", cudaGetErrorString(cudastatus));
    }
    return 0;
}
