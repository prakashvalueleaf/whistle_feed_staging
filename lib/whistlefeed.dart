import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:whistle_feed_staging/utils.dart';
import 'package:whistle_feed_staging/whistle_feed_model.dart';
import 'package:whistle_feed_staging/whistlefeed_provider.dart';
import 'adshowlistener.dart';

class Whistle_feed extends StatefulWidget  {
  String ptoken='';////////token is required///////
  int pensize=1; /////pencil size is required/////
  bool testMode=false;
  AdShowListener _adsShowListener;
  Whistle_feed(this.ptoken,this.pensize,this.testMode,this._adsShowListener){
    adShowListener=_adsShowListener;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(this.ptoken,this.pensize);

}
class _MyHomePageState extends State<Whistle_feed> with WidgetsBindingObserver{
  int firstPenciletimer=30;
  int secondpenciltimer=0;
  int thirdpenciltimer=0;
  int fourthpenciltimer=0;
  String packageName='';
  String webviewurl="";
  bool appispaused=false;
  String ptoken;
  int pensize=1;
  _MyHomePageState(this.ptoken,this.pensize);
  WhistleFeedModel  whistleFeedModel;
  int rotationtime=3;
  double opacity = 1.0;
  int counter=0;
  int indexvalue1=0;
  int indexvalue2=0;
  int indexvalue3=0;
  int indexvalue4=0;
  bool firstpencilvisible=true;
  bool secondpencilvisible=true;
  bool thirdpencilvisible=true;
  bool fourthpencilvisible=true;
  int animationMiliseconds=1200;
  int totalitems;
  //////////cubes attribute /////////
  double squeeze=1.6;
  double diameter=0.5;
  double perspective=0.00025;
  double itemextent=76;
  String platform="";

  _launchURL(String url) async {
    await launch(url);
  }
  @override
  void initState() {
    secondpenciltimer =firstPenciletimer+2;
    thirdpenciltimer =firstPenciletimer+4;
    fourthpenciltimer =firstPenciletimer+6;
    setState(() {
      startController();
    });

    WidgetsBinding.instance.addObserver(this);
    checkdevice();
    getPackage();




    super.initState();
  }

  @override
  void dispose() {
    print("dispose was called");
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void checkdevice()
  {


    if(Platform.isAndroid)
    {
      platform="Android";
    }
    else {
      platform = "IOS";
    }

  }

  void getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo.packageName;
    print('printpackagename${packageName}');
    if(packageName!='')
      {
        Provider.of<Whistle_Provider>(context,listen: false).get_whistle_Feed_Adds("${ptoken}",pensize,platform,packageName);

        get_impressions("1",flag: "1");
      }

  }

  FixedExtentScrollController _controller = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController _controller1 = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController _controller2 = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController _controller3 = FixedExtentScrollController(initialItem: 0);
  Timer upperSliderTimer;

