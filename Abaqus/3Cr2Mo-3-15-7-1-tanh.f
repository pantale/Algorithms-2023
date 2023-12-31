C **********************************************************************
C Function to compute the ANN : 3Cr2Mo-3-15-7-1-tanh yield stress
C **********************************************************************
      subroutine vuhard (
C Read only -
     +  nblock, nElement, nIntPt, nLayer, nSecPt, lAnneal, stepTime,
     +  totalTime, dt, cmname, nstatev, nfieldv, nprops, props,
     +  tempOld, tempNew, fieldOld, fieldNew, stateOld, eqps, eqpsRate,
C Write only -
     +  yield, dyieldDtemp, dyieldDeqps, stateNew)
C
      include 'vaba_param.inc'
C
      dimension nElement(nblock), props(nprops), tempOld(nblock),
     +  fieldOld(nblock,nfieldv), stateOld(nblock,nstatev),
     +  tempNew(nblock), fieldNew(nblock,nfieldv), eqps(nblock),
     +  eqpsRate(nblock), yield(nblock), dyieldDtemp(nblock),
     +  dyieldDeqps(nblock,2), stateNew(nblock,nstatev)
C
      character*80 cmname
C Block of Data
      double precision w1(15, 3)
      data w1/-75.5444402947533433D0,
     + -1.3709751038168696D0,
     + -4.0245387094906695D0,
     + -0.0040313305645774D0,
     + -0.5729523728173586D0,
     + -0.0020422459754367D0,
     + -1.5769215562559726D0,
     + 0.0079363842497294D0,
     + 0.0443103052953499D0,
     + 1.3079630891171266D0,
     + 0.9677385339854429D0,
     + 2.9029892496398588D0,
     + -0.0679788045869489D0,
     + 0.0041180469804001D0,
     + 0.9596595729909847D0,
     + 0.3284910347508931D0,
     + 3.6841240503734385D0,
     + -0.2434634367415819D0,
     + 0.0007920851648659D0,
     + -0.9436192175260616D0,
     + 0.0008079746902551D0,
     + 7.436354490198215D0,
     + -0.0009966116737367D0,
     + -1.0108673774255899D0,
     + -2.3071128616230534D0,
     + -1.5457262616503669D0,
     + -1.1976993439590935D0,
     + 1.0578337640486237D0,
     + -0.0007066364913043D0,
     + 1.2504550678299482D0,
     + -0.6885841017317398D0,
     + -1.1428813074932955D0,
     + 0.5870571090838993D0,
     + 0.0000950997819481D0,
     + 1.2753069658873655D0,
     + 0.0001680788110138D0,
     + -2.4741163388386069D0,
     + 0.0023831925645855D0,
     + -1.4781616042112562D0,
     + -0.6447100974563608D0,
     + 2.7540015654580503D0,
     + 1.7873683161692426D0,
     + -0.8701333237919128D0,
     + 0.0000023636155134D0,
     + 0.6035968744970454D0/
      double precision b1(15)
      data b1/-0.1258098445887378D0,
     + -0.1203401506725763D0,
     + -0.1294281057965802D0,
     + 0.0008052587390056D0,
     + 0.8841020235481911D0,
     + 0.0001654266831852D0,
     + -1.484835580741158D0,
     + -0.0046595459893259D0,
     + 0.8087513943019989D0,
     + 1.2034636785255917D0,
     + -0.0698580215002857D0,
     + -0.3896919069715254D0,
     + 0.0761994531549335D0,
     + -0.0007870816039992D0,
     + -2.0490753662444363D0/
      double precision w2(7, 15)
      data w2/-0.0121375032757875D0,
     + 0.2835586114886794D0,
     + -0.8141649710068674D0,
     + 0.6818913857766838D0,
     + 10.5421824439908232D0,
     + 0.208806870421293D0,
     + 1.9800644419773339D0,
     + -1.0365257693269965D0,
     + 0.1714899011381173D0,
     + -2.6606016443447782D0,
     + -0.3718205790255899D0,
     + 1.2507188154859443D0,
     + 0.7676115436336375D0,
     + -1.2954503050571571D0,
     + 0.3228512581018655D0,
     + 2.2015651361571216D0,
     + 0.6293956859948151D0,
     + -0.9760544064619361D0,
     + 0.234762763567321D0,
     + 0.5203501594687904D0,
     + -2.2276850262841021D0,
     + 0.000694970558816D0,
     + -0.0020363604052289D0,
     + 0.0114517067643744D0,
     + -0.0005561891552271D0,
     + 0.0097406805922826D0,
     + 0.000689863404697D0,
     + -0.0020317006986751D0,
     + 1.0692040960117719D0,
     + -0.9325563069989358D0,
     + -1.3109831294676251D0,
     + -0.481086696046973D0,
     + 1.9465801626141146D0,
     + 0.6585937923912638D0,
     + 1.7721920101181472D0,
     + 0.0002465321996336D0,
     + -0.0011145184549106D0,
     + 0.0029079538717954D0,
     + -0.0002693587259754D0,
     + 0.0050350115471366D0,
     + 0.0002954720565342D0,
     + 0.0001474365592901D0,
     + 0.0317892115741316D0,
     + -0.0254071321864616D0,
     + -1.2558708273102106D0,
     + -0.2796796354803333D0,
     + 0.3810328307226638D0,
     + 0.666518403416575D0,
     + 3.6724440995829992D0,
     + -0.0013106704048376D0,
     + 0.0010162680639107D0,
     + -0.0031055322387757D0,
     + 0.0004670203582239D0,
     + -0.0146090605452655D0,
     + -0.0013984988976365D0,
     + 0.0063655966272432D0,
     + 0.770834246217189D0,
     + 0.3638241972802366D0,
     + -2.4093760141094531D0,
     + 0.6141138943000737D0,
     + 0.6460361986820349D0,
     + -0.4328922814957333D0,
     + 0.9219307620139566D0,
     + -0.0790967259768621D0,
     + -0.5182344085978291D0,
     + -7.7694542663090198D0,
     + -0.1505897805191534D0,
     + -0.2194920607151181D0,
     + 0.5869329769388717D0,
     + -1.0009969156180203D0,
     + 0.1276921735590718D0,
     + 0.1252862121493047D0,
     + -7.9752056477377247D0,
     + -0.7539309000819953D0,
     + 1.8167021034145885D0,
     + 0.3881066405879119D0,
     + -0.0024028958738676D0,
     + 0.1318381932203156D0,
     + -0.7467366998346026D0,
     + 2.1448523271475226D0,
     + -0.4129490005658117D0,
     + 1.1141553829983786D0,
     + -1.0693865998134062D0,
     + 1.2521272048875522D0,
     + -0.0115959639726218D0,
     + 0.0579082499889543D0,
     + -2.7811149711037579D0,
     + 0.3447068627906172D0,
     + -0.121471820458427D0,
     + -1.6258560226698036D0,
     + -1.9002843728409102D0,
     + -0.0007201017458843D0,
     + 0.0020713591824005D0,
     + -0.0150718565368522D0,
     + 0.0006276743814545D0,
     + -0.0100227866644518D0,
     + -0.0007477353642073D0,
     + 0.0023370843718723D0,
     + 0.1302264571710037D0,
     + -0.2374565384878316D0,
     + 7.3407467275148965D0,
     + 2.0012146714864341D0,
     + 1.4842025879870451D0,
     + 0.0301936135697516D0,
     + 0.3849472489491611D0/
      double precision b2(7)
      data b2/0.2115064322997065D0,
     + -0.4967608548053311D0,
     + 2.414521262364822D0,
     + 0.0795932098148138D0,
     + 0.3333163075223112D0,
     + 0.035737261237753D0,
     + 0.9378600143443527D0/
      double precision w3(7)
      data w3/-0.2888236183120837D0,
     + -0.3887697725944707D0,
     + 0.0119204810037255D0,
     + 0.2011877688553212D0,
     + -0.247670287060762D0,
     + -0.1083011396081442D0,
     + -0.0444773207679939D0/
      double precision b3
      data b3/-0.0751713687262747D0/
      double precision xmI(3)
      data xmI/0D0,
     + 0D0,
     + 1050D0/
      double precision xrI(3)
      data xrI/0.7D0,
     + 8.5171931914162382D0,
     + 200D0/
      double precision xmO
      data xmO/0.03016674D0/
      double precision xrO
      data xrO/153.709333259999994D0/
      double precision xdeps0
      data xdeps0/0.001D0/
