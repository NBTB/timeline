package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Timeline.TimelineItem;
	
	/**
	 * ...
	 * @author Tim
	 */
	public class Main extends Sprite 
	{
		// Constant that defines the URL of the XML database.
		public static const XMLDATA:String = "data/database.xml";
		// Constant that defines an array of images to load in sequence.
		public static const IMAGES:Array = ["data/political.png", "data/union.png", "data/confederate.png", "data/battle.png", "data/art.png"];
		private var loaded:int = 0; //keeps track of which images needs to be loaded next.
		
		public var timelineLine:MovieClip;
		public var timelineItemList:Vector.<TimelineItem>;		//stores all the events from our database in sorted order
		public var currentItemList:Vector.<TimelineItem>;		//stores the currently shown events
		public var iconArray:Vector.<Bitmap>;						//stores all the icons
		
		private var beginDate:int;
		private var endDate:int;
		private var MINDATE:int = 1810;
		private var MAXDATE:int = 1895;
		private var lineStart:int = 100;
		private var lineEnd:int = 650;
		private var lineHeight:int = 500;
	
		//private var startTimeline:timeline;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//startTimeline = new timeline();
			//addChild(startTimeline);
			iconArray = new Vector.<Bitmap>();
			beginDate = 1860;
			endDate = 1866;
			
			loadNext();
		}
		
		public function loadNext(e:Event = null):void {
			//The first time this is called, e is null, every other time, e.target is a Loader that just finished.
			if(e != null) { iconArray.push(e.target.loader.content); }
			
			//if there are still images to load, load the next one.
			if (loaded < IMAGES.length)
			{
				trace("loading image #" + loaded + " now...");
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNext);
				loader.load(new URLRequest(IMAGES[loaded]));
				//iconArray.push(loader.content);
				loaded++;
			}
			//otherwise, load the xml file.
			else
			{
				trace("loading XML now...");
				var xmlloader:URLLoader = new URLLoader();
				xmlloader.addEventListener(Event.COMPLETE, parseXML);
				xmlloader.load(new URLRequest(XMLDATA));
			}
		}
		
		//pretty much copied verbatim -- those namespaces are just too messy to deal with (ditto for the xml file itself)
		public function parseXML(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace=true;
			var ss:Namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			
			trace("xml reading");
			
			timelineItemList = new Vector.<TimelineItem>();
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
					
					timelineItemList.push(tEvent);					
				}
			}
			
			trace("xml done reading");
			changeZoomLevel(0,0);
		}
		
		public function zoomIn(e:Event = null):void
		{
			changeZoomLevel(1,-1);
		}
		
		public function zoomOut(e:Event = null):void
		{
			changeZoomLevel(-1,1);
		}
		
		public function changeZoomLevel(beginDateZoom:int, endDateZoom:int):void
		{			
			var newBegin:int = beginDate + beginDateZoom;
			var newEnd:int = endDate + endDateZoom;
			
			if(newBegin < MINDATE)
			{
				newBegin = MINDATE;
			}
			else if(newEnd > MAXDATE)
			{
				newEnd = MAXDATE;
			}
						
			if(newBegin > newEnd)
			{
				trace("Date Error in timeline.changeZoomLevel");
			}
			else
			{
				beginDate = newBegin;
				endDate = newEnd;
				emptyTimeline();
				populateTimeline();
			}
		}
		
		private function populateTimeline():void
		{			
			//create Timeline Line
			createLine();
			
			//create Text stuff in Timeline
			createText();
			
			//load the Events into the timeline
			createEvents();
			
			var zoomInbox:TextField;
			zoomInbox = new TextField();
			zoomInbox.text ="zoomIn";
			zoomInbox.x = lineEnd + 10;
			zoomInbox.y = lineHeight + 50;
			zoomInbox.addEventListener(MouseEvent.CLICK, zoomIn);
			this.addChild(zoomInbox);
			
			var zoomOutbox:TextField;
			zoomOutbox = new TextField();
			zoomOutbox.text ="zoomOut";
			zoomOutbox.x = lineEnd + 10;
			zoomOutbox.y = lineHeight + 70;
			zoomOutbox.addEventListener(MouseEvent.CLICK, zoomOut);
			this.addChild(zoomOutbox);
		}
		
		private function emptyTimeline():void
		{
			//clear current events and objects on screen
			while (numChildren > 0) { removeChildAt(0); }
		}
		
		private function createLine():void
		{
			trace("creating line");
			//the line of the timeline
			var line:Shape;
			line = new Shape();
			line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0x002772,0.5);
			line.graphics.drawRect(lineStart, lineHeight - 4, lineEnd - lineStart, 8);
			line.graphics.endFill();
			this.addChild(line);
			
			//left arrow
			var ltri:Shape;
			ltri = new Shape();
			ltri.graphics.lineStyle(1, 0x000000,1);
			ltri.graphics.beginFill(0x555555,1);
			ltri.graphics.drawTriangles(Vector.<Number>([lineStart-20,lineHeight, lineStart,lineHeight+10, lineStart,lineHeight-10]),Vector.<int>([0,1,2]));
			ltri.graphics.endFill();
			this.addChild(ltri);
			
			//right arrow
			var rtri:Shape;
			rtri = new Shape();
			rtri.graphics.lineStyle(1, 0x000000,1);
			rtri.graphics.beginFill(0x555555,1);
			rtri.graphics.drawTriangles(Vector.<Number>([lineEnd+20,lineHeight, lineEnd,lineHeight+10, lineEnd,lineHeight-10]),Vector.<int>([0,1,2]));
			rtri.graphics.endFill();
			this.addChild(rtri);
						
			var bText:TextField;
			bText = new TextField();
			bText.text = beginDate.toString();
			bText.x = lineStart - 15;
			bText.y = lineHeight + 20;
			this.addChild(bText);
			
			var eText:TextField;
			eText = new TextField();
			eText.text = endDate.toString();
			eText.x = lineEnd-15;
			eText.y = lineHeight + 20;
			this.addChild(eText);
			
			var midDateAmount:int = endDate - beginDate;
			var skipAmount:int = 1;
			
			var scaler:int = midDateAmount;
			
			while(scaler > 8)
			{
				scaler = scaler / 2;
				skipAmount += 2;
			}
			
			trace("midDateAmount: " + midDateAmount);
			trace("scaler: " + scaler);
			var skipNum:int = 1;
			
			for(var i:int = 1; i < midDateAmount; i++)
			{
				if(skipNum >= skipAmount)
				{
					skipNum = 0;
					
					//solid lines on datebar/timeline
					var dLine:Shape = new Shape();
					dLine.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight-15);
					dLine.graphics.lineStyle(2, 0x000000,1);
					dLine.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight+15);
					this.addChild(dLine);
					
					//dates
					var dLineText:TextField = new TextField();
					dLineText.text = (beginDate+i).toString();
					dLineText.x = lineStart + ((lineEnd - lineStart)/ midDateAmount * i) - 15;
					dLineText.y = lineHeight + 40;
					this.addChild(dLineText);
					
					//faint lines
					var faintLine:Shape;
					faintLine = new Shape();
					faintLine.graphics.moveTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), 50);
					faintLine.graphics.lineStyle(2, 0x111188, 0.1);
					faintLine.graphics.lineTo(lineStart + ((lineEnd - lineStart)/ midDateAmount * i), lineHeight-15);
					this.addChild(faintLine);
				}
				skipNum++;
			}
		}
		
		private function createText():void
		{			
			trace("creating Text");
			var format1:TextFormat = new TextFormat();
			format1.size = 25;
			 
			var format2:TextFormat = new TextFormat();
			format2.italic = true;
			
			var nbtbT:TextField;
			nbtbT = new TextField();
			nbtbT.width = 700;
			nbtbT.text = "The Night Before the Battle and the American Civil War";
			nbtbT.setTextFormat(format1);
			nbtbT.setTextFormat(format2, 0,27);
			nbtbT.x = 100;
			nbtbT.y = 15;
			this.addChild(nbtbT);
			
			format1.size = 15;
			
			var politicalT:TextField;
			politicalT = new TextField();
			politicalT.text ="Political Front";
			politicalT.setTextFormat(format1);
			politicalT.width = 90;
			politicalT.height = 20;
			politicalT.border = true;
			politicalT.background = true;
			politicalT.backgroundColor = 0xFFFFFF;
			politicalT.wordWrap = true;
			politicalT.x = 15;
			politicalT.y = ((lineHeight - 100) / 4) * 1;
			this.addChild(politicalT);
			
			var battleT:TextField;
			battleT = new TextField();
			battleT.text ="Battles of the Civil War";
			battleT.setTextFormat(format1);
			battleT.width = 90;
			battleT.height = 40;
			battleT.border = true;
			battleT.background = true;
			battleT.backgroundColor = 0x788C42;
			battleT.wordWrap = true;
			battleT.x = 15;
			battleT.y = ((lineHeight - 100) / 4) * 2;
			this.addChild(battleT);
			
			var artistT:TextField;
			artistT = new TextField();
			artistT.text ="Life of James Henry Beard";
			artistT.setTextFormat(format1);
			artistT.width = 90;
			artistT.height = 40;
			artistT.border = true;
			artistT.background = true;
			artistT.backgroundColor = 0x935E3E;
			artistT.wordWrap = true;
			artistT.x = 15;
			artistT.y = ((lineHeight - 100) / 4) * 3;
			this.addChild(artistT);
			
			var artT:TextField;
			artT = new TextField();
			artT.text ="Art of the Civil War Era";
			artT.setTextFormat(format1);
			artT.width = 90;
			artT.height = 40;
			artT.border = true;
			artT.background = true;
			artT.backgroundColor = 0xFFBF01;
			artT.wordWrap = true;
			artT.x = 15;
			artT.y = ((lineHeight - 100) / 4) * 4;
			this.addChild(artT);
		}
		
		private function createEvents():void
		{
			trace("creating Events");
			currentItemList = new Vector.<TimelineItem>();
			var lastBattle:int = 0;
			var lastPolitical:int = 0;
			var lastArtist:int = 0;
			var safeZone:int = 50;
			var by1:int = 220;
			var by2:int = 250;
			var by3:int = 280;
			var byPos:int = by1;
			var py1:int = 100;
			var py2:int = 130;
			var py3:int = 170;
			var pyPos:int = py1;
			var ay1:int = 340;
			var ay2:int = 360;
			var ayPos:int = ay1;
			
			for(var i:int=0; i<timelineItemList.length; i++)
			{
				if(timelineItemList[i].year >= beginDate && timelineItemList[i].year < endDate)
				{
					currentItemList.push(timelineItemList[i]);
					
					var midDateAmount:int = endDate - beginDate;
					
					var yDate:int = ((lineEnd - lineStart)/ midDateAmount) * (timelineItemList[i].year - beginDate);
					var mDate:int = (((lineEnd - lineStart)/ midDateAmount) / 12) * timelineItemList[i].month;
					var dDate:int = ((((lineEnd - lineStart) / midDateAmount) / 12) / 31) * timelineItemList[i].day;
					
					var xPos:int = lineStart + yDate + mDate + dDate;
					//trace("Date: " + timelineItemList[i].month + " " + timelineItemList[i].day + ", " + timelineItemList[i].year);
					//trace(yDate + " " + mDate + " " + dDate);
					var circle:Shape;
					circle = new Shape();
					circle.graphics.lineStyle(2, 0x777777, 1);
					var bit:Bitmap;
					
					if(timelineItemList[i].type == "Battle")
					{
						var importance:int = timelineItemList[i].importance * 5 + 7;
						
						if(timelineItemList[i].victor == "Union")
						{
							circle.graphics.beginFill(0x002772,0.5);
							bit = new Bitmap((iconArray[1]).bitmapData.clone());
						}
						else if(timelineItemList[i].victor == "Confederate")
						{
							circle.graphics.beginFill(0x777777,0.5);
							bit = new Bitmap((iconArray[2]).bitmapData.clone());
						}
						else
						{
							circle.graphics.beginFill(0x722700,0.5);
							bit = new Bitmap((iconArray[3]).bitmapData.clone());
						}
						
						if(xPos - lastBattle < safeZone)
						{
							if(byPos == by1) byPos = by2;
							else if(byPos == by2) byPos = by3;
							else byPos = by1;
						}
						else
						{
							byPos = by1;
						}
						circle.x = xPos;
						circle.y = byPos;
						circle.graphics.drawCircle(0,0,importance);
						lastBattle = xPos;
						
						bit.scaleX = 0.01*(importance/2);
						bit.scaleY = 0.01*(importance/2);
						bit.x = circle.x - bit.width/2;
						bit.y = circle.y - bit.height/2;
					}
					else if (timelineItemList[i].type == "Artist")
					{
						trace("artist");
						circle.graphics.beginFill(0x55FF22,0.5);
						
						if(xPos - lastArtist < safeZone)
						{
							if(ayPos == ay1) ayPos = ay2;
							else ayPos = ay1;
						}
						else
						{
							ayPos = ay1;
						}
						circle.x = xPos;
						circle.y = ayPos;
						circle.graphics.drawCircle(0,0,20);
						lastArtist = xPos;
						
						bit = new Bitmap((iconArray[4]).bitmapData.clone());
						bit.scaleX = 0.15;
						bit.scaleY = 0.15;
						bit.x = circle.x - bit.width/2;
						bit.y = circle.y - bit.height / 2;
					}
					else
					{
						circle.graphics.beginFill(0xFFCC11,0.5);
						
						if(xPos - lastPolitical < safeZone)
						{
							if(pyPos == py1) pyPos = py2;
							else if(pyPos == py2) pyPos = py3;
							else pyPos = py1;
						}
						else
						{
							pyPos = py1;
						}
						circle.x = xPos;
						circle.y = pyPos;
						circle.graphics.drawCircle(0,0,20);
						lastPolitical = xPos;
						
						bit = new Bitmap((iconArray[0]).bitmapData.clone());
						bit.scaleX = 0.15;
						bit.scaleY = 0.15;
						bit.x = circle.x - bit.width/3;
						bit.y = circle.y - bit.height/3*2;
					}
					circle.graphics.endFill();
					this.addChild(circle);
					this.addChild(bit);
				}
			}
		}
	}
	
}