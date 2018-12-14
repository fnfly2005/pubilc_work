/*语句*/
class sentence
{
    public static void main(String[] args)
    {
        int x = 5;
        multiplicationWhile(x);
        multiplicationWhile();
    }

    static void weekIf(int x)
    /*if 语句判断星期*/
    {   
        char [] weekar = {'一','二','三','四','五','六','日'};
        if (x > 0 && x < 8)
        {
            System.out.println("星期" + weekar[x-1]);
        }
        else
            System.out.println("星期" + x + "不存在");
    }

    static void seasonIf(int x)
    /*if 语句判断季节*/
    {
        String y = "";
        if (x == 12 || x == 1 || x == 2)
            y = "冬";
        else if (x >= 3 && x <=5)
            y = "春";
        else if (x >= 6 && x <=8)
            y = "夏";
        else if (x >= 9 && x <=11)
            y = "秋";
        else
        {   
            System.out.println(x + "月不存在");
            return;
        }
        System.out.println(x + "月是" + y + "季");
    }

    static void seasonSwitch(int x)
    /*switch 语句判断季节*/
    {
        String y = "";
        switch (x)
        {
            case 12:
            case 1:
            case 2:
                System.out.println(x + "月是冬季");
                break;
            case 3:
            case 4:
            case 5:
                System.out.println(x + "月是春季");
                break;
            case 6:
            case 7:
            case 8:
                System.out.println(x + "月是夏季");
                break;
            case 9:
            case 10:
            case 11:
                System.out.println(x + "月是秋季");
            default:
                System.out.println(x + "月不存在");
        }
    }

    static void multiplicationWhile(int x)
    /*while & for语句打印99乘法表*/
    {
        int a = 1;
        while (a <= x)
        {
            for (int b = 1;b<=a;b++)
            {
                System.out.print(b + "*" + a + "=" + a*b + "\t");
            }
            a++;
            System.out.print("\n");
        }
    }

    static void multiplicationWhile()
    /*do while & for语句打印99乘法表 重载函数*/
    {
        for (int a = 1;a <= 9;a++)
        {
            int b = 1;
            do
            {
                System.out.print(b + "*" + a + "=" + a*b + "\t");
                b++;
            }
            while (b<=a);
            System.out.print("\n");
        }
    }
}