C Do the main loop for all block values
      do k = 1, nblock
C Preprocessing of the variables
      xeps = (eqps(k) - xmI(1))/xrI(1)
      if (eqpsRate(k) > xdeps0) then
        xdeps = (log(eqpsRate(k)/xdeps0) - xmI(2))/xrI(2)
      else
        xdeps = 0
        eqpsRate(k) = xdeps0
      endif
      xtemp = (tempNew(k) - xmI(3))/xrI(3)
C Hidden layer #1 - (y11 to y115)
      y11 = w1(1,1) * xeps
     + +w1(1,2) * xdeps
     + +w1(1,3) * xtemp
     + +b1(1)
      y12 = w1(2,1) * xeps
     + +w1(2,2) * xdeps
     + +w1(2,3) * xtemp
     + +b1(2)
      y13 = w1(3,1) * xeps
     + +w1(3,2) * xdeps
     + +w1(3,3) * xtemp
     + +b1(3)
      y14 = w1(4,1) * xeps
     + +w1(4,2) * xdeps
     + +w1(4,3) * xtemp
     + +b1(4)
      y15 = w1(5,1) * xeps
     + +w1(5,2) * xdeps
     + +w1(5,3) * xtemp
     + +b1(5)
      y16 = w1(6,1) * xeps
     + +w1(6,2) * xdeps
     + +w1(6,3) * xtemp
     + +b1(6)
      y17 = w1(7,1) * xeps
     + +w1(7,2) * xdeps
     + +w1(7,3) * xtemp
     + +b1(7)
      y18 = w1(8,1) * xeps
     + +w1(8,2) * xdeps
     + +w1(8,3) * xtemp
     + +b1(8)
      y19 = w1(9,1) * xeps
     + +w1(9,2) * xdeps
     + +w1(9,3) * xtemp
     + +b1(9)
      y110 = w1(10,1) * xeps
     + +w1(10,2) * xdeps
     + +w1(10,3) * xtemp
     + +b1(10)
      y111 = w1(11,1) * xeps
     + +w1(11,2) * xdeps
     + +w1(11,3) * xtemp
     + +b1(11)
      y112 = w1(12,1) * xeps
     + +w1(12,2) * xdeps
     + +w1(12,3) * xtemp
     + +b1(12)
      y113 = w1(13,1) * xeps
     + +w1(13,2) * xdeps
     + +w1(13,3) * xtemp
     + +b1(13)
      y114 = w1(14,1) * xeps
     + +w1(14,2) * xdeps
     + +w1(14,3) * xtemp
     + +b1(14)
      y115 = w1(15,1) * xeps
     + +w1(15,2) * xdeps
     + +w1(15,3) * xtemp
     + +b1(15)
