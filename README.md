##A stock graph

2016.9.13 complete the kline

2016.9.14 add pinch gesture to kline, add volumn view and so on...

####App runtime effect

<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/1.jpeg" width="187.5" height="337.5"/> 
<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/2.jpeg" width="187.5" height="337.5"/> 
<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/3.png" width="187.5" height="337.5"/>
<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/4.png" width="187.5" height="337.5"/> 
<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/5.png" width="187.5" height="337.5"/> 
<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/6.png" width="187.5" height="337.5"/>
<img src="https://github.com/dyljqq/DJStock-Swift/raw/master/ScreenShot/7.png" width="187.5" height="337.5"/>

#### Usage

Usage is very simple...

1. create a KLine Graph
just need three line code
		
		// init a KLine View
		let kLine = DJKLine(frame: CGRectMake(0, 100, screenWidth, 300))
		
		// add the view to the super view
        self.view.addSubview(kLine)
        
        // update the KLine View
        kLine.updateView("http://img1.money.126.net/data/hs/kline/day/history/2016/1000001.json")
2. So do the ShareTimeGraph and TapeView
3. And more normal situation is that we need the 
combination of ShareTimeGraph, the TapeView and the DJGroupView. So you can use the type named Group in StockType.
4. You can also request the data to use the DJRequest class.
5. It support some gesture, like tap, pinch and long press.

For more, you can see the demo in the DetailViewController file. You can read my source code, and maybe you can give me some suggestions to make this project better.

####Todo:

Next, I will complete the Time-Sharing diagram and the Market diagram like TongHuashun...(complete)