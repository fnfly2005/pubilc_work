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

    static void bubbleSort(int[] arr)
    {//通过冒泡排序算法实现顺序排列
        for (int x=1;x<arr.length-1;x++)
        {
            for (int y=0;y<arr.length-x;y++)
            {
                if (arr[y]>arr[y+1])
                {
                    swap(arr,y,y+1);
                }
            }
        }
    }

    static void bubbleSortPro(int[] arr)
    {//通过冒泡排序算法实现顺序排列,利用中间变量提高性能
        for (int x=1;x<arr.length;x++)
        {
            int tmp = 0;
            for (int y=0;y<arr.length-x;y++)
            {
                if (arr[tmp]<arr[y+1])
                {
                    tmp = y+1;
                }
            }
            if (tmp == arr.length-x)
            {
                continue;
            }
            else
            {
                swap(arr,tmp,arr.length-x);
            }
        }
    }

    static int search(int[] arr,int v)
    {//在指定数组中循环查找给定值,并返回值所在角标
        for (int x=0;x<arr.length;x++)
        {
            if(arr[x] == v)
            {
                return x;
            }
        }
        return -1;
    }

    static int binarySearch(int[] arr,int v)
    {//在指定数组中通过折半查找算法查找给定值,并返回值所在角标
        int min = 0,max = arr.length-1,mid;
        while (min <= max)
        {    
            mid = (min + max)/2;
            if (arr[mid] == v)
            {    
                return mid;
            }
            else if (arr[mid] > v)
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
        bubbleSortPro(ar);
        loopArray(ar);
        System.out.println(binarySearch(ar,200));
    }
}
