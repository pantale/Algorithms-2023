C **********************************************************************
C Function to compute the ANN : 3Cr2Mo-3-17-9-1-sigmoid yield stress
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
      double precision w1(17, 3)
      data w1/16.9731059409386837D0,
     + -346.9253239496923698D0,
     + 0.9937031575559941D0,
     + 1.0656217651251128D0,
     + -2.4223777895953096D0,
     + -0.1430895778939453D0,
     + -0.2603570422362796D0,
     + -1.3488496650042936D0,
     + -4.6468059898712966D0,
     + -5.771435298917206D0,
     + -8.189570608268502D0,
     + -7.7436106380869996D0,
     + -0.3850973781819365D0,
     + 0.0949142346610041D0,
     + -59.2024112504495506D0,
     + 2.4311397281658906D0,
     + 4.6052615893328994D0,
     + -1.3035655248755977D0,
     + 0.3549381582434802D0,
     + -7.7732912123086466D0,
     + 2.880642286781649D0,
     + -2.4494742610575631D0,
     + 3.9621086089465476D0,
     + -7.3097338410097867D0,
     + -0.1492943021821323D0,
     + 9.0532152181712107D0,
     + 11.1482532957999592D0,
     + -2.6729521833636811D0,
     + 2.3146852339158843D0,
     + 1.2487799461482854D0,
     + -4.9526024812652913D0,
     + 1.2076667345822063D0,
     + -6.6012674525799229D0,
     + 1.1630571428775416D0,
     + 0.5385036992890653D0,
     + -0.0749618990540942D0,
     + -1.8730275324549941D0,
     + -16.6863926692386286D0,
     + -15.6053153987192896D0,
     + -0.3649352284094416D0,
     + 7.0559296116977324D0,
     + -5.8462362626922859D0,
     + -0.6188924718215795D0,
     + 0.7330717288183154D0,
     + -1.6449079875651087D0,
     + -0.9854132670898076D0,
     + 7.1784112491337178D0,
     + 3.2656639814055985D0,
     + -0.774647123526648D0,
     + -16.1589450231135956D0,
     + -1.1513384840158947D0/
      double precision b1(17)
      data b1/0.3780654127405609D0,
     + 0.0927124153909286D0,
     + 4.309885492018946D0,
     + -0.2041021820311402D0,
     + 3.3430485519198156D0,
     + -4.5694292531235634D0,
     + 3.0044583124886466D0,
     + 6.035336624911543D0,
     + -7.1966749113923161D0,
     + -3.9873951159988623D0,
     + 4.4240908011391058D0,
     + 0.9680970647735414D0,
     + -3.6323630600497578D0,
     + 0.769070082328293D0,
     + -1.5008150478879718D0,
     + -0.5806954827127246D0,
     + -4.3436424636175754D0/
      double precision w2(9, 17)
      data w2/2.4533702146817267D0,
     + -3.363867200207447D0,
     + 1.2618584547924125D0,
     + 2.1540174845822135D0,
     + -1.1250949630663427D0,
     + 2.3687120207082302D0,
     + -1.5642621499549363D0,
     + 3.7291769562141965D0,
     + -1.290589440510439D0,
     + 0.7665323911146253D0,
     + 5.4142943390785625D0,
     + -0.8339213284706104D0,
     + -25.2508840850673977D0,
     + 0.2543369410063565D0,
     + 2.0333826044202459D0,
     + -1.0865644631230662D0,
     + 14.3924348567385252D0,
     + 6.1476120075290135D0,
     + -5.9157010371832683D0,
     + 5.782957101292463D0,
     + -0.2273761224134158D0,
     + 6.1072421475294103D0,
     + 0.794148882239152D0,
     + -1.7576518679525943D0,
     + 2.2132037316900872D0,
     + -15.4018268340838898D0,
     + -9.6175007611608088D0,
     + 4.9945254164963071D0,
     + -5.5180294270627401D0,
     + 2.4435489886039745D0,
     + -1.9661380542490134D0,
     + -2.4650533177453786D0,
     + -6.9445294540428657D0,
     + -2.3848333229371037D0,
     + 0.0374241807344831D0,
     + -0.6171534820812157D0,
     + -0.1780750664418911D0,
     + 2.4367280042728487D0,
     + -1.7009666880542944D0,
     + 1.0542945488775357D0,
     + 3.1390264736383195D0,
     + 5.2596811976474944D0,
     + 0.5806413793723928D0,
     + 0.3735731813265796D0,
     + 4.2077292840716503D0,
     + 6.4851377792627209D0,
     + -16.5164436003647381D0,
     + 4.4755554279668237D0,
     + -2.5359486634871726D0,
     + -1.8985345079977045D0,
     + 13.1258874763145919D0,
     + -2.0063097899527658D0,
     + 3.8738038243895185D0,
     + -11.7625082783252122D0,
     + 2.9034727079477114D0,
     + 3.0331333421498732D0,
     + 0.8969880864024918D0,
     + -5.430270267480072D0,
     + 3.3763493250296848D0,
     + -0.2496594076471924D0,
     + 3.4860365474861168D0,
     + -4.6186434251526824D0,
     + 4.9838088251694996D0,
     + 3.0983569512474873D0,
     + 1.5942321247254616D0,
     + 0.3163420451521507D0,
     + 2.7878430634914211D0,
     + -1.8071688727661643D0,
     + 0.6446598193830375D0,
     + 4.0061810578475683D0,
     + -0.3468022220918284D0,
     + 2.9982439654561768D0,
     + -9.1181418131044758D0,
     + -16.8878509003858959D0,
     + -1.0145746516260246D0,
     + 3.951355025112874D0,
     + 0.866975673970631D0,
     + 32.9957477009221947D0,
     + 1.5765972526822469D0,
     + -2.7418220209265551D0,
     + -8.1592285233937307D0,
     + -1.4959517016396064D0,
     + -2.2246130315877495D0,
     + -0.1788794238839337D0,
     + 3.1394611831021129D0,
     + 1.3146798977703213D0,
     + -0.6037855628941096D0,
     + 1.3291778583923233D0,
     + -1.0534222801972881D0,
     + -4.1849776219743351D0,
     + -0.4657276552428103D0,
     + -3.5098421441305607D0,
     + -0.2986791630004673D0,
     + 2.1414182198460141D0,
     + -0.1604831489886638D0,
     + 0.8174395567142967D0,
     + 2.6504869340631578D0,
     + -0.2794280016164938D0,
     + -6.3751445480556752D0,
     + 15.5612741682836742D0,
     + 5.1416713769520408D0,
     + -1.0100916535139173D0,
     + 1.6604233724147375D0,
     + 0.2400017659738273D0,
     + 1.3398353211430623D0,
     + -1.6872441824303186D0,
     + 0.9457002827271567D0,
     + 2.4954910084566064D0,
     + -0.0483081112442605D0,
     + 3.2786378673850041D0,
     + -0.6931980450568977D0,
     + 4.6938582451829038D0,
     + -1.9833403504514937D0,
     + 1.8991046936906595D0,
     + -3.0512827698094886D0,
     + -1.3600125546044448D0,
     + -3.1550543007593306D0,
     + -3.5243945647067623D0,
     + 14.5624383127026125D0,
     + -1.2634717394795882D0,
     + 10.5059212954692001D0,
     + 4.6040057803051448D0,
     + -4.9241109349210452D0,
     + 3.9116093604054889D0,
     + -18.7219518347739147D0,
     + 2.0833447062797013D0,
     + -32.3484993325224792D0,
     + -18.6934850371749803D0,
     + -3.590939910942454D0,
     + -1.9019728988612676D0,
     + 1.7070364055241296D0,
     + 7.4560075995542689D0,
     + 95.8684397889605719D0,
     + -12.487331405483804D0,
     + 8.0541431911413692D0,
     + -4.6185041231833655D0,
     + -10.57582178110132D0,
     + 0.0378726243347158D0,
     + -2.047246021279824D0,
     + -1.0595265080508729D0,
     + -0.4224600000089638D0,
     + -5.3033605966712347D0,
     + -4.6635464972994498D0,
     + -15.3986279212171162D0,
     + -2.915027865375996D0,
     + 2.0786711333218291D0,
     + -0.0416932769336577D0,
     + -0.1622295171191916D0,
     + 0.1399753357056281D0,
     + 1.3619842480542441D0,
     + -0.4424932419763473D0,
     + 0.1197083801300534D0,
     + -0.0049739909817682D0/
      double precision b2(9)
      data b2/-1.9215883556177835D0,
     + -6.3854476311982253D0,
     + -0.0343137854149946D0,
     + 3.2084810654435358D0,
     + -0.0892578576109452D0,
     + 1.1058165797256971D0,
     + 0.2988808289741208D0,
     + -1.1728194143629473D0,
     + -2.7309904331902173D0/
      double precision w3(9)
      data w3/0.0488371510961646D0,
     + -0.0325329031554888D0,
     + 0.424954515972579D0,
     + 0.4506663975320862D0,
     + -0.2091159908041313D0,
     + 0.173792836742944D0,
     + -0.5331002036254233D0,
     + 0.1904421688932253D0,
     + -1.2149414550978641D0/
      double precision b3
      data b3/0.1319608904105405D0/
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
C Hidden layer #1 - (y11 to y117)
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
      y116 = w1(16,1) * xeps
     + +w1(16,2) * xdeps
     + +w1(16,3) * xtemp
     + +b1(16)
      y117 = w1(17,1) * xeps
     + +w1(17,2) * xdeps
     + +w1(17,3) * xtemp
     + +b1(17)
