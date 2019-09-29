This is a basic cuda tutorial
这是个基础cuda教程  
don't forget to set path, you can add this in bash  
别忘了设置path，可以在bashrc里加入如下信息  
# set cuda path  
export LD_LIBRARY_PATH=/usr/local/cuda/lib  
export PATH=$PATH:/usr/local/cuda/bin   

use follow command to compile after you have installed cuda:  
在安装好cuda之后用如下命令编译  
nvcc -o outPutNameYouWant filename.cu    

# cuda_performance_test  
I would like to share some Example code for cuda basics.
我想更新如下示例代码
The following content will be updated in in the future
  1_cuda_performance_hello_world.cu   example for timing on a device code   基本操作，分配，把cpu内存上载到gpu，计时  
  2_cuda_performance_blocks_and_threads.cu  example code for different blocks and threads  设置不同的block和thread数量，检测结果  
  3_cuda_performance_memeory_test.cu  example code for local,shared and global Memory   设置局部，共享和全局内存，检测速度差异  
  4_cuda_performance_coalesce.cu  example code for coalesce   coalesce的差异检测  
  5_cuda_performance_atomic_operation.cu  example code for atomic_operation   原子操作速度对比  
  6_cuda_performance_thread_divergence.cu  example code for thread_divergence    thread_divergence 检测  