  void startController() async {
    totalitems = 4; //total length of items
    counter = 1;
    print('appstatus ${appispaused}');
    if (counter <= totalitems) {
      upperSliderTimer = Timer.periodic(Duration(seconds: 30), (timer) {


        setState(() {
          firstpencilvisible=false;
        });
        Timer(Duration(milliseconds: animationMiliseconds),(){
          setState(() {
            firstpencilvisible=true;
          });
        });
        _controller.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);

        _controller.addListener(() {

        });

        if(_controller.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic) != null)
        {
          print('one is rotating');
          Timer(Duration(milliseconds: animationMiliseconds),(){
            setState(() {
              secondpencilvisible=false;
            });
          });

          Timer(Duration(milliseconds: 1800),(){

            _controller1.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);

            setState(() {
              Timer(Duration(milliseconds: animationMiliseconds),(){
                setState(() {
                  secondpencilvisible=true;
                });
              });
            });

            if(_controller1.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic) != null)
            {
              Timer(Duration(milliseconds: animationMiliseconds),(){
                setState(() {
                  thirdpencilvisible=false;
                });
              });
              Timer(Duration(milliseconds: 1800),(){


                _controller2.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);
                setState(() {
                  Timer(Duration(milliseconds: animationMiliseconds),(){
                    setState(() {
                      thirdpencilvisible=true;
                    });
                  });
                });


                if(_controller2.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic) != null)
                {

                  Timer(Duration(milliseconds: animationMiliseconds),(){
                    setState(() {
                      fourthpencilvisible=false;
                    });
                  });
                  Timer(Duration(milliseconds: 1800),(){

                    _controller3.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);
                    setState(() {
                      Timer(Duration(milliseconds: animationMiliseconds),(){
                        setState(() {
                          fourthpencilvisible=true;
                        });
                      });
                    });
                    counter++;

                  });
                }
              });
            }
          });
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      setState(() {
        upperSliderTimer.cancel();
      });

      print('app is paused');
    }
    else if (state == AppLifecycleState.resumed) {
      setState(() {
        if (counter <= totalitems) {
          upperSliderTimer = Timer.periodic(Duration(seconds: firstPenciletimer), (timer) {
            setState(() {
              firstpencilvisible=false;
            });
            Timer(Duration(milliseconds: animationMiliseconds),(){
              setState(() {
                firstpencilvisible=true;
              });
            });
            _controller.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);

            _controller.addListener(() {

            });

            if(_controller.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic) != null)
            {
              print('one is rotating');
              Timer(Duration(milliseconds: animationMiliseconds),(){
                setState(() {
                  secondpencilvisible=false;
                });
              });

              Timer(Duration(milliseconds: 1800),(){

                _controller1.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);

                setState(() {
                  Timer(Duration(milliseconds: animationMiliseconds),(){
                    setState(() {
                      secondpencilvisible=true;
                    });
                  });
                });

                if(_controller1.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic) != null)
                {
                  Timer(Duration(milliseconds: animationMiliseconds),(){
                    setState(() {
                      thirdpencilvisible=false;
                    });
                  });
                  Timer(Duration(milliseconds: 1800),(){


                    _controller2.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);
                    setState(() {
                      Timer(Duration(milliseconds: animationMiliseconds),(){
                        setState(() {
                          thirdpencilvisible=true;
                        });
                      });
                    });


                    if(_controller2.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic) != null)
                    {

                      Timer(Duration(milliseconds: animationMiliseconds),(){
                        setState(() {
                          fourthpencilvisible=false;
                        });
                      });
                      Timer(Duration(milliseconds: 1800),(){

                        _controller3.animateToItem(counter, duration: Duration(milliseconds: animationMiliseconds), curve: Curves.easeInCubic);
                        setState(() {
                          Timer(Duration(milliseconds: animationMiliseconds),(){
                            setState(() {
                              fourthpencilvisible=true;
                            });
                          });
                        });
                        counter++;

                      });
                    }
                  });
                }
              });
            }
          });
        }



      });
      print('app is came back');

    }

  }
  Future get_impressions(String aliasid,{String flag='0'}) async
  {
    if(aliasid==null)
      aliasid="63";

    var request = http.Request('POST', Uri.parse('https://hooks.feed.whistle.mobi/i?alias=34&token=${ptoken}&flag=$flag&auth_url=$packageName'));

    print("url--"+"https://hooks.feed.whistle.mobi/i?alias=${aliasid}&token=${ptoken}&flag=0&auth_url=$packageName");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }


  }

  List<Color> firstpencilcolor = [Color(0xFFD72631), Color(0xFFE75974), Color(0xFF26495C), Color(0xFFE3B448), Color(0xFF077B8A), Color(0xFFBE1558), Color(0xFFC4A35A), Color(0xFF95BB6F), Color(0xFF66A995), Color(0xFF8E6C6B), Color(0xFFC66B3D), Color(0xFF3A6B35), Color(0xFF5C3C92), Color(0xFF322514), Color(0xFF655B4E), Color(0xFF05716C), Color(0xFFD72631), Color(0xFFE75974), Color(0xFF26495C), Color(0xFFE3B448),];
  List<Color> secondpencilcolor = [Color(0xFF077B8A), Color(0xFFBE1558), Color(0xFFC4A35A), Color(0xFF95BB6F), Color(0xFF66A995), Color(0xFF8E6C6B), Color(0xFFC66B3D), Color(0xFF3A6B35), Color(0xFF5C3C92),Color(0xFF322514), Color(0xFF655B4E), Color(0xFF05716C), Color(0xFFD72631), Color(0xFFE75974), Color(0xFF26495C), Color(0xFFE3B448), Color(0xFF077B8A), Color(0xFFBE1558), Color(0xFFC4A35A), Color(0xFF95BB6F),];
  List<Color> thirdpencilcolor = [Color(0xFF66A995), Color(0xFF8E6C6B), Color(0xFFC66B3D), Color(0xFF3A6B35), Color(0xFF5C3C92), Color(0xFF322514), Color(0xFF655B4E), Color(0xFF05716C), Color(0xFFD72631), Color(0xFFE75974), Color(0xFF26495C), Color(0xFFE3B448), Color(0xFF077B8A), Color(0xFFBE1558), Color(0xFFC4A35A), Color(0xFF95BB6F), Color(0xFF66A995), Color(0xFF8E6C6B), Color(0xFFC66B3D), Color(0xFF3A6B35),];
  List<Color> fourthpencilcolor = [Color(0xFF5C3C92), Color(0xFF322514), Color(0xFF655B4E), Color(0xFF05716C), Color(0xFFD72631), Color(0xFFE75974), Color(0xFF26495C), Color(0xFFE3B448), Color(0xFF077B8A), Color(0xFFBE1558), Color(0xFFC4A35A), Color(0xFF95BB6F), Color(0xFF66A995), Color(0xFF8E6C6B), Color(0xFFC66B3D), Color(0xFF3A6B35), Color(0xFF5C3C92), Color(0xFF322514), Color(0xFF655B4E), Color(0xFF05716C),];

  Widget pencils()
  {

    List<Campaindata>firstPencil=Provider.of<Whistle_Provider>(context,listen:true).firstpencillist;
    List<Campaindata>secondPencil=Provider.of<Whistle_Provider>(context,listen:true).seconfpencil;
    List<Campaindata>thirdpencil=Provider.of<Whistle_Provider>(context,listen:true).thirdpencil;
    List<Campaindata>fourthpencil=Provider.of<Whistle_Provider>(context,listen:true).fourthpencil;


    if(pensize==1)
    {
      return  Container(
          height: 82,
          child: Column(
            children: [
              Flexible(child: Padding(
                padding:
                EdgeInsets.only(left: 10, right: 5),
                child: GestureDetector(
                  onTap: (){
                    print("get index of click  ${firstPencil[indexvalue1].brandname}");
                    setState(() {
                      webviewurl="${firstPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                      print("package name ${packageName}");
                      print(webviewurl);
                      if(webviewurl!="")
                      {
                        _launchURL(webviewurl);
                      }

                    });

                  },
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: itemextent,
                    controller: _controller,
                    squeeze: squeeze,
                    diameterRatio: diameter,
                    perspective: perspective,
                    physics: NeverScrollableScrollPhysics(),
                    onSelectedItemChanged: (i) {
                      setState(() {
                        print('indexvalue${i}');
                        indexvalue1=i;
                        get_impressions(firstPencil[i].creativeId);
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List<Widget>.generate(
                        firstPencil.length,
                            (index) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(() {
                            });
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 59,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                      color: firstpencilcolor[index]
                                  ),
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: InkWell(
                                      onTap: (){
                                        print('clicked');
                                      },
                                      child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Flexible(
                                                    child: Wrap(
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      alignment: WrapAlignment.spaceBetween,
                                                      direction: Axis.horizontal,
                                                      children: [
                                                        Padding(padding: EdgeInsets.only(right: 5),
                                                        child: Text(firstPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                        )

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,

                                                  onTap: (){
                                                    setState(() {
                                                      print('clicked');
                                                      Navigator.pushNamed(context, '/Whistlecta_webview');
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black.withOpacity(0.5),
                                                            blurRadius: 2.0,
                                                            spreadRadius: 2.0,
                                                            offset: Offset(-2.2, 3.3)
                                                        ),
                                                      ],

                                                    ),
                                                    child: Center(
                                                      child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                        child: Text(firstPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                      ),
                                                    ),

                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      )



                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(padding: const EdgeInsets.only(right: 25),
                                    child: AnimatedOpacity(
                                      opacity: firstpencilvisible ?1 :0,
                                      duration:Duration(seconds: 1),
                                      child: firstpencilvisible==true?Text(firstPencil[index].brandname,):Container(height: 0,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ));
    }
    else if(pensize==2)
    {
      return Container(
        height: 160,
        child: Column(
          children: [
            Flexible(child: Padding(
              padding:
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  print("get index of click  ${firstPencil[indexvalue1].brandname}");
                  setState(() {
                    webviewurl="${firstPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                    print(webviewurl);
                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);
                    }
                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  physics: NeverScrollableScrollPhysics(),
                  onSelectedItemChanged: (i) {

                    setState(() {
                      print('indexvalue${i}');
                      indexvalue1=i;
                      get_impressions(firstPencil[i].creativeId);
                    });
                  },
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      firstPencil.length,
                          (index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          setState(() {
                          });
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    color: firstpencilcolor[index]
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: InkWell(
                                    onTap: (){
                                      print('clicked');
                                    },
                                    child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Flexible(
                                                  child: Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    alignment: WrapAlignment.spaceBetween,
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Padding(padding: EdgeInsets.only(right: 5),
                                                        child: Text(firstPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                behavior: HitTestBehavior.translucent,

                                                onTap: (){
                                                  setState(() {
                                                    print('clicked');
                                                    Navigator.pushNamed(context, '/Whistlecta_webview');
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black.withOpacity(0.5),
                                                          blurRadius: 2.0,
                                                          spreadRadius: 2.0,
                                                          offset: Offset(-2.2, 3.3)
                                                      ),
                                                    ],

                                                  ),
                                                  child: Center(
                                                    child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                      child: Text(firstPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    )



                                ),
                              ),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(padding: const EdgeInsets.only(right: 25),
                                  child: AnimatedOpacity(
                                    opacity: firstpencilvisible ?1 :0,
                                    duration:Duration(seconds: 1),
                                    child: firstpencilvisible==true?Text(firstPencil[index].brandname,):Container(height: 0,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 10,),
            Flexible(child: Padding(
              padding: const
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    print('checkclickingindex${secondPencil[indexvalue2].brandname}');
                    webviewurl="${secondPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                    print(webviewurl);
                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);
                    }
                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller1,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  onSelectedItemChanged: (i){

                    setState(() {
                      indexvalue2=i;
                      get_impressions(secondPencil[i].creativeId);

                    });
                  },

                  renderChildrenOutsideViewport: false,
                  physics: NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      secondPencil.length,
                          (index) => Container(
                        child: Column(
                          children: [
                            Container(
                              height: 59,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                  color: secondpencilcolor[index]
                              ),
                              width: MediaQuery.of(context).size.width - 40,
                              child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Flexible(
                                            child: Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              alignment: WrapAlignment.spaceBetween,
                                              direction: Axis.horizontal,
                                              children: [
                                                Padding(padding: EdgeInsets.only(right: 5),
                                                  child: Text(secondPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                )                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){},
                                          child:  Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black.withOpacity(0.5),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(-2.2, 3.3)
                                                ),
                                              ],

                                            ),
                                            child: Center(
                                              child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                child: Text(secondPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                              ),
                                            ),

                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),

                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(right: 25),
                                child: AnimatedOpacity(
                                  opacity: secondpencilvisible ?1 :0,
                                  duration:Duration(seconds: 1),
                                  child: secondpencilvisible==true?Text(secondPencil[index].brandname,):Container(height: 0,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      );
    }
    else if(pensize==3)
    {
      return Container(
        height: 260,
        child: Column(
          children: [
            Flexible(child: Padding(
              padding:
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  print('fjdsbfjsjdjdsbfj');
                  print("get index of click  ${firstPencil[indexvalue1].brandname}");

                  setState(() {
                    webviewurl="${firstPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                    print(webviewurl);
                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);
                    }

                  });

                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  physics: NeverScrollableScrollPhysics(),
                  onSelectedItemChanged: (i) {

                    setState(() {
                      print('indexvalue${i}');
                      indexvalue1=i;
                      get_impressions(firstPencil[i].creativeId);
                    });
                  },
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      firstPencil.length,
                          (index) => GestureDetector(

                        behavior: HitTestBehavior.translucent,

                        onTap: (){
                          setState(() {
                          });
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    color: firstpencilcolor[index]
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: InkWell(
                                    onTap: (){
                                      print('clicked');
                                    },
                                    child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Flexible(
                                                  child: Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    alignment: WrapAlignment.spaceBetween,
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Padding(padding: EdgeInsets.only(right: 5),
                                                        child: Text(firstPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                behavior: HitTestBehavior.translucent,

                                                onTap: (){
                                                  setState(() {
                                                    print('clicked');
                                                    Navigator.pushNamed(context, '/Whistlecta_webview');
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black.withOpacity(0.5),
                                                          blurRadius: 2.0,
                                                          spreadRadius: 2.0,
                                                          offset: Offset(-2.2, 3.3)
                                                      ),
                                                    ],

                                                  ),
                                                  child: Center(
                                                    child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                      child: Text(firstPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    )



                                ),
                              ),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(padding: const EdgeInsets.only(right: 25),
                                  child: AnimatedOpacity(
                                    opacity: firstpencilvisible ?1 :0,
                                    duration:Duration(seconds: 1),
                                    child: firstpencilvisible==true?Text(firstPencil[index].brandname,):Container(height: 0,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 10,),
            Flexible(child: Padding(
              padding: const
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    print('checkclickingindex${secondPencil[indexvalue2].brandname}');
                    webviewurl="${secondPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                    print(webviewurl);
                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);
                    }

                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller1,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  onSelectedItemChanged: (i){

                    setState(() {
                      indexvalue2=i;
                      get_impressions(secondPencil[i].creativeId);

                    });
                  },

                  renderChildrenOutsideViewport: false,
                  physics: NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      secondPencil.length,
                          (index) => Container(
                        child: Column(
                          children: [
                            Container(
                              height: 59,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                  color: secondpencilcolor[index]
                              ),
                              width: MediaQuery.of(context).size.width - 40,
                              child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Flexible(
                                            child: Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              alignment: WrapAlignment.spaceBetween,
                                              direction: Axis.horizontal,
                                              children: [
                                                Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(secondPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                )                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){},
                                          child:  Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black.withOpacity(0.5),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(-2.2, 3.3)
                                                ),
                                              ],

                                            ),
                                            child: Center(
                                              child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                child: Text(secondPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                              ),
                                            ),

                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),

                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(right: 25),
                                child: AnimatedOpacity(
                                  opacity: secondpencilvisible ?1 :0,
                                  duration:Duration(seconds: 1),
                                  child: secondpencilvisible==true?Text(secondPencil[index].brandname,):Container(height: 0,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 10,),
            Flexible(child: Padding(
              padding: const
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    print("get index value of pencil3${thirdpencil[indexvalue3].brandname}");
                    webviewurl="${thirdpencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                    print(webviewurl);
                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);
                    }
                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller2,
                  squeeze: squeeze,
                  diameterRatio:diameter,
                  perspective: perspective,
                  onSelectedItemChanged: (i){
                    setState(() {
                      indexvalue3=i;
                      get_impressions(thirdpencil[i].creativeId);

                    });

                  },

                  renderChildrenOutsideViewport: false,
                  physics: NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      thirdpencil.length,
                          (index) => Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){},
                              child:  Container(
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    color: thirdpencilcolor[index]
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Flexible(
                                              child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.spaceBetween,
                                                direction: Axis.horizontal,
                                                children: [
                                                  Padding(padding: EdgeInsets.only(right: 5),
                                                    child: Text(thirdpencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                  )                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black.withOpacity(0.5),
                                                      blurRadius: 2.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(-2.2, 3.3)
                                                  ),
                                                ],

                                              ),
                                              child: Center(
                                                child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                  child: Text(thirdpencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                ),
                                              ),

                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(right: 25),
                                child: AnimatedOpacity(
                                  opacity: thirdpencilvisible ?1 :0,
                                  duration:Duration(seconds: 1),
                                  child: thirdpencilvisible==true?Text(thirdpencil[index].brandname,):Container(height: 0,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      );
    }
    else if(pensize==4)
    {
      return Container(
        height: 360,
        child: Column(
          children: [
            Flexible(child: Padding(
              padding:
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    print("get index of click  ${firstPencil[indexvalue1].brandname}");
                    webviewurl="${firstPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                    print(webviewurl);
                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);

                    }

                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  physics: NeverScrollableScrollPhysics(),
                  onSelectedItemChanged: (i) {

                    setState(() {
                      print('indexvalue${i}');
                      indexvalue1=i;
                      get_impressions(firstPencil[i].creativeId);
                      print("print the  cta${firstPencil[i].tracker}");
                    });
                  },
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      firstPencil.length,
                          (index) => GestureDetector(

                        behavior: HitTestBehavior.translucent,

                        onTap: (){
                          setState(() {
                            print('jijkjndknfjbfk');
                          });
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    color: firstpencilcolor[index]
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: InkWell(
                                    onTap: (){
                                      print('clicked');
                                    },
                                    child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Flexible(
                                                  child: Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    alignment: WrapAlignment.spaceBetween,
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Padding(padding: EdgeInsets.only(right: 5),
                                                        child: Text(firstPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                behavior: HitTestBehavior.translucent,

                                                onTap: (){
                                                  setState(() {
                                                    print('clicked');
                                                    Navigator.pushNamed(context, '/Whistlecta_webview');
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black.withOpacity(0.5),
                                                          blurRadius: 2.0,
                                                          spreadRadius: 2.0,
                                                          offset: Offset(-2.2, 3.3)
                                                      ),
                                                    ],

                                                  ),
                                                  child: Center(
                                                    child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                      child: Text(firstPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    )



                                ),
                              ),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(padding: const EdgeInsets.only(right: 25),
                                  child: AnimatedOpacity(
                                    opacity: firstpencilvisible ?1 :0,
                                    duration:Duration(seconds: 1),
                                    child: firstpencilvisible==true?Text(firstPencil[index].brandname,):Container(height: 0,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 10,),
            Flexible(child: Padding(
              padding: const
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    print('checkclickingindex${secondPencil[indexvalue2].brandname}');
                    webviewurl="${secondPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";

                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);

                    }

                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller1,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  onSelectedItemChanged: (i){

                    setState(() {
                      indexvalue2=i;
                      get_impressions(secondPencil[i].creativeId);

                    });
                  },

                  renderChildrenOutsideViewport: false,
                  physics: NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      secondPencil.length,
                          (index) => Container(
                        child: Column(
                          children: [
                            Container(
                              height: 59,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                  color: secondpencilcolor[index]
                              ),
                              width: MediaQuery.of(context).size.width - 40,
                              child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Flexible(
                                            child: Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              alignment: WrapAlignment.spaceBetween,
                                              direction: Axis.horizontal,
                                              children: [
                                                Padding(padding: EdgeInsets.only(right: 5),
                                                  child: Text(secondPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                )                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){},
                                          child:  Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black.withOpacity(0.5),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(-2.2, 3.3)
                                                ),
                                              ],

                                            ),
                                            child: Center(
                                              child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                child: Text(secondPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                              ),
                                            ),

                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),

                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(right: 25),
                                child: AnimatedOpacity(
                                  opacity: secondpencilvisible ?1 :0,
                                  duration:Duration(seconds: 1),
                                  child: secondpencilvisible==true?Text(secondPencil[index].brandname,):Container(height: 0,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 10,),
            Flexible(child: Padding(
              padding: const
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    print("get index value of pencil3${thirdpencil[indexvalue3].brandname}");
                    webviewurl="${thirdpencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";

                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);


                    }

                  });
                },
                child: ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller2,
                  squeeze: squeeze,
                  diameterRatio:diameter,
                  perspective: perspective,
                  onSelectedItemChanged: (i){
                    setState(() {
                      indexvalue3=i;
                      get_impressions(thirdpencil[i].creativeId);


                    });

                  },

                  renderChildrenOutsideViewport: false,
                  physics: NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      thirdpencil.length,
                          (index) => Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){},
                              child:  Container(
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    color: thirdpencilcolor[index]
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Flexible(
                                              child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.spaceBetween,
                                                direction: Axis.horizontal,
                                                children: [
                                                  Padding(padding: EdgeInsets.only(right: 5),
                                                    child: Text(thirdpencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                  )                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black.withOpacity(0.5),
                                                      blurRadius: 2.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(-2.2, 3.3)
                                                  ),
                                                ],

                                              ),
                                              child: Center(
                                                child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                  child: Text(thirdpencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                ),
                                              ),

                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(right: 25),
                                child: AnimatedOpacity(
                                  opacity: thirdpencilvisible ?1 :0,
                                  duration:Duration(seconds: 1),
                                  child: thirdpencilvisible==true?Text(thirdpencil[index].brandname,):Container(height: 0,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 10,),
            Flexible(child: Padding(
              padding: const
              EdgeInsets.only(left: 10, right: 5),
              child: GestureDetector(
                onTap: (){

                  setState(() {

                    webviewurl="${fourthpencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";

                    if(webviewurl!="")
                    {
                      _launchURL(webviewurl);

                    }
                  });
                },
                child:  ListWheelScrollView.useDelegate(
                  itemExtent: itemextent,
                  controller: _controller3,
                  squeeze: squeeze,
                  diameterRatio: diameter,
                  perspective: perspective,
                  onSelectedItemChanged: (i){
                    setState(() {
                      indexvalue4=i;
                      get_impressions(fourthpencil[i].creativeId);

                    });
                  },

                  renderChildrenOutsideViewport: false,
                  physics: NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      fourthpencil.length,
                          (index) => Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){},
                              child:  Container(
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    color: fourthpencilcolor[index]
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Flexible(
                                              child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.spaceBetween,
                                                direction: Axis.horizontal,
                                                children: [
                                                  Padding(padding: EdgeInsets.only(right: 5),
                                                    child: Text(fourthpencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                  )                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child:    Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black.withOpacity(0.5),
                                                      blurRadius: 2.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(-2.2, 3.3)
                                                  ),
                                                ],

                                              ),
                                              child: Center(
                                                child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                  child: Text(fourthpencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                ),
                                              ),

                                            ),
                                          ),

                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Align(alignment: Alignment.bottomRight,
                              child: Padding(padding: const EdgeInsets.only(right: 25),
                                child:  AnimatedOpacity(
                                  opacity: fourthpencilvisible ?1 :0,
                                  duration:Duration(seconds: 1),
                                  child: fourthpencilvisible==true?Text(fourthpencil[index].brandname,):Container(height: 0,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      );
    }
    else
    {
        return  Container(
            height: 82,
            child: Column(
              children: [
                Flexible(child: Padding(
                  padding:
                  EdgeInsets.only(left: 10, right: 5),
                  child: GestureDetector(
                    onTap: (){
                      print('fjdsbfjsjdjdsbfj');
                      print("get index of click  ${firstPencil[indexvalue1].brandname}");

                      setState(() {
                        webviewurl="${firstPencil[indexvalue1].tracker}&token=${ptoken}&auth_url=$packageName";
                        print("package name ${packageName}");


                        print(webviewurl);
                        if(webviewurl!="")
                        {
                          _launchURL(webviewurl);
                        }

                      });

                    },
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: itemextent,
                      controller: _controller,
                      squeeze: squeeze,
                      diameterRatio: diameter,
                      perspective: perspective,
                      physics: NeverScrollableScrollPhysics(),
                      onSelectedItemChanged: (i) {

                        setState(() {
                          print('indexvalue${i}');
                          indexvalue1=i;
                          get_impressions(firstPencil[i].creativeId);
                        });
                      },
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List<Widget>.generate(
                          firstPencil.length,
                              (index) => GestureDetector(
                            behavior: HitTestBehavior.translucent,

                            onTap: (){
                              setState(() {
                                print('jijkjndknfjbfk');
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 59,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        color: firstpencilcolor[index]
                                    ),
                                    width: MediaQuery.of(context).size.width - 60,
                                    child: InkWell(
                                        onTap: (){
                                          print('clicked');
                                        },
                                        child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                          child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Flexible(
                                                      child: Wrap(
                                                        crossAxisAlignment: WrapCrossAlignment.center,
                                                        alignment: WrapAlignment.spaceBetween,
                                                        direction: Axis.horizontal,
                                                        children: [
                                                          Padding(padding: EdgeInsets.only(right: 5),
                                                            child: Text(firstPencil[index].headline,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                                                          )

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    behavior: HitTestBehavior.translucent,

                                                    onTap: (){
                                                      setState(() {
                                                        print('clicked');
                                                        Navigator.pushNamed(context, '/Whistlecta_webview');
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.black.withOpacity(0.5),
                                                              blurRadius: 2.0,
                                                              spreadRadius: 2.0,
                                                              offset: Offset(-2.2, 3.3)
                                                          ),
                                                        ],

                                                      ),
                                                      child: Center(
                                                        child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                                          child: Text(firstPencil[index].cTA,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                        ),
                                                      ),

                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),
                                        )



                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(padding: const EdgeInsets.only(right: 25),
                                      child: AnimatedOpacity(
                                        opacity: firstpencilvisible ?1 :0,
                                        duration:Duration(seconds: 1),
                                        child: firstpencilvisible==true?Text(firstPencil[index].brandname,):Container(height: 0,),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ));
      }
  }

  @override
  Widget build(BuildContext context) {
    whistleFeedModel =Provider.of<Whistle_Provider>(context, listen: true).whistleFeedModel;
    return Scaffold(
        body: whistleFeedModel==null?Container(
          height: 0,
        ):ptoken==""?Container(height: 0,):whistleFeedModel.message=='user not found'?Container(height: 0,):
        Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(padding: const EdgeInsets.only(right: 25,top: 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Whistle  ',
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Feed | ',
                            style: TextStyle(
                                fontStyle: FontStyle.normal
                            )

                        ),
                        TextSpan(text: 'Sponsored',
                            style: TextStyle(
                                fontStyle: FontStyle.normal
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              pencils()
            ],
          ),
        ));
  }
}