C sigmoid activation function - (yf11 to yf117)
      yf11 = 1/(1 + exp(-y11))
      yf12 = 1/(1 + exp(-y12))
      yf13 = 1/(1 + exp(-y13))
      yf14 = 1/(1 + exp(-y14))
      yf15 = 1/(1 + exp(-y15))
      yf16 = 1/(1 + exp(-y16))
      yf17 = 1/(1 + exp(-y17))
      yf18 = 1/(1 + exp(-y18))
      yf19 = 1/(1 + exp(-y19))
      yf110 = 1/(1 + exp(-y110))
      yf111 = 1/(1 + exp(-y111))
      yf112 = 1/(1 + exp(-y112))
      yf113 = 1/(1 + exp(-y113))
      yf114 = 1/(1 + exp(-y114))
      yf115 = 1/(1 + exp(-y115))
      yf116 = 1/(1 + exp(-y116))
      yf117 = 1/(1 + exp(-y117))
C Hidden layer #2 - (y21 to y29)
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
     + +w2(1,16) * yf116
     + +w2(1,17) * yf117
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
     + +w2(2,16) * yf116
     + +w2(2,17) * yf117
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
     + +w2(3,16) * yf116
     + +w2(3,17) * yf117
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
     + +w2(4,16) * yf116
     + +w2(4,17) * yf117
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
     + +w2(5,16) * yf116
     + +w2(5,17) * yf117
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
     + +w2(6,16) * yf116
     + +w2(6,17) * yf117
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
     + +w2(7,16) * yf116
     + +w2(7,17) * yf117
     + +b2(7)
      y28 = w2(8,1) * yf11
     + +w2(8,2) * yf12
     + +w2(8,3) * yf13
     + +w2(8,4) * yf14
     + +w2(8,5) * yf15
     + +w2(8,6) * yf16
     + +w2(8,7) * yf17
     + +w2(8,8) * yf18
     + +w2(8,9) * yf19
     + +w2(8,10) * yf110
     + +w2(8,11) * yf111
     + +w2(8,12) * yf112
     + +w2(8,13) * yf113
     + +w2(8,14) * yf114
     + +w2(8,15) * yf115
     + +w2(8,16) * yf116
     + +w2(8,17) * yf117
     + +b2(8)
      y29 = w2(9,1) * yf11
     + +w2(9,2) * yf12
     + +w2(9,3) * yf13
     + +w2(9,4) * yf14
     + +w2(9,5) * yf15
     + +w2(9,6) * yf16
     + +w2(9,7) * yf17
     + +w2(9,8) * yf18
     + +w2(9,9) * yf19
     + +w2(9,10) * yf110
     + +w2(9,11) * yf111
     + +w2(9,12) * yf112
     + +w2(9,13) * yf113
     + +w2(9,14) * yf114
     + +w2(9,15) * yf115
     + +w2(9,16) * yf116
     + +w2(9,17) * yf117
     + +b2(9)
