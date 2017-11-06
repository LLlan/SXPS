function scoreFun1(object,opts){
    // Ĭ������
    var defaults={
        fen_d:16,  // ÿ��a�Ŀ��
        ScoreGrade:10,  // a�ĸ���
        nameScore:"fenshu",
        parent:"star_score",
    };
    options=$.extend({},defaults,opts);
    var countScore=object.find("."+options.nameScore);  // �ҵ���Ϊ��fenshu������
    var startParent=object.find("."+options.parent);    // �ҵ���Ϊ��star_score������
    var now_cli;
    var fen_d=options.fen_d;     // ÿ��a�Ŀ��
    var len=options.ScoreGrade;  // ��a�ĸ���ֵ��len
    startParent.width(fen_d*len); //��a��div���ӵĿ��
    var preA=(5/len);
    for(var i=0;i<len;i++){
        var newSpan=$("<a href='javascript:void(0)'></a>");     // ������ˢ��ҳ�������£�����ʹ��void(0)
        newSpan.css({"left":0,"width":fen_d*(i+1),"z-index":len-i});  // ����a�Ŀ�ȡ��㼶
        newSpan.appendTo(startParent)
    }                                    //  ��a�ŵ�����Ϊ��star_score����div��
    startParent.find("a").each(          // each��������
        function(index,element){
            $(this).click(function(){        // ����¼�
                now_cli=index;                   // ��ǰa������ֵ
                show(index,$(this))             //  ����show����
            });
            $(this).mouseenter(function(){    /* mouseenter�¼�(�� mouseover �¼���ͬ��ֻ�������ָ�봩��ѡԪ��ʱ��
             �Żᴥ�� mouseenter �¼���������ָ�봩���κ���Ԫ�أ�ͬ��ᴥ�� mouseover �¼���) */
                show(index,$(this))
            });
            $(this).mouseleave(function(){    // mouseleave�¼�
                if(now_cli>=0){
                    var scor=preA*(parseInt(now_cli)+1);         // ����
                    startParent.find("a").removeClass("clibg");  // ���a�ġ�clibg����
                    startParent.find("a").eq(now_cli).addClass("clibg"); // eq()ѡ������ѡȡ����ֵΪ��now_cli����a��������ϡ�clibg����
                    var ww=fen_d*(parseInt(now_cli)+1);                  // ��ǰa�Ŀ��
                    startParent.find("a").eq(now_cli).css({"width":ww,"left":"0"});  // ������ֵΪ��now_cli����a���Ͽ�ȡ�ww����leftֵ
                    if(countScore){
                        countScore.text(scor)
                    }
                }else{
                    startParent.find("a").removeClass("clibg");
                    if(countScore){
                        countScore.text("")
                    }
                }
            })
        });

    // show����
    function show(num,obj){
        var n=parseInt(num)+1;
        var lefta=num*fen_d;
        var ww=fen_d*n;
        var scor=preA*n;                        // ����
        // �û�̬��
        object.find("a").removeClass("clibg");  // �������a�ġ�clibg����
        obj.addClass("clibg");                  // ��ǰa��ӡ�clibg����
        obj.css({"width":ww,"left":"0"});       // ��ǰa��ӿ�ȡ�ww����leftֵ
        countScore.text(scor);                  // ��ʾ����
        $("#qsscore").val(scor);
    }
};
