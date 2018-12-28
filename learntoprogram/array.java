/*数组&类*/
class array
{
    private int[] data;//封装实例变量
    
    array(int[] arr)
    {//构造函数，初始化实例变量
        this.data = arr;
    }

    array(int[] arr,String inf)
    {//构造函数重载
        this.data = arr;
        System.out.println(inf);
    }

    public int[] getData()
    {//访问内部数据的对外方法
        return this.data;
    }

    public void setData(int[] arr)
    {//改变内部数据的对外方法
        this.data = arr;
    }

    int maximum()
    {//遍历数组并查找数组中最大值的角标
        int max = 0;
        for(int i=1;i<this.data.length;i++)
        {
            if (this.data[i]>this.data[max])
            {    
                max = i;
            }
        }
        return max;
    }

    private void swap(int[] array,int a1,int a2)
    {//实现数组中两个值的位置互换
        int tmp = array[a1];
        array[a1] = array[a2];
        array[a2] = tmp;
    }

    void selectSort()
    {//通过选择排序算法实现顺序排列
        for(int x=0;x<this.data.length-1;x++)
        {
            for(int y=x+1;y<this.data.length;y++)
            {
                if (this.data[x]>this.data[y])
                {
                    swap(this.data,x,y);
                }
            }
        }
    }

    void bubbleSort()
    {//通过冒泡排序算法实现顺序排列
        for (int x=1;x<this.data.length-1;x++)
        {
            for (int y=0;y<this.data.length-x;y++)
            {
                if (this.data[y]>this.data[y+1])
                {
                    swap(this.data,y,y+1);
                }
            }
        }
    }

    void bubbleSortPro()
    {//通过冒泡排序算法实现顺序排列,利用中间变量提高性能
        for (int x=1;x<this.data.length;x++)
        {
            int tmp = 0;
            for (int y=0;y<this.data.length-x;y++)
            {
                if (this.data[tmp]<this.data[y+1])
                {
                    tmp = y+1;
                }
            }
            if (tmp == this.data.length-x)
            {
                continue;
            }
            else
            {
                swap(this.data,tmp,this.data.length-x);
            }
        }
    }

    int search(int v)
    {//在指定数组中循环查找给定值,并返回值所在角标
        for (int x=0;x<this.data.length;x++)
        {
            if(this.data[x] == v)
            {
                return x;
            }
        }
        return -1;
    }

    int binarySearch(int v)
    {//在指定数组中通过折半查找算法查找给定值,并返回值所在角标
        int min = 0,max = this.data.length-1,mid;
        while (min <= max)
        {    
            mid = (min + max)/2;
            if (this.data[mid] == v)
            {    
                return mid;
            }
            else if (this.data[mid] > v)
            {
                max = mid-1;
            }
            else
            {
                min = mid+1;
            }
        }
        return -1;
    }

    void loopArray()
    {//遍历并打印数组
        System.out.print('[');
        for(int a=0;a<this.data.length;a++)
        {
            System.out.print(this.data[a]);
            if(a<(this.data.length-1))
            {
                System.out.print(',');
            }
        }
        System.out.println(']');
    }

    public static void main(String [] args)
    {
        int [] ara = new int[3];//定义一维数组
        int [] ar = {12,443,32,5,500,27,200,64};
        int [][] br = {{12,443},{32,5,500},{27,200,64}};//定义二维数组
        array a = new array(ar,"Hello array!");//创建一个实例a
        a.loopArray();
        a.selectSort();
        a.loopArray();
    }
}