C tanh activation function - (yf11 to yf115)
      yf11 = tanh(y11)
      yf12 = tanh(y12)
      yf13 = tanh(y13)
      yf14 = tanh(y14)
      yf15 = tanh(y15)
      yf16 = tanh(y16)
      yf17 = tanh(y17)
      yf18 = tanh(y18)
      yf19 = tanh(y19)
      yf110 = tanh(y110)
      yf111 = tanh(y111)
      yf112 = tanh(y112)
      yf113 = tanh(y113)
      yf114 = tanh(y114)
      yf115 = tanh(y115)
C Hidden layer #2 - (y21 to y27)
      y21 = w2(1,1) * yf11
     + +w2(1,2) * yf12
     + +w2(1,3) * yf13
     + +w2(1,4) * yf14
     + +w2(1,5) * yf15
     + +w2(1,6) * yf16
     + +w2(1,7) * yf17
     + +w2(1,8) * yf18
     + +w2(1,9) * yf19
     + +w2(1,10) * yf110
     + +w2(1,11) * yf111
     + +w2(1,12) * yf112
     + +w2(1,13) * yf113
     + +w2(1,14) * yf114
     + +w2(1,15) * yf115
     + +b2(1)
      y22 = w2(2,1) * yf11
     + +w2(2,2) * yf12
     + +w2(2,3) * yf13
     + +w2(2,4) * yf14
     + +w2(2,5) * yf15
     + +w2(2,6) * yf16
     + +w2(2,7) * yf17
     + +w2(2,8) * yf18
     + +w2(2,9) * yf19
     + +w2(2,10) * yf110
     + +w2(2,11) * yf111
     + +w2(2,12) * yf112
     + +w2(2,13) * yf113
     + +w2(2,14) * yf114
     + +w2(2,15) * yf115
     + +b2(2)
      y23 = w2(3,1) * yf11
     + +w2(3,2) * yf12
     + +w2(3,3) * yf13
     + +w2(3,4) * yf14
     + +w2(3,5) * yf15
     + +w2(3,6) * yf16
     + +w2(3,7) * yf17
     + +w2(3,8) * yf18
     + +w2(3,9) * yf19
     + +w2(3,10) * yf110
     + +w2(3,11) * yf111
     + +w2(3,12) * yf112
     + +w2(3,13) * yf113
     + +w2(3,14) * yf114
     + +w2(3,15) * yf115
     + +b2(3)
      y24 = w2(4,1) * yf11
     + +w2(4,2) * yf12
     + +w2(4,3) * yf13
     + +w2(4,4) * yf14
     + +w2(4,5) * yf15
     + +w2(4,6) * yf16
     + +w2(4,7) * yf17
     + +w2(4,8) * yf18
     + +w2(4,9) * yf19
     + +w2(4,10) * yf110
     + +w2(4,11) * yf111
     + +w2(4,12) * yf112
     + +w2(4,13) * yf113
     + +w2(4,14) * yf114
     + +w2(4,15) * yf115
     + +b2(4)
      y25 = w2(5,1) * yf11
     + +w2(5,2) * yf12
     + +w2(5,3) * yf13
     + +w2(5,4) * yf14
     + +w2(5,5) * yf15
     + +w2(5,6) * yf16
     + +w2(5,7) * yf17
     + +w2(5,8) * yf18
     + +w2(5,9) * yf19
     + +w2(5,10) * yf110
     + +w2(5,11) * yf111
     + +w2(5,12) * yf112
     + +w2(5,13) * yf113
     + +w2(5,14) * yf114
     + +w2(5,15) * yf115
     + +b2(5)
      y26 = w2(6,1) * yf11
     + +w2(6,2) * yf12
     + +w2(6,3) * yf13
     + +w2(6,4) * yf14
     + +w2(6,5) * yf15
     + +w2(6,6) * yf16
     + +w2(6,7) * yf17
     + +w2(6,8) * yf18
     + +w2(6,9) * yf19
     + +w2(6,10) * yf110
     + +w2(6,11) * yf111
     + +w2(6,12) * yf112
     + +w2(6,13) * yf113
     + +w2(6,14) * yf114
     + +w2(6,15) * yf115
     + +b2(6)
      y27 = w2(7,1) * yf11
     + +w2(7,2) * yf12
     + +w2(7,3) * yf13
     + +w2(7,4) * yf14
     + +w2(7,5) * yf15
     + +w2(7,6) * yf16
     + +w2(7,7) * yf17
     + +w2(7,8) * yf18
     + +w2(7,9) * yf19
     + +w2(7,10) * yf110
     + +w2(7,11) * yf111
     + +w2(7,12) * yf112
     + +w2(7,13) * yf113
     + +w2(7,14) * yf114
     + +w2(7,15) * yf115
     + +b2(7)
