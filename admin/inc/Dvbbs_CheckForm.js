function checkForm(fm,disableSubmitter){
 try {
    var formats = new Array( //预定义格式类型
        "int [+-]?\\d* 整数",
		"cint ^\\d+$ 正整数",
        "long [+-]?\\d* 整数",
        "float [+-]?\\d*\\.?\\d* 小数",
        "double [+-]?\\d*\\.?\\d* 小数",
        "char . 字符",
        "Email \\w+([.]\\w+)*@\\w+([.]\\w+)+ 电子邮件地址",
        "Date \\d{4}-\\d{2}-\\d{2} 日期(yyyy-MM-dd)",
        "Time \\d{2}:\\d{2}:\\d{2} 时间(HH:mm:ss)",
        "Timestamp \\d{4}-\\d{2}-\\d{2}\\s\\d{2}:\\d{2}:\\d{2} 日期(HH:mm:ss)",
        "IdCard \\d{15}|\\d{17}[0-9xX] 身份证号(15位或18位)",
        "URL http://.* 互联网地址",
        "Chinese [^\\x00-\\xff]* 全中文",
        "");
    for(var i = 0; i < fm.length; i++) {
        var input = fm[i];
        var tag = input.tagName;
        if(tag != 'SELECT' && tag != 'INPUT' && tag != 'TEXTAREA') continue;
        var name = input.name; name = name.replace(/^\s*|\s*$/g,''); // 实现trim()方法
        var value = input.value;
        var title = input.title; if(title == null) title = '';
		//先获取格式串
        var k = name.indexOf(" ");
        var fmt = '';
        if(k > 0) {
            fmt = name.substring(0,k);
            name = name.substring(k+1);
        } else if(name.charAt(0) == '!') {
            fmt = "!";
            name = name.substring(1);
        } else { 
            k = title.indexOf("$");
            if(k < 0) continue; 
            fmt = title.substring(k+1);
            title = title.substring(0,k);
        }
        var allowEmpty = fmt.charAt(0) != '!';
        //非空检查
        if(!allowEmpty) {
            fmt = fmt.substring(1);
            if(input.type == 'radio' || input.type == 'checkbox') {
                var choices = fm[input.name];
                var choosed = false;
                if(typeof(choices.length) == 'undefined') { //只有一个选项
                    choices = [choices]; //变成只有一个元素的数组
                }

                for(var j = 0; j < choices.length; j++) {
                    var choice = choices[j];
                    if(choice.checked) {
                        choosed = true;
                        break;
                    }
                }
                if(!choosed) return error(input,name,'必须选择一项！',title);
            } else if(value.replace(/^\s*|\s*$/g,'') == '' || parseInt(value) > 2147483647) {
                return error(input,name,'不能为空值或大于2147483647！',title);
            }
        }
        if(fmt == '') continue; //无其它格式限制
        var desc = '';
        //检查预定义类型
        for(var j = 0; j < formats.length; j++) {
            var format = formats[j];
            var k = format.indexOf(" ");
            if(k < 0) continue;
            var alias = format.substring(0,k);
            format = format.substring(k+1);
            if(fmt == alias) { //找到对应的预定义类型
                k = format.indexOf(" ");
                fmt = format.substring(0,k);
                desc = format.substring(k+1);
                break;
            }
        }
        if(value != "" &&  !new RegExp("^("+fmt.replace(/\\n|\\r/g,"")+")$").test(value.replace(/\n|\r/g," ").replace(/([^\x00-\xff])/g,'$1$1')))
		{
            return error(input,name,desc != '' ? "格式不对，应该输入 "+desc
                : "不符合要求( "+fmt+" )，\n可能含非法字符或者少于或超出规定字符数等等\n（注意一个中文相当于两个字符）\n\n当前输入内容长度(字符数): "+checkForm$len(value),title);
        }
    }
    //全部检查通过，返回成功信息
    if(disableSubmitter) for(var i = 0; i < fm.length; i++) {
        var input = fm[i];
        if(input.tagName=='INPUT' && (input.type=='submit' || input.type=='image')) {
            input.disabled=true;
            input.value='请稍候...';
        }
    }
    return true;
 } catch (e){
	 alert(e);
	 return false;
 }
    function error(input,name,msg,title) {
        var bgColor = input.style.backgroundColor;
        input.style.backgroundColor = bgColor.search(/red|#?FF0000/) < 0 ? 'red' : 'blue';
        try {
            input.focus();
            input.select();
        } catch(e) {}
        msg = "输入项 "+msg;
        if(title != null && title != '') msg = title+"\n\n详细提示：\n"+msg;
        alert(msg);
        input.style.backgroundColor = bgColor;
        return false;
    }
}
function checkForm$len(s) {
    return s.replace(/[^\x00-\xff]/g,'\0\0').length;
}