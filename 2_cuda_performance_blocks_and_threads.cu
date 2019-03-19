#include <stdio.h>
const int arraySize=20;
const int Maxblock=10;
const int Maxthread=10;
__global__ void kernelfunction(int*a,int*b,int*c){
    int tid = threadIdx.x+blockIdx.x*blockDim.x;//计算线程索引
	while(tid < arraySize){
		c[tid] = a[tid]+b[tid];
		tid += gridDim.x*blockDim.x;
	}
}

int main(void){
    printf("Cuda_Performance block threads\n");

    int a[arraySize],b[arraySize],c[arraySize];
    int *d_a,*d_b,*d_c;
    int size =sizeof(int);
// Give variables values
    int i = 0;
    for(i=0;i<arraySize;i++){  
        a[i] = i;
        b[i] = i;
    }  
// Create Status for error check
    cudaError_t cudastatus;
    cudaDeviceProp prop;  
// Get Cuda Numbers
// 获取cuda数目  
    int count;  
    cudaGetDeviceCount(&count);  
    printf("CUDA Numbers==%d\n",count);  
    for(i=0;i<count;i++){  
    // Get device properties
    // 获取设备的属性  
        cudaGetDeviceProperties(&prop,i);  
        printf("compute capability: %d.%d\n",prop.major,prop.minor);  
        printf("Shared mem per mp: %ld\n",prop.sharedMemPerBlock);  
        printf("warp size: %d.%d\n",prop.warpSize);  
        printf("maxThreadsPerMultiProcessor: %ld\n",prop.maxThreadsPerMultiProcessor;) 
    }  

// loop for testing different block & threads
    int block,thread;
	for(block = 0;block<Maxblock;block++){
	for(thread = 0;thread<Maxthread;thread++){

// Allocate space for device
// take the address of d_a,and cast into void**
// 取d_a的地址（一个二级指针），然后类型转换成void**
    cudastatus=cudaMalloc((void **)&d_a, arraySize*size);
    cudastatus=cudaMalloc((void **)&d_b, arraySize*size);
    cudastatus=cudaMalloc((void **)&d_c, arraySize*size);

// Timing Start 
    cudaEvent_t start, stop;
    float timeall;
    cudastatus=cudaEventCreate(&start);
    cudastatus=cudaEventCreate(&stop);
    cudastatus=cudaEventRecord( start, 0 );
// CopyToGPU
    cudastatus=cudaMemcpy(d_a,a,arraySize*size,cudaMemcpyHostToDevice);
    cudastatus=cudaMemcpy(d_b,b,arraySize*size,cudaMemcpyHostToDevice);
    kernelfunction<<<block,thread>>>(d_a,d_b,d_c);
    cudastatus=cudaMemcpy(&c,d_c,arraySize*size,cudaMemcpyDeviceToHost);
// Timing End
    cudastatus=cudaEventRecord( stop, 0 );
    cudastatus=cudaEventSynchronize( stop );
    cudastatus=cudaEventElapsedTime( &timeall, start, stop );
    cudastatus=cudaEventDestroy( start );
    cudastatus=cudaEventDestroy( stop );
/*
	for(i = 0;i<arraySize;i++)
		printf("%i+%i=%i\n",a[i],b[i],c[i]);
*/
    printf("block: %i thread %i  time:%f \n",block,thread,timeall);
    cudastatus=cudaFree(d_a);
    cudastatus=cudaFree(d_b);
    cudastatus=cudaFree(d_c);
    if (cudastatus != cudaSuccess) {
         fprintf(stderr, "Failed at loop block %i thread %i %s\n",block,thread,cudaGetErrorString(cudastatus));
    }
    }
    }
    if (cudastatus != cudaSuccess) {
         fprintf(stderr, "Failed %s\n", cudaGetErrorString(cudastatus));
    }
    return 0;
}
