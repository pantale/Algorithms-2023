C **********************************************************************
C Function to compute the ANN : 3Cr2Mo-3-17-9-1-relu yield stress
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
      data w1/5.258655175305222D0,
     + -0.0522093678914692D0,
     + -0.210498041851396D0,
     + -0.1269899115015554D0,
     + 1.2316623794587458D0,
     + 0.3612506296697156D0,
     + 0.4989868469358664D0,
     + 0.0443199140856362D0,
     + -0.4476251151389774D0,
     + -3.1716580493474469D0,
     + 0.9899227808032492D0,
     + -0.0965874619501256D0,
     + 0.1498030893049674D0,
     + -0.9094787166098189D0,
     + -0.0110829525078706D0,
     + 5.3601371563407012D0,
     + 2.838079977154921D0,
     + -0.085426449516012D0,
     + -0.162720176312019D0,
     + -0.1889927796221446D0,
     + -0.4334839656729802D0,
     + 2.1224548020317324D0,
     + 0.827961273603034D0,
     + 0.6712229552276112D0,
     + -0.8774777014866284D0,
     + 0.0369065344098112D0,
     + 0.8065711698883496D0,
     + 2.2068284341197244D0,
     + 2.1621041947762278D0,
     + 0.9037574996548342D0,
     + -0.397413363262251D0,
     + 1.1894893043155725D0,
     + 0.0934412439055765D0,
     + -0.2057171688056703D0,
     + 0.0578856885260899D0,
     + -0.4408750379468522D0,
     + -0.0936384643147123D0,
     + 0.0033132117243451D0,
     + 0.0471827028772131D0,
     + -0.6075515769631388D0,
     + 0.2400233052436276D0,
     + 1.2931903271407972D0,
     + -0.0583477462172922D0,
     + -0.3293091756387495D0,
     + 0.0919505978442718D0,
     + 0.6406204649695635D0,
     + -2.2946305249367138D0,
     + 0.8206397916041256D0,
     + 1.1062778092461554D0,
     + 0.0478177219523141D0,
     + 0.0936871873016676D0/
      double precision b1(17)
      data b1/-0.0395753543589466D0,
     + 0D0,
     + 0D0,
     + -0.0051647749560383D0,
     + -1.8032688613160337D0,
     + -0.1282242192241898D0,
     + -0.2082514579955312D0,
     + 0.512629737100642D0,
     + -0.0372574328379199D0,
     + 0.5993766384318472D0,
     + -1.4962436294486556D0,
     + -1.9105681934580716D0,
     + -0.359612901390421D0,
     + 0.2215980720422522D0,
     + -1.0555035273902285D0,
     + -0.0114579485077583D0,
     + -0.1047893975108564D0/
      double precision w2(9, 17)
      data w2/-1.5744403569309973D0,
     + -2.542423598975851D0,
     + 3.0608781303240757D0,
     + -2.4261046013608594D0,
     + -1.704314328832059D0,
     + -3.054004950202188D0,
     + -2.1836852375277607D0,
     + -1.9019032621629377D0,
     + -2.5817445237356607D0,
     + -0.0782393523529893D0,
     + 0.0827471258645684D0,
     + -0.1485209830069187D0,
     + -0.079427699161932D0,
     + 0.4368893435162808D0,
     + -0.4510704720271486D0,
     + 0.386423667523958D0,
     + -0.0477964642496819D0,
     + -0.4438058151042935D0,
     + 0.4344013391155596D0,
     + -0.0992885953262586D0,
     + 0.0412502542949465D0,
     + 0.3467152288422955D0,
     + -0.1730988130733634D0,
     + -0.236661464249863D0,
     + -0.0329766976903687D0,
     + 0.2258960901029928D0,
     + -0.1566505478987528D0,
     + -0.0978625671253835D0,
     + 0.3473043315779903D0,
     + 0.0169111053504809D0,
     + 0.4165836429703668D0,
     + 0.0360467163041232D0,
     + -0.4392669627664378D0,
     + -0.0254278246806638D0,
     + -0.1886153142987096D0,
     + -0.1334422529130432D0,
     + -0.6539088044004231D0,
     + 0.5989377922629371D0,
     + -0.4808544768310969D0,
     + -0.44430605430513D0,
     + -1.1331174841241842D0,
     + -0.3089395153074347D0,
     + 0.734639807031693D0,
     + -0.2238659280882549D0,
     + -1.2824443198288715D0,
     + 0.9612703690012774D0,
     + -0.7060258729705651D0,
     + 0.6728644442264228D0,
     + -1.2767825685184258D0,
     + 1.0623570172946022D0,
     + -0.2604249976995445D0,
     + 0.6751624256561591D0,
     + -0.1139132966702407D0,
     + 0.1741537343533485D0,
     + 0.3220896156978446D0,
     + -0.3979876051325192D0,
     + 0.2817121005393026D0,
     + 0.4107531058194197D0,
     + -0.7904825501660744D0,
     + 0.3127142679023295D0,
     + 0.8544530089108749D0,
     + 0.4512600630873071D0,
     + -0.5153095874156164D0,
     + -0.8146095895359314D0,
     + -1.8915682111074255D0,
     + 0.6230939699618052D0,
     + -0.9746421351617581D0,
     + -0.0871780244424087D0,
     + 0.3442911424464008D0,
     + 0.2026978056570712D0,
     + -0.5207164674359219D0,
     + 0.0193778779448099D0,
     + 0.4078257565686187D0,
     + 0.4115352440071718D0,
     + -0.3907078352059419D0,
     + 0.4510494783211639D0,
     + -0.4409299035802012D0,
     + -0.0084318295700675D0,
     + -0.2581627282633187D0,
     + 0.1841230209192606D0,
     + 0.0083369537417093D0,
     + -0.2517394645572361D0,
     + -0.2431598694414238D0,
     + 1.2213409321970994D0,
     + -0.7006765604438981D0,
     + 0.1871442433065744D0,
     + 0.6613137329046646D0,
     + -0.0121273105705727D0,
     + -0.7255741250283713D0,
     + 0.2259764110705384D0,
     + 1.2069626873912327D0,
     + -0.4894879065524915D0,
     + -0.0193802218130378D0,
     + 0.873170249230837D0,
     + -1.7010286994662172D0,
     + -0.4523050320953331D0,
     + 1.2354007394600317D0,
     + -0.1376375795104587D0,
     + 0.8117196674281666D0,
     + 0.7757848312612269D0,
     + 1.8081965055491362D0,
     + 0.1651887076571291D0,
     + -0.8915542003092944D0,
     + 1.7046210755513425D0,
     + -0.4286027620894425D0,
     + -0.4514335427673082D0,
     + 0.5061265106237884D0,
     + -1.5576991242542271D0,
     + -1.6778712551381469D0,
     + 0.4198241413141365D0,
     + -0.0562531048488274D0,
     + 0.8683863189796678D0,
     + -0.3916122028676461D0,
     + 0.0160100743317D0,
     + 0.8658381335263761D0,
     + 0.1446327084719884D0,
     + -0.1442683674957679D0,
     + 0.5932758478275639D0,
     + 1.3326929180459366D0,
     + -0.8316321594296542D0,
     + 0.3278310503710491D0,
     + -0.2480342019839912D0,
     + 2.4067044254827121D0,
     + -0.6785226792963792D0,
     + 0.0481236070544406D0,
     + 0.3288032448582742D0,
     + -1.5387497109625881D0,
     + -1.5920573780260832D0,
     + 0.1141249099900479D0,
     + 0.142541121376231D0,
     + 0.2145694122744971D0,
     + -1.3039036906822006D0,
     + -0.6672482675985395D0,
     + -0.1178321669835862D0,
     + 0.9029616150116642D0,
     + 1.8421172068978684D0,
     + 2.690420589370027D0,
     + -3.5287870423559418D0,
     + 2.9312341682152798D0,
     + 1.8710349864834537D0,
     + 3.2153797922538296D0,
     + 1.9370773135888382D0,
     + 2.3814346363513912D0,
     + 3.2614170646815683D0,
     + -0.8046105106985035D0,
     + -0.0885809283234719D0,
     + 1.2693280276902608D0,
     + -1.371482580777341D0,
     + 0.4767722989280138D0,
     + -0.0239806583619202D0,
     + 0.1425841041535685D0,
     + -1.289048020346675D0,
     + -1.3451709428836436D0/
      double precision b2(9)
      data b2/0.0760486817752893D0,
     + 0.6925029928142167D0,
     + -0.334768335024903D0,
     + 1.022836273590185D0,
     + 0.3215069731363753D0,
     + -2.671165890726908D0,
     + 0.1218331819915055D0,
     + 0.8419003815489131D0,
     + -0.2876034909987974D0/
      double precision w3(9)
      data w3/0.0520304808152807D0,
     + 0.0482852568259366D0,
     + -0.1374929925402678D0,
     + 0.0724500777332212D0,
     + 0.0867899430450476D0,
     + -0.0503201037551655D0,
     + 0.1282711182903154D0,
     + 0.0629968582665895D0,
     + 0.0529556445434919D0/
      double precision b3
      data b3/0.0900422584958332D0/
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
C relu activation function - (yf11 to yf117)
      yf11 = (dmax1(0.0D0,y11))
      yf12 = (dmax1(0.0D0,y12))
      yf13 = (dmax1(0.0D0,y13))
      yf14 = (dmax1(0.0D0,y14))
      yf15 = (dmax1(0.0D0,y15))
      yf16 = (dmax1(0.0D0,y16))
      yf17 = (dmax1(0.0D0,y17))
      yf18 = (dmax1(0.0D0,y18))
      yf19 = (dmax1(0.0D0,y19))
      yf110 = (dmax1(0.0D0,y110))
      yf111 = (dmax1(0.0D0,y111))
      yf112 = (dmax1(0.0D0,y112))
      yf113 = (dmax1(0.0D0,y113))
      yf114 = (dmax1(0.0D0,y114))
      yf115 = (dmax1(0.0D0,y115))
      yf116 = (dmax1(0.0D0,y116))
      yf117 = (dmax1(0.0D0,y117))
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
C relu activation function - (yf21 to yf29)
      yf21 = (dmax1(0.0D0,y21))
      yf22 = (dmax1(0.0D0,y22))
      yf23 = (dmax1(0.0D0,y23))
      yf24 = (dmax1(0.0D0,y24))
      yf25 = (dmax1(0.0D0,y25))
      yf26 = (dmax1(0.0D0,y26))
      yf27 = (dmax1(0.0D0,y27))
      yf28 = (dmax1(0.0D0,y28))
      yf29 = (dmax1(0.0D0,y29))
