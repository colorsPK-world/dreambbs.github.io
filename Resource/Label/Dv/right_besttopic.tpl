query|||7200|||bbs|||select top 10  B.PostUserName, B.Title, B.Rootid as topicid, B.Boardid, B.Dateandtime as topictime, B.Announceid as postid, B.Id as bestid, B.Expression From Dv_BestTopic B INNER JOIN Dv_Topic T ON B.RootID = T.TopicID where B.boardid not in(444,777) and Datediff("d", B.DateAndTime, Now()) <= 90 order by B.id desc|||<ul>|||<LI><A href="dispbbs.asp?boardid={$Boardid}&amp;id={$ID}">{$Topic}</A></LI>|||</ul>|||10$1$1$$0$2$3|||28|||2