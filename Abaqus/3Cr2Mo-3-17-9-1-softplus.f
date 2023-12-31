C **********************************************************************
C Function to compute the ANN : 3Cr2Mo-3-17-9-1-softplus yield stress
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
      data w1/2.7648336438112913D0,
     + -1.1681761875792764D0,
     + 0.453237999286521D0,
     + -1.6513806452647275D0,
     + -16.9958036821612062D0,
     + 1.542644061800122D0,
     + 4.5866677387407879D0,
     + -2.2453615295858342D0,
     + -353.983893682418568D0,
     + -77.1688596728256897D0,
     + -3.2372071046981219D0,
     + -1.0807596161905622D0,
     + -34.1631464004557941D0,
     + -6.6989850582264179D0,
     + 1.0300548482043541D0,
     + 0.561132635624297D0,
     + 1.7565355451169677D0,
     + -13.2412900384100745D0,
     + -7.6987684169455735D0,
     + 2.8351184142545489D0,
     + 0.2295531804917861D0,
     + -0.1483517933783803D0,
     + 4.6422874037672379D0,
     + -3.2913319114029509D0,
     + -4.8978845722275191D0,
     + 0.9002593795998548D0,
     + -2.5166921864137608D0,
     + -2.9015179702244804D0,
     + -1.6867239966096406D0,
     + -26.4068493710922816D0,
     + 0.7729808500072894D0,
     + -6.2153368659397126D0,
     + 8.2095815962758216D0,
     + -2.9859909844064108D0,
     + 3.7511275832898372D0,
     + 1.9703176437633836D0,
     + -4.3710369250378207D0,
     + -6.6175377413103309D0,
     + 0.2113714884172458D0,
     + -7.5490115210994082D0,
     + -0.2530885739251452D0,
     + -26.3021711145922978D0,
     + -2.1060024647102615D0,
     + 0.6655651832927629D0,
     + 0.3895046509366751D0,
     + 2.8907758846304983D0,
     + 12.9882742214885756D0,
     + -0.7777762651722071D0,
     + 1.0843979587936605D0,
     + 0.9024045000039889D0,
     + -5.7016387526942278D0/
      double precision b1(17)
      data b1/0.5129697772187605D0,
     + 1.9032247051125677D0,
     + -1.2795262408637604D0,
     + -0.5040702117536089D0,
     + -1.1747177177309707D0,
     + -6.2120068426825252D0,
     + -3.9764429133256587D0,
     + 2.6294333404177226D0,
     + 0.1864351981958061D0,
     + 0.4283370124989845D0,
     + 0.378760584996696D0,
     + -1.2940280729678331D0,
     + -3.374314262440802D0,
     + -0.0523678635009061D0,
     + 2.7753261561186973D0,
     + -9.8233338968173474D0,
     + -2.0588175337535977D0/
      double precision w2(9, 17)
      data w2/-1.9701871456699138D0,
     + 4.7873899295765332D0,
     + 14.1565614619117799D0,
     + -0.2549410898793397D0,
     + 1.230848360106847D0,
     + -27.5878106896138107D0,
     + -0.2220156934305088D0,
     + -19.3413327059585036D0,
     + -1.2061531879364851D0,
     + 1.2211808194197651D0,
     + -10.8374653318077527D0,
     + -13.2842575608175348D0,
     + 2.7318260599983772D0,
     + 0.0350586362041979D0,
     + 12.3458839042932329D0,
     + 0.2224851772615266D0,
     + -9.1398593049819201D0,
     + 0.9086225939939199D0,
     + 4.4809603780090415D0,
     + -1.5713738189013839D0,
     + -0.9887126554575907D0,
     + -0.6424256960156706D0,
     + -4.9755901126874198D0,
     + 0.7049991204263385D0,
     + 0.5953824539320582D0,
     + -0.5720361490820814D0,
     + -1.7043961687108011D0,
     + -11.5344731651805468D0,
     + -9.9716953271003543D0,
     + 1.7174219260721857D0,
     + 3.2975436243479068D0,
     + -1.8139264359513874D0,
     + -0.3133691323851742D0,
     + -0.4430659946671474D0,
     + -5.5956532071118774D0,
     + 2.0373454421676005D0,
     + -19.8946450772514787D0,
     + 1.6408697838422412D0,
     + 2.7929798243509798D0,
     + -3.264059320671115D0,
     + -1.7409908629618929D0,
     + 7.0143940629797106D0,
     + -2.5493568089105016D0,
     + -51.7497424260078986D0,
     + -7.6338321616385159D0,
     + -8.7392398557115687D0,
     + -24.5890255078949203D0,
     + 0.5539709218192403D0,
     + -28.6251219794419001D0,
     + 4.0953218311581487D0,
     + -1.8839028101371882D0,
     + -0.4872057661545129D0,
     + 1.8288429776746444D0,
     + 6.7499305826673526D0,
     + 1.8588888630290479D0,
     + 3.3472421956762011D0,
     + 9.1121962650027317D0,
     + -2.0275687072519966D0,
     + 0.4410558745653944D0,
     + -0.2897989887524476D0,
     + 0.4497319413920762D0,
     + -0.7337975984596827D0,
     + -10.6775171537988776D0,
     + 0.7870996395357088D0,
     + 9.5006578324009965D0,
     + 1.8008149032460914D0,
     + -0.4048529855694332D0,
     + 0.977001536798198D0,
     + -0.0016691630016198D0,
     + 0.0851297260593889D0,
     + 2.8603298055635005D0,
     + -0.6396757153568008D0,
     + -0.4990227986593547D0,
     + 8.9911420350558D0,
     + 1.3809021632268004D0,
     + 0.5331152273316401D0,
     + 10.899243738937237D0,
     + -1.5521380589300788D0,
     + -0.4124249855661616D0,
     + -1.1372819543041501D0,
     + -87.3511313825842279D0,
     + 11.5646637329267197D0,
     + -9.1742407905800611D0,
     + -12.9843695173496485D0,
     + -2.4130328332774296D0,
     + -1.280023657235521D0,
     + 12.5368343639666975D0,
     + -0.8091576233028751D0,
     + -8.8112646025987189D0,
     + -1.9014889535458395D0,
     + 1.8247642767598919D0,
     + -7.3133435670555267D0,
     + 3.9316052728105806D0,
     + -4.985384372589043D0,
     + -0.3274982490106317D0,
     + -4.298977497849882D0,
     + -0.3609781875335204D0,
     + 8.3931992711561456D0,
     + 7.7942641194091475D0,
     + 0.4026457062433961D0,
     + 2.4702584908463456D0,
     + -4.5841683955686143D0,
     + 1.1920304751327453D0,
     + 2.0089940708314056D0,
     + -3.2063263034472693D0,
     + -0.9566110133482829D0,
     + -13.2290667252372245D0,
     + -0.2254338507114395D0,
     + -1.4312293366119875D0,
     + 4.5982687255060677D0,
     + -3.293091222873449D0,
     + -0.0322594132798116D0,
     + 0.3151078579936495D0,
     + -11.1872753512693155D0,
     + -0.1687939783455375D0,
     + -27.5803829248950656D0,
     + 0.2022159263654054D0,
     + -8.7917035833911665D0,
     + -3.4748115635817016D0,
     + -2.925890601656262D0,
     + 0.7286633975022795D0,
     + -2.3166903425456167D0,
     + 0.0617351907253539D0,
     + -0.183746146665372D0,
     + -2.3684642734935037D0,
     + -13.6553112612347007D0,
     + 1.0443285515747041D0,
     + -3.7692281818205937D0,
     + -14.8506958322726401D0,
     + -2.7240800969045726D0,
     + -2.1196359015360176D0,
     + -6.932237339606349D0,
     + -0.2807436160964534D0,
     + 1.1694135924000673D0,
     + -0.9106538927097906D0,
     + -48.3093617044577925D0,
     + -1.7071547260895887D0,
     + -5.6298075159773475D0,
     + -9.8661968039839643D0,
     + 3.8120970186164311D0,
     + 0.7132637724359393D0,
     + 1.045776911941894D0,
     + -1.571082286146342D0,
     + -15.8329498582125439D0,
     + -4.8697448594566053D0,
     + -5.0193233045898866D0,
     + 1.3661805242870295D0,
     + 13.347388693724497D0,
     + -4.7270565919821017D0,
     + 6.1332815287917386D0,
     + -0.193554862870682D0,
     + -0.9193635005294215D0,
     + 7.6239180197712031D0/
      double precision b2(9)
      data b2/-7.0127856808544875D0,
     + -2.2826060737957148D0,
     + -0.2814808668008165D0,
     + -2.3572456238879358D0,
     + -3.8544966226434081D0,
     + -5.9923309410692012D0,
     + -0.6673935083348588D0,
     + -2.2255295940708089D0,
     + -2.8404027563142584D0/
      double precision w3(9)
      data w3/-1.5080392986574875D0,
     + 2.4247363381783393D0,
     + 3.4736589635145392D0,
     + 2.0596420972284131D0,
     + -0.432224443942299D0,
     + -2.2534627277702057D0,
     + 0.8300255618539516D0,
     + 2.5885651413469062D0,
     + 2.6465533488412119D0/
      double precision b3
      data b3/0.0722469121899067D0/
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
C softplus activation function - (yf11 to yf117)
      yf11 = log(1 + exp(y11))
      yf12 = log(1 + exp(y12))
      yf13 = log(1 + exp(y13))
      yf14 = log(1 + exp(y14))
      yf15 = log(1 + exp(y15))
      yf16 = log(1 + exp(y16))
      yf17 = log(1 + exp(y17))
      yf18 = log(1 + exp(y18))
      yf19 = log(1 + exp(y19))
      yf110 = log(1 + exp(y110))
      yf111 = log(1 + exp(y111))
      yf112 = log(1 + exp(y112))
      yf113 = log(1 + exp(y113))
      yf114 = log(1 + exp(y114))
      yf115 = log(1 + exp(y115))
      yf116 = log(1 + exp(y116))
      yf117 = log(1 + exp(y117))
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
C softplus activation function - (yf21 to yf29)
      yf21 = log(1 + exp(y21))
      yf22 = log(1 + exp(y22))
      yf23 = log(1 + exp(y23))
      yf24 = log(1 + exp(y24))
      yf25 = log(1 + exp(y25))
      yf26 = log(1 + exp(y26))
      yf27 = log(1 + exp(y27))
      yf28 = log(1 + exp(y28))
      yf29 = log(1 + exp(y29))