C Derivatives terms - (xa1 to xa9) and (xb1 to xb17)
      xa1 = w3(1) * dmax1(0.0D0,sign(1.0D0,y21))
      xa2 = w3(2) * dmax1(0.0D0,sign(1.0D0,y22))
      xa3 = w3(3) * dmax1(0.0D0,sign(1.0D0,y23))
      xa4 = w3(4) * dmax1(0.0D0,sign(1.0D0,y24))
      xa5 = w3(5) * dmax1(0.0D0,sign(1.0D0,y25))
      xa6 = w3(6) * dmax1(0.0D0,sign(1.0D0,y26))
      xa7 = w3(7) * dmax1(0.0D0,sign(1.0D0,y27))
      xa8 = w3(8) * dmax1(0.0D0,sign(1.0D0,y28))
      xa9 = w3(9) * dmax1(0.0D0,sign(1.0D0,y29))
      xb1 = (w2(1,1) * xa1
     + +w2(2,1) * xa2
     + +w2(3,1) * xa3
     + +w2(4,1) * xa4
     + +w2(5,1) * xa5
     + +w2(6,1) * xa6
     + +w2(7,1) * xa7
     + +w2(8,1) * xa8
     + +w2(9,1) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y11))
      xb2 = (w2(1,2) * xa1
     + +w2(2,2) * xa2
     + +w2(3,2) * xa3
     + +w2(4,2) * xa4
     + +w2(5,2) * xa5
     + +w2(6,2) * xa6
     + +w2(7,2) * xa7
     + +w2(8,2) * xa8
     + +w2(9,2) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y12))
      xb3 = (w2(1,3) * xa1
     + +w2(2,3) * xa2
     + +w2(3,3) * xa3
     + +w2(4,3) * xa4
     + +w2(5,3) * xa5
     + +w2(6,3) * xa6
     + +w2(7,3) * xa7
     + +w2(8,3) * xa8
     + +w2(9,3) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y13))
      xb4 = (w2(1,4) * xa1
     + +w2(2,4) * xa2
     + +w2(3,4) * xa3
     + +w2(4,4) * xa4
     + +w2(5,4) * xa5
     + +w2(6,4) * xa6
     + +w2(7,4) * xa7
     + +w2(8,4) * xa8
     + +w2(9,4) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y14))
      xb5 = (w2(1,5) * xa1
     + +w2(2,5) * xa2
     + +w2(3,5) * xa3
     + +w2(4,5) * xa4
     + +w2(5,5) * xa5
     + +w2(6,5) * xa6
     + +w2(7,5) * xa7
     + +w2(8,5) * xa8
     + +w2(9,5) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y15))
      xb6 = (w2(1,6) * xa1
     + +w2(2,6) * xa2
     + +w2(3,6) * xa3
     + +w2(4,6) * xa4
     + +w2(5,6) * xa5
     + +w2(6,6) * xa6
     + +w2(7,6) * xa7
     + +w2(8,6) * xa8
     + +w2(9,6) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y16))
      xb7 = (w2(1,7) * xa1
     + +w2(2,7) * xa2
     + +w2(3,7) * xa3
     + +w2(4,7) * xa4
     + +w2(5,7) * xa5
     + +w2(6,7) * xa6
     + +w2(7,7) * xa7
     + +w2(8,7) * xa8
     + +w2(9,7) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y17))
      xb8 = (w2(1,8) * xa1
     + +w2(2,8) * xa2
     + +w2(3,8) * xa3
     + +w2(4,8) * xa4
     + +w2(5,8) * xa5
     + +w2(6,8) * xa6
     + +w2(7,8) * xa7
     + +w2(8,8) * xa8
     + +w2(9,8) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y18))
      xb9 = (w2(1,9) * xa1
     + +w2(2,9) * xa2
     + +w2(3,9) * xa3
     + +w2(4,9) * xa4
     + +w2(5,9) * xa5
     + +w2(6,9) * xa6
     + +w2(7,9) * xa7
     + +w2(8,9) * xa8
     + +w2(9,9) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y19))
      xb10 = (w2(1,10) * xa1
     + +w2(2,10) * xa2
     + +w2(3,10) * xa3
     + +w2(4,10) * xa4
     + +w2(5,10) * xa5
     + +w2(6,10) * xa6
     + +w2(7,10) * xa7
     + +w2(8,10) * xa8
     + +w2(9,10) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y110))
      xb11 = (w2(1,11) * xa1
     + +w2(2,11) * xa2
     + +w2(3,11) * xa3
     + +w2(4,11) * xa4
     + +w2(5,11) * xa5
     + +w2(6,11) * xa6
     + +w2(7,11) * xa7
     + +w2(8,11) * xa8
     + +w2(9,11) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y111))
      xb12 = (w2(1,12) * xa1
     + +w2(2,12) * xa2
     + +w2(3,12) * xa3
     + +w2(4,12) * xa4
     + +w2(5,12) * xa5
     + +w2(6,12) * xa6
     + +w2(7,12) * xa7
     + +w2(8,12) * xa8
     + +w2(9,12) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y112))
      xb13 = (w2(1,13) * xa1
     + +w2(2,13) * xa2
     + +w2(3,13) * xa3
     + +w2(4,13) * xa4
     + +w2(5,13) * xa5
     + +w2(6,13) * xa6
     + +w2(7,13) * xa7
     + +w2(8,13) * xa8
     + +w2(9,13) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y113))
      xb14 = (w2(1,14) * xa1
     + +w2(2,14) * xa2
     + +w2(3,14) * xa3
     + +w2(4,14) * xa4
     + +w2(5,14) * xa5
     + +w2(6,14) * xa6
     + +w2(7,14) * xa7
     + +w2(8,14) * xa8
     + +w2(9,14) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y114))
      xb15 = (w2(1,15) * xa1
     + +w2(2,15) * xa2
     + +w2(3,15) * xa3
     + +w2(4,15) * xa4
     + +w2(5,15) * xa5
     + +w2(6,15) * xa6
     + +w2(7,15) * xa7
     + +w2(8,15) * xa8
     + +w2(9,15) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y115))
      xb16 = (w2(1,16) * xa1
     + +w2(2,16) * xa2
     + +w2(3,16) * xa3
     + +w2(4,16) * xa4
     + +w2(5,16) * xa5
     + +w2(6,16) * xa6
     + +w2(7,16) * xa7
     + +w2(8,16) * xa8
     + +w2(9,16) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y116))
      xb17 = (w2(1,17) * xa1
     + +w2(2,17) * xa2
     + +w2(3,17) * xa3
     + +w2(4,17) * xa4
     + +w2(5,17) * xa5
     + +w2(6,17) * xa6
     + +w2(7,17) * xa7
     + +w2(8,17) * xa8
     + +w2(9,17) * xa9)
     + * dmax1(0.0D0,sign(1.0D0,y117))
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
      dyieldDeqps(k,1) = xrO * (w1(1,2) * xb1
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
