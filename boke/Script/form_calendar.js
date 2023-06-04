var dMonthName = new Array("1 月","2 月","3 月","4 月","5 月","6 月","7 月","8 月","9 月","10 月","11 月","12 月");

function populate(Dyear,Dmonth,Dday,Val) {
	if (Dyear.options[Dyear.selectedIndex].value==0)
	{
		Dmonth.options[0].selected = true;
		Dday.options[0].selected = true;
		return;
	}
	if (Dmonth.options[Dmonth.selectedIndex].value==0)
	{
		Dday.options[0].selected = true;
		return;
	}
	timeA = new Date(Dyear.options[Dyear.selectedIndex].value, Dmonth.options[Dmonth.selectedIndex].value,1);
	timeDifference = timeA - 86400000;
	timeB = new Date(timeDifference);
	var daysInMonth = timeB.getDate();
	var sel = 0;
	for (var i = 1; i <= Dday.length; i++) {
		Dday.options[i] = null;
	}
	for (var i = 1; i <= daysInMonth; i++) {
		if (i==Val)
		{
			sel = i
		}
		Dday.options[i] = new Option(i,i);

	}
	Dday.options[sel].selected = true;
}

function getYears(Dyear,Dmonth,Dday){
	var sel=0;
	var today = new Date();
	var sel_Year = today.getFullYear();
	var sel_Month = today.getMonth()+1;
	var sel_Day = today.getDate();
	if (Dyear)
	{	
		var k = 1;
		for (var i = 1980; i <= 2050; i++) {
			if (i==sel_Year)
			{
				sel = k;
			};
			Dyear.options[k++] = new Option(i,i);
		};
		//Dyear.options[sel].selected = true;
		Dyear.options[0].selected = true;
	}
	if (Dmonth)
	{	
		var k = 1;
		for (var i = 1; i <= 12; i++) {
			if (i==sel_Month)
			{
				sel = k;
			};
			Dmonth.options[k++] = new Option(i,i);
		};
		Dmonth.options[0].selected = true;
		//Dmonth.options[sel].selected = true;
	}
	populate(Dyear,Dmonth,Dday,sel_Day);
}