C sigmoid activation function - (yf21 to yf29)
      yf21 = 1/(1 + exp(-y21))
      yf22 = 1/(1 + exp(-y22))
      yf23 = 1/(1 + exp(-y23))
      yf24 = 1/(1 + exp(-y24))
      yf25 = 1/(1 + exp(-y25))
      yf26 = 1/(1 + exp(-y26))
      yf27 = 1/(1 + exp(-y27))
      yf28 = 1/(1 + exp(-y28))
      yf29 = 1/(1 + exp(-y29))
C Derivatives terms - (xa1 to xa9) and (xb1 to xb17)
      xa1 = w3(1) * (yf21*(1 - yf21))
      xa2 = w3(2) * (yf22*(1 - yf22))
      xa3 = w3(3) * (yf23*(1 - yf23))
      xa4 = w3(4) * (yf24*(1 - yf24))
      xa5 = w3(5) * (yf25*(1 - yf25))
      xa6 = w3(6) * (yf26*(1 - yf26))
      xa7 = w3(7) * (yf27*(1 - yf27))
      xa8 = w3(8) * (yf28*(1 - yf28))
      xa9 = w3(9) * (yf29*(1 - yf29))
      xb1 = (w2(1,1) * xa1
     + +w2(2,1) * xa2
     + +w2(3,1) * xa3
     + +w2(4,1) * xa4
     + +w2(5,1) * xa5
     + +w2(6,1) * xa6
     + +w2(7,1) * xa7
     + +w2(8,1) * xa8
     + +w2(9,1) * xa9)
     + * (yf11*(1 - yf11))
      xb2 = (w2(1,2) * xa1
     + +w2(2,2) * xa2
     + +w2(3,2) * xa3
     + +w2(4,2) * xa4
     + +w2(5,2) * xa5
     + +w2(6,2) * xa6
     + +w2(7,2) * xa7
     + +w2(8,2) * xa8
     + +w2(9,2) * xa9)
     + * (yf12*(1 - yf12))
      xb3 = (w2(1,3) * xa1
     + +w2(2,3) * xa2
     + +w2(3,3) * xa3
     + +w2(4,3) * xa4
     + +w2(5,3) * xa5
     + +w2(6,3) * xa6
     + +w2(7,3) * xa7
     + +w2(8,3) * xa8
     + +w2(9,3) * xa9)
     + * (yf13*(1 - yf13))
      xb4 = (w2(1,4) * xa1
     + +w2(2,4) * xa2
     + +w2(3,4) * xa3
     + +w2(4,4) * xa4
     + +w2(5,4) * xa5
     + +w2(6,4) * xa6
     + +w2(7,4) * xa7
     + +w2(8,4) * xa8
     + +w2(9,4) * xa9)
     + * (yf14*(1 - yf14))
      xb5 = (w2(1,5) * xa1
     + +w2(2,5) * xa2
     + +w2(3,5) * xa3
     + +w2(4,5) * xa4
     + +w2(5,5) * xa5
     + +w2(6,5) * xa6
     + +w2(7,5) * xa7
     + +w2(8,5) * xa8
     + +w2(9,5) * xa9)
     + * (yf15*(1 - yf15))
      xb6 = (w2(1,6) * xa1
     + +w2(2,6) * xa2
     + +w2(3,6) * xa3
     + +w2(4,6) * xa4
     + +w2(5,6) * xa5
     + +w2(6,6) * xa6
     + +w2(7,6) * xa7
     + +w2(8,6) * xa8
     + +w2(9,6) * xa9)
     + * (yf16*(1 - yf16))
      xb7 = (w2(1,7) * xa1
     + +w2(2,7) * xa2
     + +w2(3,7) * xa3
     + +w2(4,7) * xa4
     + +w2(5,7) * xa5
     + +w2(6,7) * xa6
     + +w2(7,7) * xa7
     + +w2(8,7) * xa8
     + +w2(9,7) * xa9)
     + * (yf17*(1 - yf17))
      xb8 = (w2(1,8) * xa1
     + +w2(2,8) * xa2
     + +w2(3,8) * xa3
     + +w2(4,8) * xa4
     + +w2(5,8) * xa5
     + +w2(6,8) * xa6
     + +w2(7,8) * xa7
     + +w2(8,8) * xa8
     + +w2(9,8) * xa9)
     + * (yf18*(1 - yf18))
      xb9 = (w2(1,9) * xa1
     + +w2(2,9) * xa2
     + +w2(3,9) * xa3
     + +w2(4,9) * xa4
     + +w2(5,9) * xa5
     + +w2(6,9) * xa6
     + +w2(7,9) * xa7
     + +w2(8,9) * xa8
     + +w2(9,9) * xa9)
     + * (yf19*(1 - yf19))
      xb10 = (w2(1,10) * xa1
     + +w2(2,10) * xa2
     + +w2(3,10) * xa3
     + +w2(4,10) * xa4
     + +w2(5,10) * xa5
     + +w2(6,10) * xa6
     + +w2(7,10) * xa7
     + +w2(8,10) * xa8
     + +w2(9,10) * xa9)
     + * (yf110*(1 - yf110))
      xb11 = (w2(1,11) * xa1
     + +w2(2,11) * xa2
     + +w2(3,11) * xa3
     + +w2(4,11) * xa4
     + +w2(5,11) * xa5
     + +w2(6,11) * xa6
     + +w2(7,11) * xa7
     + +w2(8,11) * xa8
     + +w2(9,11) * xa9)
     + * (yf111*(1 - yf111))
      xb12 = (w2(1,12) * xa1
     + +w2(2,12) * xa2
     + +w2(3,12) * xa3
     + +w2(4,12) * xa4
     + +w2(5,12) * xa5
     + +w2(6,12) * xa6
     + +w2(7,12) * xa7
     + +w2(8,12) * xa8
     + +w2(9,12) * xa9)
     + * (yf112*(1 - yf112))
      xb13 = (w2(1,13) * xa1
     + +w2(2,13) * xa2
     + +w2(3,13) * xa3
     + +w2(4,13) * xa4
     + +w2(5,13) * xa5
     + +w2(6,13) * xa6
     + +w2(7,13) * xa7
     + +w2(8,13) * xa8
     + +w2(9,13) * xa9)
     + * (yf113*(1 - yf113))
      xb14 = (w2(1,14) * xa1
     + +w2(2,14) * xa2
     + +w2(3,14) * xa3
     + +w2(4,14) * xa4
     + +w2(5,14) * xa5
     + +w2(6,14) * xa6
     + +w2(7,14) * xa7
     + +w2(8,14) * xa8
     + +w2(9,14) * xa9)
     + * (yf114*(1 - yf114))
      xb15 = (w2(1,15) * xa1
     + +w2(2,15) * xa2
     + +w2(3,15) * xa3
     + +w2(4,15) * xa4
     + +w2(5,15) * xa5
     + +w2(6,15) * xa6
     + +w2(7,15) * xa7
     + +w2(8,15) * xa8
     + +w2(9,15) * xa9)
     + * (yf115*(1 - yf115))
      xb16 = (w2(1,16) * xa1
     + +w2(2,16) * xa2
     + +w2(3,16) * xa3
     + +w2(4,16) * xa4
     + +w2(5,16) * xa5
     + +w2(6,16) * xa6
     + +w2(7,16) * xa7
     + +w2(8,16) * xa8
     + +w2(9,16) * xa9)
     + * (yf116*(1 - yf116))
      xb17 = (w2(1,17) * xa1
     + +w2(2,17) * xa2
     + +w2(3,17) * xa3
     + +w2(4,17) * xa4
     + +w2(5,17) * xa5
     + +w2(6,17) * xa6
     + +w2(7,17) * xa7
     + +w2(8,17) * xa8
     + +w2(9,17) * xa9)
     + * (yf117*(1 - yf117))
C Outputs of the subroutine
      Yield(k) = xrO * (w3(1) * yf21
     + +w3(2) * yf22
     + +w3(3) * yf23
     + +w3(4) * yf24
     + +w3(5) * yf25
     + +w3(6) * yf26
     + +w3(7) * yf27
     + +w3(8) * yf28
     + +w3(9) * yf29
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
     + +w1(15,1) * xb15
     + +w1(16,1) * xb16
     + +w1(17,1) * xb17) / xrI(1)
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
     + +w1(15,2) * xb15
     + +w1(16,2) * xb16
     + +w1(17,2) * xb17)
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
     + +w1(15,3) * xb15
     + +w1(16,3) * xb16
     + +w1(17,3) * xb17) / xrI(3)
C Store the eqpsRate into stateNew variable 1
      stateNew(k,1) = eqpsRate(k)
      end do
C Return from the VUHARD subroutine
      return
      end
