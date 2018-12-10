/*运算符*/
class operator
{
    public static void main(String[] args)
    {
        int x = 5,y =2 ;
        x = x/y;//int类型摄取精度
        System.out.println(x);
        x = 5;
        x = x % y;//任何数模与2=0或1，可实现开关算法
        System.out.println(x);
        
        System.out.println(x == 0 && y == 2);//&&和||实现短路运算
        
        int z = (x > y)?100:200;//三元运算符
        System.out.println(z);
    }
}
