/*数组*/
class array
{
    static int maximum(int[] arr)
    {//遍历数组并查找数组中最大值的角标
        int max = 0;
        for(int i=1;i<arr.length;i++)
        {
            if (arr[i]>arr[max])
            {    
                max = i;
            }
        }
        return max;
    }

    static void swap(int[] array,int a1,int a2)
    {//实现数组中两个值的位置互换
        int tmp = array[a1];
        array[a1] = array[a2];
        array[a2] = tmp;
    }

    static void selectSort(int[] arr)
    {//通过选择排序算法实现顺序排列
        for(int x=0;x<arr.length-1;x++)
        {
            for(int y=x+1;y<arr.length;y++)
            {
                if (arr[x]>arr[y])
                {
                    swap(arr,x,y);
                }
            }
        }
    }

    static void loopArray(int[] arr)
    {//遍历并打印数组
        System.out.print('[');
        for(int a=0;a<arr.length;a++)
        {
            System.out.print(arr[a]);
            if(a<(arr.length-1))
            {
                System.out.print(',');
            }
        }
        System.out.println(']');
    }

    public static void main(String [] args)
    {
        int [] ar = {12,443,32,5,500,27,200,64};
        loopArray(ar);
        selectSort(ar);
        loopArray(ar);
    }
}
