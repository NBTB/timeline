package Timeline
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ReadManager extends Sprite
	{		
		var xml:XML;
		var eventList:Vector.<TimelineEvent>;
		var tParent:timeline;
		var myLoader:Loader;
		var imageNum:int = 0;
		/*
		//date values
		var year:int;
		var month:int;
		var day:int;
		
		var type:String;
		
		var hoverDes;
		var fullDes;
		
		var importance;
		*/
		
		public function ReadManager(t:timeline)
		{
			tParent = t;
			
			readImage("political.png")
		}
		
		private function readImage(fileName:String)
		{
			myLoader = new Loader();
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageReady);
			
			myLoader.load(new URLRequest("Timeline/data/" + fileName));
		}
		
		private function onImageReady(e:Event)
		{
			imageNum++;
			tParent.iconArray.push(e.target.loader.content);
			switch(imageNum)
			{
				case 1:
					readImage("unionButton.png");
					break;
				case 2:
					readImage("confederate.png");
					break;
				case 3:
					readImage("battle.png");
					break;
				default:
					readXML();
			}
			/*
			tParent.addChild(myLoader);
			myLoader.x = 400;
			myLoader.y = 300;
		//	myLoader.width = 20;
//			myLoader.height = 30;
			myLoader.scaleX = 0.1;
			myLoader.scaleY = 0.1;
			var l:Loader = new Loader();
			l = myLoader;
			l.x = 50;
			//tParent.addChild(l);
			*/
		}
		
		private function readXML()
		{
			var loadXML:URLLoader = new URLLoader(new URLRequest("Timeline/data/database.xml"));
			loadXML.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		
		private function xmlLoaded(e:Event)
		{
			xml = new XML(e.target.data);
			xml.ignoreWhitespace=true;
			var ss:Namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			
			trace("xml reading");
			// trace(xml.ss::Worksheet..ss::Table.children().length());
			
			eventList = new Vector.<TimelineEvent>();
			for(var i=0; i<xml.ss::Worksheet..ss::Table.children().length(); i++)
			{
				var rName = xml.ss::Worksheet..ss::Table.children()[i].name();

				if(rName == "urn:schemas-microsoft-com:office:spreadsheet::Row")
				{
					var tEvent:TimelineEvent = new TimelineEvent();
					
					trace(i);
					tEvent.year = xml.ss::Worksheet..ss::Table.children()[i].children()[0].children()[0];
					trace(i);
					tEvent.month = xml.ss::Worksheet..ss::Table.children()[i].children()[1].children()[0];
					trace(i);
					tEvent.day = xml.ss::Worksheet..ss::Table.children()[i].children()[2].children()[0];
					trace(i);
					tEvent.type = xml.ss::Worksheet..ss::Table.children()[i].children()[3].children()[0];
					trace(i);
					tEvent.shortDes = xml.ss::Worksheet..ss::Table.children()[i].children()[4].children()[0];
					trace(i);
					tEvent.fullDes = xml.ss::Worksheet..ss::Table.children()[i].children()[5].children()[0];
					trace(i);
					if(tEvent.type == "Battle")
					{
						trace("battle");
						tEvent.victor = xml.ss::Worksheet..ss::Table.children()[i].children()[6].children()[0];						
					}
					
					eventList.push(tEvent);
					/*
					//year
					//trace(xml.ss::Worksheet..ss::Table.children()[i].children()[0].children()[0]);
					//month
					trace(xml.ss::Worksheet..ss::Table.children()[i].children()[1].children()[0]);
					//day
					trace(xml.ss::Worksheet..ss::Table.children()[i].children()[2].children()[0]);
					//type
					trace(xml.ss::Worksheet..ss::Table.children()[i].children()[3].children()[0]);
					//shortDes
					trace(xml.ss::Worksheet..ss::Table.children()[i].children()[4].children()[0]);
					//fullDes
					//trace(xml.ss::Worksheet..ss::Table.children()[i].children()[5].children()[0]);
					*/
					
				}
			}
			
			trace("xml done reading");
			tParent.timelineEventList = eventList;
			tParent.changeZoomLevel(0,0);
		}
	}
}