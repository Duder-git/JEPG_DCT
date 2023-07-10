# JEPG_DCT
Image and video processing: From Mars to Hollywood with a stop at the hospital. week2 work.
关于JEPG的图像压缩方法 DCT的具体实现

blog:https://duder-git.github.io/post/JEPG_DCT/

在线课程：[Image and video processing: From Mars to Hollywood with a stop at the hospital](https://www.coursera.org/course/images)
## 块编码技术
DCT是一种块编码压缩技术。该技术把图像分割成大小相等且不重叠的小块，使用二维变换单独处理这些块。在块编码中，用一种可逆线性变换（如傅里叶变换）将每个子块或子图像映射为变换系数集合，然后对系数进行量化和编码。

    一般步骤：子图像分解——变换——量化——编码

变换：使用最少数量的变换系数包含尽可能多的信息。
量化：以一种预定义的方式有选择地消除或更粗略地量化哪些携带最少信息的系数
编码：对量化后的系数进行编码

自适应编码：编码步骤根据局部图像内容进行调整
非自适应编码：对所有图像固定

其中经典的变换Walsh-Hadamard变换（WHT)，简单易用

## DCT
图像压缩中最常用的变换是DCT，信息携带能力比DFT和WHT强，但在信息携带方面最佳变化是KarHunen-loeve。DCT在信息携带能力和计算复杂性之间提供了较好的折中。

DCT核是

$$ 
r(x,y,u,v) = s(x,y,u,v) = \alpha(u) \alpha(v) cos[{{(2x+1)u\pi}\over{2n}}] cos[{{(2y+1)v\pi}\over{2n}}]
$$

其中

$$ 
\alpha (u) =  
\left\{
    \begin{aligned}
    \sqrt{1/n}, &&{u = 0}\\
    \sqrt{2/n}, &&{u = 1,2,...,n-1}
    \end{aligned} 
    \right.
$$
