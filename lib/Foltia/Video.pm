package Foltia::Video;

sub writelog {
    Foltia::Util::writelog(@_);
}

sub getstationid {
    #引き数:局文字列(NHK総合)
    #戻り値:1
    my ($stationname) = @_;
    my $stationid ;
    my $DBQuery =  "SELECT count(*) FROM foltia_station WHERE stationname = '$item{ChName}'";

    my $sth = $dbh->prepare($DBQuery);
	$sth->execute();
    my @stationcount = $sth->fetchrow_array;

    if ($stationcount[0] == 1){
       #チャンネルID取得
        $DBQuery =  "SELECT stationid,stationname FROM foltia_station WHERE stationname = '$item{ChName}'";
        $sth = $dbh->prepare($DBQuery);
        $sth->execute();
        @stationinfo= $sth->fetchrow_array;
        #局ID
        $stationid  = $stationinfo[0];
        #print "StationID:$stationid \n";

    }
    elsif($stationcount[0] == 0){
    #新規登録
        $DBQuery =  "SELECT max(stationid) FROM foltia_station";
        $sth = $dbh->prepare($DBQuery);
        $sth->execute();
        @stationinfo= $sth->fetchrow_array;
        my $stationid = $stationinfo[0] ;
        $stationid  ++;
        ##$DBQuery =  "insert into  foltia_station values ('$stationid'  ,'$item{ChName}','0','','','','','','')";
        #新規局追加時は非受信局をデフォルトに
        $DBQuery =  "insert into  foltia_station  (stationid , stationname ,stationrecch )  values ('$stationid'  ,'$item{ChName}','-10')";

        $sth = $dbh->prepare($DBQuery);
        $sth->execute();
        #print "Add station;$DBQuery\n";
        writelog("foltialib Add station;$DBQuery");
    }
    else {

        #print "Error  getstationid $stationcount[0] stations found. $DBQuery\n";
        writelog("foltialib [ERR]  getstationid $stationcount[0] stations found. $DBQuery");
    }


    return $stationid ;
}

1;