C Derivatives terms - (xa1 to xa9) and (xb1 to xb17)
      xa1 = w3(1) * (1/(1 + exp(-y21)))
      xa2 = w3(2) * (1/(1 + exp(-y22)))
      xa3 = w3(3) * (1/(1 + exp(-y23)))
      xa4 = w3(4) * (1/(1 + exp(-y24)))
      xa5 = w3(5) * (1/(1 + exp(-y25)))
      xa6 = w3(6) * (1/(1 + exp(-y26)))
      xa7 = w3(7) * (1/(1 + exp(-y27)))
      xa8 = w3(8) * (1/(1 + exp(-y28)))
      xa9 = w3(9) * (1/(1 + exp(-y29)))
      xb1 = (w2(1,1) * xa1
     + +w2(2,1) * xa2
     + +w2(3,1) * xa3
     + +w2(4,1) * xa4
     + +w2(5,1) * xa5
     + +w2(6,1) * xa6
     + +w2(7,1) * xa7
     + +w2(8,1) * xa8
     + +w2(9,1) * xa9)
     + * (1/(1 + exp(-y11)))
      xb2 = (w2(1,2) * xa1
     + +w2(2,2) * xa2
     + +w2(3,2) * xa3
     + +w2(4,2) * xa4
     + +w2(5,2) * xa5
     + +w2(6,2) * xa6
     + +w2(7,2) * xa7
     + +w2(8,2) * xa8
     + +w2(9,2) * xa9)
     + * (1/(1 + exp(-y12)))
      xb3 = (w2(1,3) * xa1
     + +w2(2,3) * xa2
     + +w2(3,3) * xa3
     + +w2(4,3) * xa4
     + +w2(5,3) * xa5
     + +w2(6,3) * xa6
     + +w2(7,3) * xa7
     + +w2(8,3) * xa8
     + +w2(9,3) * xa9)
     + * (1/(1 + exp(-y13)))
      xb4 = (w2(1,4) * xa1
     + +w2(2,4) * xa2
     + +w2(3,4) * xa3
     + +w2(4,4) * xa4
     + +w2(5,4) * xa5
     + +w2(6,4) * xa6
     + +w2(7,4) * xa7
     + +w2(8,4) * xa8
     + +w2(9,4) * xa9)
     + * (1/(1 + exp(-y14)))
      xb5 = (w2(1,5) * xa1
     + +w2(2,5) * xa2
     + +w2(3,5) * xa3
     + +w2(4,5) * xa4
     + +w2(5,5) * xa5
     + +w2(6,5) * xa6
     + +w2(7,5) * xa7
     + +w2(8,5) * xa8
     + +w2(9,5) * xa9)
     + * (1/(1 + exp(-y15)))
      xb6 = (w2(1,6) * xa1
     + +w2(2,6) * xa2
     + +w2(3,6) * xa3
     + +w2(4,6) * xa4
     + +w2(5,6) * xa5
     + +w2(6,6) * xa6
     + +w2(7,6) * xa7
     + +w2(8,6) * xa8
     + +w2(9,6) * xa9)
     + * (1/(1 + exp(-y16)))
      xb7 = (w2(1,7) * xa1
     + +w2(2,7) * xa2
     + +w2(3,7) * xa3
     + +w2(4,7) * xa4
     + +w2(5,7) * xa5
     + +w2(6,7) * xa6
     + +w2(7,7) * xa7
     + +w2(8,7) * xa8
     + +w2(9,7) * xa9)
     + * (1/(1 + exp(-y17)))
      xb8 = (w2(1,8) * xa1
     + +w2(2,8) * xa2
     + +w2(3,8) * xa3
     + +w2(4,8) * xa4
     + +w2(5,8) * xa5
     + +w2(6,8) * xa6
     + +w2(7,8) * xa7
     + +w2(8,8) * xa8
     + +w2(9,8) * xa9)
     + * (1/(1 + exp(-y18)))
      xb9 = (w2(1,9) * xa1
     + +w2(2,9) * xa2
     + +w2(3,9) * xa3
     + +w2(4,9) * xa4
     + +w2(5,9) * xa5
     + +w2(6,9) * xa6
     + +w2(7,9) * xa7
     + +w2(8,9) * xa8
     + +w2(9,9) * xa9)
     + * (1/(1 + exp(-y19)))
      xb10 = (w2(1,10) * xa1
     + +w2(2,10) * xa2
     + +w2(3,10) * xa3
     + +w2(4,10) * xa4
     + +w2(5,10) * xa5
     + +w2(6,10) * xa6
     + +w2(7,10) * xa7
     + +w2(8,10) * xa8
     + +w2(9,10) * xa9)
     + * (1/(1 + exp(-y110)))
      xb11 = (w2(1,11) * xa1
     + +w2(2,11) * xa2
     + +w2(3,11) * xa3
     + +w2(4,11) * xa4
     + +w2(5,11) * xa5
     + +w2(6,11) * xa6
     + +w2(7,11) * xa7
     + +w2(8,11) * xa8
     + +w2(9,11) * xa9)
     + * (1/(1 + exp(-y111)))
      xb12 = (w2(1,12) * xa1
     + +w2(2,12) * xa2
     + +w2(3,12) * xa3
     + +w2(4,12) * xa4
     + +w2(5,12) * xa5
     + +w2(6,12) * xa6
     + +w2(7,12) * xa7
     + +w2(8,12) * xa8
     + +w2(9,12) * xa9)
     + * (1/(1 + exp(-y112)))
      xb13 = (w2(1,13) * xa1
     + +w2(2,13) * xa2
     + +w2(3,13) * xa3
     + +w2(4,13) * xa4
     + +w2(5,13) * xa5
     + +w2(6,13) * xa6
     + +w2(7,13) * xa7
     + +w2(8,13) * xa8
     + +w2(9,13) * xa9)
     + * (1/(1 + exp(-y113)))
      xb14 = (w2(1,14) * xa1
     + +w2(2,14) * xa2
     + +w2(3,14) * xa3
     + +w2(4,14) * xa4
     + +w2(5,14) * xa5
     + +w2(6,14) * xa6
     + +w2(7,14) * xa7
     + +w2(8,14) * xa8
     + +w2(9,14) * xa9)
     + * (1/(1 + exp(-y114)))
      xb15 = (w2(1,15) * xa1
     + +w2(2,15) * xa2
     + +w2(3,15) * xa3
     + +w2(4,15) * xa4
     + +w2(5,15) * xa5
     + +w2(6,15) * xa6
     + +w2(7,15) * xa7
     + +w2(8,15) * xa8
     + +w2(9,15) * xa9)
     + * (1/(1 + exp(-y115)))
      xb16 = (w2(1,16) * xa1
     + +w2(2,16) * xa2
     + +w2(3,16) * xa3
     + +w2(4,16) * xa4
     + +w2(5,16) * xa5
     + +w2(6,16) * xa6
     + +w2(7,16) * xa7
     + +w2(8,16) * xa8
     + +w2(9,16) * xa9)
     + * (1/(1 + exp(-y116)))
      xb17 = (w2(1,17) * xa1
     + +w2(2,17) * xa2
     + +w2(3,17) * xa3
     + +w2(4,17) * xa4
     + +w2(5,17) * xa5
     + +w2(6,17) * xa6
     + +w2(7,17) * xa7
     + +w2(8,17) * xa8
     + +w2(9,17) * xa9)
     + * (1/(1 + exp(-y117)))
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