C tanh activation function - (yf21 to yf27)
      yf21 = tanh(y21)
      yf22 = tanh(y22)
      yf23 = tanh(y23)
      yf24 = tanh(y24)
      yf25 = tanh(y25)
      yf26 = tanh(y26)
      yf27 = tanh(y27)
C Derivatives terms - (xa1 to xa7) and (xb1 to xb15)
      xa1 = w3(1) * (1 - yf21*yf21)
      xa2 = w3(2) * (1 - yf22*yf22)
      xa3 = w3(3) * (1 - yf23*yf23)
      xa4 = w3(4) * (1 - yf24*yf24)
      xa5 = w3(5) * (1 - yf25*yf25)
      xa6 = w3(6) * (1 - yf26*yf26)
      xa7 = w3(7) * (1 - yf27*yf27)
      xb1 = (w2(1,1) * xa1
     + +w2(2,1) * xa2
     + +w2(3,1) * xa3
     + +w2(4,1) * xa4
     + +w2(5,1) * xa5
     + +w2(6,1) * xa6
     + +w2(7,1) * xa7)
     + * (1 - yf11*yf11)
      xb2 = (w2(1,2) * xa1
     + +w2(2,2) * xa2
     + +w2(3,2) * xa3
     + +w2(4,2) * xa4
     + +w2(5,2) * xa5
     + +w2(6,2) * xa6
     + +w2(7,2) * xa7)
     + * (1 - yf12*yf12)
      xb3 = (w2(1,3) * xa1
     + +w2(2,3) * xa2
     + +w2(3,3) * xa3
     + +w2(4,3) * xa4
     + +w2(5,3) * xa5
     + +w2(6,3) * xa6
     + +w2(7,3) * xa7)
     + * (1 - yf13*yf13)
      xb4 = (w2(1,4) * xa1
     + +w2(2,4) * xa2
     + +w2(3,4) * xa3
     + +w2(4,4) * xa4
     + +w2(5,4) * xa5
     + +w2(6,4) * xa6
     + +w2(7,4) * xa7)
     + * (1 - yf14*yf14)
      xb5 = (w2(1,5) * xa1
     + +w2(2,5) * xa2
     + +w2(3,5) * xa3
     + +w2(4,5) * xa4
     + +w2(5,5) * xa5
     + +w2(6,5) * xa6
     + +w2(7,5) * xa7)
     + * (1 - yf15*yf15)
      xb6 = (w2(1,6) * xa1
     + +w2(2,6) * xa2
     + +w2(3,6) * xa3
     + +w2(4,6) * xa4
     + +w2(5,6) * xa5
     + +w2(6,6) * xa6
     + +w2(7,6) * xa7)
     + * (1 - yf16*yf16)
      xb7 = (w2(1,7) * xa1
     + +w2(2,7) * xa2
     + +w2(3,7) * xa3
     + +w2(4,7) * xa4
     + +w2(5,7) * xa5
     + +w2(6,7) * xa6
     + +w2(7,7) * xa7)
     + * (1 - yf17*yf17)
      xb8 = (w2(1,8) * xa1
     + +w2(2,8) * xa2
     + +w2(3,8) * xa3
     + +w2(4,8) * xa4
     + +w2(5,8) * xa5
     + +w2(6,8) * xa6
     + +w2(7,8) * xa7)
     + * (1 - yf18*yf18)
      xb9 = (w2(1,9) * xa1
     + +w2(2,9) * xa2
     + +w2(3,9) * xa3
     + +w2(4,9) * xa4
     + +w2(5,9) * xa5
     + +w2(6,9) * xa6
     + +w2(7,9) * xa7)
     + * (1 - yf19*yf19)
      xb10 = (w2(1,10) * xa1
     + +w2(2,10) * xa2
     + +w2(3,10) * xa3
     + +w2(4,10) * xa4
     + +w2(5,10) * xa5
     + +w2(6,10) * xa6
     + +w2(7,10) * xa7)
     + * (1 - yf110*yf110)
      xb11 = (w2(1,11) * xa1
     + +w2(2,11) * xa2
     + +w2(3,11) * xa3
     + +w2(4,11) * xa4
     + +w2(5,11) * xa5
     + +w2(6,11) * xa6
     + +w2(7,11) * xa7)
     + * (1 - yf111*yf111)
      xb12 = (w2(1,12) * xa1
     + +w2(2,12) * xa2
     + +w2(3,12) * xa3
     + +w2(4,12) * xa4
     + +w2(5,12) * xa5
     + +w2(6,12) * xa6
     + +w2(7,12) * xa7)
     + * (1 - yf112*yf112)
      xb13 = (w2(1,13) * xa1
     + +w2(2,13) * xa2
     + +w2(3,13) * xa3
     + +w2(4,13) * xa4
     + +w2(5,13) * xa5
     + +w2(6,13) * xa6
     + +w2(7,13) * xa7)
     + * (1 - yf113*yf113)
      xb14 = (w2(1,14) * xa1
     + +w2(2,14) * xa2
     + +w2(3,14) * xa3
     + +w2(4,14) * xa4
     + +w2(5,14) * xa5
     + +w2(6,14) * xa6
     + +w2(7,14) * xa7)
     + * (1 - yf114*yf114)
      xb15 = (w2(1,15) * xa1
     + +w2(2,15) * xa2
     + +w2(3,15) * xa3
     + +w2(4,15) * xa4
     + +w2(5,15) * xa5
     + +w2(6,15) * xa6
     + +w2(7,15) * xa7)
     + * (1 - yf115*yf115)
