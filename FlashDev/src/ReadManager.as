package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ReadManager extends Sprite
	{		
		private var xml:XML;
		private var itemList:Vector.<TimelineItem>;
		private var tParent:Main;
		private var myLoader:Loader;
		private var imageNum:int = 0;
		
		public function ReadManager(t:Main)
		{
			tParent = t;
			
			readImage("political.png");
		}
		
		private function readImage(fileName:String):void
		{
			myLoader = new Loader();
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageReady);
			
			myLoader.load(new URLRequest("../lib/" + fileName));
		}
		
		private function onImageReady(e:Event):void
		{
			imageNum++;
			tParent.iconArray.push(e.target.loader.content);
			switch(imageNum)
			{
				case 1:
					readImage("union.png");
					break;
				case 2:
					readImage("confederate.png");
					break;
				case 3:
					readImage("battle.png");
					break;
				case 4:
					readImage("art.png");
					break;
				default:
					readXML();
			}
		}
		
		private function readXML():void
		{
			var loadXML:URLLoader = new URLLoader(new URLRequest("../lib/database.xml"));
			loadXML.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		
		private function xmlLoaded(e:Event):void
		{
			xml = new XML(e.target.data);
			xml.ignoreWhitespace=true;
			var ss:Namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			
			trace("xml reading");
			
			itemList = new Vector.<TimelineItem>();
			for(var i:int=0; i<xml.ss::Worksheet..ss::Table.children().length(); i++)
			{
				var rName:String = xml.ss::Worksheet..ss::Table.children()[i].name();

				if(rName == "urn:schemas-microsoft-com:office:spreadsheet::Row")
				{
					var tEvent:TimelineItem = new TimelineItem();
					
					tEvent.year = xml.ss::Worksheet..ss::Table.children()[i].children()[0].children()[0];
					tEvent.month = xml.ss::Worksheet..ss::Table.children()[i].children()[1].children()[0];
					tEvent.day = xml.ss::Worksheet..ss::Table.children()[i].children()[2].children()[0];
					tEvent.type = xml.ss::Worksheet..ss::Table.children()[i].children()[3].children()[0];
					tEvent.shortDes = xml.ss::Worksheet..ss::Table.children()[i].children()[4].children()[0];
					tEvent.fullDes = xml.ss::Worksheet..ss::Table.children()[i].children()[5].children()[0];
					if(tEvent.type == "Battle")
					{
						tEvent.victor = xml.ss::Worksheet..ss::Table.children()[i].children()[6].children()[0];	
						tEvent.importance = xml.ss::Worksheet..ss::Table.children()[i].children()[7].children()[0];						
					}
					
					itemList.push(tEvent);					
				}
			}
			
			trace("xml done reading");
			tParent.timelineItemList = itemList;
			tParent.changeZoomLevel(0,0);
		}
	}
}