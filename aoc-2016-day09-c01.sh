#!/bin/sh

CHALLENGE=`basename "$(realpath $0)" .sh`

do_build()
{
    exe_filename=${CHALLENGE}
    source_filename=${exe_filename}.S
    build_command="gcc -O0 -no-pie -Wall -nostdlib ${source_filename} -o ${exe_filename}"
    error_code=0
    if [ ! -e ${exe_filename} ]
    then
        echo ${build_command}
        ${build_command}
        error_code=$?
    else
        source_timestamp=$(stat --printf=%Y ${source_filename})
        exe_timestamp=$(stat --printf=%Y ${exe_filename})
        if [ ${exe_timestamp} -lt ${source_timestamp} ]
        then
            echo ${build_command}
            ${build_command}
            error_code=$?
        fi
    fi

    if [ $error_code -ne 0 ]
    then
        echo "failed to build"
        exit 1
    fi
}

do_clean()
{
    if [ -e ${CHALLENGE} ]
    then
        rm -v ${CHALLENGE}
    fi
}

do_run()
{
    ./${CHALLENGE} "${1}"
}

do_test()
{
    expected="${1}"
    str="${2}"
    if [ "${3}" != "" ]
    then
        str="${str} ${3}"
    fi
    value=$(./${CHALLENGE} "${str}")
    error_code=$?

    if [ $error_code -ne 0 ]
    then
        echo "KO: '${str}'"
        echo "program error code: $error_code"
        echo "program output: ${value}"
        exit 1
    fi

    if [ "$expected" = "$value" ]
    then
        echo "OK: got [${value}]"
    else
        echo "KO: '${str}'"
        echo "expected [${expected}], got [${value}]"
        exit 1
    fi
}

