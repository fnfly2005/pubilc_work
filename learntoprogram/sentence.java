/*语句*/
class sentence
{
    public static void main(String[] args)
    {
        int x = 5;
        seasonCon(x);
    }
    static void weekCon(int x)
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
    static void seasonCon(int x)
    /*if 语句判断季节*/
    {
        String y = "";
        if (x > 0 && x < 13)
        {
            if (x == 12 || x <= 2)
                y = "冬";
            else if (x >= 3 && x <=5)
                y = "春";
            else if (x >= 6 && x <=8)
                y = "夏";
            else if (x >= 9 && x <=11)
                y = "秋";
            System.out.println(x + "月是" + y + "季");
        }
        else
            System.out.println(x + "月不存在");
    }
}