C Outputs of the subroutine
      Yield(k) = xrO * (w3(1) * yf21
     + +w3(2) * yf22
     + +w3(3) * yf23
     + +w3(4) * yf24
     + +w3(5) * yf25
     + +w3(6) * yf26
     + +w3(7) * yf27
     + +b3)
     + +xmO
      dyieldDeqps(k,1) = xrO * (w1(1,1) * xb1
     + +w1(2,1) * xb2
     + +w1(3,1) * xb3
     + +w1(4,1) * xb4
     + +w1(5,1) * xb5
     + +w1(6,1) * xb6
     + +w1(7,1) * xb7
     + +w1(8,1) * xb8
     + +w1(9,1) * xb9
     + +w1(10,1) * xb10
     + +w1(11,1) * xb11
     + +w1(12,1) * xb12
     + +w1(13,1) * xb13
     + +w1(14,1) * xb14
     + +w1(15,1) * xb15) / xrI(1)
      dyieldDeqps(k,2) = xrO * (w1(1,2) * xb1
     + +w1(2,2) * xb2
     + +w1(3,2) * xb3
     + +w1(4,2) * xb4
     + +w1(5,2) * xb5
     + +w1(6,2) * xb6
     + +w1(7,2) * xb7
     + +w1(8,2) * xb8
     + +w1(9,2) * xb9
     + +w1(10,2) * xb10
     + +w1(11,2) * xb11
     + +w1(12,2) * xb12
     + +w1(13,2) * xb13
     + +w1(14,2) * xb14
     + +w1(15,2) * xb15)
     + /(xrI(2)*eqpsRate(k))
      dyieldDtemp(k) = xrO * (w1(1,3) * xb1
     + +w1(2,3) * xb2
     + +w1(3,3) * xb3
     + +w1(4,3) * xb4
     + +w1(5,3) * xb5
     + +w1(6,3) * xb6
     + +w1(7,3) * xb7
     + +w1(8,3) * xb8
     + +w1(9,3) * xb9
     + +w1(10,3) * xb10
     + +w1(11,3) * xb11
     + +w1(12,3) * xb12
     + +w1(13,3) * xb13
     + +w1(14,3) * xb14
     + +w1(15,3) * xb15) / xrI(3)
C Store the eqpsRate into stateNew variable 1
      stateNew(k,1) = eqpsRate(k)
      end do
C Return from the VUHARD subroutine
      return
      end