do_test_batch()
{
    # examples
    do_test "6" "$(echo -e 'ADVENT')"
    do_test "7" "$(echo -e 'A(1x5)BC')"
    do_test "9" "$(echo -e '(3x3)XYZ')"
    do_test "11" "$(echo -e 'A(2x2)BCD(2x2)EFG')"
    do_test "6" "$(echo -e '(6x1)(1x3)A')"
    do_test "18" "$(echo -e 'X(8x2)(3x3)ABCY')"
    # custom puzzle input
    do_test "97714" "$(echo -e '(19x14)(3x2)ZTN(5x14)MBPWH(112x2)(20x15)(2x15)AX(7x4)UDNOYNU(7x7)YGJJMBB(59x11)(1x10)Q(29x4)VGDXLQYSEUBZSCXVKJLIDXGHCSQXL(3x15)QMJ(2x15)GA(1x11)N(161x5)(10x8)DNMWSUEGYZ(60x12)(36x10)RFWPBFRPFUUERWOMFVIPLIIVNIKYBEPNAEMO(11x4)DJQYLWDSUYF(28x4)KMFEZNRDVFPALMIBTUSSIKBEDDES(25x4)WHBANBCBSMYYJJYMXMEHSVHLK(8x2)DXMYJAOA(157x8)(81x8)(16x13)UDZKAIWYGRMGTFEL(2x2)MX(4x10)UWEW(18x8)XFETJLTWLMXERLKYZE(10x15)ZZINBFHXMJ(58x7)(2x13)PU(6x9)EKETLU(4x14)PYWO(11x13)QPFDYVKMYQT(6x1)FXYXHT(1x9)UQKPHVIYMXGIJU(574x14)(567x3)(318x14)(311x8)(22x8)(15x13)IFVDNTIWLQZPKFY(20x9)PIAHRLMWBKSLGRMANIZG(38x3)(3x12)FJA(3x14)XBN(1x14)T(8x1)PAYAHPVW(62x13)(2x14)RP(47x12)(13x14)PAHQVKGAOCQSI(5x6)FWNZJ(11x6)UWJGVVVQNDU(137x4)(59x10)(2x15)LU(8x12)JFULFVHX(13x15)JGHVEPFJFRELS(5x9)FMEAD(2x2)UI(1x15)H(10x5)OLOGVCUNVA(42x9)(27x2)TSPUMQILTHKOYJEBYVGMIVNPGYJ(3x13)TOS(233x15)(225x13)(51x7)(32x5)ITOPJLZJXADLZUWWZODCJZSFARRBEVAW(7x13)(2x2)MY(161x7)(11x14)(5x15)NUANI(39x8)(3x2)WFP(24x14)YUXDAFGDGETSMQFKXLNAJUXB(92x1)(15x1)VVBNYVKPYIHGXVW(7x11)SHTQWTV(24x1)MFTWXBQKXYRYVHLNSHYCUCIX(8x10)DLJPXYPL(8x15)DFFGYJOZ(2413x13)(2147x9)(8x11)RQUCQBKE(189x2)(7x1)OFSVWLH(150x2)(142x12)(15x9)(9x14)LWQHHDQAO(59x14)(14x7)MXFGIEONQVAOWQ(3x9)NRO(8x3)KVVUCTPS(12x8)UTUHAKZBEWEN(5x5)XIZCQ(4x15)LVRW(29x2)(2x3)QF(1x11)E(1x14)Z(3x6)OGN(7x5)RQVWCKS(2x15)MY(725x14)(404x1)(225x5)(50x6)(12x5)TXWSSNMDRHRQ(8x5)BKJVIYJC(2x6)LT(6x13)AUEBNS(42x2)(3x14)ZVJ(12x1)IVOHWTXJGDJI(4x8)AVTY(1x3)U(50x1)(6x7)WAFFVQ(7x7)TVXBEKD(8x10)QZTUCAVH(8x3)UQQQWQRT(28x7)(12x12)AUEULVXQYLII(4x1)UNGS(25x2)VHMTBELOETJHHIMOCSSQFODHM(67x11)(37x9)(5x7)OOSOJ(21x8)IHVJDYDZMEYFJQZQYXXYU(7x8)FZRHJQZ(7x8)(2x7)MA(14x6)QHWLXSRHFUFUTP(71x14)(11x1)TUVSALWVHJO(25x11)(12x5)VROWLLAEHOLE(2x9)YN(16x9)(10x6)TSAAUESDGC(263x8)(29x13)MQGYMAWVEQTEKIHRECFCMOHOMNXLA(220x9)(2x15)KW(39x13)(2x11)HS(17x14)MDOUAHVKKAXCGWXLP(2x1)HO(36x8)(1x12)W(22x15)RQYBTSLNZTRISZUZSYVSCY(66x6)(4x11)RPRV(16x7)KCYZYRPHGWXCKTVI(11x8)QCRXXBUYCHS(5x1)QZWBP(2x6)SY(46x4)(8x6)AQQHWWDB(11x5)UPLVDZOZVOY(10x9)TQQDBCWKKV(27x9)(13x9)(7x11)BQSKLAU(3x8)ZRW(5x13)JBKRD(342x8)(120x13)(10x8)(5x2)GOBYG(36x7)CSHVGUVIIAEMDKAQLZSHTFFJKIIWHKZYMCQW(3x10)QKI(9x15)(4x9)KGHA(31x11)(3x10)QRN(5x13)ZKXNX(6x6)YHCNNJ(189x4)(9x5)ALDBNBHUT(168x2)(1x14)P(67x1)(18x1)VHYINNFXQTKRLVBXYY(29x10)QMSFREUKSLKASCUANUHBRCBOWPJMK(1x15)K(16x6)(5x8)YXIMM(1x8)A(51x10)(5x15)WQVQW(3x11)YFY(15x1)RBJODFPBSHDMRLQ(5x8)SFUQL(3x1)ARD(12x8)(6x11)VLUZSI(848x8)(214x12)(207x6)(19x4)(2x14)VA(6x2)VSFUJI(1x2)U(9x1)(4x1)GKPI(10x12)(5x9)ZRFAE(137x11)(9x12)YHHPKSKTM(16x5)CPGBRBWZGTEJCALY(14x10)YLIUSVWIMZAPRD(65x15)ZGDKFMFTSRZCNWSWPUPDVWZYXSLOISPNHEUAQJJREFBDCBRISOYQRQLDMKQGEVUQP(2x4)DK(203x8)(12x9)ZXCNCMDROASE(177x14)(7x2)NVKUHBU(2x2)GM(107x12)(3x8)OKV(16x3)LFVOGUTFSLMGBPXF(12x8)SVHILNSDJZMQ(28x5)YEEHKYMCKLSMMUBROUQFXTFCCEZT(19x1)FNZNMSIMOHDOZFVFVEC(10x10)(4x12)NGML(20x7)ICULAJEPWOHSMLJZOKJI(223x11)(31x4)(1x6)L(13x6)(8x8)CGTYOKUY(1x8)Z(167x8)(61x14)(4x9)WGDI(13x9)KKIVRFPRCORSQ(8x4)NVRMBAPP(4x1)XNCK(5x14)AJYDE(42x9)(3x13)VBK(20x9)OENBWZXYLYRJVOZATTRO(2x7)AQ(12x5)(7x7)OLOWHLP(27x2)(1x7)F(7x7)JMQKSCT(4x9)YCIT(7x7)JZSEJTP(177x13)(53x8)(46x11)(6x8)MCDKPD(15x10)AXTVGBJADSVXZQU(8x8)QVMAXBDP(111x7)(13x4)EVWQQTQLPKJGW(14x11)(9x7)QNFLRFACY(6x11)FMOZOW(1x3)K(46x10)(3x8)HFG(17x14)WVUZTQACXVRLDNCIP(1x3)F(2x15)AQ(3x13)WRD(241x14)(234x2)(182x6)(76x11)(49x12)(4x12)BKXA(27x7)VJZDTFMRHGWMWCPELDDGYSOHICE(1x5)L(7x8)LETVJYM(3x6)FOE(86x5)(3x11)RHG(3x7)PGU(3x12)HRA(54x1)(16x14)RUZDLXTFKCSHDMJX(2x15)KP(3x5)ERR(9x15)OXSUBLNDE(2x3)AO(22x13)(15x12)KVJPEBINSXCMIAJ(10x7)FDUTYGTPYO(7045x3)(1694x15)(1237x13)(2x7)TC(387x1)(123x10)(55x2)(11x3)FKYSUXQOUBT(3x3)AHD(4x5)XRKQ(5x11)MHSYF(4x10)FKAV(55x10)(15x3)PGTZRCQJTXZIDVM(13x13)IBZJCPEYTOJYK(9x6)KXUEJVAKP(249x3)(108x14)(7x11)VQJUCRC(7x15)HKKUUJF(7x4)CADYWRN(2x9)PF(57x3)ALPBVWITMJTLAEFYDFKYQZHWTPDTGDVFTWVOPTCAMEYWNPKUVBUZXXXZL(32x14)(4x6)EVRA(17x6)NBSTKJYEIRPRJBTXW(12x12)CZWVEDJMITSE(68x13)(13x9)YKEBNECKNDWYD(2x11)II(22x8)KLJENDMYESWDYZNDGWRQZA(8x6)NOYUPJEC(361x3)(88x6)(23x8)(3x12)GKU(9x9)ZJKUAVSTQ(41x5)(3x10)YTZ(26x6)UJQKFPXTJUDJQRZBIIXKOASSRR(7x5)MAXGECR(8x12)BTNQVUDH(150x8)(100x3)(11x11)DXJYIBQXEVC(17x5)DXRJKPEHAVIKKZJMZ(27x5)QXMAGKYSHNXUKCERPBJZLAMQTIP(20x8)QYNXKHBXLVXATJQMOQRZ(5x11)CDELG(26x4)WXGTJWIZQSNLWDVCWWLWFXTOFJ(10x7)VLFWYHBFIA(73x15)(66x10)(1x8)E(7x8)AGWFUEF(14x7)NUJRIZNQZGPMHS(21x15)ALPTMKCXUEHVZDAZDMDKH(131x12)(13x14)(8x8)PFDAAJLQ(6x9)HZBHJQ(12x12)(6x13)OTPHTI(13x8)(1x4)T(2x5)BG(55x15)(1x1)C(12x4)DOKEVDCYJERH(24x10)(1x6)D(5x9)FDXHK(2x10)RQ(322x4)(113x9)(11x12)CUGZEAYMHAW(89x3)(17x11)NAERBWAKWWYSWOWDR(13x15)XEGOGNUDJORCO(27x12)BDCVKNTKLNSEAWKTPYNZIAZYJJW(5x12)QMCNJ(55x11)(4x14)GIXM(38x15)(1x12)J(13x15)UTTZFEJCPXRWZ(6x4)UEVKLG(133x7)(38x6)MGNLNGQBUFNTSDODFJRNWBYXUJWOXMZSKPFSES(77x4)(9x12)OCPDSQAXL(4x15)BCRP(12x11)KAZCKBRPGBXQ(17x11)URTUNBJWKZUFUASCY(3x11)QDX(1x9)S(441x2)(285x14)(7x13)HASJKVW(6x2)GURASU(254x4)(40x8)(34x7)EMKSEGMUWUONRQLNHUJDNWFOSPQJUDEIVV(100x9)(14x2)NCNRTHZEQMSFPY(19x2)TFWPRMZOKFVALYACOJO(1x1)H(36x11)SUKGBMMXYFLOLBONANUKAAOXDIEUWYQGNMHF(1x2)R(95x1)(22x8)KINSVVMPHKGNNYBLPRRNDX(28x11)EERSHQYWXXRXFGCZPZVQSKNADFDH(15x11)ISRXKHOICZSGUYT(5x6)IAXEY(7x4)(1x13)A(5x14)LIYFY(105x8)(9x13)PVUDVCCHN(83x15)(17x14)(11x8)PKHOYTPFZPW(52x15)(1x2)R(5x15)LADVM(16x15)CVRXNFJKOYDTUNBB(6x13)ZSBETZ(7x10)JTWLXUN(1262x2)(1143x3)(368x5)(14x3)QKANPUZNJGORAQ(128x2)(46x15)(27x12)RPQVEQLOEFEQFLDEGAEPZAJURCI(7x8)MZTIAWL(61x7)(13x7)GIEHKXTFWLIIV(24x1)UBGZCPTFSJKNAKWRQCRHPUIV(6x13)BOTCBY(2x11)ST(34x8)KHKIVTCYSIYGODVLCOYFZZDYSCTRPSGLQX(165x12)(13x14)(8x5)TBBSQPIO(29x12)(9x13)JKDEMHKWM(2x7)CV(2x4)TP(102x4)(17x5)TCDDTQQQEOXSGWWKE(17x5)UEUALEIASUDELICWN(16x6)MMMWRNDZHBIBXKOM(28x5)HEIGFFENZZRRFTUVBUQORHWTPGOV(247x1)(17x9)(10x11)ESATUGNVTG(25x4)(18x14)YNMKZINZXPZLHQQIRR(2x4)IT(110x1)(21x14)GMZFGRDOTAEUSTJHZMLOP(60x12)(19x6)XOOHSVUKPPWUMJLUQHS(20x6)ZILZMQNAUSIRVRUIZZTM(3x14)DWI(1x3)L(3x13)DEZ(63x5)(47x15)(16x14)VRFJFDIWFJFTJGKT(8x8)ZOFGVHDC(6x1)VCQQVH(4x9)LQRG(494x3)(56x15)(50x9)(8x8)ZPJBEIIG(5x15)UJNQO(9x2)ONVTMWKNV(6x12)HUTGXL(268x11)(7x2)EWDPKKS(84x10)(37x5)UYUCMWOMGOYZGZXWNRVRUHXTFEWCOPKHADOEU(3x13)OAF(8x7)ZGCBECWP(3x10)OMO(4x13)KAFH(77x13)(15x14)EGPWQGKQEDDDOTO(2x12)JV(10x2)PCAHKAXYDX(2x8)FS(17x14)XUZQMQWRECWVDYLDL(21x8)YKRLUENASPLZJWIVYDMFB(47x10)KJRRWAWOMNUYCMEVOHMLFLKYIKLZFWXDZJINORLBJBWKNYQ(24x15)JHATNNZZXPHCXIKGNIHUSEBQ(100x13)(29x10)(4x8)POID(13x10)LQCWOSJVGLQQC(17x2)YTTHNDHRWMKRKXTUU(25x10)SPQMEFRJIUPXTZMMUJEPGKRJO(3x15)AOL(10x1)VLDBQNWERE(8x4)(2x10)ZV(104x4)(97x11)(43x10)(27x6)(2x15)HP(13x7)UFIZONIMVDCDF(4x10)SLRZ(16x3)WOGBTZXRVWHTCWAO(7x13)(2x6)XL(6x13)(1x6)X(48x2)(42x1)(36x9)DYLVFNGCJRJXEUOSSYOFSGKDMIHCGQCRXYXN(1750x2)(483x7)(467x11)(5x14)CDNBJ(85x13)(21x1)(9x13)UKLCTCFUI(1x6)J(9x7)RAITDZYEJ(21x4)FGQRBVJLQEVYSZAISQMAD(10x12)RGBXVGSOSR(202x15)(5x7)VJZBP(45x15)(31x8)DNLGOFUIWITQUZFFTPOHRMRVXYNIFSL(2x15)IM(56x13)(10x6)COOZPWTGPM(9x7)YJIILGZQT(4x15)HUKR(10x2)CMURLLTHBG(54x1)(7x14)PKUUDKU(11x15)FFJJILDMOAS(8x10)XHNHFOLS(3x14)ZAI(10x13)(4x10)JNNQ(112x7)(28x3)RXVJTWPTNOOLVKCHIPPPWMVBADPH(72x2)(32x7)UDNRKYALNRLKMDBJXTRRIMFKQFJVBWTH(1x9)Q(9x13)STRWFASIW(1x3)S(1x13)X(28x14)OFNSRVYFPSFPNJIARCUNLKMQIXPG(3x7)ZMT(113x3)(7x8)JILQNPH(95x3)(88x10)(7x4)UHLRLXX(8x14)YAQKCKWZ(10x12)(5x3)HUEJY(25x1)(19x2)EJASIEVVGPKVRDZZBHI(8x10)CSVAAVTT(1132x1)(253x4)(245x12)(64x9)(12x13)MYBUMZYQQGNB(14x9)OAEHKVUSGEJDJO(10x2)VKBQQKMWLD(4x9)PJBX(47x8)UQICXEKIQVMCVYGFVBDTOYLEKJQNFWWYMWPPIPKJRYDLNJY(7x8)JDOMLTT(92x6)(16x11)JZVSYKXQARJNCBOT(10x9)KEOWHTHIMB(2x9)IH(10x1)KOQIDZLQWE(23x12)ZASFEWYQTEMIRJMHFMKOUYD(6x12)EEZUYP(516x1)(75x2)(35x4)(7x5)TBOZCBW(1x3)K(11x7)ZAHCEIPCSLQ(27x13)WITJKURFYKCDZGLXQGTJTPILOPP(77x12)(35x13)(9x7)NGKJUFJPN(5x7)HEVKK(5x11)MRZRQ(11x12)QTZKFFPUJCM(11x2)(6x7)GOINTN(240x8)(17x15)VCSTHOVEMGKRCLAQO(85x10)(10x5)SFSFSXXZHZ(39x8)YHPHGOLEAICNEYFXRJZBEEPINXNONPSFEAEQLXR(17x10)NQOKSBBYTARGSUKAU(54x8)(29x8)XGZVIQEPZUZQXPWKPLVGVELWXEKZO(13x5)ABVOVHEUIFMCX(21x11)(8x9)PSCTVFMT(2x10)HG(29x13)(6x13)OIZWHI(10x13)UYJJQMXNEW(98x4)(92x1)(10x8)AMZNTRUYRJ(17x5)ZBOWCAIWECBUAUEEM(22x12)DQJCCJAUAWBUEDPYJWFATH(9x7)XNRAELWJX(4x13)LBKM(3x1)WSZ(334x3)(127x1)(21x3)ERKYTWYIAWUNQFCVGCVXG(13x13)ETKUWEVUDSUHY(10x3)ELMXXYOTMD(31x3)(1x12)E(3x12)WIS(9x11)RTUHDIEUN(21x4)(2x3)TC(3x6)BXB(1x2)M(19x7)QNWITDFPSLBAFFGYCNA(148x3)(20x4)FSSZIPFMPZFWEXIOHLPB(38x10)(8x5)UAIUVNOI(3x14)UBN(10x6)YWSRAYTVVH(32x15)(12x10)YRUFKQCOTDBG(7x13)OGFFBVM(25x3)(2x6)SV(12x8)OGPQUGBVHNPC(2x6)OW(13x10)YQUNEVPKGOAPQ(2252x4)(694x12)(250x12)(46x3)(1x3)P(21x15)(14x14)CBMUTIRGZRFPAQ(6x11)PXQNXN(160x6)(75x2)(2x2)WD(19x4)SDRKNDIDOXNJITECWVG(14x8)DKDNISRFFORICQ(10x5)WESURVPTOZ(1x13)V(72x13)(1x8)R(9x5)PAIEXGUAC(23x1)FHJZZBOFYERBKPOVZSRVXHA(3x6)AGX(9x11)VFIHMBVBV(24x14)(17x13)(11x6)ZYXEYJCXYRW(428x15)(50x10)(44x8)(14x12)YHRVJYBVASYNWC(8x6)DNMHGANB(5x3)AUZYC(6x10)DBAATO(176x1)(63x4)(12x11)MBJDMYYEOCJA(3x2)LCJ(6x1)QRUSJC(2x9)KN(12x9)DVZNCHHUDGDW(100x4)(9x4)IIZRYEAUC(19x5)NLNZCCJWUBUAPJISLSX(2x14)VR(27x13)KDJNNCAJVAERWHNQDXUNUHVVRQQ(13x5)GCIXBFKQTDTEU(168x14)(6x4)EWVTCB(34x11)(5x12)FFMBP(5x11)UXPXJ(6x10)HSECNG(5x15)IUUGP(66x11)(1x3)T(4x9)OFCQ(4x8)JMMI(36x9)CAMNVOZZVPYJNDYPIZXIFHRBIVJASQNCDNWZ(25x14)TKUWPVOTDZPWETHELIHWLEMYR(2x13)KT(579x9)(546x10)(157x14)(23x1)(1x14)B(3x8)ASI(2x13)YX(51x7)(14x3)TFZHYALQMHGPQP(6x1)SJIRBC(7x7)WDWLJIJ(3x7)WWF(1x4)N(50x12)(3x12)RLQ(5x1)EPNYQ(18x11)UAUIVHYLEXFIXMQOZO(1x2)R(3x9)IGZ(16x1)(2x4)XH(3x15)BMR(19x15)(13x2)HWIQKVODOFFQC(197x10)(35x2)(6x15)LCQRWS(16x13)BXVVYMMZZDFXPXPU(62x1)(3x3)ZAR(13x13)VKDSKLZOFTDGQ(12x4)UIFXQZAWEPYD(10x3)SJVMMCZQOD(22x9)(16x4)NINGDACSLHCILBTR(4x12)SCEN(43x10)(5x6)VMROP(9x3)BBMOWMAPY(12x12)HCJJNJQOFMBY(120x14)(102x7)(18x14)BUUKADNKOMHTIJDYEG(11x9)AIIFROSXCYW(34x15)FBJALEBNGFWQBBEZORTVGPUYKYFQIFVHUI(4x9)DWOK(4x12)PUYE(6x6)VDQBFE(19x4)CCUMDYGMGFDDIQWDVAL(948x12)(163x14)(18x12)(12x2)KDPCCMAMCABD(18x11)FPPLQNGQRLBMSBBTFG(99x8)(25x6)MSLIUSOYDOLZJRTIEOGMZIDIH(62x6)(8x12)EVGKTWID(2x3)GQ(11x2)UGQGKEPOVWY(17x11)VVPJOGPMWDXNUTZZC(3x9)EMT(393x12)(104x7)(72x5)(4x2)MKQY(3x11)FNO(24x1)YPSJAURBEWDJJMHKCZMNZCPN(18x6)JFLKSKXDKZUDARJSFW(1x11)I(12x11)MASFYNDTUUUO(133x3)(54x8)(16x9)HZJSKPDRMHSDLKWS(26x1)ONAIOWRXKXWGIPXHFPVXOWWTXV(59x11)(7x11)DHNWANP(1x9)C(13x10)PIUGQNICQPQIU(13x15)IVOPXOVIIOBYL(2x7)WO(127x13)(62x14)(6x10)ZAVFEI(4x8)STLP(11x12)FUCCXWZPALV(17x1)BMSSMCUZBCSWSQUUP(21x9)RXGCKKYMFYUCWLUPVKZGN(1x13)D(3x2)SNT(10x6)(5x9)IRHCC(1x10)R(47x8)(40x11)(2x5)IQ(3x11)LMP(6x8)(1x9)K(8x6)HLLGSFQT(316x7)(213x15)(113x10)(3x14)HKU(35x10)FHIQCKIPOYTKPLINYJFKUXNYHNXYTGDWPXZ(23x11)KRHKVKMFQQPNKAQYRZYNRPU(13x14)WOKSNIFCMECYU(7x5)SGTERJS(4x14)UXQX(6x15)(1x3)S(2x5)TU(57x8)(8x9)RPLYSWYI(6x10)XICJBU(1x9)X(20x9)ATAPYXISIGMKIIBNTULM(88x13)(1x4)E(9x13)NUJURGIXF(61x8)(18x12)DALJEKYLLCLSPZSKBZ(14x15)WCXYCPZPGKJBMR(2x13)GX(2x5)CO(6220x5)(1950x12)(1083x3)(267x1)(142x7)(63x6)(3x14)ALL(9x6)AMKZAHKHQ(6x12)EOSVKP(21x10)XJNRXDQENHCOBUXXTMZQZ(1x6)C(21x15)(14x12)IYMQWIYRVMSALV(32x11)(8x8)ABNSTYLH(1x6)S(2x9)BT(1x3)N(4x6)MVLQ(102x3)(22x13)EQBHHMWOYZQVTQZLIDDSFY(7x10)ZSPXWLN(54x9)(15x15)NHLKXTAMFXTLABT(4x5)ZXSE(8x14)IOLHOJLI(3x11)JFU(306x12)(39x2)(2x11)QF(1x13)K(5x6)PKURE(8x14)(2x15)BO(9x15)PVJTAXRXL(239x6)(96x3)(6x14)AYRKJN(10x12)UQOMVXMWMB(6x6)MEHBIG(6x13)TPYQAD(37x15)VRXCOGKSHRGKDIMEEWKYDTJOZSMTOOYMTIQAL(10x4)SNHIQWGRNW(18x9)(12x8)XEFUPQOWYBWX(3x8)ZMP(83x7)(20x8)YPUNCWPNFNHRELHRSUPX(19x11)XPJPRYIVBWLHJOEXORD(18x13)EEXUFYPAIOBMWNHZXH(1x8)E(487x12)(206x1)(2x12)TR(11x1)(6x5)IWGICM(40x10)(3x15)STY(6x13)EPDTGW(6x1)IVQYIZ(3x6)LMG(105x10)(18x7)JKERYRQOLQUIIKMLJM(7x12)DLXNYSN(35x6)FOKFBMDLAYUFJXRWYNRPTQNVCJSVAEQOSVC(8x10)SEVZYQTV(8x8)GKBPKOCD(15x5)LWERTYWMCBAEWHL(8x6)THHETSJF(127x14)(34x13)(2x10)FT(11x9)XPPKFXTKQDN(4x5)AFNN(80x2)(16x8)IXPPCOIUMXELYPCF(5x13)XUAZM(13x12)WZTXEDBDJBMSW(14x9)GPDHGANCKSAORD(2x9)JZ(34x15)(27x14)(21x8)ZNYOGHEJSDMXNYGNGKBYH(78x13)(3x11)MLH(9x14)JWNQCKWVK(7x15)FAFTQNI(35x4)(9x3)RGVLDDOGJ(4x9)QUBG(7x6)RTCATAL(191x15)(183x14)(175x13)(2x15)QX(101x7)(12x1)ZJYOHMXRPRRZ(3x5)PPF(11x5)BCIBNOGLZIV(21x1)NEWSLJUMKONJNVZKJHWCG(24x15)BYCEHYBSVYYZORDAVXVTQVIR(53x5)(5x13)JFLTG(23x6)LBFUCYDAFBQOUFISYUJOQID(8x5)FBVIEKWA(10x9)FYZURKLTPI(617x8)(3x7)RPT(602x5)(75x2)(4x3)WEEB(20x12)YFBAXJKVTMOGUNAVPHPJ(1x13)K(26x4)WBETTVSKASVIONCMNWLDPBJWJP(155x4)(9x1)WFWKVFGRV(99x3)(8x4)OYTCNIPO(2x7)TK(47x13)ZPCQDJKLJBZFRAOEVCRICHONYZDPQYPIBAZAMAUTQXFECMJ(10x8)ZEBAQGBAJM(3x13)CTH(30x5)(24x4)WNGAZRPZIVAOIAUEOADIMUZH(18x7)(2x10)GD(4x15)GVJO(92x1)(4x6)TSZH(24x8)OZTAYDZQDKWTAVHUSLJIYHJA(18x11)POWLTPGHWNTSUWUVIB(22x2)MAVRDHTYGVHYJVUURXIKHD(229x10)(6x8)IFNNZD(2x3)UN(81x5)(7x6)TZCQCCP(19x8)VCAPXKOHMQVBVWIKZPL(38x7)XUVSOXLAKSJVGSFREYSXZPICKSAESBBMNXYLER(19x6)RWNWHPVOUNYKIZXWDEU(93x5)(39x12)LKMRRQYYTLRVWUBQBRQYTUEJLWNVZECMGVZQLSI(5x14)QFEPQ(3x10)JCJ(12x2)WXLDSYATBGIW(3x11)SUE(13x14)PKIJONLXUANPI(2034x15)(601x9)(153x15)(137x15)(18x10)(2x4)XK(5x15)ZYJPJ(5x4)HAHKZ(14x8)SBFWAVGECLXPZG(63x5)(12x13)WMKTEGIOQDIO(12x1)PIFFUKEMLEHG(13x1)DNKNWIDXUNMHA(2x2)PT(8x7)DFEBPKUX(2x12)IS(155x7)(2x8)OD(2x11)MM(122x1)(65x5)(28x13)BRSKRLKHOUDCDOERWDPCHEJPRSWT(1x10)P(2x14)GH(9x10)AQRYRARFQ(45x1)(22x8)ATSCKEGSMYXFSJTCMUTPPE(10x15)KRSQOYZBMR(6x1)(1x4)G(86x10)(80x6)(28x11)(6x12)EOWFGX(3x1)CAQ(2x11)BY(29x3)WKLNUKTMDNXVQOEKOXOCOAETCVMYB(4x13)IEMT(178x2)(86x1)(44x11)(11x10)MTIOKFLCGYO(6x10)YALYGE(3x9)OFJ(1x5)J(10x12)XTNXMYFPMS(12x2)(7x8)DTVHZAC(34x7)(28x6)UNSUAFQCOTEQDLBXOKRCWXRUZDNA(40x1)(1x4)L(4x5)CMKN(19x5)XNZACQOQPXKFNXJZRRW(690x10)(224x2)(169x2)(2x13)OE(11x7)CBLHVYUEZJL(53x12)(7x11)DZMDXYZ(7x15)OQCQKPV(1x5)V(8x15)OFUHWXYC(2x8)RH(53x4)(7x7)YTJZFFK(7x11)VKFTYMQ(2x6)CW(15x1)HHWVGEDXIXHNZEC(19x8)(1x14)D(7x1)COKXISK(12x11)(6x14)EUFORX(22x15)(16x3)(10x1)XWUFYPOXDQ(444x15)(131x8)(13x2)ELWFYKDQUUTXY(6x4)RTHAIG(57x15)(7x10)TTEYCXM(1x10)S(10x2)ZRRFOMFAKP(14x14)JGNGIWLDMCSTRP(16x15)COAGPQBGKAHNYKEG(8x11)MPMRCZKA(86x13)(3x13)KMF(50x6)(7x8)BKPEJJO(5x1)ZLPNJ(14x10)OSTMKTEYXWPLXM(2x2)VJ(8x5)VEEVFOUR(2x12)GB(46x10)(9x4)QCUTJIDCA(14x9)ZTYDOZXUSMNXBF(6x11)KOONJV(20x12)(14x1)(8x15)VHFNUTKY(126x9)(7x1)(2x1)JS(1x1)T(92x12)(17x7)QGPXBGBVVHSPXGTOD(22x8)CINHYVENGXSJRJMZQYJDDO(9x3)PKHDXXMCM(21x7)BVCUZQJTLALQRXJIEEULS(4x7)AMWX(1x11)N(41x1)ARDAIXBZPOZZDDMVJRVAKWRXDCRWZHJNVTKBQENNI(137x4)(129x14)(122x6)(64x12)(26x2)ROKLQLSCIZLYQAJPTJHVKEVSMT(5x10)MQQKO(2x10)VP(7x12)NUIMAYJ(16x2)QGKTFKJTGYBWKQQB(22x13)(16x5)CBZENHLSYDZSFZHH(530x9)(164x15)(80x10)(7x3)CMJCERB(10x13)CWMRXJPGSG(13x14)(7x10)CIRUISS(9x8)(4x7)IRVQ(10x13)OGQXOHPBYK(71x2)(8x1)(2x13)QA(19x11)(3x10)VCK(5x9)KOAMK(9x2)AMGVLBSPI(12x7)(6x15)NHUWPB(350x10)(214x9)(19x14)(12x13)IOZNVGXCNCKG(70x15)(4x3)BSHO(14x6)VDILSQWNAWWNSF(5x5)EGKTN(2x15)IK(16x12)RLZLPKTDPJDVOVVU(87x9)(4x12)SBSP(21x15)QRYPMOLSULJWTWEBHOPIP(13x7)EELJZCAWLYING(24x4)OUPBNCPPYVWGQLPHFBHLFLHI(11x13)KUCQAROVMAV(112x2)(104x11)(26x14)AGSYXXHOODOCXVXEODQMGCBNFP(12x1)GCFQCETQZBOV(40x13)ZBOSZWQXUXSMKJBKGSZCURKKDMNPCPRDDNKNLIOI(1x9)F(5x3)SYLNJ(2160x9)(1124x2)(87x2)(80x10)(30x1)XODLGJEXHRGYWWETBMBDWUKRRAIZIC(14x15)DITBLTCVZYPDAH(6x14)HDAADE(6x1)UEERYO(260x10)(114x3)(32x9)(2x15)AM(7x1)ZKLONKC(6x12)TWEUFU(70x4)(15x3)PTXSEDFTSSOFZCQ(12x5)SPVKIQWORWQE(9x4)DLOUFOYKH(11x5)WKPQLMIERMA(131x15)(26x3)(6x2)BJNUED(9x15)MNROHJHAK(92x11)(5x5)OUIDX(35x10)EDARHYPBZKBSGWCDIBSKQMNPVSUCUFZNJXX(27x6)YQDCAUPUPSJMOEETGPBXEEXEHCH(2x7)LD(42x5)(3x12)ZSN(27x2)MWNWUNUMDOJVEZJRTIARFIXFAKY(708x5)(19x15)INPDEQAMXMYFNORSQAF(18x13)(11x15)CDEVAHIXUDQ(287x7)(59x1)(5x14)IRCIJ(10x5)ECQKNQICSB(18x8)XULECWJKBBPVZLGAMI(3x6)ZEG(67x3)(51x11)WOBTJCECZKEAMPUNADTDWGIUEBALLNTTPQXUXMSKUCKLDSMFFWE(3x13)FWG(51x13)(28x5)BWIRYOBBPRCKBGPUPOFXWJCAGKNG(10x14)JATDGJSCRI(15x14)ZHDEXOJIQSAHUKX(63x2)(9x9)CWNCSOTPX(3x5)CEL(8x7)VJOKSFQB(1x13)X(14x12)VVPDWLOGZFOQKH(192x15)(66x13)(24x8)UIVKTUMUTTWKCJBXUHEPRRGJ(2x1)XJ(10x2)IRCYLCZVLC(7x10)ARKRVPN(35x13)(1x9)U(16x13)NSKKVVSYKFWVEMQJ(1x1)J(48x15)(1x10)E(27x14)EDOEXQKEVWNOFOEAPPSQAIUZBGB(1x14)V(5x11)CTQMU(6x6)LKXFZN(156x1)(8x13)DFWSYVQQ(12x12)RHPCOUCLGADN(2x7)BU(31x5)(3x11)AFA(2x5)RJ(3x3)OVG(2x2)GG(73x3)(28x10)RRSWIAUUVVAPMRDKOLQJNENWEOOO(17x15)AJWJWWBZCYJMLTNHQ(8x13)WTCEHSBP(197x13)(189x13)(83x15)(22x3)(5x8)JJUNN(7x8)HBZVBUS(7x5)STHZRYT(25x1)SWGOLBEXDEDYMMHEYNUGOTPNU(1x5)X(1x3)E(10x7)LEFTYQSXKP(48x7)(5x4)JICYF(21x3)OCTBXKFVGRBCMMGKXODKH(5x11)SJUKW(9x11)UGMMXRERE(8x12)BOKVEIDJ(68x10)(62x9)(56x7)(43x5)(7x12)MFIHEQH(5x1)GLAYP(13x15)UTBQBFWWKMQOC(2x4)NG(717x15)(17x11)QUALCHVKEVAXUUVKX(8x13)IBTEPRMV(192x1)(19x2)AWQRWSKKWOXGJICCTKN(138x14)(90x13)(18x1)TVPWLYCAPUVOVLQWTT(17x15)ENPJMPJIZKMGRSUVD(20x15)AKXGALMORIJJGPYHRTJN(1x12)N(2x15)PS(18x10)AGHCGUWMXZDOVVTASF(10x3)WCKTOSJIZS(14x11)ILJHKTALBUBWIL(457x7)(198x5)(83x13)(2x4)MP(16x15)QFKTRPWECWUEVAYW(10x6)WPTCNHEKOS(31x4)ZQQHPRIDCHIYUKZLARMBJQDHKXUCWBD(45x5)(1x10)I(3x8)JQB(18x8)UWCVSYJNGXABCQBKCX(1x7)N(38x1)(24x11)AFJRIBIVWPLQLPWTUOTLREVT(1x15)W(8x6)DKNEKQOL(9x3)ZRDPXQKVR(13x15)(8x4)KDGOQAXL(211x9)(96x2)(37x3)YKGSAULQBELDOIDZOEDTWGYKSFVXWMZMHYGUV(8x3)BUORTCYM(33x15)NELWDCXCKNPBDREDWJZTWNTRPKKCGZXOR(8x5)HVMLQWMY(44x12)(11x8)JZXVXXQNOWZ(20x12)LKUODIKCVQKZMKIVFIKM(10x15)EOUHTLYSHS(22x3)DHLODIEKOAROSBTTAHVEVM(10x5)(5x5)QZNNF(16x13)(10x6)(5x3)KFIUY(43x13)(23x15)(8x7)EGWZMQBO(5x3)MTQWQ(7x13)MTPQZKX(14x3)PQSSIBHUPVETLZ(119x7)(7x5)(1x10)L(28x6)UFGLKEEGGQGKCNCZFZJOGSXQBVZW(67x2)(10x15)HQCQWGJUKJ(11x7)BAQUKCTSELT(4x4)IHPR(18x9)QJNPGYUDFYCHZSNPRQ(63x2)(1x1)T(51x6)(1x10)Z(21x4)EXVMGKZHCIEYWNYOOAAMF(5x11)LYPBQ(1x2)R(24x10)ETDLKFDMGOVMGWFUVGNRSDYU(4x7)DCYI(85x9)(6x5)AYSNJZ(50x8)(7x14)QRJDDCA(4x3)UHSC(13x8)JIBQGVVZWXRAR(4x2)NMQN(12x9)TXZBPVOMPAXW(246x6)(84x10)(34x6)DXNIWQLJXQXBCFKGIAXJNLFNCCKSQNQWFW(1x2)M(31x10)WZLMERNAUBXXBVXVSDZHGFPDETZOVUY(131x11)(13x6)AHBVWEJATPTNC(50x15)EKZFGPVIGZRLJEYNHPZVRDJTFJFYCMOZBJYVYVAHDEQDPBGCKR(17x8)KCMDUTXFIVHOIKSJK(8x2)HCIXTJJM(13x3)AIFGBDHAKCDVY(10x9)DVHZVHZISZ')"
}

if [ $# -eq 0 ]
then
    do_build
    do_test_batch
elif [ "$1" = "clean" ]
then
    do_clean
else
    do_build
    for i in "$@"
    do
        do_run "$i"
    done
fi
