<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>信息中心 /</title>
	<link rel="stylesheet" href="/?mode=section&id=style.css" type="text/css">
    <script type="text/javascript" src="/?mode=jquery"></script>
	<link rel="shortcut icon" href="/favicon.ico">
	<style class='trash-me'>
	.onlyscript, button[onclick] { display:none; }
	</style>
    <script>
    // 此对象在javascript空间储存%symbols%供库文件读取
    HFS = { folder:'/', number:1, paged:1 }; 
    </script>
	<script type="text/javascript" src="/?mode=section&id=lib.js"></script>
</head>
<body>
<!-- -->
<div id='panel'>
    	<fieldset id='msgs'>
		<legend><img src="/~img10"> 消息</legend>
		<ul style='padding-left:2em'>
		</ul>
	</fieldset>

    	<fieldset id='login'>
		<legend><img src="/~img27"> 用户</legend>
		<center>
		<a href="~login">登录</a>
		</center>
	</fieldset>                                       

    	<fieldset id='folder'>
		<legend><img src="/~img8"> 目录</legend>

       <div style='float:right; position:relative; top:-1em; font-weight:bold;'>
		
		</div>

		<div id='breadcrumbs'>
		
		<a href="/"  /> <img src="/~img1"> 首页</a>
       </div>
        
		<div id='folder-stats'>1 个子目录, 0 个文件, 0 B
		</div>
		
		
	</fieldset>

    	<fieldset id='search'>
		<legend><img src="/~img3"> 搜索</legend>
		<form style='text-align:center'>
			<input name='search' size='15' value="">
			<input type='submit' value="确定">
		</form>
		<div style='margin-top:0.5em;' class='hidden popup'>
			<fieldset>
				<legend>搜索选项</legend>
					<input type='radio' name='where' value='fromhere' checked='true' />  包含子目录
					<br><input type='radio' name='where' value='here' />  仅在当前目录下搜索(不含子目录)
					<br><input type='radio' name='where' value='anywhere' />  整个服务器
			</fieldset>
		</div>
	</fieldset>

    	<fieldset id='select' class='onlyscript'>
		<legend><img src="/~img15"> 选择</legend>
		<center>
    	<button onclick="
            var x = $('#files .selector');
            if (x.size() > x.filter(':checked').size())
                x.attr('checked', true).closest('tr').addClass('selected');
			else
                x.attr('checked', false).closest('tr').removeClass('selected');
			selectedChanged();
			">全选</button>
    	<button onclick="
            $('#files .selector').attr('checked', function(i,v){ return !v }).closest('tr').toggleClass('selected');
			selectedChanged();
            ">反选</button>
    	<button onclick='selectionMask.call(this)'>通配符</button>
		<p style='display:none; margin-top:1em;'><span id='selected-number'>0</span> 项已选定</p>
		</center>
	</fieldset>

    	

    	<fieldset id='actions'>
		<legend><img src="/~img18"> 操作</legend>
		<center>
		
		
		
		
		<button id='archiveBtn' onclick='if (confirm("是否确定？")) submit({}, "/?mode=archive&recursive")'>打包下载</button>
		<a href="/?tpl=list&folders-filter=\&recursive">文件列表</a>
		</center>
	</fieldset>

    	<fieldset id='serverinfo'>
		<legend><img src="/~img0"> 服务器信息</legend>
		<a href="http://www.iziu.net/hfs/">HttpFileServer v2.3i 297 随波汉化版</a>
		<br />服务器时间: 2019/6/30 9:55:51
		<br />在线时长: (12 天) 08:48:03
	</fieldset>


</div>

<div id='files_outer'>
	<div style='height:1.6em;'></div>  
	
        <form method='post'>
            <table id='files'>
             
            <th><a href="/?sort=n">文件名</a><a href="/?sort=e">.扩展名</a>
            <th><a href="/?sort=s">大小(类型)</a>
            <th><a href="/?sort=t">修改时间</a>
            <th><a href="/?sort=d">点击量</a>
            	<tr class=''><td>
        <input type='checkbox' class='selector' name='selection' value="20190608/"  />
		
		
		<a href="20190608/"><img src="/~img_folder"> 20190608</a>
		
		
<td class='nosize'>目录<td>2019/6/18 1:21:02<td>1

            </table>
        </form>
	
</div>

</body>
</html>
<!-- Build-time: 0.016 -->
